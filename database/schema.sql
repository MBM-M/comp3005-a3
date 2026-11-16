-- psql -h localhost -U postgres -d student_db -f database/schema.sql

-- Drop first so this script can be re-run to reset the table.
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id      SERIAL PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    enrollment_date DATE
);
