class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    Student.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql =<<-SQL
        SELECT * FROM students
        SQL
    DB[:conn].execute(sql).collect do |student_row|
      self.new_from_db(student_row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql =<<-SQL 
        SELECT * FROM students
        WHERE name = ?
        Limit 1
        SQL
    
    self.new_from_db(DB[:conn].execute(sql, name)[0])   
  end

  def self.count_all_students_in_grade_9
    sql =<<-SQL
        SELECT * 
        FROM students
        WHERE grade = ?
        SQL

    DB[:conn].execute(sql,9)
  end

  def self.students_below_12th_grade
    sql =<<-SQL
        SELECT *
        FROM students
        WHERE grade < ?
        SQL

    DB[:conn].execute(sql, 12)
  end

  def self.first_x_students_in_grade_10(number)
    sql =<<-SQL
        SELECT * 
        FROM students
        WHERE grade = ? 
        LIMIT ?
        SQL
    DB[:conn].execute(sql,10,number)
  end

  def self.first_student_in_grade_10
    sql =<<-SQL
        SELECT * 
        FROM students
        WHERE grade = 10
        LIMIT 1
        SQL
    self.new_from_db(DB[:conn].execute(sql).flatten)
  end

  def self.all_students_in_grade_x(grade)
    sql =<<-SQL
        SELECT *
        FROM students
        WHERE grade = ?
        SQL

    DB[:conn].execute(sql, grade)
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
end
