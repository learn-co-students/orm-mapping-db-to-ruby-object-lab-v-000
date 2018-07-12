require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    #row=[id, name, grade]
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    DB[:conn].execute("Select * FROM students").map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = ("SELECT * FROM students WHERE name = ? LIMIT 1")
     DB[:conn].execute(sql, name).map do |row|
       self.new_from_db(row)
     end.first #end the find by name
  end #end the find by name

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

  def self.count_all_students_in_grade_9
     sql = <<-text
       SELECT COUNT(*)
       FROM students
       WHERE grade = 9;
    text

     DB[:conn].execute(sql).map do |row|
       self.new_from_db(row)
     end
   end
############
def self.students_below_12th_grade
   sql = <<-text
     SELECT *
     FROM students
     WHERE grade < 12
   text

   DB[:conn].execute(sql).map do |row|
     self.new_from_db(row)
   end
 end
##############
  def self.first_X_students_in_grade_10(number)
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY students.id LIMIT ?"
    DB[:conn].execute(sql, number).map do |row|
      self.new_from_db(row)
    end
  end
###################
def self.first_student_in_grade_10
  sql = "SELECT * FROM students WHERE grade = 10 ORDER BY students.id LIMIT 1"
  DB[:conn].execute(sql).map do |row|
    self.new_from_db(row)
  end.first
end
###################
def self.all_students_in_grade_X(grade)
   sql = <<-text
     SELECT *
     FROM students
     WHERE grade = ?
   text

   DB[:conn].execute(sql, grade).map do |row|
     self.new_from_db(row)
   end
 end
##############
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
