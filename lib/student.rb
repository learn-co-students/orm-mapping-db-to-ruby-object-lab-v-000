require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    stu=Student.new()
    stu.name=row[1]
    stu.grade=row[2]
    stu.id=row[0]
    stu
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql="SELECT * FROM students"
    DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql='SELECT * FROM students WHERE name=(?)'
    #binding.pry
    stu_row=DB[:conn].execute(sql,name).flatten
    stu=Student.new_from_db(stu_row)
    stu
  end

  def self.count_all_students_in_grade_9
    sql="SELECT COUNT(id) FROM students WHERE grade=9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql="SELECT * FROM students WHERE grade<12"
    stu_data=DB[:conn].execute(sql)  #execute sql and store it in stu_data array of rows
    stu_data.map do |stu_row|       #map each row
      Student.new_from_db(stu_row)  #build an array of objects from the rows
    end
  end

  def self.first_X_students_in_grade_10(num)
    sql="SELECT * FROM students WHERE grade=10 LIMIT (?)"
    data=DB[:conn].execute(sql,num)
    data.map do |stu_row|
      Student.new_from_db(stu_row)
    end
  end

  def self.first_student_in_grade_10
    sql="SELECT * FROM students WHERE grade=10 LIMIT 1"
    stu=DB[:conn].execute(sql)[0]
    Student.new_from_db(stu)
  end

  def self.all_students_in_grade_X(grd)
    sql="SELECT * FROM students WHERE grade=?"
    data=DB[:conn].execute(sql,grd)
    data.map do |stu_row|
      Student.new_from_db(stu_row)
    end
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
