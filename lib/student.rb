class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student_new = self.new
    student_new.id = row[0]
    student_new.name = row[1]
    student_new.grade = row[2]
    student_new
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students;
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.name = ?
    ;
    SQL

    row = DB[:conn].execute(sql, name).flatten
    self.new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT COUNT(students.grade) FROM students
    WHERE students.grade = 9;
    SQL
    DB[:conn].execute(sql).flatten
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    GROUP BY students.grade
    HAVING students.grade < 12;
    SQL
    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.grade = 10 LIMIT(?);
    SQL
    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.grade = 10
    ORDER BY students.id LIMIT(1);
    SQL
    self.new_from_db(DB[:conn].execute(sql).flatten)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.grade = ?;
    SQL
    DB[:conn].execute(sql, x)
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
