class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new = self.new
    new.id = row[0]
    new.name = row[1]
    new.grade = row[2]
    new
  end

  def self.all
    sql = <<-SQL
        SELECT *
        FROM students
    SQL
    DB[:conn].execute(sql).collect do |row|
        self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE students.name = ?
        LIMIT 1
      SQL

      DB[:conn].execute(sql, name).collect do |row|
          self.new_from_db(row)
      end.first
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
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE students.grade = 9
      SQL

      DB[:conn].execute(sql).collect do |row|
        self.new_from_db(row)
        end
  end

  def self.students_below_12th_grade
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE students.grade < 12
      SQL

      DB[:conn].execute(sql).collect do |row|
        self.new_from_db(row)
      end
   end

   def self.first_X_students_in_grade_10(number)
       sql = <<-SQL
            SELECT *
            FROM students
            WHERE students.grade = 10
            LIMIT ?
       SQL

       DB[:conn].execute(sql, number).collect do |row|
           self.new_from_db(row)
       end
   end


end
