-- =====================================================
-- FPT UNIVERSITY 2025 - COMBINED SCHEMA V2 (Production Ready)
-- Version: 1.3.0 - UUID Standard + Manual updated_at + Critical Optimizations
-- Date: 2025-01-27
-- Changes: Added foreign key indexes, data integrity constraints, enhanced monitoring
-- =====================================================

-- ✅ ENABLE EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- ✅ BASE SCHEMA: TABLES
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE programs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    department_id UUID NOT NULL REFERENCES departments(id),
    duration_years INTEGER NOT NULL DEFAULT 4,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE campuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    discount_percentage DECIMAL(5,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE progressive_tuition (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    program_id UUID NOT NULL REFERENCES programs(id),
    campus_id UUID NOT NULL REFERENCES campuses(id),
    year INTEGER NOT NULL,
    semester_group_1_3_fee DECIMAL(15,2) NOT NULL, -- Học kỳ 1,2,3
    semester_group_4_6_fee DECIMAL(15,2) NOT NULL, -- Học kỳ 4,5,6
    semester_group_7_9_fee DECIMAL(15,2) NOT NULL, -- Học kỳ 7,8,9
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(program_id, campus_id, year)
);

CREATE TABLE scholarships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    recipients INTEGER,
    percentage DECIMAL(5,2),
    requirements TEXT,
    year INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE admission_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    method_code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    requirements TEXT,
    year INTEGER NOT NULL DEFAULT 2025,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE foundation_fees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campus_id UUID NOT NULL REFERENCES campuses(id),
    year INTEGER NOT NULL DEFAULT 2025,
    standard_fee DECIMAL(15,2) NOT NULL, -- Học phí kỳ định hướng gốc
    discounted_fee DECIMAL(15,2) NOT NULL, -- Học phí sau khi áp dụng discount
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(campus_id, year)
);

CREATE TABLE program_campus_availability (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    program_id UUID NOT NULL REFERENCES programs(id),
    campus_id UUID NOT NULL REFERENCES campuses(id),
    is_available BOOLEAN DEFAULT true,
    year INTEGER NOT NULL DEFAULT 2025,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(program_id, campus_id, year)
);

-- ✅ VIEW: v_progressive_tuition 
CREATE OR REPLACE VIEW v_progressive_tuition AS
SELECT
    pt.id,
    pt.program_id,
    p.code AS program_code,
    p.name AS program_name,
    pt.year,
    pt.semester_group_1_3_fee,
    pt.semester_group_4_6_fee,
    pt.semester_group_7_9_fee,
    c.id AS campus_id,
    c.code AS campus_code,
    c.name AS campus_name,
    c.discount_percentage,
    ff.standard_fee AS foundation_standard_fee,
    ff.discounted_fee AS foundation_discounted_fee,
    pt.is_active,
    pt.created_at
FROM progressive_tuition pt
JOIN campuses c ON pt.campus_id = c.id
JOIN programs p ON pt.program_id = p.id
LEFT JOIN foundation_fees ff ON ff.campus_id = c.id AND ff.year = pt.year AND ff.is_active = true
WHERE pt.is_active = true AND c.is_active = true AND p.is_active = true;

-- ✅ MATERIALIZED VIEW: mv_program_search 
CREATE MATERIALIZED VIEW mv_program_search AS
SELECT
    p.id,
    p.code,
    p.name,
    p.name_en,
    d.name as department,
    d.code as department_code,
    p.duration_years,
    string_agg(DISTINCT c.code || ':' || c.name, '; ') as campus_info,
    string_agg(DISTINCT c.code, ', ') as campus_codes,
    COUNT(DISTINCT c.id) as campus_count,
    MIN(pt.semester_group_1_3_fee) as min_tuition,
    MAX(pt.semester_group_7_9_fee) as max_tuition,
    AVG((pt.semester_group_1_3_fee + pt.semester_group_4_6_fee + pt.semester_group_7_9_fee) / 3)::DECIMAL(15,2) as avg_tuition,
    p.code || ' ' || p.name || ' ' || COALESCE(p.name_en, '') || ' ' || d.name as search_text
FROM programs p
JOIN departments d ON d.id = p.department_id
LEFT JOIN program_campus_availability pca ON pca.program_id = p.id AND pca.is_available = true
LEFT JOIN campuses c ON c.id = pca.campus_id AND c.is_active = true
LEFT JOIN progressive_tuition pt ON pt.program_id = p.id AND pt.is_active = true
WHERE p.is_active = true AND d.is_active = true
GROUP BY p.id, p.code, p.name, p.name_en, d.name, d.code, p.duration_years;

