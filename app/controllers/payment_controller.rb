require 'active_merchant'

class PaymentController < ApplicationController
  before_action :authenticate_user!

  def validate
    create_subscription_service = CreateSubscriptionService.new
    response = create_subscription_service.call(current_user, payment_params, 100)

    render json: { success: response.success?, message: response.message }
  end

  private

  def payment_params
    params.permit(:first_name, :last_name, :number, :month, :year, :verification_value)
  end
end
