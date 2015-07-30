require 'minitest/autorun'
require_relative '../game_processor'

class TestGameProcessor <  Minitest::Test
  def setup
    @game_processor = MinerGameProcessor.new('session_934757')
  end

  def test_init_map
    rows = 5
    cols = 4
    bombs = 11
    z = 10
    @game_processor.init_game(rows, cols, bombs, z)
    assert_equal(rows*cols, @game_processor.map.size)
    assert_equal(11, @game_processor.mines_count)
  end

end