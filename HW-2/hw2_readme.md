# ECON485 Homework 2 - SQL Implementation

## Overview
This homework implements the Course Registration System designed in HW1 using SQL (PostgreSQL syntax).

## Files
- `hw2_sql_complete.sql` - Complete SQL script with all CREATE, INSERT, DELETE, and SELECT statements

## Database Structure

### Core Tables
1. **Students** - Student information
2. **Courses** - Course catalog
3. **Semesters** - Academic terms
4. **Instructors** - Faculty information
5. **Sections** - Course offerings
6. **Registrations** - Student enrollments

### Prerequisite Support Tables
7. **Prerequisites** - Course prerequisite relationships
8. **CompletedCourses** - Student grade history

## How to Run

### PostgreSQL
```bash
# Create database
createdb course_registration

# Run the script
psql -d course_registration -f hw2_sql_complete.sql
```

### Using psql interactive mode
```bash
psql course_registration
\i hw2_sql_complete.sql
```

## Data Summary

### Inserted Data
- 12 Students (STU001-STU012)
- 7 Courses (ECON, MATH, CS, STAT)
- 5 Instructors
- 9 Sections (Fall 2025 semester)
- 3 Semesters

### Registration Actions
- Initial: 27 registrations
- Drops: 4 students dropped courses
- Final: 23 registrations

### Prerequisites Defined
- ECON311 requires ECON211 (min C)
- ECON311 requires MATH101 (min C)
- MATH102 requires MATH101 (min C)

## Key Queries

### Query 1: Find Prerequisites
Finds all prerequisite courses for a given course code.

**Example Input:** `ECON311`

**Output:** Shows ECON211 and MATH101 with minimum grade C

### Query 2: Check Student Eligibility
Checks if a student has satisfied prerequisites for a course.

**Example Input:** StudentID=5, CourseCode='ECON311'

**Output:** Shows each prerequisite with student's grade and status (SATISFIED/NOT COMPLETED/GRADE TOO LOW)

## Sample Query Results

### Final Registrations Summary
```
CourseCode | Section | Enrolled | Capacity | Available
-----------|---------|----------|----------|----------
CS101      | 01      | 2        | 35       | 33
ECON211    | 01      | 3        | 40       | 37
ECON211    | 02      | 3        | 40       | 37
ECON212    | 01      | 3        | 35       | 32
ECON311    | 01      | 2        | 30       | 28
MATH101    | 01      | 3        | 50       | 47
MATH101    | 02      | 2        | 50       | 48
MATH102    | 01      | 2        | 45       | 43
STAT201    | 01      | 2        | 40       | 38
```

### Prerequisite Check Example (Emma for ECON311)
```
Prerequisite | Required Grade | Student Grade | Status
-------------|---------------|---------------|----------
ECON211      | C             | A             | SATISFIED
MATH101      | C             | B             | SATISFIED

Overall: ELIGIBLE
```

## Design Notes

### Assistive SQL Approach
This implementation uses the "assistive SQL" approach rather than database-enforced constraints:
- SQL queries provide information
- Application logic makes decisions
- No triggers or complex check constraints
- Easier to understand and modify

### Foreign Key Relationships
- All relationships use CASCADE delete for simplicity
- UNIQUE constraints prevent duplicate registrations
- SERIAL primary keys for all tables

## Assumptions Made

1. Grade comparison uses a defined grade scale in queries (A+ > A > A- > B+ > ... > F)
2. All sections are for Fall 2025 semester
3. Students can only register once for each section (UNIQUE constraint)
4. RegistrationDate uses CURRENT_TIMESTAMP by default
5. Drop actions are permanent DELETE operations (no history tracking)

## Future Enhancements

The following features are NOT implemented (as per assignment scope):
- Time conflict checking
- Credit limit validation
- Co-requisite support
- Registration history/action log
- Mutually exclusive courses
- Grade replacement logic

## AI Usage

Claude AI was used to:
- Generate realistic sample data
- Format SQL queries
- Create comprehensive documentation
- Validate query logic

All design decisions and SQL structure were reviewed and approved.

## Testing

To verify the implementation:

1. **Check table creation:**
   ```sql
   \dt
   ```

2. **Verify data insertion:**
   ```sql
   SELECT COUNT(*) FROM Students;  -- Should be 12
   SELECT COUNT(*) FROM Registrations;  -- Should be 20
   ```

3. **Test prerequisite queries:**
   ```sql
   -- Run Query 1 with different course codes
   -- Run Query 2 with different student IDs
   ```

4. **Verify drops worked:**
   ```sql
   -- Check that Alice, Bob, Carol, Frank have fewer registrations
   SELECT s.FirstName, COUNT(r.RegistrationID)
   FROM Students s
   LEFT JOIN Registrations r ON s.StudentID = r.StudentID
   WHERE s.FirstName IN ('Alice', 'Bob', 'Carol', 'Frank')
   GROUP BY s.FirstName;
   ```

## Contact

For questions about this implementation, please refer to the ECON485 course materials or contact your instructor.
