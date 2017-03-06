class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student=self.new
    student.id=row[0]
    student.name=row[1]
    student.grade=row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    rows= DB[:conn].execute('SELECT * FROM students')
    all=rows.map { |e| self.new_from_db(e) }
    all
  end

  def self.count_all_students_in_grade_9
    rows= DB[:conn].execute('SELECT * FROM students WHERE grade=9')
    all=rows.map { |e| self.new_from_db(e) }
    all
  end

  def self.students_below_12th_grade
    rows= DB[:conn].execute('SELECT * FROM students WHERE grade<12')
    all=rows.map { |e| self.new_from_db(e) }
    all
  end

  def self.first_x_students_in_grade_10(x)
    rows= DB[:conn].execute('SELECT * FROM students WHERE grade=10 LIMIT 2')
    all=rows.map { |e| self.new_from_db(e) }
    all
  end

  def self.first_student_in_grade_10
    self.first_x_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_x(x)
    rows= DB[:conn].execute('SELECT * FROM students WHERE grade=?',x)
    all=rows.map { |e| self.new_from_db(e) }
    all
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    row=DB[:conn].execute('SELECT * FROM students WHERE name=?',name)[0]
    self.new_from_db(row)
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
