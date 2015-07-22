require 'minitest/autorun'
require '../game_processor'

class TestGameProcessor <  Minitest::Test
  def setup
    @game_processor = MinerGameProcessor.new('session_934757')
  end

  def test_bomb_at
    x = MinerGameProcessor::CELL[:mine]
    @game_processor.map = [
      [0, 0, 0, x],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0]]
    @game_processor.rows = 4
    @game_processor.cols = 4
    @game_processor.bombs = 1
    assert_equal(false, @game_processor.bomb_at(0))
    assert_equal(false, @game_processor.bomb_at(1))
    assert_equal(false, @game_processor.bomb_at(2))
    assert_equal(true, @game_processor.bomb_at(3)) #FIXME
  end

end