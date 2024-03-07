class Student
  def initialize(n, g)
    @name = n
    @grade = g
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected
  def grade
    @grade
  end

end

joe = Student.new('Joe', 89)
bob = Student.new('Bob', 76)

puts "Well done!" if joe.better_grade_than?(bob)