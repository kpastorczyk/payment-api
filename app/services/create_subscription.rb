module Services
  class CreateSubscription
    def initialize(user, params, amount)
      @gateway = Adapters::Getway.new
      @user = user
      @params = params
      @amount = amount
    end

    def call
      amount = @amount * 100 # $100.00

      if credit_card.validate.empty?
        response = @gateway.purchase(amount, credit_card)
        persist_transaction(response)

        return get_response(response.success?, response.message)
      end

      get_response(false, credit_card.validate)
    end

    private

    def persist_transaction(response)
      PaymentSubscription.new(
        first_name: @params[:first_name],
        last_name: @params[:last_name],
        number: @params[:number],
        month: @params[:month],
        year: @params[:year],
        verification_value: @params[:verification_value],
        user_id: @user.id,
        paid: response.success?
      ).save
    end

    def credit_card
      ActiveMerchant::Billing::CreditCard.new(
        first_name: @params[:first_name],
        last_name: @params[:last_name],
        number: @params[:number],
        month: @params[:month],
        year: @params[:year],
        verification_value: @params[:verification_value]
      )
    end

    def get_response(success, message)
      {
        success: success,
        message: message
      }
    end
  end
end
