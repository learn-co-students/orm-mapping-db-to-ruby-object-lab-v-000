class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
      p = self.new
      p.id = row[0]
      p.name = row[1]
      p.grade = row[2]
      p
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    DB[:conn].execute(sql).collect {|row|
      self.new_from_db(row)
      }
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    SQL
    x = nil
    DB[:conn].execute(sql, name).collect {|row|
      x = self.new_from_db(row)
      }
    x
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
    sql = <<-SQL
    SELECT name FROM students
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT name FROM students
    WHERE grade < 12
    SQL

    DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT 1
    SQL
    x = nil
    DB[:conn].execute(sql).collect {|row|
      x = self.new_from_db(row)
      }
    x
  end

end
