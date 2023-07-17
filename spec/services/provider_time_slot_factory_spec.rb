require "rails_helper"

RSpec.describe "ProviderTimeSlotFactory" do
  subject(:tested) { ProviderTimeSlotFactory.new }

  let(:provider) { create(:provider) }

  describe "#make_slots" do
    context "Valid time slot" do
      it "Passes validation" do
        slot_start = DateTime.current.next_day.change({hour: 8, min: 0})
        slot_end = DateTime.current.next_day.change({hour: 9, min: 0})

        expect {
          tested.make_slots(slot_start.to_s, slot_end.to_s, provider)
        }.to change { ProviderTimeSlot.count }.by(10)

        expect(ProviderTimeSlot.first.start_at.min).to eql(slot_start.min)
        expect(ProviderTimeSlot.first.end_at.min).to eql(slot_start.min + 15)

        expect(ProviderTimeSlot.last.end_at.hour).to eql(slot_end.hour)
        expect(ProviderTimeSlot.last.end_at.min).to eql(slot_end.min)
      end
    end
  end
end
