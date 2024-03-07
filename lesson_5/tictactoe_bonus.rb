module ComputerMoves
  def check_for_potential_win
    winning_square = nil

    Board::WINNING_LINES.each do |line|
      winning_square = find_winning_square(line)
      break if winning_square
    end

    winning_square
  end

  def check_for_potential_threat
    threat_square = nil

    Board::WINNING_LINES.each do |line|
      threat_square = find_threat_square(line)
      break if threat_square
    end

    threat_square
  end

  def find_winning_square(line)
    current_line_squares = board.squares.select { |key, _| line.include? key }

    if current_line_squares.values.count do |square|
      square.marker == computer.marker
    end == 2
      current_line_squares.select { |_, square| square.unmarked? }
                          .keys.first
    end
  end

  def find_threat_square(line)
    current_line_squares = board.squares.select { |key, _| line.include? key }

    if current_line_squares.values.count do |square|
      square.marker == human.marker
    end == 2
      current_line_squares.select { |_, square| square.unmarked? }
                          .keys.first
    end
  end
end

module Display
  def clear_screen_and_display_board
    Format.clear
    display_scoreboard
    display_board
  end

  def display_board
    puts "=> The board is numbered from 1 (top left) to 9 (bottom right)."
    puts "=> You're playing as #{human.marker}. " \
         "#{computer.name} is playing as #{computer.marker}."
    Format.blank_line
    board.draw
    Format.blank_line
  end

  def display_computer_is_choosing
    "=> #{computer.name} is choosing...".each_char do |char|
      putc char
      sleep(0.05)
      $stdout.flush
    end
    sleep(0.75)
  end

  def display_goodbye_message
    Format.clear
    Format.blank_line
    puts "=> Thanks for playing Tic Tac Toe. Goodbye!"
    Format.blank_line
  end

  def display_grand_result
    Format.blank_line
    puts "=> -------------------------"
    Format.blank_line

    if human.score >= winning_score
      puts "=> CONGRATS! You won the match."
    else
      puts "=> Too bad! #{computer.name} won the match this time."
    end

    Format.blank_line
  end

  def display_how_to
    how_to = <<~HOWTO
    => This game follows the best-of principle, meaning you'll play a series of
    => rounds, and the first player to win the majority of rounds is the grand winner!
    => For example, best of 5 means the first to win 3 rounds is the winner.

    => You can play a match of up to 10 rounds.
    HOWTO

    Format.clear
    display_welcome_message
    puts how_to
  end

  def display_invalid_choice
    puts "=> Sorry, that's not a valid choice."
  end

  def display_invalid_marker_input
    puts "=> Sorry, that is not a valid marker."
    Format.blank_line
  end

  def display_invalid_name_input
    puts "=> Sorry, that's not a valid name."
    Format.blank_line
  end

  def display_round_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "=> You won this round!"
    when computer.marker
      puts "=> #{computer.name} won this round!"
    else
      puts "=> It's a tie!"
    end
  end

  def display_scoreboard
    scores = <<~SCORES
    -------------------------
            SCOREBOARD
    -------------------------
     #{human}: #{human.score}   #{computer}: #{computer.score}
    -------------------------

    SCORES

    Format.clear
    puts scores
  end

  def display_welcome_message
    welcome = <<~WELCOME
    =>  WELCOME TO TIC TAC TOE!
    => -------------------------

    WELCOME

    Format.clear
    puts welcome
  end
end

