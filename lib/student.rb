require 'pry'
class Student
  attr_accessor :id, :name, :grade

@@all = []

  def self.new_from_db(row)
    s = self.new
    s.id = row[0]
    s.name = row[1]
    s.grade = row[2]
    s
  end

  def self.all
    # retrieve all the rows from the "Students" database
    s_arr = DB[:conn].execute("SELECT * FROM students")
    # remember each row should be a new instance of the Student class
    s_arr.each do |s|
      @@all << self.new_from_db(s)
    end
    @@all
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    row = DB[:conn].execute("SELECT * FROM students WHERE students.name = ?", name)
    # return a new instance of the Student class
    s = self.new
      row.each do |r|
        s.id=r[0]
        s.name=r[1]
        s.grade=r[2]
      end
    s
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
  
  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
  end
  
  def self.students_below_12th_grade
    s = []
    rows = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    # binding.pry
    rows.each do |r|
      s << self.new_from_db(r)
    end
    s
  end
  
  def self.first_X_stuents_in_grade_10(num)
    
  end
  
  def self.all_students_in_grade_x
  
  end
  
end
