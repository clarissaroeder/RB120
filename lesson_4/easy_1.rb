=begin

Question 1:
all 4 are objects
find out which class by invoking #class on the object

Question 2:
use include Speed to include the module
Then try it out: instantiate a new object and call the go_fast method on it

Question 3:
By using the reserved word self, which inside an instance method in a class
references the calling object. When we call small_car.go_fast, small_car is the calling 
object and the invocation of the #class method on that objects returns Car.
There is no need to call to_s on the return value because string interpolation does that automatically.

Quesion 4:
cat1 = AngryCat.new

Quesiton 5:
The class Pizza, because it has a variable @name that is prefixed with an @, meaning it's an instance variable
You can also ask an object if it has any instance variables. So you could create two example objects and ask:

>> hot_pizza.instance_variables
=> [:@name]
>> orange.instance_variables
=> []

Question 6:
The default return value of to_s is the objects class and an encoding of the object id
You could look a general definition of to_s up in the Ruby Documentation under Object#to_s

Question 7:
self here refers to the specific instance that will be calling the method

Question 8:
In this case self refers to the class itself, it's equivalent to calling Cat.cats_count

Question 9:
my_bag = Bag.new("black", "leather")