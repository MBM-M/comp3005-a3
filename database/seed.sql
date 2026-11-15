-- seed.sql: inserts the 3 starting students. Run after schema.sql.
-- psql -h localhost -U postgres -d student_db -f database/seed.sql

-- student_id is left out: SERIAL assigns 1, 2, 3.
INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES
('John', 'Doe',   'john.doe@example.com',   '2023-09-01'),
('Jane', 'Smith', 'jane.smith@example.com', '2023-09-01'),
('Jim',  'Beam',  'jim.beam@example.com',   '2023-09-02');
