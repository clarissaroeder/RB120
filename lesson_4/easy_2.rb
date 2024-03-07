=begin

Question 1
A string will be returned "You will [something]" with something chosen randomly from choices

Question 2
A string is returned: "You will [something]" with something randomly chosen from the choices defined in RoadTrip.

We're calling #predict_the_future on a RoadTrip object. Everytime Ruby tries to resolve a method, it will start
in the RoadTrip class and then work its way up the inheritance chain

Question 3
By calling #ancestors on a class you can see the hierarchy through which Ruby will look for methods etc.

Orange / HotSauce
Taste
Object
Kernel
BasicObject

#ancestors is a class method and will not work on specific instances, unless they also have an #ancestors method defined

Question 4
attr_accessor :type   replaces both the getter and setter methods that are currently manually defined
Inside the describe_type method you can then reference the getter method instead of the instance variable directly

Question 5
excited_dog = local variable
@excited_dog = instance variable (as per single @)
@@excited_dog = class variable (as per double @@)

Question 6
The #manufacturer method is a class method, as per the use of the keyword self in the method definition before the method name.
To call: Television.manufacturer

Question 7
The @@cats_count variable is a class variable that is intended to keep track of how many Cat objects have been instantiated, as 
it's set to increment by one everytime #initialise is called. To test this, I would instantiate some Cat objects and see if the 
@@cats_count variable change accordingly:

Cat.cats_count => expected: 0
cat1 = Cat.new("tabby")
cat2 = Cat.new("black")
Cat.cats_count => expected: 2

Question 8
add "< Game" after the class name:

class Bingo < Game
  ...
end

Question 9
If we added a play method to the Bingo class, that would override the play method of the Game class.
This means, that every time a Bingo object calls the play method, it will call the play method of the Bingo class rather
than then one of the Game class, which is the Bingos superclass. This is because Ruby's method lookup path starts at the calling
object's class definition, and if it finds a definition there, it stops looking further up the inheritance chain.

Question 10
Benefits of OOP:
- Less dependence throughout the programme: less ripple effects
- More managable
- Encapsulation: possible to protect data and only make necessary information available to all of the programme/the interface
- Namespacing issues become less
- Allows for abstraction: can create more general classes and more refined subclasses
- Also allows for more realistic representation of real world objects
- Reuse of functionality within a programme without duplication of code
- Reuse of functionality across programmes


=end


class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

trip = RoadTrip.new
p trip.predict_the_future