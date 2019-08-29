class Student
    attr_accessor :id, :name, :grade

    def self.new_from_db(row)
        self.new.tap do |student|
            student.id = row[0]
            student.name = row[1]
            student.grade = row[2]
        end
    end

    def self.reify(db_data)
        db_data.map { |row| self.new_from_db(row) }
    end

    def self.all
        self.reify(DB[:conn].execute("SELECT * FROM students"))
    end

    def self.find_by_name(name)
        self.reify(DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)).first
    end

    def self.count_all_students_in_grade_9
        self.reify(DB[:conn].execute("SELECT * FROM students WHERE grade = ?", 9))
    end

    def self.students_below_12th_grade
        self.reify(DB[:conn].execute("SELECT * FROM students WHERE grade < ?", 12))
    end

    def self.first_x_students_in_grade_10(x)
        self.reify(DB[:conn].execute("SELECT * FROM students WHERE grade = ? LIMIT ?", 10, x))
    end

    def self.first_student_in_grade_10
        self.reify(DB[:conn].execute("SELECT * FROM students WHERE grade = ? LIMIT ?", 10, 1)).first
    end

    def self.all_students_in_grade_x(x)
        self.reify(DB[:conn].execute("SELECT * FROM students WHERE grade = ?", x))
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
        DB[:conn].execute("DROP TABLE IF EXISTS students")
    end

    def save
        sql = <<-SQL
            INSERT INTO students (name, grade) 
            VALUES (?, ?)
        SQL

        DB[:conn].execute(sql, self.name, self.grade)
    end
end
