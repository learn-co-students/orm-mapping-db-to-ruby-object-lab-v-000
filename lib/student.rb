class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map {|row| self.new_from_db}
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first
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
   sql = "SELECT * FROM students WHERE grade = 9"
   DB[:conn].execute(sql)
 end

 def self.students_below_12th_grade
   sql = "SELECT * FROM students WHERE grade < 12"
   DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
 end

 def self.all
   sql = "SELECT * FROM students"
   DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
 end

 def self.first_X_students_in_grade_10(selection)
   sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
   DB[:conn].execute(sql, selection).map {|row| self.new_from_db(row)}
 end

 def self.first_student_in_grade_10
   sql = "SELECT * FROM students WHERE grade == 10 LIMIT 1"
   row = DB[:conn].execute(sql).flatten
   self.new_from_db(row)
 end

 def self.all_students_in_grade_X(selection)
   sql = "SELECT * FROM students WHERE grade == ?"
   DB[:conn].execute(sql, selection).map {|row| self.new_from_db(row)}
 end
end
