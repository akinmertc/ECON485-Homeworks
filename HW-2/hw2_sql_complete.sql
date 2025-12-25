-- ============================================================================
-- ECON485 Fall 2025 – Homework Assignment 2
-- Course Registration System – SQL Implementation
-- ============================================================================

-- ============================================================================
-- PART 1a: CREATE TABLES
-- ============================================================================

-- Drop existing tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS Registrations CASCADE;
DROP TABLE IF EXISTS CompletedCourses CASCADE;
DROP TABLE IF EXISTS Prerequisites CASCADE;
DROP TABLE IF EXISTS Sections CASCADE;
DROP TABLE IF EXISTS Students CASCADE;
DROP TABLE IF EXISTS Courses CASCADE;
DROP TABLE IF EXISTS Instructors CASCADE;
DROP TABLE IF EXISTS Semesters CASCADE;

-- Create STUDENTS table
CREATE TABLE Students (
    StudentID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    StudentNumber VARCHAR(20) UNIQUE NOT NULL,
    EnrollmentYear INT NOT NULL
);

-- Create COURSES table
CREATE TABLE Courses (
    CourseID SERIAL PRIMARY KEY,
    CourseCode VARCHAR(20) UNIQUE NOT NULL,
    CourseTitle VARCHAR(200) NOT NULL,
    Credits INT NOT NULL,
    ECTSCredits INT NOT NULL,
    Department VARCHAR(100) NOT NULL,
    Description TEXT
);

-- Create SEMESTERS table
CREATE TABLE Semesters (
    SemesterID SERIAL PRIMARY KEY,
    SemesterName VARCHAR(50) NOT NULL,
    AcademicYear VARCHAR(10) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);

-- Create INSTRUCTORS table
CREATE TABLE Instructors (
    InstructorID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Department VARCHAR(100) NOT NULL,
    Title VARCHAR(50)
);

-- Create SECTIONS table
CREATE TABLE Sections (
    SectionID SERIAL PRIMARY KEY,
    CourseID INT NOT NULL,
    SemesterID INT NOT NULL,
    InstructorID INT NOT NULL,
    SectionNumber VARCHAR(10) NOT NULL,
    Capacity INT NOT NULL,
    MeetingDays VARCHAR(20),
    MeetingTime VARCHAR(50),
    Classroom VARCHAR(50),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    FOREIGN KEY (SemesterID) REFERENCES Semesters(SemesterID) ON DELETE CASCADE,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID) ON DELETE CASCADE,
    UNIQUE (CourseID, SemesterID, SectionNumber)
);

-- Create REGISTRATIONS table
CREATE TABLE Registrations (
    RegistrationID SERIAL PRIMARY KEY,
    StudentID INT NOT NULL,
    SectionID INT NOT NULL,
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID) ON DELETE CASCADE,
    UNIQUE (StudentID, SectionID)
);

-- ============================================================================
-- PART 2b: ADDITIONAL TABLES FOR PREREQUISITE SUPPORT
-- ============================================================================

