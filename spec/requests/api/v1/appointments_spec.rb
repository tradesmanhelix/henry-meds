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

    it "Reserves an appointments" do
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
  end
end
