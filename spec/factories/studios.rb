# frozen_string_literal: true

FactoryBot.define do
  factory :studio do
    name { Faker::Name.name }
    description { 'Studio description' }
  end
end
