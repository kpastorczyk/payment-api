require 'rails_helper'

RSpec.describe PaymentSubscription, type: :model do
  it { should validate_presence_of(:user_id) }
end
