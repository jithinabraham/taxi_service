FactoryGirl.define do
  factory :cab do
    name "Cab"
    factory :pink_cab do
      color  'pink'
    end
    sequence(:latitude) { |n| n }
    sequence(:longitude) { |n| n }
    is_available true
    is_deleted false
  end
end
