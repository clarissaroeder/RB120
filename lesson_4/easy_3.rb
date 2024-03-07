=begin

Question 1
case 1: prints "Hello", returns nil
case 2: no Method Error: bye is defined in GoodBye class
case 3: Argument Error: expected 1, given 0
case 4: prints "Goodby" returns nil
case 5: No method error: there is no such class method hi


Question 2
Define a class method hi:
def self.hi
  #code
end

Question 3
cat1 = AngryCat(7, "garfield")
cat2 = AngryCat(10, "tom")

Question 4

class Cat
  attr_reader :type
  ...

  def to_s
    "I am a #{type} cat"
  end
end

Question 5

tv = Television.new
tv.manufacturer => undefined method error, because manufacturer is a class method
tv.model => returns whatever the method is defined to return

Television.manufacturer => returns whatever the method is defined to return
Television.model => undefined method error, because this is an instance method

Question 6
class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    @age += 1
  end
end

Question 7
"return" -  The string is implicitly returned anyway without the keyword
