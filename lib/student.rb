class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 9
     SQL
     DB[:conn].execute(sql).collect do |row|
       self.new_from_db(row)
     end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade < 12
     SQL
     DB[:conn].execute(sql).collect do |row|
       self.new_from_db(row)
     end
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    rows = DB[:conn].execute(sql)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(x)
    arr = []
    self.all.select do |student|
      arr << student.grade == 10
    end
    arr.take(x)
  end
  def self.first_student_in_grade_10
    # student = self.all.find do |student|
    #   student.grade == 10
    # end
    # student
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 limit 1;
    SQL
     rows = DB[:conn].execute(sql)
    self.new_from_db(rows.first)
  end
   def self.all_students_in_grade_X(x)
    arr = []
    self.all.select do |student|
      arr << student.grade == x
    end
    arr
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
