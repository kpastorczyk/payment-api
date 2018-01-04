module Adapters
  class Getway
    ActiveMerchant::Billing::Base.mode = :test

    def initialize
      @gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
        login: 'TestMerchant',
        password: 'password'
      )
    end

    def purchase(amount, credit_card)
      if [true, false].sample
        raise Timeout::Error
      else
        @gateway.purchase(amount, credit_card)
      end
    end
  end
end
