-- =====================================================
-- VIEWS AND STORED PROCEDURES
-- Version: 1.0.0
-- Date: 2025-01-27
-- Purpose: Database views and stored procedures for business logic
-- =====================================================

-- ✅ CORE BUSINESS VIEWS

-- Progressive tuition view with related data
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

-- Materialized view for program search optimization
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

-- Index for materialized view
CREATE INDEX idx_mv_program_search_code ON mv_program_search(code);
CREATE INDEX idx_mv_program_search_text ON mv_program_search USING gin(search_text gin_trgm_ops);

-- ✅ APPLICATION MANAGEMENT VIEWS

-- Complete application information view
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

-- Application statistics view
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

-- ✅ MONITORING VIEWS

-- Table sizes monitoring
CREATE VIEW v_table_sizes AS
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Data summary view
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
SELECT 'users', COUNT(*), COUNT(*) FILTER (WHERE is_active = true), MAX(created_at) FROM users
UNION ALL
SELECT 'applications', COUNT(*), COUNT(*) FILTER (WHERE status != 'cancelled'), MAX(created_at) FROM applications
UNION ALL
SELECT 'application_documents', COUNT(*), COUNT(*), MAX(created_at) FROM application_documents;

-- ✅ STORED PROCEDURES

-- Search programs with ranking
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

-- Refresh materialized views
CREATE OR REPLACE FUNCTION refresh_materialized_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_program_search;
END;
$$ LANGUAGE plpgsql;

-- Generate unique application code
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

-- Update application status with processing info
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

-- Get application statistics by period
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
