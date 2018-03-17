require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
  end
  end


     def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
SQL

    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end


  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
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
    sql = <<-SQL
    SELECT COUNT(name)
    FROM students
    WHERE grade = 9
SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
  sql = <<-SQL
  SELECT name
  FROM students
  WHERE grade <= 11
SQL
     DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(x)
      sql = <<-SQL
      SELECT name
      FROM students
      WHERE grade = 10
      Limit ?
SQL
    DB[:conn].execute(sql,x)
  end

    def self.first_student_in_grade_10
      #binding.pry
      sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      Limit 1
SQL
 search = DB[:conn].execute(sql)
    self.new_from_db(search[0])
  end

    def self.all_students_in_grade_X
      sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10

SQL
      DB[:conn].execute(sql)
      end

end
