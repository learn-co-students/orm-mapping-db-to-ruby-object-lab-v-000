class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    r=self.new;r.id=row[0];r.name=row[1];r.grade=row[2];r

    # create a new Student object given a row from the database
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map{|r| new_from_db(r)}
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students WHERE name IS ?",name).map{|r| new_from_db(r)}[0]
  end
  
  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade IS 9").map{|r| new_from_db(r)}
  end
  def self.first_x_students_in_grade_10(n)
    DB[:conn].execute("SELECT * FROM students WHERE grade IS 10 LIMIT ?",n).map{|r| new_from_db(r)}
  end
  def self.first_student_in_grade_10
    first_x_students_in_grade_10(1)[0]
  end
  
  def self.all_students_in_grade_x(g)
     DB[:conn].execute("SELECT * FROM students WHERE grade IS ?",g).map{|r| new_from_db(r)}
  end
  
  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade<12").map{|r| new_from_db(r)}
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
