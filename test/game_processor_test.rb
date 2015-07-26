require 'minitest/autorun'
require '../game_processor'

class TestGameProcessor <  Minitest::Test
  def setup
    @game_processor = MinerGameProcessor.new('session_934757')
    @game_processor.rows = 4
    @game_processor.cols = 4
    @game_processor.bombs = 5
    x = MinerGameProcessor::CELL[:mine]
    @game_processor.map = [
        [0, 0, 0, x],
        [x, 0, 0, 0],
        [0, 0, 0, 0],
        [x, x, 0, x]].flatten
  end

  def test_bombs_count_around
    assert_equal(1, @game_processor.bombs_count_around(0))
    assert_equal(1, @game_processor.bombs_count_around(1))
    assert_equal(1, @game_processor.bombs_count_around(2))
    assert_equal(0, @game_processor.bombs_count_around(3))
    assert_equal(0, @game_processor.bombs_count_around(4))
    assert_equal(1, @game_processor.bombs_count_around(5))
    assert_equal(1, @game_processor.bombs_count_around(6))
    assert_equal(1, @game_processor.bombs_count_around(7))
    assert_equal(3, @game_processor.bombs_count_around(8))
    assert_equal(3, @game_processor.bombs_count_around(9))
    assert_equal(2, @game_processor.bombs_count_around(10))
    assert_equal(1, @game_processor.bombs_count_around(11))
    assert_equal(1, @game_processor.bombs_count_around(12))
    assert_equal(1, @game_processor.bombs_count_around(13))
    assert_equal(2, @game_processor.bombs_count_around(14))
    assert_equal(0, @game_processor.bombs_count_around(15))
  end

  def test_bomb_at
    assert_equal(false, @game_processor.bomb_at(0))
    assert_equal(false, @game_processor.bomb_at(1))
    assert_equal(false, @game_processor.bomb_at(2))
    assert_equal(true, @game_processor.bomb_at(3))
    assert_equal(true, @game_processor.bomb_at(4))
    assert_equal(false, @game_processor.bomb_at(5))
    assert_equal(false, @game_processor.bomb_at(6))
    assert_equal(false, @game_processor.bomb_at(7))
    assert_equal(false, @game_processor.bomb_at(8))
    assert_equal(false, @game_processor.bomb_at(9))
    assert_equal(false, @game_processor.bomb_at(10))
    assert_equal(false, @game_processor.bomb_at(11))
    assert_equal(true, @game_processor.bomb_at(12))
    assert_equal(true, @game_processor.bomb_at(13))
    assert_equal(false, @game_processor.bomb_at(14))
    assert_equal(true, @game_processor.bomb_at(15))
    # out of bounds:
    assert_equal(false, @game_processor.bomb_at(-1))
    assert_equal(false, @game_processor.bomb_at(100))
  end

  # def test_place_bombs
  #   @game_processor.map =
  #   @game_processor.place_bombs
  #   mines = @game_processor.map.select{|c| c == MinerGameProcessor::CELL[:mine]}
  #
  # end
  #
  # def test_init_map
  #   @game_processor.init_map
  #   mines = @game_processor.map.select{|c| c == MinerGameProcessor::CELL[:mine]}
  #
  # end

end