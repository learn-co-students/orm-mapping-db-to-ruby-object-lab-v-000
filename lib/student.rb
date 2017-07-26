class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
     obj= self.new
     obj.id=row[0]
     obj.name=row[1]
     obj.grade=row[2]
     obj
    # create a new Student object given a row from the database
  end

  def self.all
    sql= <<-SQL
       SELECT * from students
       SQL
       DB[:conn].execute(sql).map do |e|
         self.new_from_db(e)
       end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end
  def self.count_all_students_in_grade_9
   list=[]
   sql= <<-SQL
      SELECT * FROM students WHERE grade=?
      SQL
      DB[:conn].execute(sql,9).each do |e|
        obj=self.new_from_db(e)
        list<<obj
      end
      list
  end
  def self.students_below_12th_grade
    list=[]
    sql= <<-SQL
       SELECT * FROM students WHERE grade<?
       SQL
       DB[:conn].execute(sql,12).each do |e|
         obj=self.new_from_db(e)
         list<<obj
       end
       list
  end
  def self.first_x_students_in_grade_10(x)
    list=[]
    sql= <<-SQL
       SELECT * FROM students WHERE grade=?
       SQL
       c=0
       while (c<x)
         e=DB[:conn].execute(sql,10)[c]
         obj=self.new_from_db(e)
         list<<obj
         c+=1
      end
       list
   end
   def self.first_student_in_grade_10
     obj=nil
     sql= <<-SQL
        SELECT * FROM students WHERE grade=?
        SQL
          e=DB[:conn].execute(sql,10)[0]
          obj=self.new_from_db(e)
          obj
   end
   def self.all_students_in_grade_x(x)
     list=[]
     sql= <<-SQL
        SELECT * FROM students WHERE grade=?
        SQL
        DB[:conn].execute(sql,x).each do |e|
          obj=self.new_from_db(e)
          list<<obj
        end
        list

   end



  def self.find_by_name(name)
    sql= <<-SQL
       SELECT * from students where name = ?
       SQL
       DB[:conn].execute(sql,name).map do |e|
         self.new_from_db(e)

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
end
