-- =====================================================
-- FPT UNIVERSITY 2025 - DATA MIGRATION SCRIPT
-- Version: 1.0.0 - Real Business Data Population
-- Date: 2025-01-27
-- Purpose: Populate database with actual FPT University 2025 data
-- =====================================================

-- ✅ CAMPUSES DATA (Real FPT campuses with correct discount policies)
INSERT INTO campuses (code, name, city, address, phone, email, discount_percentage) VALUES
('HN', 'FPT University Hà Nội', 'Hà Nội', 'Khu Giáo dục và Đào tạo - Khu Công nghệ cao Hòa Lạc - Km29 Đại lộ Thăng Long, H. Thạch Thất, TP. Hà Nội', '024 7300 5588', 'tuyensinhhanoi@fpt.edu.vn', 0),
('HCM', 'FPT University TP.HCM', 'TP. Hồ Chí Minh', 'Lô E2a-7, Đường D1 Khu Công nghệ cao, P. Long Thạnh Mỹ, TP. Thủ Đức, TP. Hồ Chí Minh', '028 7300 5588', 'tuyensinhhcm@fpt.edu.vn', 0),
('DN', 'FPT University Đà Nẵng', 'Đà Nẵng', 'Khu đô thị công nghệ FPT Đà Nẵng, P. Hoà Hải, Q. Ngũ Hành Sơn, TP. Đà Nẵng', '0236 730 0999', 'tuyensinhdanang@fpt.edu.vn', 30),
('CT', 'FPT University Cần Thơ', 'Cần Thơ', 'Số 600 Đường Nguyễn Văn Cừ (nối dài), P. An Bình, Q. Ninh Kiều, TP. Cần Thơ', '0292 730 3636', 'tuyensinhcantho@fpt.edu.vn', 30),
('QN', 'FPT University Quy Nhơn', 'Quy Nhơn', 'Khu đô thị mới An Phú Thịnh, Phường Nhơn Bình & Phường Đống Đa, TP. Quy Nhơn, Bình Định', '0256 7300 999', 'tuyensinhquynhon@fpt.edu.vn', 50);

-- ✅ FOUNDATION FEES DATA (Real 2025 foundation fees by campus)
INSERT INTO foundation_fees (campus_id, year, standard_fee, discounted_fee) VALUES
-- Hà Nội & HCM: No discount
((SELECT id FROM campuses WHERE code = 'HN'), 2025, 13100000, 13100000),
((SELECT id FROM campuses WHERE code = 'HCM'), 2025, 13100000, 13100000),
-- Đà Nẵng & Cần Thơ: 30% discount
((SELECT id FROM campuses WHERE code = 'DN'), 2025, 13100000, 9170000),
((SELECT id FROM campuses WHERE code = 'CT'), 2025, 13100000, 9170000),
-- Quy Nhơn: 50% discount
((SELECT id FROM campuses WHERE code = 'QN'), 2025, 13100000, 6550000);

-- ✅ DEPARTMENTS DATA (Normalized department structure)
INSERT INTO departments (code, name, name_en, description) VALUES
('IT', 'Công nghệ thông tin', 'Information Technology', 'Khoa Công nghệ thông tin - Đào tạo các chuyên ngành về phần mềm, AI, an toàn thông tin'),
('BUS', 'Quản trị kinh doanh', 'Business Administration', 'Khoa Quản trị kinh doanh - Đào tạo các chuyên ngành về marketing, tài chính, logistics'),
('COM', 'Công nghệ truyền thông', 'Communications Technology', 'Khoa Công nghệ truyền thông - Đào tạo về truyền thông đa phương tiện và quan hệ công chúng'),
('LAW', 'Luật', 'Law', 'Khoa Luật - Đào tạo các chuyên ngành luật kinh tế và thương mại quốc tế'),
('LANG', 'Ngôn ngữ', 'Languages', 'Khoa Ngôn ngữ - Đào tạo tiếng Anh và các chương trình song ngữ');

