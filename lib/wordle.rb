require_relative './../config/config'

class Wordle

  attr_accessor :attempt, :guess, :score, :word_of_the_day

  def play
    until score == Constants::ALL_GREEN || attempt > Constants::ATTEMPT_LIMIT
      puts start_banner
      @guess = gets.chomp.downcase
      manage_flow
    end
    end_this_game
  end

  def manage_flow
    if guess == 'x'
      end_this_game
    elsif guess.length != 5
      puts Constants::WORD_LENGTH
    elsif !valid_word?
      puts Constants::WORD_INVALID
    else
      evaluate_guess
      puts colorize
      puts color_map
      archive_score
      increment_attempt
    end
  end

    def valid_word?
    dictionary.any? { |line| line.chomp == guess}
  end

  def evaluate_guess
    given = word_of_the_day.downcase.chars
    word = guess.chars
    @score = %w[B B B B B]
    given.each_index do |index|
      @score[index] = Constants::YELLOW if given.include? word[index]
      @score[index] = Constants::GREEN if given[index] == word[index]
    end
  end

  private

  attr_reader :archive, :dictionary, :word_of_the_day

  def initialize(dictionary = File.readlines(Constants::WORDS_LIST))
    @dictionary = dictionary
    @word_of_the_day = dictionary.sample.downcase.chomp
    @attempt = 1
    @word = ''
    @score = []
    @archive = []
    puts "The word of the day is: #{word_of_the_day.green}" if $DEBUG
  end

  def start_banner
    format "Attempt #{attempt}"
  end

  def archive_score
    @archive << score
  end

  def increment_attempt
    @attempt += 1
  end

  def color_map(colors = score)
    colormap = Colors.add_color(colors)
    colormap.map { |color| print color << '|' }.join(' ')
  end

  def colorize(word = guess)
    word.chars.map {|char| char}.join(' ').yellow
  end

  def retrieve_archive
    archive.each { |colors| color_map(colors) }
  end

  def end_banner
    puts
    puts "H i s t o r y:".yellow
    retrieve_archive
    puts
    puts <<~EOS
    #{score == Constants::ALL_GREEN ? 'Well done!' : 'Sorry, you did not get it this time!'}
    The word you are looking for is: #{word_of_the_day.green}
    EOS
  end

  def end_this_game
    end_banner
    play_again? ? Wordle.new.play : (puts Constants::BYE)
    exit!
  end

  def play_again?
    puts 'Do you want to play again? (y/n)'
    true if gets.downcase.chomp == 'y'
  end
end
