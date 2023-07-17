# frozen_string_literal: true

class Api::V1::SchedulesController < ApplicationController
  def index
    slots = ProviderTimeSlot.where(
      provider_id: provider_id,
      reserved: false,
      editable: true,
    )

    render json: slots
  end

  def create
    provider = Provider.find(provider_id)

    if !time_slot_validator.is_valid?(start_at, end_at, provider)
      render json: time_slot_validator.error, status: :bad_request and return
    end

    slots = provider_time_slot_factory.make_slots(start_at, end_at, provider)

    render json: slots, status: :ok and return
  end

  private

  def provider_id
    params.require(:provider_id)&.to_i
  end

  def start_at
    params.require(:start_at)
  end

  def end_at
    params.require(:end_at)
  end

  def time_slot_validator
    @time_slot_validator ||= TimeSlotValidator.new
  end

  def provider_time_slot_factory
    @provider_time_slot_factory ||= ProviderTimeSlotFactory.new
  end
end
