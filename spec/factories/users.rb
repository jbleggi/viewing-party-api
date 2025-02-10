# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    username { Faker::Internet.username(specifier: 10) }
    password { Faker::Alphanumeric.alpha(number: 6) }
  end
end
