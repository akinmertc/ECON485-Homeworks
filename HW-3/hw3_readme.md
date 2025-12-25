# ECON485 Homework 3 - Advanced SQL Queries

## Overview
This homework demonstrates advanced SQL query techniques using JOIN operations on the Course Registration System database created in HW1 and HW2.

## Files
- `hw3_sql_complete.sql` - Complete SQL queries for all 5 tasks
- `hw3_readme.md` - This file

## Prerequisites
- PostgreSQL database with HW2 schema and data
- Database name: `course_registration`
- All tables from HW2 must be populated

## How to Run

### Run All Queries
```bash
psql -d course_registration -f hw3_sql_complete.sql
```

### Run Individual Queries
```bash
psql -d course_registration
\i hw3_sql_complete.sql
```

### Run Specific Tasks
Open `hw3_sql_complete.sql` and copy-paste individual query blocks into psql.

## Task Summary

### Task 1: List Students and Registered Sections
**Purpose:** Display all current student registrations

**Query Type:** Multi-table INNER JOIN

**Tables Used:**
- Students
- Registrations
- Sections
- Courses
- Semesters

**Output Columns:**
- Student Number
- Student Name
- Course Code
- Section Number
- Course Title
- Semester Name

**Expected Rows:** 23 (all current registrations from HW2)

---

### Task 2: Show Courses with Total Student Counts
**Purpose:** Aggregate enrollment data by course

**Query Type:** LEFT JOIN with GROUP BY

**Key Features:**
- Uses LEFT JOIN to include courses with zero enrollment
- COUNT(DISTINCT) to avoid duplicate counting
- Groups by course
- Includes section-level detail in alternative query

**Output Columns:**
- Course Code
- Course Title
- Department
- Total Students Enrolled
- Number of Sections

**Special Handling:** LEFT JOIN ensures courses without registrations still appear

---

### Task 3: List All Prerequisites for Each Course
**Purpose:** Show prerequisite relationships

**Query Type:** Self-referencing LEFT JOIN

**Key Features:**
- LEFT JOIN to include courses without prerequisites
- Self-join on Courses table (course -> prerequisite course)
- STRING_AGG alternative for compact display

**Output Columns:**
- Course Code
- Course Title
- Prerequisite Course
- Prerequisite Title
- Minimum Required Grade

**Expected Rows:** 
- 8 rows (including NULL for courses without prerequisites)
- Alternative query: 2 rows (only courses WITH prerequisites)

---

### Task 4: Identify Students Eligible to Take a Course
**Purpose:** Find students who meet all prerequisites and aren't registered

**Query Type:** Complex multi-step with CTEs

**Key Features:**
- Common Table Expressions (CTEs) for clarity
- CROSS JOIN to check all students against requirements
- Aggregation to verify ALL prerequisites met
- Exclusion of already-registered students

**CTEs Used:**
1. `CoursePrerequisites` - Get target course requirements
2. `StudentPrerequisiteStatus` - Check each student's status
3. `EligibleStudents` - Filter to those meeting all requirements
4. `CurrentlyRegistered` - Exclude already-registered students

**Output Columns:**
- Student Name
- Eligible For Course
- Total Prerequisites
- Met Prerequisites
- Registration Status

**Example Target:** ECON311 (requires ECON211 + MATH101 with min grade C)

---

### Task 5: Detect Prerequisite Violations
**Purpose:** Find students registered without meeting prerequisites

**Query Type:** Complex violation detection with CTEs

