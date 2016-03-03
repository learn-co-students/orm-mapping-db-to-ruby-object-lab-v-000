class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    s = self.new
    s.id = row[0]
    s.name = row[1]
    s.grade = row[2]
    s
  end

  def self.all
     sql = <<-SQL
    SELECT *
    FROM students;
    SQL

    DB[:conn].execute(sql).map do |student_row|
      self.new_from_db(student_row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    LIMIT 1;
    SQL

    DB[:conn].execute(sql, name).map do |student_row|
      self.new_from_db(student_row)
    end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade=9;
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade<12;
    SQL
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_X(target_grade)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade=?;
    SQL
    DB[:conn].execute(sql,target_grade)
  end

  def self.first_X_students_in_grade_10(count)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade=10
    LIMIT ?;
    SQL
    DB[:conn].execute(sql, count)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT 1;
    SQL
    self.new_from_db(DB[:conn].execute(sql).flatten)
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
