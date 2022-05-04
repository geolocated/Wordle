require_relative './../config/config'
require_relative './colors'

class Wordle

  include Colors
  attr_accessor  :score

  def initialize(word_of_the_day = '')
    @characters_of_the_day = word_of_the_day.downcase.chars
    @attempt = 1
    @score = []
    @history = []
  end

  def play
    until score == Constants::ALL_GREEN || attempt > Constants::ATTEMPT_LIMIT
      banner
      evaluate_guess(guess)
      add_to_history
      increment
      print_score
      puts
    end
    puts
    puts "Your entries:"
    print_history
    puts
    puts score == Constants::ALL_GREEN ? 'Well done!' : 'Sorry, you did not get it this time!'
    puts
    puts 'Do you want to play again? (y/n)'
    play if gets.downcase.chomp == 'y'
    puts Constants::BYE
    exit(1)
  end

  def evaluate_guess(guess_word)
    @score = %w[B B B B B]
    characters_of_the_day.each_index do |index|
      @score[index] = Constants::YELLOW if characters_of_the_day.include? guess_word[index]
      @score[index] = Constants::GREEN if guess_word[index] == characters_of_the_day[index]
    end
  end

  def valid_word?(word)
    lines = File.readlines(Constants::WORDS_FILE)
    lines.each do |line|
      return true if line.chomp == word
    end
    false
  end

  private

  attr_accessor :attempt, :history
  attr_reader :characters_of_the_day

  def add_to_history
    @history << score
  end

  def increment
    @attempt += 1
  end

  def banner
    puts
    puts "Attempt #{attempt}: Guess a word..."
  end

 def print_score(colors = score)
   colormap = Colors.add_color(colors)
   colormap.each { |color| print color << '|' }
 end

  def print_history
    history.each do |colors|
      print_score(colors)
      puts
    end
  end

  def guess
    word = gets.chomp.downcase
    if word == 'x' || word == 'q'
      puts Constants::BYE
      exit(1)
    elsif word.length != 5
      puts Constants::WORD_LENGTH
      play
    elsif !valid_word?(word)
      puts Constants::WORD_INVALID
      play
    else
      word.chars
    end
  end

end
