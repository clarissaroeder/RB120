module Formattable
  def blank_line
    puts
  end

  def clear
    system 'clear'
  end

  def continue
    print "=> Press Enter to continue. "
    gets
  end

  def double_separator
    puts "=" * Displayable::WIDTH
    blank_line
  end

  def single_separator
    puts "-" * Displayable::WIDTH
    blank_line
  end
end

module Promptable
  include Formattable

  def prompt_choice
    choice = nil
    loop do
      print "=> It's your turn... Would you like to (h)it or (s)tay? "
      choice = gets.chomp.downcase
      break if %w(h s).include? choice
      puts "=> Sorry, that's not a valid choice."
      blank_line
    end
    choice
  end

  def prompt_name
    print "=> What's your name? "
  end

  def invalid_name
    puts "=> Please enter a valid name of 1-12 characters."
    blank_line
  end

  def prompt_play_again
    double_separator
    print "=> Do you want to play again? (y/n) "
  end

  def invalid_play_again
    puts "=> Please enter 'y' for yes, or 'n' for no."
    blank_line
  end

  def prompt_winning_score
    print "=> How many points would you like to play for (1-10)? "
  end

  def invalid_score
    puts "=> Please enter a number between 1 and 10."
    blank_line
  end
end

module Displayable
  include Promptable

  WIDTH = 80

  def display_goodbye_message
    clear
    puts "=> Thanks for playing 21. Goodbye!"
    blank_line
  end

  def display_grand_result
    single_separator
    if player.score == winning_score
      puts "=> CONGRATS! You won the game!"
    else
      puts "=> Too bad, #{dealer} won the game this time!"
    end
    blank_line
  end

  def display_how_to_play
    display_welcome_banner

    how_to = <<~HOWTO
    => You'll play against #{dealer}. Build a hand total of 21, or as close as
    => possible, without going over. Numbered cards are worth their value, face
    => cards are 10 points, and Ace can be 1 or 11 points.

    => First to win #{winning_score} rounds wins the game!

    HOWTO
    puts how_to
  end

  def display_round_result
    puts case detect_result
         when :player_busted
           "=> Looks like you busted. #{dealer} won!"
         when :dealer_busted
           "=> Looks like #{dealer} busted. You won!"
         when :tie
           puts "=> It's a tie!"
         else
           "=> #{detect_result == :win ? 'You' : dealer} won!"
         end
  end

  def display_scoreboard
    clear
    puts " SCOREBOARD ".center(WIDTH, '=')
    print "#{player}: #{player.score}".center(WIDTH / 2)
    puts "#{dealer}: #{dealer.score}".center(WIDTH / 2)
    double_separator
  end

  def display_welcome_banner
    clear
    puts " WELCOME TO 21! ".center(WIDTH, '=')
    blank_line
  end

  def display_welcome_message
    display_welcome_banner
    puts "=> Welcome, #{player}! Your dealer for today is #{dealer}."
    blank_line
  end
end

module Hand
  include Displayable

  LEFT_ALIGN = 20
  RIGHT_ALIGN = Displayable::WIDTH

  def blackjack?
    total == 21
  end

  def busted?
    total > 21
  end

  def add_card(new_card)
    hand << new_card
  end

  def show_hand
    name_display = "#{name}'s hand:".ljust(LEFT_ALIGN)
    hand_display = hand.join(' |  ')

    total_width = LEFT_ALIGN + hand_display.length

    print name_display
    print hand_display
    puts format("Total: %2d", total).rjust(RIGHT_ALIGN - total_width)
    blank_line
  end

  def show_up_and_hole_card
    name_display = "#{name}'s hand:".ljust(LEFT_ALIGN)
    hand_display = "#{hand.first} |  ?  "

    total_width = LEFT_ALIGN + hand_display.length

    print name_display
    print hand_display
    puts "Total:  ?".rjust(RIGHT_ALIGN - total_width)
    blank_line
  end

  def total
    total = hand.reduce(0) { |sum, card| sum + card.value }

    # adjust for aces
    hand.count { |card| card.ace? }.times do
      break if total <= 21
      total -= 10
    end

    total
  end
end

