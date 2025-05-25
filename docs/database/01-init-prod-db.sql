-- =====================================================
-- PRODUCTION DATABASE INITIALIZATION
-- This file runs first to ensure database exists
-- =====================================================

-- Create production database if it doesn't exist
-- Note: This will only work if we're connected to postgres database
SELECT 'CREATE DATABASE chatbot_prod'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'chatbot_prod')\gexec

-- Connect to the production database
\c chatbot_prod

-- Create a simple test table to verify connection
CREATE TABLE IF NOT EXISTS _db_init_test (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert test record
INSERT INTO _db_init_test DEFAULT VALUES;

-- Log successful initialization
DO $$
BEGIN
    RAISE NOTICE 'Production database chatbot_prod initialized successfully at %', NOW();
END $$;