-- ✅ CRITICAL INDEXES: Foreign Keys (Performance Critical)
CREATE INDEX idx_progressive_tuition_program_id ON progressive_tuition(program_id);
CREATE INDEX idx_progressive_tuition_campus_id ON progressive_tuition(campus_id);
CREATE INDEX idx_program_campus_program_id ON program_campus_availability(program_id);
CREATE INDEX idx_program_campus_campus_id ON program_campus_availability(campus_id);
CREATE INDEX idx_foundation_fees_campus_id ON foundation_fees(campus_id);
CREATE INDEX idx_programs_department_id ON programs(department_id);

-- ✅ QUERY PERFORMANCE INDEXES
CREATE INDEX idx_progressive_tuition_year ON progressive_tuition(year);
CREATE INDEX idx_scholarships_year ON scholarships(year);
CREATE INDEX idx_departments_code ON departments(code);

-- ✅ INDEXES FOR MATERIALIZED VIEWS
CREATE INDEX idx_mv_program_search_code ON mv_program_search(code);
CREATE INDEX idx_mv_program_search_text ON mv_program_search USING gin(search_text gin_trgm_ops);

-- ✅ FUNCTION: search_programs_ranked 
CREATE OR REPLACE FUNCTION search_programs_ranked(
    search_query VARCHAR,
    limit_results INTEGER DEFAULT 20
) RETURNS TABLE (
    code VARCHAR,
    name VARCHAR,
    name_en VARCHAR,
    department VARCHAR,
    campuses TEXT,
    min_tuition DECIMAL,
    max_tuition DECIMAL,
    relevance_score REAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        mv.code,
        mv.name,
        mv.name_en,
        mv.department,
        mv.campus_codes,
        mv.min_tuition,
        mv.max_tuition,
        CASE
            WHEN LOWER(mv.code) = LOWER(search_query) THEN 1.0
            WHEN LOWER(mv.name) = LOWER(search_query) THEN 0.9
            WHEN LOWER(mv.name_en) = LOWER(search_query) THEN 0.9
            ELSE similarity(mv.search_text, search_query)
        END as relevance_score
    FROM mv_program_search mv
    WHERE
        similarity(mv.search_text, search_query) > 0.1
        OR LOWER(mv.code) = LOWER(search_query)
        OR LOWER(mv.search_text) LIKE LOWER('%' || search_query || '%')
    ORDER BY
        relevance_score DESC,
        mv.name
    LIMIT limit_results;
END;
$$ LANGUAGE plpgsql;

-- ✅ CALL TO REFRESH MATERIALIZED VIEWS
CREATE OR REPLACE FUNCTION refresh_materialized_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_program_search;
END;
$$ LANGUAGE plpgsql;

-- ✅ DATA INTEGRITY CONSTRAINTS (Critical for Data Protection)
ALTER TABLE progressive_tuition ADD CONSTRAINT chk_semester_fees_positive
    CHECK (semester_group_1_3_fee > 0 AND semester_group_4_6_fee > 0 AND semester_group_7_9_fee > 0);

ALTER TABLE progressive_tuition ADD CONSTRAINT chk_semester_fee_progression
    CHECK (semester_group_1_3_fee <= semester_group_4_6_fee AND semester_group_4_6_fee <= semester_group_7_9_fee);

ALTER TABLE campuses ADD CONSTRAINT chk_discount_valid
    CHECK (discount_percentage >= 0 AND discount_percentage <= 100);

ALTER TABLE foundation_fees ADD CONSTRAINT chk_foundation_fees_positive
    CHECK (standard_fee > 0 AND discounted_fee > 0);

ALTER TABLE foundation_fees ADD CONSTRAINT chk_foundation_discount_logic
    CHECK (discounted_fee <= standard_fee);

ALTER TABLE scholarships ADD CONSTRAINT chk_percentage_valid
    CHECK (percentage >= 0 AND percentage <= 100);

ALTER TABLE programs ADD CONSTRAINT chk_duration_valid
    CHECK (duration_years BETWEEN 1 AND 6);

ALTER TABLE progressive_tuition ADD CONSTRAINT chk_year_valid
    CHECK (year >= 2020 AND year <= 2035);

ALTER TABLE admission_methods ADD CONSTRAINT chk_year_valid_admission
    CHECK (year >= 2020 AND year <= 2035);

-- ✅ MONITORING
CREATE VIEW v_table_sizes AS
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- ✅ ENHANCED MONITORING VIEW (Updated with departments table)
CREATE VIEW v_data_summary AS
SELECT
    'departments' as table_name,
    COUNT(*) as total_records,
    COUNT(*) FILTER (WHERE is_active = true) as active_records,
    MAX(created_at) as latest_created
FROM departments
UNION ALL
SELECT 'programs', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM programs
UNION ALL
SELECT 'campuses', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM campuses
UNION ALL
SELECT 'scholarships', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM scholarships
UNION ALL
SELECT 'progressive_tuition', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM progressive_tuition
UNION ALL
SELECT 'foundation_fees', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM foundation_fees
UNION ALL
SELECT 'admission_methods', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM admission_methods;

-- =====================================================
-- PHASE 1: CHATBOT ADMISSION APPLICATION SYSTEM
-- Added: applications, users, application_documents tables
-- Focus: Application process workflow for chatbot
-- =====================================================

-- ✅ USER AUTHENTICATION TABLE
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'student' CHECK (role IN ('student', 'admin', 'staff', 'super_admin')),
    is_active BOOLEAN DEFAULT true,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ✅ APPLICATION MANAGEMENT TABLE (Optimized for Chatbot)
CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_code VARCHAR(20) UNIQUE NOT NULL,
    student_name VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    address TEXT,
    high_school_name VARCHAR(255),
    graduation_year INTEGER CHECK (graduation_year >= 2020 AND graduation_year <= 2035),
    program_id UUID NOT NULL REFERENCES programs(id),
    campus_id UUID NOT NULL REFERENCES campuses(id),
    admission_method_id UUID REFERENCES admission_methods(id),
    scholarship_id UUID REFERENCES scholarships(id),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'reviewing', 'approved', 'rejected', 'cancelled')),
    chatbot_session_id VARCHAR(100), -- Track chatbot conversation
    source VARCHAR(50) DEFAULT 'chatbot' CHECK (source IN ('chatbot', 'website', 'manual')),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP,
    processed_by UUID REFERENCES users(id),
    notes TEXT,
    admin_notes TEXT, -- Internal notes for staff
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ✅ DOCUMENT MANAGEMENT TABLE
CREATE TABLE application_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    document_type VARCHAR(50) NOT NULL CHECK (document_type IN ('transcript', 'certificate', 'id_card', 'photo', 'other')),
    file_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    file_size INTEGER CHECK (file_size > 0),
    mime_type VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ✅ FOREIGN KEY INDEXES FOR NEW TABLES (Performance Critical)
