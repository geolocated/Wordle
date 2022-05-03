require 'colorize'

module Constants

  WORDS_LIST = './resources/wordlist.txt'
  ALL_GREEN = %w[G G G G G]
  ALL_BLACK = %w[B B B B B]
  GREEN = 'G'
  YELLOW = 'Y'
  ATTEMPT_LIMIT = 6
  WORD_LENGTH = 'Please try again! The word should be exactly 5 characters in length.'.red
  WORD_INVALID = 'Please try again! The word you entered is not in the word list.'.red
  BYE = 'Thank you for playing!'.blue

end
