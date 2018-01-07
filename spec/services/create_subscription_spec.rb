require 'rails_helper'

RSpec.describe Services::CreateSubscription do
  class GetwayMock
    def purchase
      raise Timeout::Error
    end
  end

  class CreditCardValidationMock
    def validate
      {}
    end
  end

  describe "#call" do
    let(:current_user) do
      build(:user)
    end

    let(:payment_params) do
      {
          first_name: "Bob",
          last_name: "Mental",
          number: "4242424242424242",
          month: "07",
          year: "2017",
          verification_value: 000
      }
    end

    let(:service) do
      ::Services::CreateSubscription.new(current_user, payment_params, 100)
    end

    context "getway return timeout" do
      before :each do
        allow_any_instance_of(Services::CreateSubscription)
            .to receive(:credit_card)
            .and_return(CreditCardValidationMock.new)

        allow(Adapters::Getway)
            .to receive(:new)
            .and_return(GetwayMock)
      end

      it "raise error" do
        expect { service.call }.to raise_error
      end
    end
  end
end
