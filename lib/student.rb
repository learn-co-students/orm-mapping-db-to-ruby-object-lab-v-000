require 'pry'

class Student
  	attr_accessor :id, :name, :grade

  	def self.new_from_db(row)
		student = self.new
		student.id = row[0]
		student.name = row[1]
		student.grade = row[2]

		student
  	end

  	def self.all
	  	sql = "SELECT * FROM students"
	  	students = DB[:conn].execute(sql)
	  	students.map do |student|
			new_from_db(student)
	  	end
	end

  	def self.find_by_name(name)
	  	sql = <<-SQL
	  	SELECT * FROM students WHERE name = ?
	  	SQL
	  	student = (DB[:conn].execute(sql, name)).flatten
	  	student = new_from_db(student)
  	end

  	def save
    	sql = <<-SQL
      		INSERT INTO students (name, grade)
      		VALUES (?, ?)
    	SQL
    	DB[:conn].execute(sql, self.name, self.grade)
  	end

  	def self.create_table
    	sql = <<-SQL
    		CREATE TABLE IF NOT EXISTS students (
      		id INTEGER PRIMARY KEY,
      		name TEXT,
      		grade TEXT
    		)
    	SQL
    	DB[:conn].execute(sql)
  	end

  	def self.drop_table
    	sql = "DROP TABLE IF EXISTS students"
    	DB[:conn].execute(sql)
  	end

	def self.count_all_students_in_grade_9
		#returns an array of all students in grades 9
		sql = "SELECT * FROM students WHERE grade = 9"
		DB[:conn].execute(sql)
	end

	def self.students_below_12th_grade
		#returns an array of all students in grades 11 or below
		sql = "SELECT * FROM students WHERE grade <= 11"
		students = (DB[:conn].execute(sql))
		students.map {|student_row| new_from_db(student_row)}
	end

	def self.first_X_students_in_grade_10(x)
	 	#returns an array of the first X students in grade 10
		sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
		students = DB[:conn].execute(sql, x)
		students.map {|student_row| new_from_db(student_row)}

		students
 	end

	def self.first_student_in_grade_10
		student = (first_X_students_in_grade_10(1)).flatten
		#why is first_X an array to this method instead of objects during rspec tests
		# when I ran tests using pry it returned objects like it was supposed
		#the line below should not be neccesary
		student = new_from_db(student)
	end

	def self.all_students_in_grade_X(grade)
		sql = "SELECT * FROM students WHERE grade = ?"
		students = DB[:conn].execute(sql, grade)
		students.map {|student_row| new_from_db(student_row)}
	end
end
