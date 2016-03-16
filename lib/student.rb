class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
    SELECT *
    FROM students;
    SQL
    rows = DB[:conn].execute(sql)
    
    # remember each row should be a new instance of the Student class
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE name = ?
      LIMIT 1;
    SQL
    student_row = DB[:conn].execute(sql, name)

    # return a new instance of the Student class
    # call .first because the return is an array with a nested array - you want that nested array
    student_row.map do |row|
      self.new_from_db(row)
    end.first

  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    #call .first x2 because the return is an array and you want the first value (i.e., id) of the nested array
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
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
    #returns an array of all students in grade 9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9;
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    #returns an array of all students below 12th grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade <= 11;
    SQL
    DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY students.id 
    LIMIT 1;
    SQL
    first_student_row = DB[:conn].execute(sql)

    first_student_row.map do |row|
      self.new_from_db(row)
    end.first
  end

end
