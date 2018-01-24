require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    std = Student.new # create a new Student object given a row from the database
    std.id = row[0]
    std.name = row[1]
    std.grade = row[2]
    std
  end

  def self.all

    std_array = DB[:conn].execute("SELECT * FROM students") # retrieve all the rows from the "Students" database
    std_array.map{|std| Student.new_from_db(std)} # remember each row should be a new instance of the Student class

  end

  def self.find_by_name(name)
    std_found = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).first # find the student in the database given a name
    Student.new_from_db(std_found) if std_found  # return a new instance of the Student class
  end

  def self.count_all_students_in_grade_9
     DB[:conn].execute("SELECT count(*) FROM students WHERE grade = 9 ")
  end

  def self.students_below_12th_grade
     DB[:conn].execute("SELECT * FROM students WHERE grade < 12 ")
  end

  def self.first_x_students_in_grade_10(x)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?",x)
  end

    def self.first_student_in_grade_10
      first_std = DB[:conn].execute("SELECT * FROM students WHERE grade = 10  LIMIT 1").first
      Student.new_from_db(first_std)
    end

    def self.all_students_in_grade_x(x)
       DB[:conn].execute("SELECT * FROM students WHERE grade = ? ",x)
    end

    def save
      DB[:conn].execute("INSERT INTO students (name, grade)
      VALUES (?, ?)", self.name, self.grade)
    end

    def self.create_table
        DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )")
    end

    def self.drop_table
      DB[:conn].execute("DROP TABLE IF EXISTS students")
    end


end
