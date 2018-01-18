class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    Student.new.tap do |student|
      student.id, student.name, student.grade = row
    end
  end

  def self.all
    DB[:conn].execute(<<-SQL).map{|student_row| self.new_from_db(student_row)}
      SELECT * FROM students;
    SQL
  end

  def self.find_by_name(name)
    student_row = DB[:conn].execute(<<-SQL, name).first
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    self.new_from_db(student_row)
  end

  def save
    DB[:conn].execute(<<-SQL, self.name, self.grade)
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL
  end

  def self.create_table
    DB[:conn].execute(<<-SQL)
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    SQL
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute(<<-SQL).map{|student_row| self.new_from_db(student_row)}
      SELECT *
      FROM students
      WHERE students.grade = 9;
    SQL
  end

  def self.students_below_12th_grade
    DB[:conn].execute(<<-SQL).map{|student_row| self.new_from_db(student_row)}
      SELECT *
      FROM students
      WHERE students.grade < 12;
    SQL
  end

  def self.first_x_students_in_grade_10(x)
    DB[:conn].execute(<<-SQL, x).map{|student_row| self.new_from_db(student_row)}
      SELECT *
      FROM students
      WHERE students.grade = 10
      ORDER BY students.id ASC
      LIMIT ?;
    SQL
  end

  def self.first_student_in_grade_10
    self.first_x_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_x(grade_x)
    DB[:conn].execute(<<-SQL, grade_x).map{|student_row| self.new_from_db(student_row)}
      SELECT *
      FROM students
      WHERE students.grade = ?;
    SQL
  end
end
