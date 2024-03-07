module Towable
  def can_tow?(pounds)
    pounds < 2000
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model

  @@number_of_vehicles = 0

  def initialize(y, c, m)
    @@number_of_vehicles += 1
    @year = y
    @color = c
    @model = m
    @speed = 0
  end

  def speed_up(s)
    puts "You pump the gas and increase speed by #{s} mph."
    @speed += s
  end

  def brake(s)
    puts "You hit the brakes and decrease speed by #{s} mph."
    @speed -= s
  end

  def shut_off
    puts "Let's park!"
    @speed = 0
  end

  def current_speed
    puts "You're going #{@speed} mph."
  end

  def spray_paint(new_color)
    self.color = new_color
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def self.how_many_vehicles
    puts "There are #{@@number_of_vehicles} vehicles."
  end

  def age
    "Your #{self.model} is #{years} years old."
  end

  private

  def years
    Time.now.year - self.year
  end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4

  def to_s
    "This car is a #{color} #{@model} from #{year}."
  end
end

class MyTruck < Vehicle
  include Towable
  NUMBER_OF_DOORS = 2

  def to_s
    "This truck is a #{color} #{@model} from #{year}."
  end
end

# ------------------------------------------------- 

camry = MyCar.new(1999, 'grey', 'toyota camry')
camry.speed_up(20)
camry.current_speed
camry.shut_off
camry.color = 'silver'
puts camry.color
puts camry.age

MyCar.gas_mileage(25, 800)

puts camry
puts

truck = MyTruck.new(2004, 'blue', 'ford something')
truck.speed_up(35)
truck.current_speed
truck.brake(15)
truck.current_speed
puts truck.can_tow?(2001)
truck.color = 'navy blue'
puts truck.age
puts truck.color
puts truck 
puts

puts "--- Car Ancestors --"
puts MyCar.ancestors
puts
puts "--- Truck Ancestors --"
puts MyTruck.ancestors