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
    get_all_sql = <<-SQL
        SELECT * FROM students;
      SQL
    all_info = DB[:conn].execute(get_all_sql)
    all_info.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql_find_name = <<-SQL
        SELECT * FROM students WHERE name = ?;
      SQL
    student = DB[:conn].execute(sql_find_name, name)[0]
    self.new_from_db(student)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
        SELECT * FROM students WHERE grade = 9;
      SQL
    info = DB[:conn].execute(sql)
    info.map{|i| self.new_from_db(i)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
        SELECT * FROM students WHERE grade < 12;
      SQL

    info = DB[:conn].execute(sql);
    info.map{|i| self.new_from_db(i)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
        SELECT * FROM students WHERE grade = 10 LIMIT ?
      SQL

    info = DB[:conn].execute(sql, x)
    info.map{|i| self.new_from_db(i)}
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
        SELECT * FROM students WHERE grade = ?
      SQL
    DB[:conn].execute(sql, x).map{|i| self.new_from_db(i)}
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
