require 'pg'

# Database connection settings.
DB_CONFIG = {
  host: 'localhost',
  port: 5432,
  dbname: 'student_db',
  user: 'postgres',
  # Password comes from the DB_PASSWORD environment variable
  password: ENV.fetch('DB_PASSWORD'),
}.freeze

# Opens a connection to the database (caller closes it). Exits if it fails.
def connect
  PG.connect(DB_CONFIG)
rescue PG::ConnectionBad => e
  puts "Could not connect to the database: #{e.message}"
  exit 1
end

# READ (getAllStudents): show all students.
def get_all_students
  conn = connect
  result = conn.exec('SELECT * FROM students ORDER BY student_id')

  layout = '%-4s %-12s %-12s %-26s %s'
  puts format(layout, 'ID', 'First', 'Last', 'Email', 'Enrolled')
  result.each do |row|
    puts format(layout, row['student_id'], row['first_name'], row['last_name'], row['email'], row['enrollment_date'])
  end
rescue PG::Error => e
  puts "Error reading students: #{e.message}"
ensure
  conn&.close
end

# CREATE (addStudent): add a student. Date is 'YYYY-MM-DD' or nil.
def add_student(first_name, last_name, email, enrollment_date)
  conn = connect
  conn.exec_params(
    'INSERT INTO students (first_name, last_name, email, enrollment_date) ' \
    'VALUES ($1, $2, $3, $4)',
    [first_name, last_name, email, enrollment_date]
  )
  puts "Added student #{first_name} #{last_name}."
rescue PG::UniqueViolation
  puts "Error: a student with the email #{email} already exists."
rescue PG::Error => e
  puts "Error adding student: #{e.message}"
ensure
  conn&.close
end

# UPDATE (updateStudentEmail): change a student's email.
def update_student_email(student_id, new_email)
  conn = connect
  result = conn.exec_params(
    'UPDATE students SET email = $1 WHERE student_id = $2',
    [new_email, student_id]
  )

  if result.cmd_tuples.zero?
    puts "No student found with id #{student_id}."
  else
    puts "Updated the email of student #{student_id} to #{new_email}."
  end
rescue PG::UniqueViolation
  puts "Error: the email #{new_email} is already used by another student."
rescue PG::Error => e
  puts "Error updating email: #{e.message}"
ensure
  conn&.close
end

# DELETE (deleteStudent): remove a student.
def delete_student(student_id)
  conn = connect
  result = conn.exec_params('DELETE FROM students WHERE student_id = $1', [student_id])

  if result.cmd_tuples.zero?
    puts "No student found with id #{student_id}."
  else
    puts "Deleted student #{student_id}."
  end
rescue PG::Error => e
  puts "Error deleting student: #{e.message}"
ensure
  conn&.close
end

# Asks a question and returns the typed answer.
def ask(prompt)
  print prompt
  gets.to_s.chomp
end

# Menu loop: runs the chosen option until the user quits.
def main_menu
  loop do
    puts "\n1. List all students"
    puts '2. Add a student'
    puts "3. Update a student's email"
    puts '4. Delete a student'
    puts '5. Quit'
    print 'Choose an option: '
    input = gets
    break if input.nil?

    case input.chomp
    when '1'
      get_all_students
    when '2'
      first = ask('First name: ')
      last = ask('Last name: ')
      email = ask('Email: ')
      date = ask('Enrollment date (YYYY-MM-DD, blank for none): ')
      add_student(first, last, email, date.empty? ? nil : date)
    when '3'
      id = ask('Student id: ').to_i
      email = ask('New email: ')
      update_student_email(id, email)
    when '4'
      delete_student(ask('Student id: ').to_i)
    when '5'
      puts 'Goodbye!'
      break
    else
      puts 'Invalid option, please choose 1-5.'
    end
  end
end


main_menu if __FILE__ == $PROGRAM_NAME
