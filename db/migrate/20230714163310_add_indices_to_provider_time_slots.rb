class AddIndicesToProviderTimeSlots < ActiveRecord::Migration[7.0]
  def change
    change_table :provider_time_slots do |t|
      t.index :start_at
      t.index :end_at
    end
  end
end