CREATE INDEX idx_applications_program_id ON applications(program_id);
CREATE INDEX idx_applications_campus_id ON applications(campus_id);
CREATE INDEX idx_applications_admission_method_id ON applications(admission_method_id);
CREATE INDEX idx_applications_scholarship_id ON applications(scholarship_id);
CREATE INDEX idx_applications_processed_by ON applications(processed_by);
CREATE INDEX idx_applications_email ON applications(email);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_submitted_at ON applications(submitted_at);
CREATE INDEX idx_applications_source ON applications(source);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

CREATE INDEX idx_application_documents_application_id ON application_documents(application_id);
CREATE INDEX idx_application_documents_type ON application_documents(document_type);

-- ✅ QUERY PERFORMANCE INDEXES (Chatbot Optimized)
CREATE INDEX idx_applications_code ON applications(application_code);
CREATE INDEX idx_applications_chatbot_session ON applications(chatbot_session_id);
CREATE INDEX idx_applications_graduation_year ON applications(graduation_year);
CREATE INDEX idx_applications_processed_at ON applications(processed_at);

-- ✅ VIEWS FOR APPLICATION MANAGEMENT (Chatbot Optimized)

-- View: Complete application information with related data
CREATE OR REPLACE VIEW v_applications_complete AS
SELECT
    a.id,
    a.application_code,
    a.student_name,
    a.email,
    a.phone,
    a.date_of_birth,
    a.gender,
    a.address,
    a.high_school_name,
    a.graduation_year,
    a.status,
    a.source,
    a.chatbot_session_id,
    a.submitted_at,
    a.processed_at,
    a.notes,
    a.admin_notes,
    p.code AS program_code,
    p.name AS program_name,
    d.name AS department_name,
    c.code AS campus_code,
    c.name AS campus_name,
    c.city AS campus_city,
    am.name AS admission_method,
    s.name AS scholarship_name,
    s.percentage AS scholarship_percentage,
    u.username AS processed_by_user,
    COUNT(ad.id) AS document_count
FROM applications a
JOIN programs p ON a.program_id = p.id
JOIN departments d ON p.department_id = d.id
JOIN campuses c ON a.campus_id = c.id
LEFT JOIN admission_methods am ON a.admission_method_id = am.id
LEFT JOIN scholarships s ON a.scholarship_id = s.id
LEFT JOIN users u ON a.processed_by = u.id
LEFT JOIN application_documents ad ON a.id = ad.application_id
GROUP BY a.id, a.application_code, a.student_name, a.email, a.phone, a.date_of_birth,
         a.gender, a.address, a.high_school_name, a.graduation_year, a.status, a.source,
         a.chatbot_session_id, a.submitted_at, a.processed_at, a.notes, a.admin_notes,
         p.code, p.name, d.name, c.code, c.name, c.city, am.name, s.name, s.percentage, u.username;

