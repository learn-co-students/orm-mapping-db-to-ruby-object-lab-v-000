class Student
#===========================================================
# See DRY helper methods lines 100-106
  attr_accessor :id, :name, :grade
#======================class methods========================
  def self.new_from_db(row)
    song = self.new.tap do |song|
    song.id = row[0]
    song.name =  row[1]
    song.grade = row[2]
    end
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    #======================
    new_from_query(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    #====================== 
    new_from_query_arg(sql, name)[0]
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    #====================== 
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL
    #======================
    new_from_query(sql)
  end
#===================query class methods=====================
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL
    #======================
    new_from_query(sql)
  end
  
  def self.first_X_students_in_grade_10(n)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL
    #======================
    new_from_query_arg(sql, n)
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL
    #======================
    new_from_query(sql)[0]
  end
  
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    #======================
    new_from_query_arg(sql, grade)
  end
#=====================instance methods====================== 
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    #======================
    DB[:conn].execute(sql, self.name, self.grade)
  end
#=======================DRY Helpers========================= 
  def self.new_from_query(sql)
    DB[:conn].execute(sql).map{|row| self.new_from_db(row)}
  end
  
  def self.new_from_query_arg(sql, x)
    DB[:conn].execute(sql, x).map{|row| self.new_from_db(row)}
  end
#===========================================================  
end
