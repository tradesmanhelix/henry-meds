class CreateClientBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :client_bookings do |t|
      t.references :client, null: false, foreign_key: true
      t.references :provider_time_slot, null: false, foreign_key: true
      t.boolean :expired, null: false, default: false
      t.boolean :confirmed, null: false, default: false
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
