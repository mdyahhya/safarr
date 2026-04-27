-- 1. Create Passenger Users Table
CREATE TABLE IF NOT EXISTS safarr_users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name TEXT NOT NULL,
    mobile TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    address TEXT,
    emergency_contact1 TEXT,
    emergency_contact2 TEXT,
    email TEXT,
    push_sub TEXT, -- To receive notifications from driver (e.g. driver accepted)
    profile_image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Update Ride Bookings Table for Multi-Store/Multi-Role logic
-- Ensure these columns exist for the passenger details in the ride record
ALTER TABLE ride_bookings ADD COLUMN IF NOT EXISTS customer_id UUID;
ALTER TABLE ride_bookings ADD COLUMN IF NOT EXISTS customer_name TEXT;
ALTER TABLE ride_bookings ADD COLUMN IF NOT EXISTS customer_mobile TEXT;
ALTER TABLE ride_bookings ADD COLUMN IF NOT EXISTS customer_profile_image TEXT;

-- Enhance ride_bookings to store Driver contact/identification info directly at acceptance
ALTER TABLE ride_bookings ADD COLUMN IF NOT EXISTS driver_name TEXT;
ALTER TABLE ride_bookings ADD COLUMN IF NOT EXISTS driver_mobile TEXT;
ALTER TABLE ride_bookings ADD COLUMN IF NOT EXISTS auto_number TEXT;
ALTER TABLE ride_bookings ADD COLUMN IF NOT EXISTS driver_profile_image TEXT;

-- 3. Ensure Driver table has push_sub if not already there
ALTER TABLE auto_drivers ADD COLUMN IF NOT EXISTS push_sub TEXT;
