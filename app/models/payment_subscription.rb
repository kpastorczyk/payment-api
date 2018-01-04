class PaymentSubscription < ApplicationRecord
  validates_presence_of :user_id
end
