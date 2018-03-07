class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    nu_stud = self.new
    nu_stud.id = row[0]
    nu_stud.name = row[1]
    nu_stud.grade = row[2]
    nu_stud
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    
    DB[:conn].execute(sql).map {|x| self.new_from_db(x)}
  end

  def self.find_by_name(name)
    self.all.each {|x| return x if x.name == name}
  end
  
  def self.count_all_students_in_grade_9
    grade_nine_arr = []
    self.all.each {|x| grade_nine_arr << x if x.grade == "9"}
    grade_nine_arr
  end
  
  def self.students_below_12th_grade
    twelve_under_arr = []
    self.all.each {|x| twelve_under_arr << x if x.grade.to_i < 12}
    twelve_under_arr
  end
  
  def self.first_X_students_in_grade_10(num)
    self.all[0..num-1]
  end
  
  def self.first_student_in_grade_10
    gr_ten_arr = self.all.map {|x| x if x.grade == "10"}
    gr_ten_arr.delete(nil)
    gr_ten_arr[0]
  end
  
  def self.all_students_in_grade_X(num)
    sel_gr_arr = self.all.map {|x| x if x.grade.to_i == num}
    sel_gr_arr.delete(nil)
    sel_gr_arr
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
