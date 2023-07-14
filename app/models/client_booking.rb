class ClientBooking < ApplicationRecord
  belongs_to :client
  belongs_to :provider_time_slot
end
