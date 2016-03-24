 class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil)
    @id = id
  end

  def self.new_from_db(row) 
    Student.new(row[0]).tap do |s|
      s.name  = row[1]
      s.grade = row[2]
    end
  end
 
  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
 
    results = DB[:conn].execute(sql)
      results.collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    results = DB[:conn].execute(sql, name)[0]
    self.new_from_db(results)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(grade) FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(sql, "9th")
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade <= ?
    SQL

    DB[:conn].execute(sql, "11th")
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ? LIMIT ?
    SQL

    DB[:conn].execute(sql, "10", x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = '10' ORDER BY id ASC LIMIT 1
    SQL
    
    result = DB[:conn].execute(sql)
    self.new_from_db(result[0])
  end
#################################################################
 
  def self.all_students_in_grade_X
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

   DB[:conn].execute(sql, "10")
  end


  # def self.all_students_in_grade_X(argument)
  #   sql = <<-SQL
  #     SELECT * FROM students WHERE grade = ?
  #   SQL

  #  DB[:conn].execute(sql, argument)
  # end
 
#################################################################
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
