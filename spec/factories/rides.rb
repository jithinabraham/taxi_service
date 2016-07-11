FactoryGirl.define do
  factory :ride do
    association :user ,factory: :customer_user
    association :cab ,factory: :cab
    source_latitude 1.5
    source_longitude 1.5
    destination_latitude 1.5
    destination_longitude 1.5
    duration "00:21:50"
    distance 2
    amount 100
    is_canceled false
    is_done false
  end
end
