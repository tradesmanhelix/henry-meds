# Henry Meds Coding Challenge

## Initial Set Up

Install Docker

Install asdf

Install Ruby plugin

Install language runtimes

Set up app:

bundle install

make build

## Running the Application

./bin/rails server

## Approach

---

```
Base Namespace:
/api/v1/providers

/api/v1/providers/{id}/schedules 
  - GET: Display provider_time_slots for a provider
    - Params:
      - ?date="2023-08-01": Filter by date
    - Returns:
      - provider_time_slots.as_json where reserved == false and editable == true
  - POST: Create provider_time_slots for a provider:
    - Params:
      - start_time
      - end_time
    - Requirements:
      - Validate:
        - Does not overlap existing provider_time_slots start or end times
        - 5 min increments, i.e., start_time and end_time both end in 0 or 5
        - end_time - start_time >= 15 minutes (at least one usable slot)
      - Once validated, "slotify":
        - Create records in provider_time_slots for given time span in 15 min increments
    - Returns:
      - HTTP operation result (200, 400, etc.)
      
/api/v1/providers/{id}/appointments/{id}/reserve
  - POST: Reserve a slot:
    - Params:
      - slot_id
      - client_id
    - Requirements:
      - Validate:
        - slot.reserved == false && slot.editable == true
        - slot.start_at >= 24.hours.from_now
      - Reserve
        - Set slot.editable == false
          - Set slot reserved and reserved_at
          - Create client_booking for slot and given client_id
        - Set slot.editable == true
        - For all **unusable_slots:
          - Set slot.editable == false
            - Set reserved and reserved_at
          - Set slot.editable == true
    - Returns:
      - client_booking_id on HTTP:200
    
/api/v1/providers/{id}/appointments/{id}/confirm
  - POST: Confirm a reserved slot:
    - Params:
      - client_booking_id
    - Requirements:
      - Bail unless slot.editable == true
      - Set client_booking.confirmed and confirmed_at
    - Returns:
      - HTTP operation result (200, 400, etc.)
   
---
      
Cron that runs every minute:
  - For client_bookings where confirmed == false
    - If client_booking.provider_time_slot.reserved_at > 30.minutes.ago
      - Set slot.editable = false
        - Change slot.reserved = false
        - Change slot.reserved_at = nil
        - Set the corresponding client_booking.expired == true
      - Set slot.editable = true
      - For all previously **unusable_slots, reset reserved and reserved_at
      
---
      
**unusable_slots: Any slot whose start or end time is in the non-inclusive time interval of a reserved slot

---

Database Outline:
      
  providers
    id

  clients
    id

  provider_time_slots
    id
    provider_id
    
    start_at
    end_at
    
    editable=true
    
    reserved=false
    reserved_at=nil
    
  client_bookings
    id
    client_id
    provider_time_slot_id
    
    expired=false
    
    confirmed=false
    confirmed_at=nil
```
