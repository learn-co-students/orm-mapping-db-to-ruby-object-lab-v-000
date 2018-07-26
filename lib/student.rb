class Student
    attr_accessor :id, :name, :grade

    def self.new_from_db(row)
        student = self.new
        student.id = row[0]
        student.name = row[1]
        student.grade = row[2]
        student
    end

    def self.all
        sql = <<-SQL
        select * from students
        SQL
        DB[:conn].execute(sql).map { |row|  self.new_from_db(row)}
    end

    def self.find_by_name(name)
        sql = <<-SQL
        select * from students where name = ?
        SQL
        DB[:conn].execute(sql, name).map { |row|  self.new_from_db(row)}.first
    end

    def save
        sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
        SQL

        DB[:conn].execute(sql, self.name, self.grade)
    end

    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)
        SQL
        DB[:conn].execute(sql)
    end

    def self.count_all_students_in_grade_9
        sql = "select count(*) from students where grade = 9"
        DB[:conn].execute(sql).map { |std|  self.new_from_db(std)}
    end

    def self.students_below_12th_grade
        sql = "select * from students where grade < 12"
        DB[:conn].execute(sql).map { |std|  self.new_from_db(std)}
    end

    def self.first_X_students_in_grade_10(num)
        sql = "select * from students where grade = 10 limit ?"
        DB[:conn].execute(sql, num).map { |std|  self.new_from_db(std)}
    end

    def self.first_student_in_grade_10
        sql = "select * from students where grade = 10 limit 1"
        DB[:conn].execute(sql).map { |std|  self.new_from_db(std)}.first
    end

    def self.all_students_in_grade_X(x)
        sql = "select * from students where grade = ?"
        DB[:conn].execute(sql, x).map { |std|  self.new_from_db(std)}
    end

    def self.drop_table
        sql = "DROP TABLE IF EXISTS students"
        DB[:conn].execute(sql)
    end
end
