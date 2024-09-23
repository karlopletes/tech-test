# frozen_string_literal: true

FactoryBot.define do
  factory :stay do
    studio { nil }
    start_date { Date.current }
    end_date { nil }
  end
end
