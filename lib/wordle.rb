require_relative './../config/config'

class Wordle

  attr_accessor  :results

  def initialize(word_of_the_day = '', dictionary = File.readlines(Constants::WORDS_LIST))
    @characters_of_the_day = word_of_the_day.downcase.chars
    @attempt = 1
    @results = []
    @archive = []
    @dictionary = dictionary
  end

  def self.play
    word = File.readlines(Constants::WORDS_LIST).sample.chomp
    puts "The word of the day is: #{word.green}" if $DEBUG
    Wordle.new(word).wordle
  end

  def wordle
    until results == Constants::ALL_GREEN || attempt > Constants::ATTEMPT_LIMIT
      start_banner
      user_input
      show_results
      archive_results
      increment_attempt
    end
    end_banner
  end

  def valid_word?(word)
    dictionary.any? do |line|
      line.chomp == word
    end
  end

  def evaluate(user_guess)
    @results = %w[B B B B B]
    characters_of_the_day.each_index do |index|
      @results[index] = Constants::YELLOW if characters_of_the_day.include? user_guess[index]
      @results[index] = Constants::GREEN if user_guess[index] == characters_of_the_day[index]
    end
    user_guess
  end

  private

  attr_accessor :attempt, :archive
  attr_reader :characters_of_the_day, :dictionary

  def start_banner
    puts
    puts "Attempt #{attempt}"
  end

  def user_input
    word = evaluate(guess)
    word.each {|character| print character.yellow << ' '}
    puts
  end

  def guess
    word = gets.chomp.downcase
    end_banner if word == 'x'
    puts
    if word.length != 5
      puts Constants::WORD_LENGTH
      wordle
    elsif !valid_word?(word)
      puts Constants::WORD_INVALID
      wordle
    else
      word.chars
    end
  end

  def archive_results
    @archive << results
  end

  def increment_attempt
    @attempt += 1
  end

  def show_results(colors = results)
    colormap = Colors.add_color(colors)
    colormap.each { |color| print color << '|' }
    puts
  end

  def retrieve_archive
    archive.each do |colors|
      show_results(colors)
    end
  end

  def end_banner
    puts
    puts "H i s t o r y:".yellow
    retrieve_archive
    puts
    puts <<~EOS
    #{results == Constants::ALL_GREEN ? 'Well done!' : 'Sorry, you did not get it this time!'}
    The word you are looking for is: #{characters_of_the_day.join.green}
  end

end
