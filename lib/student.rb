class Student
  attr_accessor :id, :name, :grade



  def self.all
    sql = <<-SQL
      SELECT * FROM students;
    SQL

    data = DB[:conn].execute(sql);

    all_students = Array.new;

    data.each do | datum |
      new_student = Student.new_from_db(datum);
      all_students << new_student;
    end
    all_students;
  end

  def self.new_from_db(record)
    new_student = Student.new
    new_student.id = record[0];
    new_student.name = record[1];
    new_student.grade = record[2];
    new_student;
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    new_student = Student.new_from_db(DB[:conn].execute(sql, name)[0]);
    new_student;
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = '9'
    SQL

    data = DB[:conn].execute(sql);
    data.collect do | datum |
      datum = Student.new_from_db(datum);
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < '12'
    SQL

    data = DB[:conn].execute(sql);
    data.collect do | datum |
      datum = Student.new_from_db(datum);
    end
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students LIMIT ?
    SQL

    data = DB[:conn].execute(sql, num);
    data.collect do | datum |
      datum = Student.new_from_db(datum);
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = '10' limit 1
    SQL

    data = Student.new_from_db(DB[:conn].execute(sql)[0]);
  end

  def self.all_students_in_grade_X(num)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    data = DB[:conn].execute(sql, num);
    data.collect do | datum |
      datum = Student.new_from_db(datum);
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
