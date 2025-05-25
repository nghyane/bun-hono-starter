-- =====================================================
-- INDEXES AND CONSTRAINTS
-- Version: 1.0.0
-- Date: 2025-01-27
-- Purpose: Performance indexes and data integrity constraints
-- =====================================================

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

-- ✅ APPLICATION SYSTEM INDEXES
CREATE INDEX idx_applications_program_id ON applications(program_id);
CREATE INDEX idx_applications_campus_id ON applications(campus_id);
CREATE INDEX idx_applications_admission_method_id ON applications(admission_method_id);
CREATE INDEX idx_applications_scholarship_id ON applications(scholarship_id);
CREATE INDEX idx_applications_processed_by ON applications(processed_by);
CREATE INDEX idx_applications_email ON applications(email);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_submitted_at ON applications(submitted_at);
CREATE INDEX idx_applications_source ON applications(source);
CREATE INDEX idx_applications_code ON applications(application_code);
CREATE INDEX idx_applications_chatbot_session ON applications(chatbot_session_id);
CREATE INDEX idx_applications_graduation_year ON applications(graduation_year);
CREATE INDEX idx_applications_processed_at ON applications(processed_at);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

CREATE INDEX idx_application_documents_application_id ON application_documents(application_id);
CREATE INDEX idx_application_documents_type ON application_documents(document_type);

-- ✅ DATA INTEGRITY CONSTRAINTS (Critical for Data Protection)

-- Progressive tuition constraints
ALTER TABLE progressive_tuition ADD CONSTRAINT chk_semester_fees_positive
    CHECK (semester_group_1_3_fee > 0 AND semester_group_4_6_fee > 0 AND semester_group_7_9_fee > 0);

ALTER TABLE progressive_tuition ADD CONSTRAINT chk_semester_fee_progression
    CHECK (semester_group_1_3_fee <= semester_group_4_6_fee AND semester_group_4_6_fee <= semester_group_7_9_fee);

-- Campus constraints
ALTER TABLE campuses ADD CONSTRAINT chk_discount_valid
    CHECK (discount_percentage >= 0 AND discount_percentage <= 100);

-- Foundation fees constraints
ALTER TABLE foundation_fees ADD CONSTRAINT chk_foundation_fees_positive
    CHECK (standard_fee > 0 AND discounted_fee > 0);

ALTER TABLE foundation_fees ADD CONSTRAINT chk_foundation_discount_logic
    CHECK (discounted_fee <= standard_fee);

-- Scholarship constraints
ALTER TABLE scholarships ADD CONSTRAINT chk_percentage_valid
    CHECK (percentage >= 0 AND percentage <= 100);

-- Program constraints
ALTER TABLE programs ADD CONSTRAINT chk_duration_valid
    CHECK (duration_years BETWEEN 1 AND 6);

-- Year validation constraints
ALTER TABLE progressive_tuition ADD CONSTRAINT chk_year_valid
    CHECK (year >= 2020 AND year <= 2035);

ALTER TABLE admission_methods ADD CONSTRAINT chk_year_valid_admission
    CHECK (year >= 2020 AND year <= 2035);
