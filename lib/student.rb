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
    sql = <<-SQL
      SELECT * FROM students
    SQL
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    row = DB[:conn].execute(sql,name).first
    self.new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(name) FROM students
      WHERE grade = ?
    SQL
    count = DB[:conn].execute(sql,"9").first
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
