-- Run AFTER schema.sql:  psql -h localhost -U postgres -d student_db -f database/seed.sql

-- student_id omitted since SERIAL assigns 1, 2, 3 automatically.

INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES
('John', 'Doe',   'john.doe@example.com',   '2023-09-01'),
('Jane', 'Smith', 'jane.smith@example.com', '2023-09-01'),
('Jim',  'Beam',  'jim.beam@example.com',   '2023-09-02');
