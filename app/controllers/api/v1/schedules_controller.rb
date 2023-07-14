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
  end

  private

  def provider_id
    params.require(:provider_id)&.to_i
  end
end
