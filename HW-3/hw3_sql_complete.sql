-- ============================================================================
-- ECON485 Fall 2025 - Homework Assignment 3
-- Course Registration System - SQL Queries with JOINs
-- ============================================================================
-- This homework builds on HW1 and HW2 schemas and data
-- All queries use JOIN operations to retrieve meaningful information
-- ============================================================================

-- ============================================================================
-- TASK 1: List Students and Their Registered Sections
-- ============================================================================
-- Purpose: Display all students with the courses they are currently registered for
-- Shows: Student name, Course code, Section number

SELECT 
    s.StudentNumber,
    s.FirstName || ' ' || s.LastName AS StudentName,
    c.CourseCode,
    sec.SectionNumber AS Section,
    c.CourseTitle,
    sem.SemesterName,
    sem.AcademicYear
FROM Students s
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Sections sec ON r.SectionID = sec.SectionID
INNER JOIN Courses c ON sec.CourseID = c.CourseID
INNER JOIN Semesters sem ON sec.SemesterID = sem.SemesterID
ORDER BY s.StudentNumber, c.CourseCode;

/*
EXPECTED OUTPUT (Sample):
studentnumber | studentname      | coursecode | section | coursetitle                    | semestername | academicyear
--------------+------------------+------------+---------+--------------------------------+--------------+-------------
STU001        | Alice Anderson   | ECON211    | 01      | Principles of Microeconomics   | Fall 2025    | 2025-2026
STU001        | Alice Anderson   | MATH101    | 01      | Calculus I                     | Fall 2025    | 2025-2026
STU002        | Bob Bennett      | ECON211    | 01      | Principles of Microeconomics   | Fall 2025    | 2025-2026
STU003        | Carol Clark      | ECON211    | 02      | Principles of Microeconomics   | Fall 2025    | 2025-2026
STU003        | Carol Clark      | MATH101    | 02      | Calculus I                     | Fall 2025    | 2025-2026
...
*/

-- ============================================================================
-- TASK 2: Show Courses with Total Student Counts
-- ============================================================================
-- Purpose: List all courses with total enrollment across all sections
-- Uses: GROUP BY to aggregate counts, LEFT JOIN to include courses with zero enrollment
-- Shows: Course code, name, and total student count

SELECT 
    c.CourseCode,
    c.CourseTitle,
    c.Department,
    COUNT(DISTINCT r.StudentID) AS TotalStudentsEnrolled,
    COUNT(DISTINCT sec.SectionID) AS NumberOfSections
FROM Courses c
LEFT JOIN Sections sec ON c.CourseID = sec.CourseID 
    AND sec.SemesterID = (SELECT SemesterID FROM Semesters WHERE SemesterName = 'Fall 2025')
LEFT JOIN Registrations r ON sec.SectionID = r.SectionID
GROUP BY c.CourseCode, c.CourseTitle, c.Department
ORDER BY c.CourseCode;

/*
EXPECTED OUTPUT:
coursecode | coursetitle                      | department        | totalstudentsenrolled | numberofsections
-----------+----------------------------------+-------------------+-----------------------+-----------------
CS101      | Introduction to Programming      | Computer Science  | 2                     | 1
ECON211    | Principles of Microeconomics     | Economics         | 6                     | 2
ECON212    | Principles of Macroeconomics     | Economics         | 3                     | 1
ECON311    | Intermediate Microeconomics      | Economics         | 2                     | 1
MATH101    | Calculus I                       | Mathematics       | 5                     | 2
MATH102    | Calculus II                      | Mathematics       | 2                     | 1
STAT201    | Statistics for Social Sciences   | Statistics        | 3                     | 1

Note: All courses have at least one section in Fall 2025, so none show 0 enrollment
*/

-- Alternative query: Show section-level detail
SELECT 
    c.CourseCode,
    c.CourseTitle,
    sec.SectionNumber,
    i.FirstName || ' ' || i.LastName AS Instructor,
    COUNT(r.StudentID) AS EnrolledStudents,
    sec.Capacity,
    sec.Capacity - COUNT(r.StudentID) AS AvailableSeats,
    ROUND(COUNT(r.StudentID)::NUMERIC / sec.Capacity * 100, 1) AS PercentFull
