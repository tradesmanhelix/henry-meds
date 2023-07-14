class ProviderTimeSlot < ApplicationRecord
  belongs_to :provider

  has_one :client_booking
end
