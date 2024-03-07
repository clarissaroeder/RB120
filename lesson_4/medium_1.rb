=begin

Question 1
You don't need an @ because of attr_reader

Question 2
There is only a getter method for quantity, no setter. Add attr_writer, or replace with attr_accessor. 
Or, reference the variable directly with @quantity

Question 3
A problem might be that now it is possible to change the quantity from outside the class,
as the setter method is publicly available.

Question 4
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Question 5
class KrispyKreme
  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    filling_string = @filling_type ? @filling_type : "Plain"
    glazing_string = @glazing ? " with #{@glazing}" : ''
    filling_string + glazing_string
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1 #  => "Plain"
puts donut2 #  => "Vanilla"
puts donut3 #  => "Plain with sugar"
puts donut4 #  => "Plain with chocolate sprinkles"
puts donut5 #  => "Custard with icing"

Question 6
There is no difference - the code works the exact same. The self keyword is unnecessary
to refer to the getter method though, and should be avoided if not needed.

Question 7
def status as opposed to light_status -> The class is called Light, so every object we'll be calling
this method on we know is a Light. It's therefore not necessary to point out that we're asking for 
the light status, as that's obvious.