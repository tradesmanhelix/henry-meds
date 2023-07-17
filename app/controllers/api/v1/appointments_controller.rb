class Api::V1::AppointmentsController < ApplicationController
  def reserve
    client = Client.find(client_id)
    provider = Provider.find(provider_id)
    slot = ProviderTimeSlot.find(provider_time_slot_id)

    if !slot.editable
      render json: "Slot cannot be updated at this time", status: :locked and return
    end

    if slot.reserved
      render json: "Slot is already reserved", status: :conflict and return
    end

    if slot.start_at < 24.hours.from_now
      render json: "Slots cannot be booked less than 24 hours in advance", status: :bad_request and return
    end

    slot.update!(editable: false)
    slot.reserved = true
    slot.reserved_at = Time.current
    slot.save!

    booking = ClientBooking.create(
      provider_time_slot: slot,
      client: client,
    )

    time_slot_validator.overlapping_for_slot(slot).find_each do |overlapping|
      overlapping.update!(reserved: true)
    end

    render json: { booking_id: booking.id }, status: :ok and return
  end

  def confirm
  end

  private

  def client_id
    params.require(:client_id)&.to_i
  end

  def provider_id
    params.require(:provider_id)&.to_i
  end

  def provider_time_slot_id
    params.require(:appointment_id)&.to_i
  end

  def time_slot_validator
    @time_slot_validator ||= TimeSlotValidator.new
  end
end
