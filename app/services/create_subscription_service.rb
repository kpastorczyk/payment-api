ActiveMerchant::Billing::Base.mode = :test

class CreateSubscriptionService
  def initialize(user, params, amount)
    @gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
      login: 'TestMerchant',
      password: 'password'
    )
    @user = user
    @params = params
    @amount = amount
  end

  def call
    amount = @amount * 100 # $100.00
    credit_card = ActiveMerchant::Billing::CreditCard.new(
      first_name: @params[:first_name],
      last_name: @params[:last_name],
      number: @params[:number],
      month: @params[:month],
      year: @params[:year],
      verification_value: @params[:verification_value]
    )
    credit_card_validation = credit_card.validate

    if credit_card_validation.empty?
      response = @gateway.purchase(amount, credit_card)
      persist_transaction(response)

      return get_response(response.success?, response.message)
    end

    get_response(false, credit_card_validation)
  end

  private

  def persist_transaction(response)
    transaction = PaymentSubscription.new(
      first_name: @params[:first_name],
      last_name: @params[:last_name],
      number: @params[:number],
      month: @params[:month],
      year: @params[:year],
      verification_value: @params[:verification_value],
      user_id: @user.id,
      paid: response.success?
    )
    transaction.save
  end

  def get_response(success, message)
    {
      success: success,
      message: message
    }
  end
end
