require "rails_helper"

RSpec.describe "Api::V1::Schedules", type: :request do
  let(:provider) { create(:provider) }

  describe "api_v1_provider_schedules#index" do
    let!(:slot1) { create(:provider_time_slot, provider: provider) }
    let!(:slot2) { create(:provider_time_slot, provider: provider) }

    it "Lists available time slots" do
      get api_v1_provider_schedules_path(provider_id: provider.id)

      parsed_body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_body.count).to eql 2
      expect(parsed_body[0]["provider_id"]).to eql provider.id
    end
  end

  describe "api_v1_provider_schedules#create" do
    it "Creates a new provider time slot" do
      json_params = {
        start_at: DateTime.current.next_day.change({ hour: 9, min: 0 }),
        end_at: DateTime.current.next_day.change({ hour: 9, min: 15 }),
      }

      expect {
        post api_v1_provider_schedules_path(provider_id: provider.id), params: json_params
      }.to change { ProviderTimeSlot.count }.by(1)

      expect(response).to have_http_status(:ok)
    end
  end
end
