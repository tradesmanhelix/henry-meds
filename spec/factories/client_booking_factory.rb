FactoryBot.define do
  factory :client_booking do
    client
    provider_time_slot

    expired { false }

    confirmed { false }
    confirmed_at { nil }
  end
end
