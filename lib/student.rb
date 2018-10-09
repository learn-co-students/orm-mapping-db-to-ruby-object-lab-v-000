class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    nstudent = self.new
    nstudent.id = row[0]
    nstudent.name = row[1]
    nstudent.grade = row[2]
  end

  def self.all
    sql = <<-SQL
          SELECT *
          FROM students
          SQL

          DB[:conn].execute(sql)
  end

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
