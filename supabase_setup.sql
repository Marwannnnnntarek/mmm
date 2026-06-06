-- Run this in: Supabase Dashboard → SQL Editor → New Query

-- 1. Create the registration_requests table
CREATE TABLE IF NOT EXISTS registration_requests (
  id             UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at     TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  parent_name    TEXT        NOT NULL,
  parent_phone   TEXT        NOT NULL,
  child_name     TEXT        NOT NULL,
  child_age      INTEGER     NOT NULL CHECK (child_age BETWEEN 1 AND 99),
  child_gender   TEXT        NOT NULL CHECK (child_gender IN ('male', 'female')),
  swimming_level TEXT        NOT NULL CHECK (swimming_level IN ('beginner', 'intermediate', 'advanced')),
  preferred_branch TEXT      NOT NULL,
  notes          TEXT
);

-- 2. Enable Row Level Security
ALTER TABLE registration_requests ENABLE ROW LEVEL SECURITY;

-- 3. Allow the anonymous (public) role to insert rows
--    This is required for the mobile app to submit without authentication.
CREATE POLICY "anon_can_insert"
  ON registration_requests
  FOR INSERT
  TO anon
  WITH CHECK (true);
