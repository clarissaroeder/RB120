require 'yaml'
MESSAGES = YAML.load_file('rps_messages.yml')

module Display
  COLUMN_WIDTH = 20
  MAX_WIDTH = 48

  def blank_line(n=1)
    n.times do
      puts
    end
  end

  def goodbye_message
    system 'clear'
    puts MESSAGES['div']
    blank_line
    puts MESSAGES['bye']
    blank_line
  end

  def grand_winner(winner)
    puts MESSAGES['div']
    blank_line
    if Computer::NAMES.values.include? winner.name
      puts format(MESSAGES['sorry'], name: winner.name)
    else
      puts MESSAGES['congrats']
    end
    blank_line(2)
  end

  def history_header(move_log)
    puts "#{'Round'.center(COLUMN_WIDTH)}|" \
         "#{move_log.keys[0].center(COLUMN_WIDTH)}|" \
         "#{move_log.keys[1].center(COLUMN_WIDTH)}|" \
         "#{'Winner'.center(COLUMN_WIDTH)}"
  end

  def history_round(round, move_log, idx)
    "#{round.to_s.center(COLUMN_WIDTH)}|" \
      "#{move_log[move_log.keys[0]][idx].center(COLUMN_WIDTH)}|" \
      "#{move_log[move_log.keys[1]][idx].center(COLUMN_WIDTH)}|" \
      "#{move_log[move_log.keys[2]][idx].center(COLUMN_WIDTH)}"
  end

  def history_rounds(move_log)
    horizontal_line
    round = 1

    move_log[move_log.keys[0]].each_index do |idx|
      puts history_round(round, move_log, idx)
      round += 1
    end
  end

  def horizontal_line
    puts ("#{'-' * COLUMN_WIDTH}|" * 3) + ("-" * COLUMN_WIDTH)
  end

  def moves(human, computer)
    puts format(MESSAGES['choice'], name: 'You', move: human.move)
    puts format(MESSAGES['choice'], name: computer.name, move: computer.move)
    blank_line
  end

  def move_history(history)
    system 'clear'
    puts ' MOVE HISTORY '.center(83, '-')
    blank_line
    history_header(history.first.move_log)

    history.each do |game|
      history_rounds(game.move_log)
    end

    blank_line
    print MESSAGES['exit_history']
    gets
  end

  def print_winner(winner, loser)
    name = winner.is_a?(Human) ? 'You' : winner.name
    puts format(MESSAGES['round_result'],
                winner: winner.move.value.capitalize,
                beats: Move::BEATS[winner.move.value][loser.move.value],
                loser: loser.move, name: name)
  end

  def round_winner(winner, loser)
    if winner.is_a?(Symbol)
      puts MESSAGES['tie']
    else
      print_winner(winner, loser)
    end
    blank_line
  end

  def scoreboard(human, computer)
    system 'clear'
    puts "=> #{'SCOREBOARD'.center(MAX_WIDTH)}"
    puts MESSAGES['div']

    human_score = "#{human.name}: #{human.score}"
    comp_score = "#{computer.name}: #{computer.score}"
    puts human_score.center(MAX_WIDTH / 2) + comp_score.center(MAX_WIDTH / 2)
    blank_line(2)
  end

  def welcome_message
    system 'clear'
    puts MESSAGES['welcome']
    puts MESSAGES['div']
    blank_line
  end
end

class Move
  MOVES = { 'r' => 'rock', 'p' => 'paper', 's' => 'scissors', 'l' => 'lizard',
            'v' => 'spock', 'h' => 'history' }

  BEATS = { 'scissors' => { 'paper' => 'cuts', 'lizard' => 'decapitates' },
            'paper' => { 'rock' => 'covers', 'spock' => 'disproves' },
            'rock' => { 'lizard' => 'crushes', 'scissors' => 'crushes' },
            'lizard' => { 'spock' => 'poisons', 'paper' => 'eats' },
            'spock' => { 'scissors' => 'smashes', 'rock' => 'vaporizes' } }

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def >(other_move)
    BEATS[value].keys.include? other_move.value
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
  end

  def increment_score
    self.score += 1
  end

  def reset
    self.score = 0
  end

  def to_s
    name
  end
end

class Human < Player
  def choose
    choice = nil

    loop do
      print MESSAGES['how_to_play'].chomp
      choice = gets.downcase.chomp
      break if valid_choice?(choice)
      puts MESSAGES['invalid_choice']
      puts
    end

    choice = Move::MOVES[choice] if Move::MOVES.keys.include? choice

    self.move = Move.new(choice)
  end

  private

  def set_name
    n = nil
    loop do
      print MESSAGES['name_prompt']
      n = gets.chomp
      break unless n.strip.empty?
      puts MESSAGES['invalid_name']
      puts
    end

    self.name = n
  end

  def valid_choice?(choice)
    (Move::MOVES.values.include? choice) || (Move::MOVES.keys.include? choice)
  end
end

class Computer < Player
  NAMES = { 'r2d2' => 'R2D2', 'hal' => 'Hal', 'chappie' => 'Chappie',
            'sonny' => 'Sonny', 'number 5' => 'Number5' }

  attr_accessor :round_count, :previous_human_move

  def reset
    super
    self.round_count = 1
    self.previous_human_move = nil
  end
end

