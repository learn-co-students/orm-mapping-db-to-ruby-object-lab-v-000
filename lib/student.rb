require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    obj = self.new
    obj.id, obj.name, obj.grade = row
    obj
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM #{self.to_s+"s"}
    SQL

    DB[:conn].execute(sql).map{|obj| self.new_from_db(obj) }
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM #{self.to_s+"s"} WHERE name = ?"
    self.new_from_db( DB[:conn].execute(sql,name).flatten! )
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM #{self.to_s+"s"} WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM #{self.to_s+"s"} WHERE grade <= 11"
    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(num_of_students)
    sql = <<-SQL
    SELECT * FROM #{self.to_s+"s"}
    WHERE grade = 10
    LIMIT ?
    SQL
    DB[:conn].execute(sql,num_of_students)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM #{self.to_s+"s"}
    WHERE grade = 10
    LIMIT 1
    SQL
    self.new_from_db(DB[:conn].execute(sql).flatten!)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM #{self.to_s+"s"}
    WHERE grade = ?
    SQL
    DB[:conn].execute(sql,grade)
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

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end

end
