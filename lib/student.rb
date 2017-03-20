require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_song = self.new
    new_song.id = row[0]
    new_song.name = row[1]
    new_song.grade = row[2]
    new_song
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
    # find the student in the database given a name
    # return a new instance of the Student class


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
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    GROUP BY grade
    HAVING grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    SQL

    number = 1
    array = []

    DB[:conn].execute(sql).each do |row|
      while number <= x
        array << self.new_from_db(row)
        number+=1
      end
    end
    array
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

def self.all_students_in_grade_x(number)
  sql = <<-SQL
  SELECT *
  FROM students
  SQL

  DB[:conn].execute(sql).map do |row|
    if row[1] = number
      self.new_from_db(row)
    end
  end
end

end
