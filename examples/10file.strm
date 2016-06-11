class Student
  def initialize(name, age)
  	@age = age
  	@name = name
  end

  def to_s
  	"My name #@name, I'm #@age."
  end
end

studentlize = lambda do |str|
  Student.new(*str.split(","))
end

line_io("student.csv").
  | chomp.
  | studentlize.
  | STDOUT