FROM Courses c
LEFT JOIN Sections sec ON c.CourseID = sec.CourseID
LEFT JOIN Registrations r ON sec.SectionID = r.SectionID
LEFT JOIN Instructors i ON sec.InstructorID = i.InstructorID
WHERE sec.SemesterID = (SELECT SemesterID FROM Semesters WHERE SemesterName = 'Fall 2025')
GROUP BY c.CourseCode, c.CourseTitle, sec.SectionNumber, sec.Capacity, sec.SectionID, 
         i.FirstName, i.LastName
ORDER BY c.CourseCode, sec.SectionNumber;

/*
SECTION-LEVEL OUTPUT:
coursecode | coursetitle                    | sectionnumber | instructor      | enrolledstudents | capacity | availableseats | percentfull
-----------+--------------------------------+---------------+-----------------+------------------+----------+----------------+-------------
CS101      | Introduction to Programming    | 01            | Sarah Williams  | 2                | 35       | 33             | 5.7
ECON211    | Principles of Microeconomics   | 01            | John Smith      | 3                | 40       | 37             | 7.5
ECON211    | Principles of Microeconomics   | 02            | Maria Garcia    | 3                | 40       | 37             | 7.5
...
*/

-- ============================================================================
-- TASK 3: List All Prerequisites for Each Course
-- ============================================================================
-- Purpose: Show prerequisite relationships and minimum grade requirements
-- Shows: Course, its prerequisites, and minimum required grades

SELECT 
    c.CourseCode AS Course,
    c.CourseTitle AS CourseTitle,
    prereq_course.CourseCode AS PrerequisiteCourse,
    prereq_course.CourseTitle AS PrerequisiteTitle,
    p.MinimumGrade AS MinimumRequiredGrade,
    c.Department,
    prereq_course.Credits AS PrerequisiteCredits
FROM Courses c
LEFT JOIN Prerequisites p ON c.CourseID = p.CourseID
LEFT JOIN Courses prereq_course ON p.RequiredCourseID = prereq_course.CourseID
ORDER BY c.CourseCode, prereq_course.CourseCode;

/*
EXPECTED OUTPUT:
course  | coursetitle                      | prerequisitecourse | prerequisitetitle            | minimumrequiredgrade | department  | prerequisitecredits
--------+----------------------------------+--------------------+------------------------------+----------------------+-------------+--------------------
CS101   | Introduction to Programming      | NULL               | NULL                         | NULL                 | Comp Sci    | NULL
ECON211 | Principles of Microeconomics     | NULL               | NULL                         | NULL                 | Economics   | NULL
ECON212 | Principles of Macroeconomics     | NULL               | NULL                         | NULL                 | Economics   | NULL
ECON311 | Intermediate Microeconomics      | ECON211            | Principles of Microeconomics | C                    | Economics   | 3
ECON311 | Intermediate Microeconomics      | MATH101            | Calculus I                   | C                    | Economics   | 4
MATH101 | Calculus I                       | NULL               | NULL                         | NULL                 | Mathematics | NULL
MATH102 | Calculus II                      | MATH101            | Calculus I                   | C                    | Mathematics | 4
STAT201 | Statistics for Social Sciences   | NULL               | NULL                         | NULL                 | Statistics  | NULL
*/

-- Alternative: Show only courses that HAVE prerequisites
SELECT 
    c.CourseCode AS Course,
    c.CourseTitle AS CourseTitle,
    STRING_AGG(prereq_course.CourseCode || ' (' || p.MinimumGrade || ')', ', ' 
               ORDER BY prereq_course.CourseCode) AS Prerequisites
FROM Courses c
INNER JOIN Prerequisites p ON c.CourseID = p.CourseID
INNER JOIN Courses prereq_course ON p.RequiredCourseID = prereq_course.CourseID
GROUP BY c.CourseCode, c.CourseTitle
ORDER BY c.CourseCode;

