FactoryBot.define do
  factory :provider_time_slot do
    provider

    start_at { DateTime.current.next_day.change({hour: 9, minute: 0}) }
    end_at { DateTime.current.next_day.change({hour: 5, minute: 0}) }

    editable { true }

    reserved { false }
    reserved_at { nil }
  end
end
