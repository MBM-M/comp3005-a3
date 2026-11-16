# COMP 3005 - Assignment 3: PostgreSQL CRUD Application (Ruby)

A Ruby command-line app that connects to a PostgreSQL database and performs
Create, Read, Update and Delete (CRUD) operations on a `students` table.

## Demo Video

https://youtu.be/1-tEiuoaNZI

## Project Structure

```
A3/
├── Gemfile
├── app/
│   └── students.rb      # the application (CRUD functions + text menu)
├── database/
│   ├── schema.sql       # creates the students table
│   └── seed.sql         # inserts the 3 starting students
└── README.md
```

## Prerequisites

- Ruby 3.x (developed with 3.3.5)
- PostgreSQL (developed with 14), running on `localhost:5432`
- pgAdmin (optional, for viewing the data)
- The `pg` gem (installed in the steps below). On Ubuntu/WSL it needs
  `sudo apt install libpq-dev`.

## Database Setup

Run these from the project root. Each command asks for the `postgres` password.

```bash
# 1. Create the database
createdb -h localhost -U postgres student_db

# 2. Create the students table
psql -h localhost -U postgres -d student_db -f database/schema.sql

# 3. Insert the initial data
psql -h localhost -U postgres -d student_db -f database/seed.sql

# 4. Check it worked (should show 3 rows)
psql -h localhost -U postgres -d student_db -c "SELECT * FROM students;"
```

To reset the data, run steps 2 and 3 again (`schema.sql` drops and recreates the table).

## Running the Application

```bash
# Install the pg gem
bundle install

# Give the app the database password (it is not stored in the code)
export DB_PASSWORD='your_postgres_password'

# Start the app
ruby app/students.rb
```

The app shows a menu:

```
1. List all students
2. Add a student
3. Update a student's email
4. Delete a student
5. Quit
```

The host, port, database name and user are set in `DB_CONFIG` at the top of
`app/students.rb`. Change them there if your setup is different.

## Function Reference

| Function | Assignment name | What it does |
|----------|-----------------|--------------|
| `get_all_students` | `getAllStudents()` | Prints every student, ordered by `student_id` |
| `add_student(first_name, last_name, email, enrollment_date)` | `addStudent(...)` | Inserts a new student. The date is `'YYYY-MM-DD'`, or `nil` to leave it empty |
| `update_student_email(student_id, new_email)` | `updateStudentEmail(...)` | Changes the email of the student with that id |
| `delete_student(student_id)` | `deleteStudent(...)` | Deletes the student with that id |

All queries use parameters (`$1`, `$2`, ...) instead of building SQL strings, and each
function closes its database connection when it finishes.

Errors are reported with a message instead of crashing:

- **Duplicate email** (add or update): prints that the email is already used.
- **Unknown id** (update or delete): prints "No student found with id ...".
- **Invalid date** (add): prints the database error.
- **Cannot connect**: prints the reason and exits (check that PostgreSQL is running
  and `DB_PASSWORD` is correct).