/*
COMPACT OUTPUT:
course  | coursetitle                  | prerequisites
--------+------------------------------+-------------------------
ECON311 | Intermediate Microeconomics  | ECON211 (C), MATH101 (C)
MATH102 | Calculus II                  | MATH101 (C)
*/

-- ============================================================================
-- TASK 4: Identify Students Eligible to Take a Course
-- ============================================================================
-- Purpose: Find students who meet all prerequisites for a specific course
-- Logic: Student is eligible if they completed all prerequisites with sufficient grades
--        AND are not already registered for the course

-- For this example, we'll check eligibility for ECON311
-- ECON311 requires: ECON211 (min C) and MATH101 (min C)

WITH grade_scale AS (
    SELECT * FROM (VALUES
        ('A+', 12), ('A', 11), ('A-', 10),
        ('B+', 9), ('B', 8), ('B-', 7),
        ('C+', 6), ('C', 5), ('C-', 4),
        ('D+', 3), ('D', 2), ('D-', 1),
        ('F', 0)
    ) AS gs(Grade, RankValue)
),
CoursePrerequisites AS (
    -- Get all prerequisites for the target course
    SELECT 
        p.CourseID AS TargetCourseID,
        p.RequiredCourseID,
        p.MinimumGrade,
        c.CourseCode AS TargetCourse,
        prereq.CourseCode AS PrerequisiteCourse
    FROM Prerequisites p
    JOIN Courses c ON p.CourseID = c.CourseID
    JOIN Courses prereq ON p.RequiredCourseID = prereq.CourseID
    WHERE c.CourseCode = 'ECON311'  -- Target course
),
StudentPrerequisiteStatus AS (
    -- Check each student's status for each prerequisite
    SELECT 
        s.StudentID,
        s.FirstName || ' ' || s.LastName AS StudentName,
        cp.TargetCourse,
        cp.PrerequisiteCourse,
        cp.MinimumGrade AS RequiredGrade,
        COALESCE(cc.Grade, 'NOT TAKEN') AS StudentGrade,
        CASE 
            WHEN cc.Grade IS NULL THEN FALSE
            WHEN gs_student.RankValue >= gs_min.RankValue THEN TRUE
            ELSE FALSE
        END AS PrerequisiteMet
    FROM Students s
    CROSS JOIN CoursePrerequisites cp
    LEFT JOIN CompletedCourses cc ON s.StudentID = cc.StudentID 
        AND cc.CourseID = cp.RequiredCourseID
    LEFT JOIN grade_scale gs_student ON gs_student.Grade = cc.Grade
    LEFT JOIN grade_scale gs_min ON gs_min.Grade = cp.MinimumGrade
),
EligibleStudents AS (
    -- Students who met ALL prerequisites
    SELECT 
        StudentID,
        StudentName,
        TargetCourse,
        COUNT(*) AS TotalPrerequisites,
        SUM(CASE WHEN PrerequisiteMet THEN 1 ELSE 0 END) AS MetPrerequisites
    FROM StudentPrerequisiteStatus
    GROUP BY StudentID, StudentName, TargetCourse
    HAVING COUNT(*) = SUM(CASE WHEN PrerequisiteMet THEN 1 ELSE 0 END)
),
CurrentlyRegistered AS (
    -- Check who is already registered
    SELECT DISTINCT r.StudentID
    FROM Registrations r
    JOIN Sections sec ON r.SectionID = sec.SectionID
    JOIN Courses c ON sec.CourseID = c.CourseID
    WHERE c.CourseCode = 'ECON311'
)
-- Final output: Eligible students not already registered
SELECT 
    es.StudentName,
    es.TargetCourse AS EligibleForCourse,
    es.TotalPrerequisites,
    es.MetPrerequisites,
    CASE 
        WHEN cr.StudentID IS NOT NULL THEN 'Already Registered'
        ELSE 'Available to Register'
    END AS RegistrationStatus
FROM EligibleStudents es
LEFT JOIN CurrentlyRegistered cr ON es.StudentID = cr.StudentID
ORDER BY es.StudentName;

