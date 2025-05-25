-- =====================================================
-- POSTGRESQL EXTENSIONS SETUP
-- Version: 1.0.0
-- Date: 2025-01-27
-- Purpose: Enable required PostgreSQL extensions
-- =====================================================

-- ✅ ENABLE CORE EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";    -- UUID generation functions
CREATE EXTENSION IF NOT EXISTS pg_trgm;        -- Trigram matching for text search
CREATE EXTENSION IF NOT EXISTS btree_gist;     -- Additional B-tree operators

-- ✅ EXTENSION VERIFICATION
DO $$
BEGIN
    -- Verify extensions are loaded
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'uuid-ossp') THEN
        RAISE EXCEPTION 'Extension uuid-ossp failed to load';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_trgm') THEN
        RAISE EXCEPTION 'Extension pg_trgm failed to load';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'btree_gist') THEN
        RAISE EXCEPTION 'Extension btree_gist failed to load';
    END IF;
    
    RAISE NOTICE 'All extensions loaded successfully';
END
$$;
