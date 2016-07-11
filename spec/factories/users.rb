FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@domain.com" }
    name 'user'
    password 'password'
    factory :customer_user do
      role 'customer'
    end
    factory :admin_user do
      role 'admin'
    end
  end

end