-- View: Application statistics for admin dashboard
CREATE OR REPLACE VIEW v_application_stats AS
SELECT
    COUNT(*) as total_applications,
    COUNT(*) FILTER (WHERE status = 'pending') as pending_count,
    COUNT(*) FILTER (WHERE status = 'reviewing') as reviewing_count,
    COUNT(*) FILTER (WHERE status = 'approved') as approved_count,
    COUNT(*) FILTER (WHERE status = 'rejected') as rejected_count,
    COUNT(*) FILTER (WHERE source = 'chatbot') as chatbot_applications,
    COUNT(*) FILTER (WHERE submitted_at >= CURRENT_DATE) as today_applications,
    COUNT(*) FILTER (WHERE submitted_at >= CURRENT_DATE - INTERVAL '7 days') as week_applications,
    AVG(EXTRACT(EPOCH FROM (processed_at - submitted_at))/3600) FILTER (WHERE processed_at IS NOT NULL) as avg_processing_hours
FROM applications;

-- ✅ FUNCTIONS FOR APPLICATION MANAGEMENT (Chatbot Optimized)

-- Function: Generate unique application code
CREATE OR REPLACE FUNCTION generate_application_code()
RETURNS VARCHAR(20) AS $$
DECLARE
    new_code VARCHAR(20);
    year_suffix VARCHAR(4);
    counter INTEGER;
BEGIN
    year_suffix := EXTRACT(YEAR FROM CURRENT_DATE)::VARCHAR;

    -- Get next sequence number for this year
    SELECT COALESCE(MAX(CAST(SUBSTRING(application_code FROM 4 FOR 6) AS INTEGER)), 0) + 1
    INTO counter
    FROM applications
    WHERE application_code LIKE 'APP' || year_suffix || '%';

    new_code := 'APP' || year_suffix || LPAD(counter::VARCHAR, 6, '0');

    RETURN new_code;
END;
$$ LANGUAGE plpgsql;

-- Function: Update application status with processing info
CREATE OR REPLACE FUNCTION update_application_status(
    app_id UUID,
    new_status VARCHAR(20),
    processor_id UUID DEFAULT NULL,
    admin_note TEXT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE applications
    SET
        status = new_status,
        processed_at = CASE WHEN new_status != 'pending' THEN CURRENT_TIMESTAMP ELSE processed_at END,
        processed_by = CASE WHEN processor_id IS NOT NULL THEN processor_id ELSE processed_by END,
        admin_notes = CASE WHEN admin_note IS NOT NULL THEN admin_note ELSE admin_notes END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = app_id;

    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Function: Get application statistics for dashboard
CREATE OR REPLACE FUNCTION get_application_stats_by_period(days_back INTEGER DEFAULT 30)
RETURNS TABLE (
    period_date DATE,
    total_count INTEGER,
    pending_count INTEGER,
    approved_count INTEGER,
    rejected_count INTEGER,
    chatbot_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        DATE(a.submitted_at) as period_date,
        COUNT(*)::INTEGER as total_count,
        COUNT(*) FILTER (WHERE a.status = 'pending')::INTEGER as pending_count,
        COUNT(*) FILTER (WHERE a.status = 'approved')::INTEGER as approved_count,
        COUNT(*) FILTER (WHERE a.status = 'rejected')::INTEGER as rejected_count,
        COUNT(*) FILTER (WHERE a.source = 'chatbot')::INTEGER as chatbot_count
    FROM applications a
    WHERE a.submitted_at >= CURRENT_DATE - INTERVAL '1 day' * days_back
    GROUP BY DATE(a.submitted_at)
    ORDER BY period_date DESC;
END;
$$ LANGUAGE plpgsql;

-- ✅ UPDATED DATA SUMMARY VIEW (Chatbot Focus)
DROP VIEW v_data_summary;
CREATE VIEW v_data_summary AS
SELECT
    'departments' as table_name,
    COUNT(*) as total_records,
    COUNT(*) FILTER (WHERE is_active = true) as active_records,
    MAX(created_at) as latest_created
FROM departments
UNION ALL
SELECT 'programs', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM programs
UNION ALL
SELECT 'campuses', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM campuses
UNION ALL
SELECT 'scholarships', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM scholarships
UNION ALL
SELECT 'progressive_tuition', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM progressive_tuition
UNION ALL
SELECT 'foundation_fees', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM foundation_fees
UNION ALL
SELECT 'admission_methods', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM admission_methods
UNION ALL
SELECT 'applications', COUNT(*), COUNT(*) FILTER (WHERE status != 'cancelled'), MAX(created_at) FROM applications
UNION ALL
SELECT 'users', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM users
UNION ALL
SELECT 'application_documents', COUNT(*), COUNT(*), MAX(created_at) FROM application_documents;

