class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
  end

  def speed_up(s)
    @speed += s
  end

  def brake(s)
    @speed -= s
  end

  def shut_off
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

  def to_s
    "This car is a #{color} #{@model} from #{year}."
  end
end

camry = MyCar.new(1999, 'grey', 'toyota camry')
camry.speed_up(20)
camry.current_speed
camry.color = 'silver'
puts camry.color

MyCar.gas_mileage(25, 800)

puts camry