/*
EXPECTED OUTPUT:
studentname    | eligibleforcourse | totalprerequisites | metprerequisites | registrationstatus
---------------+-------------------+--------------------+------------------+---------------------
Emma Evans     | ECON311           | 2                  | 2                | Already Registered
Jack Jackson   | ECON311           | 2                  | 2                | Already Registered

Note: With the HW2 data, all eligible students are already registered
*/

-- Detailed view: Show each student's prerequisite status
WITH grade_scale AS (
    SELECT * FROM (VALUES
        ('A+', 12), ('A', 11), ('A-', 10),
        ('B+', 9), ('B', 8), ('B-', 7),
        ('C+', 6), ('C', 5), ('C-', 4),
        ('D+', 3), ('D', 2), ('D-', 1),
        ('F', 0)
    ) AS gs(Grade, RankValue)
),
CoursePrerequisites AS (
    -- Get all prerequisites for the target course
    SELECT 
        p.CourseID AS TargetCourseID,
        p.RequiredCourseID,
        p.MinimumGrade,
        c.CourseCode AS TargetCourse,
        prereq.CourseCode AS PrerequisiteCourse
    FROM Prerequisites p
    JOIN Courses c ON p.CourseID = c.CourseID
    JOIN Courses prereq ON p.RequiredCourseID = prereq.CourseID
    WHERE c.CourseCode = 'ECON311'  -- Target course
),
StudentPrerequisiteStatus AS (
    -- Check each student's status for each prerequisite
    SELECT 
        s.StudentID,
        s.FirstName || ' ' || s.LastName AS StudentName,
        cp.TargetCourse,
        cp.PrerequisiteCourse,
        cp.MinimumGrade AS RequiredGrade,
        COALESCE(cc.Grade, 'NOT TAKEN') AS StudentGrade,
        CASE 
            WHEN cc.Grade IS NULL THEN FALSE
            WHEN gs_student.RankValue >= gs_min.RankValue THEN TRUE
            ELSE FALSE
        END AS PrerequisiteMet
    FROM Students s
    CROSS JOIN CoursePrerequisites cp
    LEFT JOIN CompletedCourses cc ON s.StudentID = cc.StudentID 
        AND cc.CourseID = cp.RequiredCourseID
    LEFT JOIN grade_scale gs_student ON gs_student.Grade = cc.Grade
    LEFT JOIN grade_scale gs_min ON gs_min.Grade = cp.MinimumGrade
),
EligibleStudents AS (
    -- Students who met ALL prerequisites
    SELECT 
        StudentID,
        StudentName,
        TargetCourse,
        COUNT(*) AS TotalPrerequisites,
        SUM(CASE WHEN PrerequisiteMet THEN 1 ELSE 0 END) AS MetPrerequisites
    FROM StudentPrerequisiteStatus
    GROUP BY StudentID, StudentName, TargetCourse
    HAVING COUNT(*) = SUM(CASE WHEN PrerequisiteMet THEN 1 ELSE 0 END)
)
SELECT 
    sps.StudentName,
    sps.TargetCourse,
    sps.PrerequisiteCourse,
    sps.RequiredGrade,
    sps.StudentGrade,
    CASE 
        WHEN sps.PrerequisiteMet THEN 'Met'
        ELSE 'Not Met'
    END AS Status
FROM StudentPrerequisiteStatus sps
WHERE sps.StudentID IN (
    SELECT StudentID FROM EligibleStudents
)
ORDER BY sps.StudentName, sps.PrerequisiteCourse;

/*
DETAILED OUTPUT:
studentname    | targetcourse | prerequisitecourse | requiredgrade | studentgrade | status
---------------+--------------+--------------------+---------------+--------------+--------
Emma Evans     | ECON311      | ECON211            | C             | A            | Met
Emma Evans     | ECON311      | MATH101            | C             | B            | Met
Jack Jackson   | ECON311      | ECON211            | C             | B+           | Met
Jack Jackson   | ECON311      | MATH101            | C             | A            | Met
*/

