FactoryGirl.define do
  factory :user do
		email "tom@onet.pl"
  	password { "password" }
  	password_confirmation { "password" }
  end
end
