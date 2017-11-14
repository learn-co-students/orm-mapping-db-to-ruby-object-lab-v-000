class Student
  attr_accessor :id, :name, :grade

  def initialize(id=nil,name=nil,grade=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row)
    Student.new(row[0],row[1],row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students where name = ?
    SQL

    DB[:conn].execute(sql,name).map {|r|
      self.new_from_db(r)
    }.first

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM  students
    SQL
    DB[:conn].execute(sql).map {|r|
      self.new_from_db(r)
    }
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
    sql = "SELECT COUNT(ID) FROM students where grade = 9"
    DB[:conn].execute(sql).first
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students where grade < 12"
    DB[:conn].execute(sql).map {|r|
      self.new_from_db(r)
    }
  end

  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students where grade = 10 LIMIT ?"
    DB[:conn].execute(sql,x).map {|r|
      self.new_from_db(r)
    }
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students where grade = ?"
    DB[:conn].execute(sql,x).map {|r|
      self.new_from_db(r)
    }
  end

end
