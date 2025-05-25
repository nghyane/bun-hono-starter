-- =====================================================
-- FPT UNIVERSITY 2025 - DATABASE SCHEMA
-- Version: 1.0.0
-- Date: 2025-01-27
-- Purpose: Core database schema for FPT University system
-- =====================================================

-- ✅ CORE TABLES

-- Departments table
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Programs table
CREATE TABLE programs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    department_id UUID NOT NULL REFERENCES departments(id),
    duration_years INTEGER NOT NULL DEFAULT 4,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Campuses table
CREATE TABLE campuses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
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

-- Progressive tuition table
CREATE TABLE progressive_tuition (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
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

-- Scholarships table
CREATE TABLE scholarships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
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

-- Admission methods table
CREATE TABLE admission_methods (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
    method_code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    requirements TEXT,
    year INTEGER NOT NULL DEFAULT 2025,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Foundation fees table
CREATE TABLE foundation_fees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
    campus_id UUID NOT NULL REFERENCES campuses(id),
    year INTEGER NOT NULL DEFAULT 2025,
    standard_fee DECIMAL(15,2) NOT NULL, -- Học phí kỳ định hướng gốc
    discounted_fee DECIMAL(15,2) NOT NULL, -- Học phí sau khi áp dụng discount
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(campus_id, year)
);

-- Program campus availability table
CREATE TABLE program_campus_availability (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
    program_id UUID NOT NULL REFERENCES programs(id),
    campus_id UUID NOT NULL REFERENCES campuses(id),
    is_available BOOLEAN DEFAULT true,
    year INTEGER NOT NULL DEFAULT 2025,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(program_id, campus_id, year)
);

-- ✅ APPLICATION SYSTEM TABLES

-- Users table for authentication
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'student' CHECK (role IN ('student', 'admin', 'staff', 'super_admin')),
    is_active BOOLEAN DEFAULT true,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Applications table (optimized for chatbot)
CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
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

-- Application documents table
CREATE TABLE application_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v8(),
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
