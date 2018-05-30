class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
		new_student = self.new
		new_student.id = row[0]
		new_student.name = row[1]
		new_student.grade = row[2]
		new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
		sql = "SELECT * FROM students"

		
		q_data = DB[:conn].execute(sql)

		rtn = q_data.collect do |row|
			self.new_from_db(row)
		end	

		rtn
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
		
		sql = <<-SQL
			SELECT * 
			FROM students 
			WHERE name = ?
			LIMIT 1
		SQL

		rtn = DB[:conn].execute(sql, name)

		rtn.map do |row|
			self.new_from_db(row)
		end.first
  end
  
	def self.count_all_students_in_grade_9
		sql = self.sql_base_all

		q_data = DB[:conn].execute(sql, 9, 9)
		
		rtn = q_data.collect do |row|
			self.new_from_db(row)
		end

		rtn
	end

		
	def self.students_below_12th_grade
		sql = self.sql_base_all

		q_data = DB[:conn].execute(sql, 1, 11)

		rtn = q_data.collect do |row|
			self.new_from_db(row)
		end

		rtn
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

	def self.first_X_students_in_grade_10(count)
		sql = self.sql_limit_base
		q_data = DB[:conn].execute(sql, 10, 10, count)

		rtn = q_data.collect do |row|
			self.new_from_db(row)		
		end
		rtn
	end

	def self.first_student_in_grade_10
		sql = self.sql_limit_base
		q_data = DB[:conn].execute(sql, 10, 10, 1)
		
		rtn = q_data.collect do |row|
			self.new_from_db(row)
		end.first
		rtn
	end

	def self.all_students_in_grade_X(grade)
		sql = self.sql_base_all
		q_data = DB[:conn].execute(sql, grade, grade)

		rtn = q_data.collect do |row|
			self.new_from_db(row)
		end
		rtn
	end
private

	def self.sql_base_all
		sql = <<-SQL                        	
			SELECT *
			FROM students
			WHERE grade >= ? AND
  			grade <= ?
			SQL
		sql
	end
	
	def self.sql_limit_base
		sql = <<-SQL
			SELECT * 
			FROM students
			WHERE grade >= ? AND
				grade <= ?
			LIMIT ?
		SQL
		sql
	end
end