-- Create PREREQUISITES table
CREATE TABLE Prerequisites (
    PrerequisiteID SERIAL PRIMARY KEY,
    CourseID INT NOT NULL,
    RequiredCourseID INT NOT NULL,
    MinimumGrade VARCHAR(2) NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    FOREIGN KEY (RequiredCourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    UNIQUE (CourseID, RequiredCourseID)
);

-- Create COMPLETED_COURSES table (grade history)
CREATE TABLE CompletedCourses (
    CompletionID SERIAL PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Grade VARCHAR(2) NOT NULL,
    SemesterID INT NOT NULL,
    CompletionStatus VARCHAR(20) DEFAULT 'Completed',
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    FOREIGN KEY (SemesterID) REFERENCES Semesters(SemesterID) ON DELETE CASCADE
);

-- ============================================================================
-- PART 1b: INSERT EXAMPLE DATA
-- ============================================================================

-- Insert Semesters
INSERT INTO Semesters (SemesterName, AcademicYear, StartDate, EndDate) VALUES
('Fall 2024', '2024-2025', '2024-09-15', '2025-01-15'),
('Spring 2025', '2024-2025', '2025-02-01', '2025-06-15'),
('Fall 2025', '2025-2026', '2025-09-15', '2026-01-15');

-- Insert Courses
INSERT INTO Courses (CourseCode, CourseTitle, Credits, ECTSCredits, Department, Description) VALUES
('ECON211', 'Principles of Microeconomics', 3, 6, 'Economics', 'Introduction to microeconomic theory and applications'),
('ECON212', 'Principles of Macroeconomics', 3, 6, 'Economics', 'Introduction to macroeconomic theory and policy'),
('ECON311', 'Intermediate Microeconomics', 3, 6, 'Economics', 'Advanced microeconomic analysis and applications'),
('MATH101', 'Calculus I', 4, 8, 'Mathematics', 'Differential calculus and applications'),
('MATH102', 'Calculus II', 4, 8, 'Mathematics', 'Integral calculus and series'),
('CS101', 'Introduction to Programming', 3, 6, 'Computer Science', 'Programming fundamentals using Python'),
('STAT201', 'Statistics for Social Sciences', 3, 6, 'Statistics', 'Descriptive and inferential statistics');

-- Insert Instructors
INSERT INTO Instructors (FirstName, LastName, Email, Department, Title) VALUES
('John', 'Smith', 'john.smith@university.edu', 'Economics', 'Professor'),
('Maria', 'Garcia', 'maria.garcia@university.edu', 'Economics', 'Associate Professor'),
('David', 'Johnson', 'david.johnson@university.edu', 'Mathematics', 'Professor'),
('Sarah', 'Williams', 'sarah.williams@university.edu', 'Computer Science', 'Assistant Professor'),
('Michael', 'Brown', 'michael.brown@university.edu', 'Statistics', 'Associate Professor');

-- Insert Students
INSERT INTO Students (FirstName, LastName, Email, StudentNumber, EnrollmentYear) VALUES
('Alice', 'Anderson', 'alice.anderson@student.edu', 'STU001', 2023),
('Bob', 'Bennett', 'bob.bennett@student.edu', 'STU002', 2023),
('Carol', 'Clark', 'carol.clark@student.edu', 'STU003', 2024),
('David', 'Davis', 'david.davis@student.edu', 'STU004', 2024),
('Emma', 'Evans', 'emma.evans@student.edu', 'STU005', 2022),
('Frank', 'Foster', 'frank.foster@student.edu', 'STU006', 2023),
('Grace', 'Green', 'grace.green@student.edu', 'STU007', 2024),
('Henry', 'Harris', 'henry.harris@student.edu', 'STU008', 2023),
('Iris', 'Ivanov', 'iris.ivanov@student.edu', 'STU009', 2024),
('Jack', 'Jackson', 'jack.jackson@student.edu', 'STU010', 2022),
('Kate', 'Kumar', 'kate.kumar@student.edu', 'STU011', 2023),
('Leo', 'Lopez', 'leo.lopez@student.edu', 'STU012', 2024);

-- Insert Sections for Fall 2025 semester
INSERT INTO Sections (CourseID, SemesterID, InstructorID, SectionNumber, Capacity, MeetingDays, MeetingTime, Classroom) VALUES
-- ECON211 sections
((SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211'), 3, 1, '01', 40, 'Mon-Wed', '09:00-10:30', 'Building A-101'),
((SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211'), 3, 2, '02', 40, 'Tue-Thu', '11:00-12:30', 'Building A-102'),
-- ECON212 sections
((SELECT CourseID FROM Courses WHERE CourseCode = 'ECON212'), 3, 1, '01', 35, 'Mon-Wed', '14:00-15:30', 'Building A-103'),
-- ECON311 section
((SELECT CourseID FROM Courses WHERE CourseCode = 'ECON311'), 3, 2, '01', 30, 'Tue-Thu', '09:00-10:30', 'Building A-201'),
-- MATH101 sections
((SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101'), 3, 3, '01', 50, 'Mon-Wed-Fri', '08:00-09:00', 'Building B-101'),
((SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101'), 3, 3, '02', 50, 'Mon-Wed-Fri', '10:00-11:00', 'Building B-102'),
-- MATH102 section
((SELECT CourseID FROM Courses WHERE CourseCode = 'MATH102'), 3, 3, '01', 45, 'Tue-Thu', '13:00-14:30', 'Building B-201'),
-- CS101 section
((SELECT CourseID FROM Courses WHERE CourseCode = 'CS101'), 3, 4, '01', 35, 'Mon-Wed', '11:00-12:30', 'Building C-101'),
-- STAT201 section
((SELECT CourseID FROM Courses WHERE CourseCode = 'STAT201'), 3, 5, '01', 40, 'Tue-Thu', '14:00-15:30', 'Building D-101');

-- ============================================================================
-- PART 1c: DEMONSTRATE ADD AND DROP ACTIONS
-- ============================================================================

-- Initial registrations (ADDS)
-- Alice adds 3 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(1, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211') AND SectionNumber = '01')),
(1, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101') AND SectionNumber = '01')),
(1, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'CS101') AND SectionNumber = '01'));

-- Bob adds 2 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(2, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211') AND SectionNumber = '01')),
(2, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'STAT201') AND SectionNumber = '01'));

-- Carol adds 3 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(3, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211') AND SectionNumber = '02')),
(3, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101') AND SectionNumber = '02')),
(3, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'CS101') AND SectionNumber = '01'));

-- David adds 2 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(4, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON212') AND SectionNumber = '01')),
(4, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH102') AND SectionNumber = '01'));

-- Emma adds 2 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(5, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON311') AND SectionNumber = '01')),
(5, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'STAT201') AND SectionNumber = '01'));

-- Frank adds 3 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(6, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211') AND SectionNumber = '01')),
(6, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101') AND SectionNumber = '01')),
(6, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'STAT201') AND SectionNumber = '01'));

-- Grace adds 2 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(7, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON212') AND SectionNumber = '01')),
(7, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'CS101') AND SectionNumber = '01'));

-- Henry adds 2 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(8, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211') AND SectionNumber = '02')),
(8, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101') AND SectionNumber = '02'));

-- Iris adds 2 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(9, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON212') AND SectionNumber = '01')),
(9, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'STAT201') AND SectionNumber = '01'));

-- Jack adds 2 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(10, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON311') AND SectionNumber = '01')),
(10, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH102') AND SectionNumber = '01'));

-- Kate adds 2 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(11, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'CS101') AND SectionNumber = '01')),
(11, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101') AND SectionNumber = '01'));

-- Leo adds 2 courses
INSERT INTO Registrations (StudentID, SectionID) VALUES
(12, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211') AND SectionNumber = '02')),
(12, (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'STAT201') AND SectionNumber = '01'));

-- DROP ACTIONS: At least 3 students drop a course
-- Alice drops CS101
DELETE FROM Registrations 
WHERE StudentID = 1 
AND SectionID = (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'CS101') AND SectionNumber = '01');

-- Bob drops STAT201
DELETE FROM Registrations 
WHERE StudentID = 2 
AND SectionID = (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'STAT201') AND SectionNumber = '01');

-- Carol drops CS101
DELETE FROM Registrations 
WHERE StudentID = 3 
AND SectionID = (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'CS101') AND SectionNumber = '01');

-- Frank drops STAT201 (4th drop to show more activity)
DELETE FROM Registrations 
WHERE StudentID = 6 
AND SectionID = (SELECT SectionID FROM Sections WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = 'STAT201') AND SectionNumber = '01');

-- ============================================================================
-- PART 1d: SHOW ALL FINAL REGISTRATIONS
-- ============================================================================

-- Query to display final registration state with student names and course details
SELECT 
    s.StudentNumber,
    s.FirstName || ' ' || s.LastName AS StudentName,
    c.CourseCode,
    sec.SectionNumber,
    c.CourseTitle,
    i.FirstName || ' ' || i.LastName AS InstructorName,
    sec.MeetingDays,
    sec.MeetingTime,
    sec.Classroom,
    r.RegistrationDate
FROM Registrations r
JOIN Students s ON r.StudentID = s.StudentID
JOIN Sections sec ON r.SectionID = sec.SectionID
JOIN Courses c ON sec.CourseID = c.CourseID
JOIN Instructors i ON sec.InstructorID = i.InstructorID
ORDER BY s.StudentNumber, c.CourseCode;

-- Summary: Count of registrations per course
SELECT 
    c.CourseCode,
    c.CourseTitle,
    sec.SectionNumber,
    COUNT(r.RegistrationID) AS EnrolledStudents,
    sec.Capacity,
    sec.Capacity - COUNT(r.RegistrationID) AS AvailableSeats
FROM Sections sec
JOIN Courses c ON sec.CourseID = c.CourseID
LEFT JOIN Registrations r ON sec.SectionID = r.SectionID
GROUP BY c.CourseCode, c.CourseTitle, sec.SectionNumber, sec.Capacity, sec.SectionID
ORDER BY c.CourseCode, sec.SectionNumber;

-- ============================================================================
-- PART 2b: INSERT PREREQUISITE DATA
-- ============================================================================

-- Define prerequisite relationships
INSERT INTO Prerequisites (CourseID, RequiredCourseID, MinimumGrade) VALUES
-- ECON311 requires ECON211 with at least C
((SELECT CourseID FROM Courses WHERE CourseCode = 'ECON311'),
 (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211'),
 'C'),
-- MATH102 requires MATH101 with at least C
((SELECT CourseID FROM Courses WHERE CourseCode = 'MATH102'),
 (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101'),
 'C'),
-- ECON311 also requires MATH101 with at least C
((SELECT CourseID FROM Courses WHERE CourseCode = 'ECON311'),
 (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101'),
 'C');

-- Insert sample completed courses (past grades for students)
INSERT INTO CompletedCourses (StudentID, CourseID, Grade, SemesterID) VALUES
-- Emma (StudentID 5) has completed prerequisites for ECON311
(5, (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211'), 'A', 1),
(5, (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101'), 'B', 1),
(5, (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON212'), 'A-', 1),
-- Jack (StudentID 10) has completed prerequisites for ECON311
(10, (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211'), 'B+', 1),
(10, (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101'), 'A', 1),
-- David (StudentID 4) has completed MATH101 for MATH102
(4, (SELECT CourseID FROM Courses WHERE CourseCode = 'MATH101'), 'B', 2),
-- Alice has completed some courses
(1, (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211'), 'C+', 2),
-- Bob has completed ECON211 but with D (insufficient for ECON311)
(2, (SELECT CourseID FROM Courses WHERE CourseCode = 'ECON211'), 'D', 2);

-- ============================================================================
-- PART 2c: ASSISTIVE SQL QUERIES FOR PREREQUISITE CHECKING
-- ============================================================================

-- QUERY 1: Find All Prerequisites of a Course
-- This query takes a CourseCode as input and returns all prerequisite courses
-- with their minimum required grades

-- Example usage for ECON311:
SELECT 
    c.CourseCode AS TargetCourse,
    c.CourseTitle AS TargetCourseTitle,
    req_course.CourseCode AS PrerequisiteCourseCode,
    req_course.CourseTitle AS PrerequisiteCourseTitle,
    p.MinimumGrade AS MinimumRequiredGrade
FROM Prerequisites p
JOIN Courses c ON p.CourseID = c.CourseID
JOIN Courses req_course ON p.RequiredCourseID = req_course.CourseID
WHERE c.CourseCode = 'ECON311'  -- Input parameter: replace with desired course code
ORDER BY req_course.CourseCode;

-- QUERY 2: Check Whether a Student Has Passed the Prerequisites
-- This query takes StudentID and CourseCode as inputs and checks if the student
-- has satisfied all prerequisites for the target course

-- Example usage for Student Emma (ID=5) and Course ECON311:
WITH grade_scale AS (
    SELECT * FROM (VALUES
        ('A+', 12), ('A', 11), ('A-', 10),
        ('B+', 9), ('B', 8), ('B-', 7),
        ('C+', 6), ('C', 5), ('C-', 4),
        ('D+', 3), ('D', 2), ('D-', 1),
        ('F', 0)
    ) AS gs(Grade, RankValue)
)
SELECT 
    c.CourseCode AS TargetCourse,
    req_course.CourseCode AS PrerequisiteCourse,
    req_course.CourseTitle AS PrerequisiteTitle,
    p.MinimumGrade AS MinimumRequired,
    COALESCE(cc.Grade, 'NOT TAKEN') AS StudentGrade,
    CASE 
        WHEN cc.Grade IS NULL THEN 'NOT COMPLETED'
        WHEN gs_student.RankValue >= gs_min.RankValue THEN 'SATISFIED'
        ELSE 'GRADE TOO LOW'
    END AS PrerequisiteStatus
FROM Prerequisites p
JOIN Courses c ON p.CourseID = c.CourseID
JOIN Courses req_course ON p.RequiredCourseID = req_course.CourseID
LEFT JOIN CompletedCourses cc ON cc.CourseID = req_course.CourseID 
    AND cc.StudentID = 5  -- Input parameter: replace with desired student ID
LEFT JOIN grade_scale gs_student ON gs_student.Grade = cc.Grade
LEFT JOIN grade_scale gs_min ON gs_min.Grade = p.MinimumGrade
WHERE c.CourseCode = 'ECON311'  -- Input parameter: replace with desired course code
ORDER BY req_course.CourseCode;

-- Alternative comprehensive check that shows overall eligibility:
WITH grade_scale AS (
    SELECT * FROM (VALUES
        ('A+', 12), ('A', 11), ('A-', 10),
        ('B+', 9), ('B', 8), ('B-', 7),
        ('C+', 6), ('C', 5), ('C-', 4),
        ('D+', 3), ('D', 2), ('D-', 1),
        ('F', 0)
    ) AS gs(Grade, RankValue)
)
SELECT 
    s.StudentNumber,
    s.FirstName || ' ' || s.LastName AS StudentName,
    c.CourseCode AS TargetCourse,
    COUNT(p.PrerequisiteID) AS TotalPrerequisites,
    COUNT(CASE WHEN gs_student.RankValue >= gs_min.RankValue THEN 1 END) AS SatisfiedPrerequisites,
    CASE 
        WHEN COUNT(p.PrerequisiteID) = COUNT(CASE WHEN gs_student.RankValue >= gs_min.RankValue THEN 1 END) 
        THEN 'ELIGIBLE'
        ELSE 'NOT ELIGIBLE'
    END AS OverallEligibility
FROM Students s
CROSS JOIN Courses c
LEFT JOIN Prerequisites p ON p.CourseID = c.CourseID
LEFT JOIN CompletedCourses cc ON cc.CourseID = p.RequiredCourseID 
    AND cc.StudentID = s.StudentID
LEFT JOIN grade_scale gs_student ON gs_student.Grade = cc.Grade
LEFT JOIN grade_scale gs_min ON gs_min.Grade = p.MinimumGrade
WHERE s.StudentID = 5  -- Input parameter: student ID
    AND c.CourseCode = 'ECON311'  -- Input parameter: course code
GROUP BY s.StudentNumber, s.FirstName, s.LastName, c.CourseCode;

-- ============================================================================
-- SAMPLE QUERY OUTPUTS (Expected Results)
-- ============================================================================

/*
QUERY 1 OUTPUT (Prerequisites for ECON311):
targetcourse | targetcoursetitle          | prerequisitecoursecode | prerequisitecoursetitle        | minimumrequiredgrade
-------------+---------------------------+-----------------------+-------------------------------+---------------------
ECON311      | Intermediate Microeconomics| ECON211               | Principles of Microeconomics  | C
ECON311      | Intermediate Microeconomics| MATH101               | Calculus I                    | C

QUERY 2 OUTPUT (Emma's prerequisite status for ECON311):
targetcourse | prerequisitecourse | prerequisitetitle             | minimumrequired | studentgrade | prerequisitestatus
-------------+-------------------+-------------------------------+-----------------+--------------+-------------------
ECON311      | ECON211           | Principles of Microeconomics  | C               | A            | SATISFIED
ECON311      | MATH101           | Calculus I                    | C               | B            | SATISFIED

Overall: Emma is ELIGIBLE for ECON311

QUERY 2 OUTPUT (Bob's prerequisite status for ECON311):
targetcourse | prerequisitecourse | prerequisitetitle             | minimumrequired | studentgrade | prerequisitestatus
-------------+-------------------+-------------------------------+-----------------+--------------+-------------------
ECON311      | ECON211           | Principles of Microeconomics  | C               | D            | GRADE TOO LOW
ECON311      | MATH101           | Calculus I                    | C               | NOT TAKEN    | NOT COMPLETED

Overall: Bob is NOT ELIGIBLE for ECON311
*/

-- ============================================================================
-- END OF HOMEWORK 2
-- ============================================================================
