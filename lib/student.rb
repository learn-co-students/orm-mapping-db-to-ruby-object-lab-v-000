class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_song=self.new
    new_song.id=row[0]
    new_song.name=row[1]
    new_song.grade=row[2]
    new_song
    # create a new Student object given a row from the database
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map do |row|
      self.new_from_db(row)
    end
# retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    DB[:conn].execute("SELECT * FROM students WHERE name= ? LIMIT 1", name).map do |row|
      self.new_from_db(row)
    end.first
    # find the student in the database given a name
    # return a new instance of the Student class
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
    DB[:conn].execute("SELECT * FROM students WHERE grade= 9").map do |row|
      self.new_from_db(row)
    end
  end
    def self.students_below_12th_grade
      DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map do |row|
        self.new_from_db(row)
      end
    end
    def self.first_X_students_in_grade_10(x)
        array= DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", x).map do |row|
          self.new_from_db(row)
        end

    end
    def self.first_student_in_grade_10
       DB[:conn].execute("SELECT * FROM students WHERE grade = 10").map do |row|
        self.new_from_db(row)
      end.first
    end
    def self.all_students_in_grade_X(x)
      DB[:conn].execute("SELECT * FROM students WHERE grade = ?", x).map do |row|
        self.new_from_db(row)
      end

    end

  end
