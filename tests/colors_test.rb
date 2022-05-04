require_relative './../config/config'
require 'minitest/autorun'
require_relative './../lib/colors'

class Colors_test < Minitest::Test

  def test_G_Y_B_G_Y
    colors = [
      'G'.on_green,
      'Y'.on_yellow,
      'B'.on_black,
      'G'.on_green,
      'Y'.on_yellow
    ]
    assert_equal  colors, Colors.add_color(%w[G Y B G Y])
  end
end
