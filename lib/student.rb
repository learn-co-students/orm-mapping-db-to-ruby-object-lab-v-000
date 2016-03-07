class Student
  attr_accessor :id, :name, :grade

  def save
    sql = (<<-SQL)
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = (<<-SQL)
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

      def self.new_from_db(row)
      student = self.new
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
      student
  end

  def self.all
    student_array = []
    DB[:conn].execute("SELECT * FROM students").each do |student_info|
      student_array << self.new_from_db(student_info)
    end
    student_array
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = (<<-SQL)
          SELECT * FROM students
          WHERE name = ?
          SQL

    student_info = DB[:conn].execute(sql, name).first
    # return a new instance of the Student class
    student = Student.new
    student.id = student_info[0]
    student.name = student_info[1]
    student.grade = student_info[2]
    student
  end

    def self.count_all_students_in_grade_9
      DB[:conn].execute("SELECT * FROM students WHERE grade = '9'")
    end

    def self.students_below_12th_grade
      DB[:conn].execute("SELECT * FROM students WHERE grade != '12'")
    end

    def self.first_student_in_grade_10
      student_info = DB[:conn].execute("SELECT * FROM students WHERE grade = '10'").first
      student = Student.new
      student.id = student_info[0]
      student.name = student_info[1]
      student.grade = student_info[2]
      student
    end

end