module Turn
  include Displayable

  def player_turn
    if player.blackjack?
      player_has_blackjack
      return
    end

    player_choice

    end_of_round_sequence if player.busted?
  end

  def dealer_turn
    dealer_choice

    end_of_round_sequence if dealer.busted?
  end

  private

  def player_choice
    loop do
      choice = prompt_choice

      if choice == 'h'
        player_hits

        break if player.blackjack?

      elsif choice == 's'
        player_stays
      end

      break if choice == 's' || player.busted?
    end
  end

  def player_hits
    player.add_card(deck.deal_card)
    print "=> You chose to hit! "
    sleep(1)
    show_initial_deal

    return unless player.blackjack?
    player_has_twentyone
  end

  def player_stays
    print "=> You chose to stay! "
    sleep(1)
    show_cards
  end

  def player_has_blackjack
    puts "=> You have a BLACKJACK! Stay here."
    blank_line
    sleep(1.5)
    show_cards
  end

  def player_has_twentyone
    puts "=> You've reached the goal of 21! Stay here."
    blank_line
    sleep(1.5)
    show_cards
  end

  def dealer_choice
    loop do
      dealer_is_choosing

      if dealer.total < 17
        dealer_hits
      elsif dealer.total >= 17 && !dealer.busted?
        dealer_stays
        break
      end

      break if dealer.busted?
    end
  end

  def dealer_is_choosing
    print "=> #{dealer}'s turn... "
    sleep(1.5)
  end

  def dealer_hits
    dealer.add_card(deck.deal_card)
    print "#{dealer} hits! "
    sleep(1)
    show_cards
  end

  def dealer_stays
    print "#{dealer} stays! "
    sleep(1)
  end
end

class Card
  SUITS = ['H', 'D', 'S', 'C']
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10',
           'J', 'Q', 'K', 'A']

  attr_reader :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def to_s
    format("%s %2s", suit, rank)
  end

  def suit
    suit_symbols = {
      'H' => "\u2665",
      'D' => "\u2666",
      'S' => "\u2660",
      'C' => "\u2663"
    }
    suit_symbols[@suit]
  end

  def value
    case @rank
    when 'J', 'Q', 'K' then 10
    when 'A' then 11
    else
      rank.to_i
    end
  end

  def ace?
    rank == 'A'
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::RANKS.each { |rank| @cards << Card.new(suit, rank) }
    end

    cards.shuffle!
  end

  def deal_card
    cards.pop
  end
end

class Participant
  include Hand

  attr_accessor :name, :hand, :score

  def initialize
    set_name
    @score = 0
  end

  def increment_score
    self.score += 1
  end

  def reset_hand
    @hand = []
  end

  def reset_score
    @score = 0
  end

  def to_s
    name
  end

  def ==(other_participant)
    total == other_participant.total
  end

  def >(other_participant)
    total > other_participant.total
  end
end

class Player < Participant
  MAX_NAME_LENGTH = 12

  private

  def set_name
    n = nil

    loop do
      prompt_name
      n = gets.chomp.strip
      break unless n.empty? || n.size > MAX_NAME_LENGTH
      invalid_name
    end

    self.name = n
  end
end

class Dealer < Participant
  ROBOTS = %w(R2D2 Hal Wall-E Bender Marvin)

  private

  def set_name
    self.name = ROBOTS.sample
  end
end

# Game Orchestration Engine
class TwentyOne
  include Turn

  def initialize
    display_welcome_banner
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    welcome_sequence
    play_game
    display_goodbye_message
  end

  private

  attr_reader :player, :dealer, :deck
  attr_accessor :winning_score

  def play_game
    loop do
      play_rounds
      display_grand_result
      break unless play_again?
      reset_scores
    end
  end

  def play_rounds
    loop do
      break if grand_win?
      begin_of_round_sequence

      player_turn
      next if player.busted?

      dealer_turn
      next if dealer.busted?

      end_of_round_sequence
    end
  end

  # ---------------------------------------------------- #
  def begin_of_round_sequence
    reset_round
    initial_deal
    show_initial_deal
  end

  def detect_result
    if player.busted?
      :player_busted
    elsif dealer.busted?
      :dealer_busted
    elsif player == dealer
      :tie
    else
      player > dealer ? :win : :lose
    end
  end

  def end_of_round_sequence
    update_scores
    show_cards
    display_round_result
    blank_line
  end

  def grand_win?
    player.score == winning_score || dealer.score == winning_score
  end

  def initial_deal
    2.times do
      player.add_card(deck.deal_card)
      dealer.add_card(deck.deal_card)
    end
  end

  def play_again?
    answer = nil

    loop do
      prompt_play_again
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      invalid_play_again
    end

    answer == 'y'
  end

  def reset_scores
    player.reset_score
    dealer.reset_score
  end

  def reset_round
    @deck = Deck.new
    player.reset_hand
    dealer.reset_hand
  end

  def set_winning_score
    choice = nil

    loop do
      prompt_winning_score
      choice = gets.chomp.to_i
      break if (1..10).include? choice
      invalid_score
    end

    self.winning_score = choice
  end

  def show_cards
    display_scoreboard
    dealer.show_hand
    player.show_hand
    single_separator
  end

  def show_initial_deal
    display_scoreboard
    dealer.show_up_and_hole_card
    player.show_hand
    single_separator
  end

  def update_scores
    case detect_result
    when :win, :dealer_busted
      player.increment_score
    when :lose, :player_busted
      dealer.increment_score
    end
  end

  def welcome_sequence
    display_welcome_message
    set_winning_score
    display_how_to_play
    continue
  end
end

TwentyOne.new.start
