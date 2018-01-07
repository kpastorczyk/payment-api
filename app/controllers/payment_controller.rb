class PaymentController < ApplicationController
  before_action :authenticate_user!

  def validate
    create_subscription_service = ::Services::CreateSubscription.new(current_user, payment_params, 100)
    response = create_subscription_service.call

    render json: response
  rescue => e
    render json: {
        success: false,
        message: e.to_json
    }
  end

  private

  def payment_params
    params.permit(:first_name, :last_name, :number, :month, :year, :verification_value)
  end
end
