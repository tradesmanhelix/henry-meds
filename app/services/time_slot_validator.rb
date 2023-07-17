# frozen_string_literal: true

class TimeSlotValidator
  MIN_SLOT_DURATION = 15

  attr_reader :error

  def is_valid?(start_at, end_at, provider)
    slot_start = start_at.to_datetime
    slot_end = end_at.to_datetime

    if !valid_increment?(slot_start) || !valid_increment?(slot_end)
      @error = "Both the start (#{start_at}) and end (#{end_at}) time must be in 5 minute increments"
      return false
    end

    # end_time - start_time >= 15 minutes (at least one usable slot)
    if minutes_difference(slot_start, slot_end) < MIN_SLOT_DURATION
      @error = "The start (#{start_at}) and end (#{end_at}) times must be at least 15 minutes apart"
      return false
    end

    # Does not overlap existing provider_time_slots start or end times
    if overlapping_for_range(start_at, end_at, provider).count.positive?
      @error = "Overlaps existing"
      return false
    end

    return true
  end

  def overlapping_for_range(start_at, end_at, provider)
    slot_start = start_at.to_datetime
    slot_end = end_at.to_datetime

    ProviderTimeSlot.where(provider: provider).where("start_at < ? AND ? < end_at", slot_end, slot_start)
  end

  def overlapping_for_slot(slot)
    overlapping_for_range(slot.start_at, slot.end_at, slot.provider).where.not(id: slot.id)
  end

  private

  def valid_increment?(time)
    begin
      # 5 min increments, i.e., start_time and end_time both end in 0 or 5
      time.min % 5 == 0
    rescue StandardError
      false
    end
  end

  def minutes_difference(slot_start, slot_end)
    begin
      # Difference in days so need to multiply by num hours in day and num minuts per hour
      ((slot_end - slot_start) * 24 * 60).to_i
    rescue StandardError
      0
    end
  end
end
