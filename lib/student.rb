class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    newbie = Student.new
    newbie.id = row[0]
    newbie.name = row[1]
    newbie.grade = row[2]
    newbie
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    query = <<-SQL
      SELECT * FROM students;
      SQL
    DB[:conn].execute(query).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    query = <<-SQL
      SELECT * FROM students
      WHERE name = ?;
      SQL
    DB[:conn].execute(query, name).map do |row|
      newbie = Student.new_from_db(row)
    end.first
  end

  def self.students_below_12th_grade
    query = <<-SQL
      SELECT * FROM students
      WHERE grade < ?;
      SQL
    DB[:conn].execute(query, 12).map
  end

  def self.first_student_in_grade_10
    query = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      LIMIT 1;
      SQL
    result = DB[:conn].execute(query, 10)
    self.find_by_name(result[0][1])
  end

  def self.count_all_students_in_grade_9
    query = <<-SQL
      SELECT * FROM students
      WHERE grade = ?;
      SQL
    DB[:conn].execute(query, 9)
    
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
