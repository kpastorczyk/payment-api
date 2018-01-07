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
      create(:user)
    end

    let(:payment_params) do
      {
          first_name: "Bob",
          last_name: "Mental",
          number: "4242424242424242",
          month: "07",
          year: Time.now.year+1,
          verification_value: "002"
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

    context "call" do
      it "return success" do
        response = service.call
        expect(response)
            .to eq({success: true, message: "The transaction was successful"})
      end

      it "save info about transaction" do
        service.call
        transaction = PaymentSubscription.last
        expect(transaction).to have_attributes({
                                                   first_name: payment_params[:first_name],
                                                   last_name: payment_params[:last_name],
                                                   user_id: current_user.id,
                                               })
      end
    end
  end
end