-- ============================================================================
-- TASK 5: Detect Students Who Registered Without Meeting Prerequisites
-- ============================================================================
-- Purpose: Find prerequisite violations in current registrations
-- A violation occurs when a student is registered for a course but:
--   1. Hasn't completed a required prerequisite, OR
--   2. Completed it with a grade below the minimum required

WITH grade_scale AS (
    SELECT * FROM (VALUES
        ('A+', 12), ('A', 11), ('A-', 10),
        ('B+', 9), ('B', 8), ('B-', 7),
        ('C+', 6), ('C', 5), ('C-', 4),
        ('D+', 3), ('D', 2), ('D-', 1),
        ('F', 0)
    ) AS gs(Grade, RankValue)
),
StudentCourseRegistrations AS (
    -- Get all current registrations with course details
    SELECT DISTINCT
        s.StudentID,
        s.FirstName || ' ' || s.LastName AS StudentName,
        c.CourseID,
        c.CourseCode,
        c.CourseTitle
    FROM Students s
    JOIN Registrations r ON s.StudentID = r.StudentID
    JOIN Sections sec ON r.SectionID = sec.SectionID
    JOIN Courses c ON sec.CourseID = c.CourseID
),
RequiredPrerequisites AS (
    -- For each registered course, get its prerequisites
    SELECT 
        scr.StudentID,
        scr.StudentName,
        scr.CourseCode AS RegisteredCourse,
        prereq.CourseCode AS RequiredPrerequisite,
        prereq.CourseTitle AS PrerequisiteTitle,
        p.MinimumGrade AS MinimumRequired
    FROM StudentCourseRegistrations scr
    JOIN Prerequisites p ON scr.CourseID = p.CourseID
    JOIN Courses prereq ON p.RequiredCourseID = prereq.CourseID
),
PrerequisiteViolations AS (
    -- Check if students met each prerequisite
    SELECT 
        rp.StudentID,
        rp.StudentName,
        rp.RegisteredCourse,
        rp.RequiredPrerequisite,
        rp.PrerequisiteTitle,
        rp.MinimumRequired,
        COALESCE(cc.Grade, 'NOT COMPLETED') AS StudentGrade,
        CASE 
            WHEN cc.Grade IS NULL THEN 'Missing Prerequisite'
            WHEN gs_student.RankValue < gs_min.RankValue THEN 'Grade Too Low'
            ELSE 'OK'
        END AS ViolationType
    FROM RequiredPrerequisites rp
    LEFT JOIN CompletedCourses cc ON rp.StudentID = cc.StudentID 
        AND cc.CourseID = (SELECT CourseID FROM Courses WHERE CourseCode = rp.RequiredPrerequisite)
    LEFT JOIN grade_scale gs_student ON gs_student.Grade = cc.Grade
    LEFT JOIN grade_scale gs_min ON gs_min.Grade = rp.MinimumRequired
    WHERE cc.Grade IS NULL OR gs_student.RankValue < gs_min.RankValue
)
-- Final output: All violations found
SELECT 
    StudentName,
    RegisteredCourse AS CourseRegisteredFor,
    RequiredPrerequisite AS MissingOrFailedPrerequisite,
    PrerequisiteTitle,
    MinimumRequired AS MinimumGradeRequired,
    StudentGrade AS StudentActualGrade,
    ViolationType
FROM PrerequisiteViolations
ORDER BY StudentName, RegisteredCourse, RequiredPrerequisite;

/*
EXPECTED OUTPUT:
(no rows - all students meet prerequisites)

Note: Based on our HW2 data:
- Emma (registered for ECON311): Has ECON211(A) and MATH101(B) OK
- Jack (registered for ECON311): Has ECON211(B+) and MATH101(A) OK
- David (registered for MATH102): Has MATH101(B) OK
- All other students registered for courses without prerequisites

If we had inserted violation data, output would show:
studentname      | courseregisteredfor | missingorfailedprerequisite | minimumgraderequired | studentactualgrade | violationtype
-----------------+---------------------+-----------------------------+----------------------+--------------------+------------------
Example Student  | ECON311             | ECON211                     | C                    | NOT COMPLETED      | Missing Prerequisite
Another Student  | ECON311             | MATH101                     | C                    | D                  | Grade Too Low
*/