-- ✅ PROGRAMS DATA (Real FPT programs with normalized departments)
INSERT INTO programs (code, name, name_en, department_id, duration_years) VALUES
-- Công nghệ thông tin
('SE', 'Kỹ thuật phần mềm', 'Software Engineering', (SELECT id FROM departments WHERE code = 'IT'), 4),
('IS', 'Hệ thống thông tin', 'Information Systems', (SELECT id FROM departments WHERE code = 'IT'), 4),
('AI', 'Trí tuệ nhân tạo', 'Artificial Intelligence', (SELECT id FROM departments WHERE code = 'IT'), 4),
('IA', 'An toàn thông tin', 'Information Assurance', (SELECT id FROM departments WHERE code = 'IT'), 4),
('DT', 'Công nghệ ô tô số', 'Digital Automotive Technology', (SELECT id FROM departments WHERE code = 'IT'), 4),
('MC', 'Thiết kế vi mạch bán dẫn', 'Microchip Design', (SELECT id FROM departments WHERE code = 'IT'), 4),
('GD', 'Thiết kế mỹ thuật số', 'Graphic Design', (SELECT id FROM departments WHERE code = 'IT'), 4),

-- Quản trị kinh doanh
('MKT', 'Digital Marketing', 'Digital Marketing', (SELECT id FROM departments WHERE code = 'BUS'), 4),
('IB', 'Kinh doanh quốc tế', 'International Business', (SELECT id FROM departments WHERE code = 'BUS'), 4),
('HM', 'Quản trị khách sạn', 'Hotel Management', (SELECT id FROM departments WHERE code = 'BUS'), 4),
('TM', 'Quản trị dịch vụ du lịch và lữ hành', 'Tourism Management', (SELECT id FROM departments WHERE code = 'BUS'), 4),
('CF', 'Tài chính doanh nghiệp', 'Corporate Finance', (SELECT id FROM departments WHERE code = 'BUS'), 4),
('DBF', 'Ngân hàng số - Tài chính', 'Digital Banking and Finance', (SELECT id FROM departments WHERE code = 'BUS'), 4),
('FT', 'Công nghệ tài chính', 'Fintech', (SELECT id FROM departments WHERE code = 'BUS'), 4),
('IF', 'Tài chính đầu tư', 'Investment Finance', (SELECT id FROM departments WHERE code = 'BUS'), 4),
('SCM', 'Logistics & quản lý chuỗi cung ứng toàn cầu', 'Global Supply Chain Management', (SELECT id FROM departments WHERE code = 'BUS'), 4),

-- Công nghệ truyền thông
('MM', 'Truyền thông đa phương tiện', 'Multimedia Communications', (SELECT id FROM departments WHERE code = 'COM'), 4),
('PR', 'Quan hệ công chúng', 'Public Relations', (SELECT id FROM departments WHERE code = 'COM'), 4),

-- Luật
('BL', 'Luật kinh tế', 'Business Law', (SELECT id FROM departments WHERE code = 'LAW'), 4),
('IL', 'Luật thương mại quốc tế', 'International Commercial Law', (SELECT id FROM departments WHERE code = 'LAW'), 4),

-- Ngôn ngữ (Normalized to single department)
('EN', 'Ngôn ngữ Anh', 'English Language', (SELECT id FROM departments WHERE code = 'LANG'), 4),
('CN', 'Song ngữ Trung - Anh', 'Chinese-English Bilingual', (SELECT id FROM departments WHERE code = 'LANG'), 4),
('JP', 'Song ngữ Nhật - Anh', 'Japanese-English Bilingual', (SELECT id FROM departments WHERE code = 'LANG'), 4),
('KR', 'Song ngữ Hàn - Anh', 'Korean-English Bilingual', (SELECT id FROM departments WHERE code = 'LANG'), 4);

