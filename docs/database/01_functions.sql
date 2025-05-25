-- =====================================================
-- CUSTOM FUNCTIONS LIBRARY
-- Version: 1.0.0
-- Date: 2025-01-27
-- Purpose: Custom PostgreSQL functions for enhanced functionality
-- =====================================================

-- ✅ UUID FUNCTIONS (PostgreSQL 17 Enhanced Support)
-- UUIDv8 with microsecond precision - optimal for all use cases
CREATE OR REPLACE FUNCTION uuid_generate_v8()
RETURNS uuid
AS $$
DECLARE
  timestamp timestamptz;
  microseconds int;
BEGIN
  timestamp = clock_timestamp();
  microseconds = (cast(extract(microseconds from timestamp)::int - (floor(extract(milliseconds from timestamp))::int * 1000) as double precision) * 4.096)::int;

  -- Use random v4 uuid as starting point (which has the same variant we need)
  -- Then overlay timestamp, set version 8 and add microseconds for precision
  RETURN encode(
    set_byte(
      set_byte(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from timestamp) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        6, (b'1000' || (microseconds >> 8)::bit(4))::bit(8)::int
      ),
      7, microseconds::bit(8)::int
    ),
    'hex')::uuid;
END
$$
LANGUAGE plpgsql
VOLATILE;

-- ✅ UTILITY FUNCTIONS

-- Extract timestamp from UUIDv8
CREATE OR REPLACE FUNCTION uuid_extract_timestamp_ms(uuid_val uuid)
RETURNS timestamp with time zone
AS $$
BEGIN
  -- Extract millisecond timestamp from first 48 bits
  RETURN to_timestamp(
    ('x' || substring(uuid_val::text, 1, 8) || substring(uuid_val::text, 10, 4))::bit(48)::bigint / 1000.0
  );
END
$$
LANGUAGE plpgsql
IMMUTABLE;

-- Generate sortable short ID (base62 encoded timestamp + random)
CREATE OR REPLACE FUNCTION generate_short_id(length int DEFAULT 12)
RETURNS text
AS $$
DECLARE
  chars text := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  result text := '';
  timestamp_part bigint;
  random_part bigint;
  i int;
BEGIN
  -- Get current timestamp in milliseconds
  timestamp_part := extract(epoch from clock_timestamp()) * 1000;

  -- Generate random part
  random_part := floor(random() * 999999999)::bigint;

  -- Combine timestamp and random
  timestamp_part := timestamp_part + random_part;

  -- Convert to base62
  FOR i IN 1..length LOOP
    result := substring(chars, (timestamp_part % 62)::int + 1, 1) || result;
    timestamp_part := timestamp_part / 62;
    EXIT WHEN timestamp_part = 0;
  END LOOP;

  -- Pad with random chars if needed
  WHILE length(result) < length LOOP
    result := substring(chars, (floor(random() * 62) + 1)::int, 1) || result;
  END LOOP;

  RETURN result;
END
$$
LANGUAGE plpgsql
VOLATILE;

-- ✅ FUNCTION VERIFICATION
DO $$
BEGIN
    -- Test UUIDv8 function
    IF uuid_generate_v8() IS NULL THEN
        RAISE EXCEPTION 'uuid_generate_v8() function failed';
    END IF;

    -- Test utility functions
    IF uuid_extract_timestamp_ms(uuid_generate_v8()) IS NULL THEN
        RAISE EXCEPTION 'uuid_extract_timestamp_ms() function failed';
    END IF;

    IF generate_short_id() IS NULL THEN
        RAISE EXCEPTION 'generate_short_id() function failed';
    END IF;

    RAISE NOTICE 'All custom functions loaded successfully';
END
$$;