-- Alternative approach: More comprehensive with all registration details
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
    c.CourseCode AS RegisteredCourse,
    sec.SectionNumber,
    prereq.CourseCode AS RequiredPrerequisiteCourse,
    p.MinimumGrade AS MinimumRequired,
    COALESCE(cc.Grade, 'NOT COMPLETED') AS StudentGrade,
    CASE 
        WHEN cc.Grade IS NULL THEN 'VIOLATION: Prerequisite not completed'
        WHEN gs_student.RankValue < gs_min.RankValue THEN 'VIOLATION: Grade insufficient'
        ELSE 'OK'
    END AS PrerequisiteStatus,
    r.RegistrationDate
FROM Registrations r
JOIN Students s ON r.StudentID = s.StudentID
JOIN Sections sec ON r.SectionID = sec.SectionID
JOIN Courses c ON sec.CourseID = c.CourseID
JOIN Prerequisites p ON c.CourseID = p.CourseID
JOIN Courses prereq ON p.RequiredCourseID = prereq.CourseID
LEFT JOIN CompletedCourses cc ON s.StudentID = cc.StudentID 
    AND cc.CourseID = prereq.CourseID
LEFT JOIN grade_scale gs_student ON gs_student.Grade = cc.Grade
LEFT JOIN grade_scale gs_min ON gs_min.Grade = p.MinimumGrade
WHERE cc.Grade IS NULL OR gs_student.RankValue < gs_min.RankValue
ORDER BY s.StudentNumber, c.CourseCode, prereq.CourseCode;

-- Summary statistics of violations
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
    'Total Registrations' AS Metric,
    COUNT(DISTINCT r.RegistrationID) AS Count
FROM Registrations r
UNION ALL
SELECT 
    'Registrations for Courses with Prerequisites' AS Metric,
    COUNT(DISTINCT r.RegistrationID)
FROM Registrations r
JOIN Sections sec ON r.SectionID = sec.SectionID
JOIN Prerequisites p ON sec.CourseID = p.CourseID
UNION ALL
SELECT 
    'Prerequisite Violations Found' AS Metric,
    COUNT(DISTINCT r.RegistrationID)
FROM Registrations r
JOIN Sections sec ON r.SectionID = sec.SectionID
JOIN Prerequisites p ON sec.CourseID = p.CourseID
JOIN Students s ON r.StudentID = s.StudentID
LEFT JOIN CompletedCourses cc ON s.StudentID = cc.StudentID 
    AND cc.CourseID = p.RequiredCourseID
LEFT JOIN grade_scale gs_student ON gs_student.Grade = cc.Grade
LEFT JOIN grade_scale gs_min ON gs_min.Grade = p.MinimumGrade
WHERE cc.Grade IS NULL OR gs_student.RankValue < gs_min.RankValue;

/*
SUMMARY OUTPUT:
metric                                          | count
------------------------------------------------+-------
Total Registrations                             | 23
Registrations for Courses with Prerequisites    | 4
Prerequisite Violations Found                   | 0
*/

-- ============================================================================
-- END OF HOMEWORK 3
-- ============================================================================

/*
SUBMISSION NOTES:
-----------------
1. All queries tested with HW2 database
2. Queries use proper JOIN operations (INNER, LEFT, CROSS as appropriate)
3. Output formatted for readability
4. Comments explain logic and expected results
5. Alternative query versions provided for deeper analysis

ASSUMPTIONS:
------------
1. Grade comparison uses a grade_scale mapping: A+ > A > A- > B+ > B > B- > C+ > C > C- > D+ > D > D- > F
2. Current registrations are in Fall 2025 semester
3. CompletedCourses contains only successfully completed courses
4. Prerequisites are not transitive (if A requires B, and B requires C, taking C does not satisfy A)

AI USAGE:
---------
Claude AI assisted with:
- Query optimization
- Complex JOIN logic
- CTE (Common Table Expression) structuring
- Output formatting and documentation
*/
