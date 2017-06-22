require 'pry'
class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    return student
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL
    all = []
    all_db = DB[:conn].execute(sql)

    all_db.each do |row|
      student = Student.new_from_db(row)
     all << student
    end
     return all
  end

  def self.find_by_name(name)

    Student.all.each do |student|
      if student.name == name
        return student
      end
    end
  end

  def self.count_all_students_in_grade_9
    grade_9 = []
    Student.all.each do |student|
        if student.grade == "9"
           grade_9 << student
        end
    end
    return grade_9
  end

  def self.students_below_12th_grade
    below_12 = []
    Student.all.each do |student|
      if student.grade < "12"
        below_12 << student
      end
    end
    return below_12
  end

  def self.first_x_students_in_grade_10(num)
    grade_10 = []
      Student.all.each do |student|
        if student.grade == "10" && grade_10.length < num
          grade_10 << student
        end
      end
      grade_10
  end

  def self.first_student_in_grade_10
    student = Student.first_x_students_in_grade_10(1)
    return student[0]
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end


  def self.all_students_in_grade_x(grade)
    grade_x = []
    Student.all.each do |student|
      if student.grade == grade.to_s
         grade_x << student
      end
    end
     return grade_x
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