-- ✅ PROGRESSIVE TUITION DATA (Real 2025 tuition fees by program and campus)
-- Hà Nội Campus
INSERT INTO progressive_tuition (program_id, campus_id, year, semester_group_1_3_fee, semester_group_4_6_fee, semester_group_7_9_fee) VALUES
-- IT Programs (High tier)
((SELECT id FROM programs WHERE code = 'SE'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'IS'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'AI'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'IA'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'DT'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'MC'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'GD'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
-- Business Programs (High tier)
((SELECT id FROM programs WHERE code = 'MKT'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'IB'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'CF'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'DBF'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'FT'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'IF'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'SCM'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
-- Communications Programs (High tier)
((SELECT id FROM programs WHERE code = 'MM'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'PR'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 31600000, 33600000, 35800000),
-- Law Programs (Low tier)
((SELECT id FROM programs WHERE code = 'BL'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'IL'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 22120000, 23520000, 25060000),
-- Language Programs (Low tier)
((SELECT id FROM programs WHERE code = 'EN'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'CN'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'JP'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'KR'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, 22120000, 23520000, 25060000);

-- TP.HCM Campus (Same as Hà Nội)
INSERT INTO progressive_tuition (program_id, campus_id, year, semester_group_1_3_fee, semester_group_4_6_fee, semester_group_7_9_fee) VALUES
-- IT Programs (High tier)
((SELECT id FROM programs WHERE code = 'SE'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'IS'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'AI'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'IA'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'DT'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'MC'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'GD'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
-- Business Programs (High tier)
((SELECT id FROM programs WHERE code = 'MKT'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'IB'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'CF'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'DBF'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'FT'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'IF'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'SCM'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
-- Communications Programs (High tier)
((SELECT id FROM programs WHERE code = 'MM'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
((SELECT id FROM programs WHERE code = 'PR'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 31600000, 33600000, 35800000),
-- Law Programs (Low tier)
((SELECT id FROM programs WHERE code = 'BL'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'IL'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 22120000, 23520000, 25060000),
-- Language Programs (Low tier)
((SELECT id FROM programs WHERE code = 'EN'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'CN'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'JP'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'KR'), (SELECT id FROM campuses WHERE code = 'HCM'), 2025, 22120000, 23520000, 25060000);

-- Đà Nẵng Campus (30% discount applied)
INSERT INTO progressive_tuition (program_id, campus_id, year, semester_group_1_3_fee, semester_group_4_6_fee, semester_group_7_9_fee) VALUES
-- IT Programs (Discounted from high tier)
((SELECT id FROM programs WHERE code = 'SE'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'AI'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'IA'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'DT'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'MC'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'GD'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
-- Business Programs (Mixed tiers)
((SELECT id FROM programs WHERE code = 'MKT'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'IB'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'HM'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 15480000, 16460000, 17540000), -- Special lower rate
((SELECT id FROM programs WHERE code = 'TM'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 15480000, 16460000, 17540000), -- Special lower rate
((SELECT id FROM programs WHERE code = 'CF'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'DBF'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'FT'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'IF'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'SCM'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
-- Communications Programs
((SELECT id FROM programs WHERE code = 'MM'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'PR'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 22120000, 23520000, 25060000),
-- Law Programs (Lower tier)
((SELECT id FROM programs WHERE code = 'BL'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 15480000, 16460000, 17540000),
((SELECT id FROM programs WHERE code = 'IL'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 15480000, 16460000, 17540000),
-- Language Programs (Lower tier)
((SELECT id FROM programs WHERE code = 'EN'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 15480000, 16460000, 17540000),
((SELECT id FROM programs WHERE code = 'CN'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 15480000, 16460000, 17540000),
((SELECT id FROM programs WHERE code = 'JP'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 15480000, 16460000, 17540000),
((SELECT id FROM programs WHERE code = 'KR'), (SELECT id FROM campuses WHERE code = 'DN'), 2025, 15480000, 16460000, 17540000);

-- Cần Thơ Campus (Same as Đà Nẵng - 30% discount)
INSERT INTO progressive_tuition (program_id, campus_id, year, semester_group_1_3_fee, semester_group_4_6_fee, semester_group_7_9_fee) VALUES
-- IT Programs (Discounted from high tier)
((SELECT id FROM programs WHERE code = 'SE'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'AI'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'IA'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'DT'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'MC'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'GD'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
-- Business Programs (Mixed tiers)
((SELECT id FROM programs WHERE code = 'MKT'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'IB'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'HM'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 15480000, 16460000, 17540000), -- Special lower rate
((SELECT id FROM programs WHERE code = 'TM'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 15480000, 16460000, 17540000), -- Special lower rate
((SELECT id FROM programs WHERE code = 'CF'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'DBF'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'FT'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'IF'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'SCM'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
-- Communications Programs
((SELECT id FROM programs WHERE code = 'MM'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
((SELECT id FROM programs WHERE code = 'PR'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 22120000, 23520000, 25060000),
-- Law Programs (Lower tier)
((SELECT id FROM programs WHERE code = 'BL'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 15480000, 16460000, 17540000),
((SELECT id FROM programs WHERE code = 'IL'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 15480000, 16460000, 17540000),
-- Language Programs (Lower tier)
((SELECT id FROM programs WHERE code = 'EN'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 15480000, 16460000, 17540000),
((SELECT id FROM programs WHERE code = 'CN'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 15480000, 16460000, 17540000),
((SELECT id FROM programs WHERE code = 'JP'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 15480000, 16460000, 17540000),
((SELECT id FROM programs WHERE code = 'KR'), (SELECT id FROM campuses WHERE code = 'CT'), 2025, 15480000, 16460000, 17540000);

-- Quy Nhơn Campus (50% discount - Limited programs)
INSERT INTO progressive_tuition (program_id, campus_id, year, semester_group_1_3_fee, semester_group_4_6_fee, semester_group_7_9_fee) VALUES
-- IT Programs (50% discount from high tier)
((SELECT id FROM programs WHERE code = 'SE'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
((SELECT id FROM programs WHERE code = 'AI'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
((SELECT id FROM programs WHERE code = 'IA'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
((SELECT id FROM programs WHERE code = 'DT'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
((SELECT id FROM programs WHERE code = 'MC'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
((SELECT id FROM programs WHERE code = 'GD'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
-- Business Programs (Limited selection)
((SELECT id FROM programs WHERE code = 'MKT'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
((SELECT id FROM programs WHERE code = 'IB'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
((SELECT id FROM programs WHERE code = 'FT'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
((SELECT id FROM programs WHERE code = 'SCM'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
-- Communications Programs
((SELECT id FROM programs WHERE code = 'MM'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
((SELECT id FROM programs WHERE code = 'PR'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 15800000, 16800000, 17900000),
-- Law Programs (50% discount from low tier)
((SELECT id FROM programs WHERE code = 'BL'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 11060000, 11760000, 12530000),
-- Language Programs (50% discount from low tier)
((SELECT id FROM programs WHERE code = 'EN'), (SELECT id FROM campuses WHERE code = 'QN'), 2025, 11060000, 11760000, 12530000);

-- ✅ PROGRAM CAMPUS AVAILABILITY (Based on real data from reference)
INSERT INTO program_campus_availability (program_id, campus_id, year, is_available) VALUES
-- All programs available at Hà Nội and HCM
((SELECT id FROM programs WHERE code = 'SE'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'IS'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'AI'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'IA'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'DT'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'MC'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'GD'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'MKT'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'IB'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'CF'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'DBF'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'FT'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'IF'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'SCM'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'MM'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'PR'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'BL'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'IL'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'EN'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'CN'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'JP'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true),
((SELECT id FROM programs WHERE code = 'KR'), (SELECT id FROM campuses WHERE code = 'HN'), 2025, true);

-- ✅ SAMPLE SCHOLARSHIPS DATA (Real FPT 2025 scholarships)
INSERT INTO scholarships (code, name, type, recipients, percentage, requirements, year) VALUES
('EXPERT_GLOBAL', 'Học bổng Chuyên gia Toàn cầu', 'Toàn phần + Sinh hoạt phí', 100, 100, 'Giải Nhất/Nhì/Ba HSG cấp quốc gia ngành CNTT + Phỏng vấn', 2025),
('SCHOOL_PATH', 'Học bổng Học đường', 'Toàn phần', 900, 100, 'Top 10 SchoolRank tại trường THPT Khu vực 1', 2025),
('FULL_SCHOLARSHIP', 'Học bổng Toàn phần', 'Toàn phần', 300, 100, 'Olympic quốc tế hoặc HSG Nhất quốc gia hoặc ĐGNL >= 90%', 2025),
('TWO_YEAR', 'Học bổng 2 năm', 'Miễn 2 năm đầu', 500, 100, 'HSG Nhì quốc gia hoặc ĐGNL >= 85%', 2025),
('ONE_YEAR', 'Học bổng 1 năm', 'Miễn năm đầu', 1000, 100, 'HSG Ba quốc gia hoặc ĐGNL >= 80%', 2025);

-- ✅ SAMPLE ADMISSION METHODS DATA (Real FPT 2025 methods)
INSERT INTO admission_methods (method_code, name, requirements, year) VALUES
('HB', 'Xét học bạ THPT', 'Top 50 SchoolRank + Điểm kỳ 2 lớp 12 >= 21', 2025),
('DGNL_HN', 'Đánh giá năng lực ĐHQG Hà Nội', 'Điểm >= 80 (đợt 1) hoặc Top 50', 2025),
('DGNL_HCM', 'Đánh giá năng lực ĐHQG TP.HCM', 'Điểm >= 609 (đợt 1) hoặc Top 50', 2025),
('THPT', 'Thi tốt nghiệp THPT', 'Top 50 với tổ hợp Toán + 2 môn bất kỳ', 2025),
('OTHER', 'Phương thức khác', 'BTEC HND, Melbourne Polytechnic, FUNiX, v.v.', 2025);

-- ✅ REFRESH MATERIALIZED VIEW
REFRESH MATERIALIZED VIEW mv_program_search;

-- ✅ VERIFICATION QUERIES
SELECT 'Data Migration Completed Successfully!' as status;

-- Check campus data
SELECT 'Campus Count: ' || COUNT(*) as info FROM campuses;

-- Check foundation fees
SELECT 'Foundation Fees Count: ' || COUNT(*) as info FROM foundation_fees;

-- Check departments
SELECT 'Departments Count: ' || COUNT(*) as info FROM departments;

-- Check programs
SELECT 'Programs Count: ' || COUNT(*) as info FROM programs;

-- Check tuition data
SELECT 'Progressive Tuition Records: ' || COUNT(*) as info FROM progressive_tuition;

-- Check program availability
SELECT 'Program Availability Records: ' || COUNT(*) as info FROM program_campus_availability;

-- Sample query to verify data integrity
SELECT
    c.name as campus,
    c.discount_percentage,
    ff.standard_fee,
    ff.discounted_fee,
    COUNT(pt.id) as tuition_records
FROM campuses c
LEFT JOIN foundation_fees ff ON ff.campus_id = c.id
LEFT JOIN progressive_tuition pt ON pt.campus_id = c.id
GROUP BY c.id, c.name, c.discount_percentage, ff.standard_fee, ff.discounted_fee
ORDER BY c.name;

-- Verify department normalization
SELECT
    d.code as dept_code,
    d.name as department_name,
    COUNT(p.id) as program_count
FROM departments d
LEFT JOIN programs p ON p.department_id = d.id
GROUP BY d.id, d.code, d.name
ORDER BY program_count DESC;
