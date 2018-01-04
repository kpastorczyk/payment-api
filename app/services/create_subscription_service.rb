ActiveMerchant::Billing::Base.mode = :test

class CreateSubscriptionService
  def initialize
    @gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
        :login => 'TestMerchant',
        :password => 'password')
  end

  def call(user, params, amount)
    amount = amount * 100  # $100.00
    credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name         => params[:first_name],
        :last_name          => params[:last_name],
        :number             => params[:number],
        :month              => params[:month],
        :year               => params[:year],
        :verification_value => params[:verification_value]
    )

    if credit_card.validate.empty?
      response = @gateway.purchase(amount, credit_card)

      if response.success?
        return response
      else
        raise StandardError, response.message
      end
    end
    raise StandardError
  end
end