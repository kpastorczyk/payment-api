require 'active_merchant'

class PaymentController < ApplicationController
  before_action :authenticate_user!
  ActiveMerchant::Billing::Base.mode = :test

  def validate

    gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
        :login => 'TestMerchant',
        :password => 'password')

    amount = 10000  # $100.00

    credit_card = ActiveMerchant::Billing::CreditCard.new(
        :first_name         => 'Bob',
        :last_name          => 'Bobsen',
        :number             => '4242424242424242',
        :month              => '8',
        :year               => Time.now.year+1,
        :verification_value => '000')

    if credit_card.validate.empty?
      # Capture $10 from the credit card
      response = gateway.purchase(amount, credit_card)

      if response.success?
        render json: {
            success: true,
            amount: amount / 100
        }
      else
        raise StandardError, response.message
      end
    end
  end
end
