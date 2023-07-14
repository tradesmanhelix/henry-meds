require "rails_helper"

RSpec.describe "Api::V1::Schedules", type: :request do
  let(:provider) { create(:provider) }
  let!(:slot1) { create(:provider_time_slot, provider: provider) }
  let!(:slot2) { create(:provider_time_slot, provider: provider) }

  describe "api_v1_provider_schedules#index" do
    it "Lists available time slots" do
      get api_v1_provider_schedules_path(provider_id: provider.id)

      parsed_body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_body.count).to eql 2
      expect(parsed_body[0]["provider_id"]).to eql provider.id
    end
  end
end