module Format
  def self.blank_line
    puts
  end

  def self.clear
    system 'clear'
  end

  def self.joinor(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then '' # NECESSARY?
    when 1 then arr.first.to_s
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end
end

module Prompt
  def prompt_choice
    print "=> Choose a square (#{Format.joinor(board.unmarked_keys)}): "
  end

  def prompt_human_name
    print "=> Please enter your name: "
  end

  def prompt_keep_playing
    Format.blank_line
    sleep(0.5)
    "=> Get ready for the next round...".each_char do |char|
      putc char
      sleep(0.05)
      $stdout.flush
    end
    sleep(0.75)
  end

  def prompt_marker
    print "=> Please pick your marker (any letter from A - Z): "
  end

  def prompt_round_number
    Format.blank_line
    print "=> Please choose how many rounds you'd like to play: "
  end

  def prompt_play_again
    Format.blank_line
    print "=> Would you like to play again? (y/n) "
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
                   [1, 4, 7], [2, 5, 8], [3, 6, 9], # columns
                   [1, 5, 9], [3, 5, 7]]            # diagonals

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "         |     |     "
    puts "      #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}  "
    puts "         |     |     "
    puts "    -----|-----|-----"
    puts "         |     |     "
    puts "      #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}  "
    puts "         |     |     "
    puts "    -----|-----|-----"
    puts "         |     |     "
    puts "      #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}  "
    puts "         |     |     "
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def [](key)
    @squares[key]
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end

    nil
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).map(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def to_s
    marker
  end
end

class Player
  attr_accessor :name, :marker
  attr_reader :score

  POSSIBLE_MARKERS = ('A'..'Z').to_a

  @@taken_marker = []

  def initialize
    set_name
    set_marker
    @score = 0
  end

  def increment_score
    @score += 1
  end

  def reset_score
    @score = 0
  end

  def to_s
    name
  end
end

class Human < Player
  include Display, Prompt

  private

  def set_name
    n = nil

    loop do
      prompt_human_name
      n = gets.chomp
      break unless n.strip.empty?
      display_invalid_name_input
    end

    self.name = n
  end

  def set_marker
    m = nil

    loop do
      prompt_marker
      m = gets.upcase.chomp
      break if POSSIBLE_MARKERS.include? m
      display_invalid_marker_input
    end

    self.marker = m
    @@taken_marker << m
  end
end

class Computer < Player
  private

  NAMES = %w(R2D2 Hal WALL-E Bender Marvin)

  def set_name
    self.name = NAMES.sample
  end

  def set_marker
    self.marker = if @@taken_marker.include? 'O'
                    (POSSIBLE_MARKERS - @@taken_marker).sample
                  else
                    'O'
                  end
  end
end

# Game Orchestration Engine
class TTTGame
  include ComputerMoves, Display, Prompt

  attr_reader :board, :human, :computer, :winning_score, :first_to_move

  def initialize
    display_welcome_message
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @winning_score = (set_match_number / 2) + 1
    @first_to_move = computer.marker
  end

  def play
    main_game
    display_goodbye_message
  end

  private

  def main_game
    loop do
      play_match
      break unless play_again?
      reset_game
    end
  end

  def play_match
    loop do
      play_round
      break if someone_won_match?
      prompt_keep_playing
    end

    display_grand_result
  end

  def play_round
    reset_round

    loop do
      display_scoreboard
      display_board
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end

    update_scores
    display_round_result
  end

  #------------------------------------------------------#
  def change_turn
    @turn = human_turn? ? computer.marker : human.marker
  end

  def change_first_to_move
    @first_to_move = if @first_to_move == human.marker
                       computer.marker
                     else
                       human.marker
                     end
  end

  def current_player_moves
    human_turn? ? human_moves : computer_moves
    change_turn
  end

  def computer_moves
    display_computer_is_choosing

    square = check_for_potential_win
    square = check_for_potential_threat if !square

    if !square
      square = board[5].unmarked? ? 5 : board.unmarked_keys.sample
    end

    board[square] = computer.marker
  end

  def human_moves
    square = nil
    loop do
      prompt_choice
      square = gets.chomp.to_i
      break if board.unmarked_keys.include? square
      display_invalid_choice
    end

    board[square] = human.marker
  end

  def human_turn?
    @turn == human.marker
  end

  def play_again?
    answer = nil

    loop do
      prompt_play_again
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      display_invalid_choice
    end

    answer == 'y'
  end

  def reset_game
    board.reset
    human.reset_score
    computer.reset_score
    @first_to_move = computer.marker
  end

  def reset_round
    board.reset
    change_first_to_move
    @turn = @first_to_move
  end

  def set_match_number
    n = nil
    display_how_to

    loop do
      prompt_round_number
      n = gets.chomp.to_i
      break if (1..10).include? n
      display_invalid_choice
    end

    n
  end

  def someone_won_match?
    human.score >= winning_score || computer.score >= winning_score
  end

  def update_scores
    case board.winning_marker
    when human.marker then human.increment_score
    when computer.marker then computer.increment_score
    end
  end
end

game = TTTGame.new
game.play
