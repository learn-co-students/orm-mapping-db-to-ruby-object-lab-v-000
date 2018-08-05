class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
          SELECT * FROM students
          SQL
    array_of_rows = DB[:conn].execute(sql)

    # create new student objects
    array_of_rows.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    self.all.detect do |student|
      student.name = name
    end
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
          SELECT COUNT(id) FROM students
          WHERE grade = 9
          SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    self.all.select do |student|
      if student.grade.to_i < 12
        true
      end
    end
  end

  def self.first_X_students_in_grade_10(number)
    grade_10_students = self.all.select do |student|
      student.grade.to_i == 10
    end
    grade_10_students.take(number)
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(grade)
    self.all.select do |student|
        student.grade == grade.to_s
    end
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
