class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    s = self.new
    s.id = row[0]
    s.name = row[1]
    s.grade = row[2]
    s
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      select *
      from Students
    SQL
    DB[:conn].execute(sql).map { |s| self.new_from_db(s) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      select *
      from Students
      where name = ?
    SQL
    DB[:conn].execute(sql, name).map { |s| self.new_from_db(s) }.first
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
  
  def self.all_students_in_grade_9
    self.all.select{|x| x.grade.to_i == 9}
  end
  
  def self.students_below_12th_grade
    self.all.select{|x| x.grade.to_i < 12}
  end
  
  def self.first_X_students_in_grade_10(n)
    self.all.select{|x| x.grade.to_i == 10}.first(n)
  end
  
  def self.first_student_in_grade_10
    self.all.select{|x| x.grade.to_i == 10}.first
  end
  
  def self.all_students_in_grade_X(n)
    self.all.select{|x| x.grade.to_i == n}
  end
end