class R2D2 < Computer
  # Always starts with rock
  def choose(*)
    self.move = if round_count == 1
                  Move.new('rock')
                else
                  Move.new(Move::MOVES.values[0..-2].sample)
                end

    self.round_count += 1
  end

  private

  def set_name
    self.name = 'R2D2'
  end
end

class Hal < Computer
  # Gives you an advantage and then wins
  # ABC too high
  def choose(human, points_to_win)
    human_move = human.move.value
    self.move = if round_count < points_to_win
                  Move.new(Move::BEATS[human_move].keys.sample)
                else
                  Move.new((Move::MOVES.values[0..-2] -
                                    Move::BEATS[human_move].keys -
                                    [human_move]).sample)
                end

    self.round_count += 1
  end

  private

  def set_name
    self.name = 'Hal'
  end
end

class Chappie < Computer
  # Only plays rock, paper, scissors
  def choose(*)
    self.move = Move.new(Move::MOVES.values[0..2].sample)
  end

  private

  def set_name
    self.name = 'Chappie'
  end
end

class Sonny < Computer
  # Starts with rock
  # Learns the human's previous move and counters accordingly on the next
  def choose(human, _points_to_win)
    self.move = if previous_human_move.nil?
                  Move.new('rock')
                else
                  losing_moves = Move::BEATS[previous_human_move].keys
                  winning_moves = Move::MOVES.values[0..-2] - losing_moves -
                                  [previous_human_move]

                  Move.new(winning_moves.sample)
                end

    self.previous_human_move = human.move.value
  end

  private

  def set_name
    self.name = 'Sonny'
  end
end

class Number5 < Computer
  # Chooses paper, lizard, spock with 3 x the likelihood
  def choose(*)
    winning_moves = Move::MOVES.values[0..-2] +
                    (['paper', 'lizard', 'spock'] * 2)
    self.move = Move.new(winning_moves.sample)
  end

  private

  def set_name
    self.name = 'Number 5'
  end
end

class MoveLog
  attr_accessor :move_log, :winner

  def initialize(human, computer)
    @move_log = { human.name => [], computer.name => [], @winner => [] }
  end

  def log_move(human, computer, winner)
    move_log[human.name] << human.move.value
    move_log[computer.name] << computer.move.value
    winner = winner.capitalize if winner == 'tie'
    move_log[self.winner] << winner
  end
end

# Game Orchestration Engine
class RPSGame
  include Display

  def initialize
    welcome_message #
    @human = Human.new
    @computer = Object.const_get(choose_opponent_prompt).new
    @history = []
    set_points_prompt
  end

  def play
    loop do
      reset_scores
      history << MoveLog.new(@human, @computer)
      play_rounds
      break unless play_again?
    end

    goodbye_message #
  end

  private

  attr_accessor :human, :computer, :points_to_win, :history

  def choose_opponent_prompt
    opponent = nil
    loop do
      print MESSAGES['choose_opponent'].chomp
      opponent = gets.downcase.chomp
      break if (Computer::NAMES.keys.include? opponent) || opponent.empty?
      puts MESSAGES['invalid_choice']
    end

    opponent.empty? ? Computer::NAMES.values.sample : Computer::NAMES[opponent]
  end

  def countdown
    puts
    MESSAGES['countdown'].each_char do |char|
      putc char
      sleep(0.05)
      $stdout.flush
    end
    sleep(0.5)
  end

  def determine_grand_winner
    human.score >= points_to_win ? human : computer
  end

  def determine_loser(winner)
    winner == human ? computer : human
  end

  def determine_round_winner
    if human.move > computer.move
      human
    elsif computer.move > human.move
      computer
    else
      :tie
    end
  end

  def end_of_game_options
    loop do
      print MESSAGES['again'].chomp
      answer = gets.chomp

      if history?(answer)
        move_history(history) #
        show_round_results
        next
      end

      return answer
    end
  end

  def history?(answer)
    answer == 'history' || answer == 'h'
  end

  def keep_playing_prompt
    sleep(0.75)
    MESSAGES['keep_playing'].each_char do |char|
      putc char
      sleep(0.05)
      $stdout.flush
    end
    sleep(0.75)
  end

  def play_again?
    answer = end_of_game_options
    return true if answer.downcase == 'y'
    false
  end

  def play_rounds
    loop do
      player_choices
      process_round
      break if somebody_won?
      keep_playing_prompt
    end
  end

  def player_choices
    loop do
      scoreboard(human, computer) # 
      human.choose

      if history?(human.move.value)
        move_history(history) #
        next
      end

      computer.choose(human, points_to_win)
      return
    end
  end

  def process_round
    countdown
    history.last.log_move(human, computer, determine_round_winner.to_s)
    update_scores
    show_round_results
  end

  def reset_scores
    human.reset
    computer.reset
  end

  def set_points_prompt
    loop do
      puts
      print MESSAGES['choose_points']
      self.points_to_win = gets.chomp.to_i
      break if (1..10).to_a.include? points_to_win
      puts MESSAGES['invalid_choice']
    end
  end

  def show_round_results
    scoreboard(human, computer) #
    moves(human, computer) #
    round_winner(determine_round_winner,
                 determine_loser(determine_round_winner)) #
    grand_winner(determine_grand_winner) if somebody_won? #
  end

  def somebody_won?
    human.score >= points_to_win || computer.score >= points_to_win
  end

  def update_scores
    case determine_round_winner
    when human then human.increment_score
    when computer then computer.increment_score
    end
  end
end

RPSGame.new.play
