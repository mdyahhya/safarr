-- ==========================================
-- SAFARR DATABASE MIGRATIONS HISTORY
-- ==========================================

-- 1. ADD TRANSLATION SUPPORT TO MESSAGES
-- Added columns to store AI-translated text and identify the source language.
ALTER TABLE safarr_messages 
ADD COLUMN IF NOT EXISTS translated_text TEXT,
ADD COLUMN IF NOT EXISTS source_lang VARCHAR(20);

-- 2. ADD PREFERRED LANGUAGE TO USERS
-- Added a column to store the passenger's language preference.
ALTER TABLE safarr_users 
ADD COLUMN IF NOT EXISTS preferred_language VARCHAR(20) DEFAULT 'English';

-- 3. FIX AUTO_DRIVERS LANGUAGE CONSTRAINTS
-- Removed old restrictive constraints and added a flexible one that supports
-- the languages used in the AI translation system.
-- (Includes data cleanup to ensure existing rows don't block the migration)

ALTER TABLE auto_drivers 
DROP CONSTRAINT IF EXISTS auto_drivers_language_check;

UPDATE auto_drivers 
SET language = 'English' 
WHERE language NOT IN ('English', 'Hindi', 'Marathi', 'english', 'hindi', 'marathi') 
   OR language IS NULL;

ALTER TABLE auto_drivers 
ADD CONSTRAINT auto_drivers_language_check 
CHECK (language IN ('English', 'Hindi', 'Marathi', 'english', 'hindi', 'marathi'));

-- ==========================================
-- 4. RLS POLICIES (SECURITY)
-- ==========================================

-- Enable RLS and Create Permissive Policies
ALTER TABLE auto_drivers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all on auto_drivers" ON auto_drivers FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE auto_vehicles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all on auto_vehicles" ON auto_vehicles FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE ride_bookings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all on ride_bookings" ON ride_bookings FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE driver_notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all on driver_notifications" ON driver_notifications FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE safarr_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can chat" ON safarr_messages FOR ALL USING (true) WITH CHECK (true);

-- ==========================================
-- END OF HISTORY
-- ==========================================