**Key Features:**
- LEFT JOIN to find missing prerequisites
- Conditional logic for violation types:
  - Missing Prerequisite (never took the course)
  - Grade Too Low (took but didn't meet minimum)
- Summary statistics query included

**Violation Types:**
1. **Missing Prerequisite:** Student never completed required course
2. **Grade Too Low:** Student completed but grade below minimum

**CTEs Used:**
1. `StudentCourseRegistrations` - Current enrollments
2. `RequiredPrerequisites` - What each enrolled course requires
3. `PrerequisiteViolations` - Actual violations found

**Output Columns:**
- Student Name
- Course Registered For
- Missing/Failed Prerequisite
- Prerequisite Title
- Minimum Grade Required
- Student's Actual Grade
- Violation Type

**Expected Result:** Based on HW2 data, **0 violations** (all students properly qualified)

---

## Query Techniques Demonstrated

### JOIN Types Used
- **INNER JOIN:** Link related records that must exist
- **LEFT JOIN:** Include records even if no match (e.g., courses without prerequisites)
- **CROSS JOIN:** Create all combinations (students x prerequisites)

### Advanced SQL Features
- **Common Table Expressions (CTEs):** Break complex logic into steps
- **Subqueries:** Inline queries for filtering
- **Aggregate Functions:** COUNT, SUM with GROUP BY
- **String Functions:** Concatenation (||), STRING_AGG
- **Conditional Logic:** CASE WHEN statements
- **HAVING Clause:** Filter aggregated results

### Optimization Techniques
- **DISTINCT:** Avoid duplicate counting
- **COALESCE:** Handle NULL values gracefully
- **Table Aliases:** Improve readability
- **Proper Indexing:** (Assumed on PK/FK columns)

## Sample Output

### Task 1 Sample
```
studentnumber | studentname    | coursecode | section | coursetitle
--------------+----------------+------------+---------+----------------------------
STU001        | Alice Anderson | ECON211    | 01      | Principles of Microeconomics
STU001        | Alice Anderson | MATH101    | 01      | Calculus I
STU002        | Bob Bennett    | ECON211    | 01      | Principles of Microeconomics
```

### Task 2 Sample
```
coursecode | coursetitle                  | totalstudentsenrolled | numberofsections
-----------+------------------------------+-----------------------+-----------------
ECON211    | Principles of Microeconomics | 6                     | 2
MATH101    | Calculus I                   | 5                     | 2
CS101      | Introduction to Programming  | 2                     | 1
```

### Task 3 Sample
```
course  | prerequisitecourse | minimumrequiredgrade
--------+--------------------+---------------------
ECON311 | ECON211            | C
ECON311 | MATH101            | C
MATH102 | MATH101            | C
```

### Task 4 Sample
```
studentname    | eligibleforcourse | registrationstatus
---------------+-------------------+------------------------
Emma Evans     | ECON311           | Already Registered
Jack Jackson   | ECON311           | Already Registered
```

### Task 5 Sample
```
metric                                      | count
--------------------------------------------+-------
Total Registrations                         | 23
Registrations for Courses with Prerequisites| 4
Prerequisite Violations Found               | 0
```

## Assumptions

1. **Grade Ordering:**
   - A+ > A > A- > B+ > B > B- > C+ > C > C- > D+ > D > D- > F
   - Queries map grades to numeric ranks via a grade_scale CTE

2. **Semester Context:**
   - All queries focus on Fall 2025 semester (current)
   - Historical data exists in CompletedCourses

3. **Data Integrity:**
   - Foreign key constraints maintained
   - No orphaned records
   - Registration timestamps accurate

4. **Prerequisite Logic:**
   - Must complete ALL prerequisites (AND logic, not OR)
   - Prerequisites are not transitive
   - Grade must be greater than or equal to minimum

## Testing Queries

### Verify Task 1
```sql
-- Should return 23 rows
SELECT COUNT(*) FROM Registrations;
```

### Verify Task 2
```sql
-- Should show all 7 courses
SELECT COUNT(*) FROM Courses;
```

### Verify Task 4
```sql
-- Check who completed ECON211 and MATH101
SELECT s.FirstName, COUNT(cc.CompletionID)
FROM Students s
LEFT JOIN CompletedCourses cc ON s.StudentID = cc.StudentID
WHERE cc.CourseID IN (
    SELECT CourseID FROM Courses 
    WHERE CourseCode IN ('ECON211', 'MATH101')
)
GROUP BY s.FirstName;
```

### Verify Task 5
```sql
-- Should return 0 if no violations
WITH grade_scale AS (
    SELECT * FROM (VALUES
        ('A+', 12), ('A', 11), ('A-', 10),
        ('B+', 9), ('B', 8), ('B-', 7),
        ('C+', 6), ('C', 5), ('C-', 4),
        ('D+', 3), ('D', 2), ('D-', 1),
        ('F', 0)
    ) AS gs(Grade, RankValue)
)
SELECT COUNT(*)
FROM Registrations r
JOIN Sections sec ON r.SectionID = sec.SectionID
JOIN Prerequisites p ON sec.CourseID = p.CourseID
JOIN Students s ON r.StudentID = s.StudentID
LEFT JOIN CompletedCourses cc ON s.StudentID = cc.StudentID 
    AND cc.CourseID = p.RequiredCourseID
LEFT JOIN grade_scale gs_student ON gs_student.Grade = cc.Grade
LEFT JOIN grade_scale gs_min ON gs_min.Grade = p.MinimumGrade
WHERE cc.Grade IS NULL OR gs_student.RankValue < gs_min.RankValue;
```

## Common Issues and Solutions

### Issue: No output for Task 1
**Solution:** Verify Registrations table has data
```sql
SELECT COUNT(*) FROM Registrations;
```

### Issue: Task 2 missing courses
**Solution:** Ensure using LEFT JOIN, not INNER JOIN
```sql
-- Correct: LEFT JOIN
FROM Courses c LEFT JOIN Sections sec ...
-- Wrong: INNER JOIN
FROM Courses c INNER JOIN Sections sec ...
```

### Issue: Task 4 shows wrong eligibility
**Solution:** Check CompletedCourses has proper grade data
```sql
SELECT * FROM CompletedCourses 
WHERE StudentID = 5;
```

### Issue: Grade comparison not working
**Solution:** Use the grade_scale CTE in the HW3 queries to compare grades numerically
- Ensure grades match the scale (A+, A, A-, B+, ...)
- Update the scale if your grading scheme differs

## AI Usage

Claude AI was used to assist with:
- Complex CTE query structure
- JOIN optimization strategies
- Handling NULL values with COALESCE
- String aggregation techniques (STRING_AGG)
- Query formatting and documentation

All query logic was reviewed, tested, and validated.

## Future Enhancements

Potential extensions to these queries:
1. Add GPA calculation in Task 1
2. Show enrollment trends over time in Task 2
3. Visualize prerequisite chains (recursive CTEs) in Task 3
4. Include "almost eligible" students in Task 4
5. Add violation severity ranking in Task 5

## References

- PostgreSQL Documentation: https://www.postgresql.org/docs/
- SQL JOIN Types: https://www.w3schools.com/sql/sql_join.asp
- Common Table Expressions: https://www.postgresql.org/docs/current/queries-with.html

## Contact

For questions about this homework, refer to ECON485 course materials or instructor office hours.

---

**Note:** This README assumes the database structure and data from HW2 are correctly implemented.
