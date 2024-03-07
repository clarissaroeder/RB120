class Person
   attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_name(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_name(full_name)
  end

  def to_s
    name
  end

  private

  def parse_name(full_name)
    names = full_name.split
    @first_name = names.first
    @last_name = names.size > 1 ? names.last : ''
  end

end

# p bob = Person.new('Robert')
# p bob.name                  # => 'Robert'
# p bob.first_name            # => 'Robert'
# p bob.last_name             # => ''
# p bob.last_name = 'Smith'
# p bob.name                  # => 'Robert Smith'

# p bob.name = "John Adams"
# p bob.first_name            # => 'John'
# p bob.last_name             # => 'Adams'

# p bob = Person.new('Robert Smith')
# p rob = Person.new('Robert Smith')

# p rob.name == bob.name

p bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"