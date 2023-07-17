require 'rails_helper'

RSpec.describe "Api::V1::Appointments", type: :request do
  let(:provider) { create(:provider) }
  let(:client) { create(:client) }
  let(:hour) { (24.hours.from_now + 1.hour).hour }

  describe "api_v1_provider_appointment#reserve" do
    let!(:slot1) do
      create(
        :provider_time_slot,
        provider: provider,
        start_at: DateTime.current.next_day.change({hour: hour, min: 0}),
        end_at: DateTime.current.next_day.change({hour: hour, min: 15}),
      )
    end
    let!(:slot2) do
      create(
        :provider_time_slot,
        provider: provider,
        start_at: DateTime.current.next_day.change({hour: hour, min: 5}),
        end_at: DateTime.current.next_day.change({hour: hour, min: 20}),
      )
    end
    let!(:slot3) do
      create(
        :provider_time_slot,
        provider: provider,
        start_at: DateTime.current.next_day.change({hour: hour, min: 15}),
        end_at: DateTime.current.next_day.change({hour: hour, min: 30}),
      )
    end

    it "Reserves an appointment" do
      json_params = {
        client_id: client.id,
      }

      expect {
        post api_v1_provider_appointment_reserve_path(provider_id: provider.id, appointment_id: slot1.id), params: json_params
      }.to change { ClientBooking.count }.by(1)

      expect(response).to have_http_status(:ok)

      expect(slot1.reload.reserved).to be true
      expect(slot2.reload.reserved).to be true
      expect(slot3.reload.reserved).to be false
    end
  end

  describe "api_v1_provider_appointment#confirm" do
    let(:slot) do
      create(
        :provider_time_slot,
        provider: provider,
        start_at: DateTime.current.next_day.change({hour: hour, min: 0}).utc,
        end_at: DateTime.current.next_day.change({hour: hour, min: 15}).utc,
        reserved: true,
        reserved_at: Time.current.utc,
      )
    end

    let(:booking) { create(:client_booking, provider_time_slot: slot, client: client) }

    it "Confirms an appointment" do
      json_params = {
        booking_id: booking.id,
        client_id: client.id,
      }

      post api_v1_provider_appointment_confirm_path(provider_id: provider.id, appointment_id: slot.id), params: json_params

      expect(response).to have_http_status(:ok)
      expect(booking.reload.confirmed).to be true
      expect(booking.reload.confirmed_at).not_to be nil
    end
  end
end
