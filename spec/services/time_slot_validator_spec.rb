require "rails_helper"

RSpec.describe "TimeSlotValidator" do
  subject(:tested) { TimeSlotValidator.new }
  let(:provider) { create(:provider) }

  describe "#is_valid?" do
    context "Valid time slot" do
      it "Passes validation" do
        slot_start = DateTime.current.next_day.change({hour: 9, min: 0}).to_s
        slot_end = DateTime.current.next_day.change({hour: 17, min: 0}).to_s

        result = tested.is_valid?(slot_start, slot_end, provider)

        expect(result).to be true
      end
    end

    context "Invalid time slot" do
      context "Invalid time increment" do
        it "Fails validation with an invalid start increment" do
          slot_start = DateTime.current.next_day.change({hour: 9, min: 17}).to_s
          slot_end = DateTime.current.next_day.change({hour: 10, min: 0}).to_s

          result = tested.is_valid?(slot_start, slot_end, provider)

          expect(result).to be false
          expect(tested.error).to match(/time must be in 5 minute increments/)
        end
      end

      context "Invalid length of time" do
        it "Fails validation with an invalid length" do
          slot_start = DateTime.current.next_day.change({hour: 18, min: 0}).to_s
          slot_end = DateTime.current.next_day.change({hour: 18, min: 10}).to_s

          result = tested.is_valid?(slot_start, slot_end, provider)

          expect(result).to be false
          expect(tested.error).to match(/times must be at least 15 minutes apart/)
        end
      end

      context "Overlaps existing time slots" do
        let!(:existing_slot) do
          create(
            :provider_time_slot,
            provider: provider,
            start_at: DateTime.current.next_day.change({hour: 17, min: 15}),
            end_at: DateTime.current.next_day.change({hour: 17, min: 30}),
          )
        end

        it "Fails validation with an overlap error" do
          slot_start = DateTime.current.next_day.change({hour: 9, min: 0}).to_s
          slot_end = DateTime.current.next_day.change({hour: 17, min: 30}).to_s

          result = tested.is_valid?(slot_start, slot_end, provider)

          expect(result).to be false
          expect(tested.error).to match(/Overlaps existing/)
        end
      end
    end
  end
end
