module Speak
  def speak(sound)
    puts sound
  end
end

class Penguin
  include Speak
end

adelieksey = Penguin.new

adelieksey.speak("I want krill")