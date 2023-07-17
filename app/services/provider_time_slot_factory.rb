# frozen_string_literal: true

class ProviderTimeSlotFactory
  def make_slots(start_at, end_at, provider)
    slot_start = start_at.to_datetime
    slot_end = end_at.to_datetime

    # Create records in provider_time_slots for given time span in 15 min increments
    new_slot_start = slot_start

    while new_slot_start <= slot_end
      if new_slot_start + 15.minutes <= slot_end
        new_slot = ProviderTimeSlot.create(
          start_at: new_slot_start,
          end_at: new_slot_start + 15.minutes,
          provider: provider,
        )
      end

      # Increment start_time by 5 mins
      new_slot_start += 5.minutes
    end
  end
end
