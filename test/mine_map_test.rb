require 'minitest/autorun'
require_relative '../mine_map'

class TestMineMap <  Minitest::Test
  class M; include MineMap end

  def setup
    @testMineMap = M.new
    rows = 5
    cols = 5
    @testMap = Array.new(rows*cols, 0)
    @testMineMap.instance_variable_set '@rows', rows
    @testMineMap.instance_variable_set '@cols', cols
    @testMineMap.instance_variable_set '@map', @testMap
  end

  def test_mines_count
    x = @testMineMap.mine
    @testMineMap.instance_variable_set '@map', [ x,x,x,0,0,
                                                 x,0,x,0,0,
                                                 x,x,x,0,x,
                                                 0,0,x,0,0,
                                                 0,x,0,x,x ]
    assert_equal(13, @testMineMap.mines_count)
  end

  def test_put_mine_1
    @testMineMap.put_mines(1)
    assert_equal(1, @testMineMap.mines_count)
  end
  def test_put_mine_3
    @testMineMap.put_mines(3)
    assert_equal(3, @testMineMap.mines_count)
  end
  def test_put_mine_25
    @testMineMap.put_mines(25)
    assert_equal(25, @testMineMap.mines_count)
  end
  def test_put_mine_26
    assert_raises RuntimeError do
      @testMineMap.put_mines(26)
    end
  end

  def test_mine_at
    x = @testMineMap.mine
    @testMineMap.instance_variable_set '@map', [ x,0,x,0,x,
                                                 x,0,0,x,0,
                                                 0,x,0,0,x,
                                                 0,0,x,0,0,
                                                 0,x,0,x,x ]
    assert_equal(true , @testMineMap.mine_at(0, 0))
    assert_equal(false, @testMineMap.mine_at(1, 0))
    assert_equal(true , @testMineMap.mine_at(2, 0))
    assert_equal(false, @testMineMap.mine_at(3, 0))
    assert_equal(true , @testMineMap.mine_at(4, 0))
    assert_equal(true , @testMineMap.mine_at(5, 1))
    assert_equal(false, @testMineMap.mine_at(6, 1))
    assert_equal(false, @testMineMap.mine_at(7, 1))
    assert_equal(true , @testMineMap.mine_at(8, 1))
    assert_equal(false, @testMineMap.mine_at(9, 1))
    #..
    assert_equal(false, @testMineMap.mine_at(20, 4))
    assert_equal(true , @testMineMap.mine_at(21, 4))
    assert_equal(false, @testMineMap.mine_at(22, 4))
    assert_equal(true , @testMineMap.mine_at(23, 4))
    assert_equal(true , @testMineMap.mine_at(24, 4))
    #..out of bounds checks returns false:
    assert_equal(false, @testMineMap.mine_at(-1, 0))
    assert_equal(false, @testMineMap.mine_at(0, -1))
    assert_equal(false, @testMineMap.mine_at(100, 0))
    assert_equal(false, @testMineMap.mine_at(0, 100))
  end

  def test_mines_count_around
    x = @testMineMap.mine
    @testMineMap.instance_variable_set '@map', [ x,x,x,0,0,
                                                 x,0,x,0,0,
                                                 x,x,x,0,x,
                                                 0,0,x,0,0,
                                                 0,x,0,x,x ]
    assert_equal(2, @testMineMap.mines_count_around(0))
    assert_equal(4, @testMineMap.mines_count_around(1))
    assert_equal(2, @testMineMap.mines_count_around(2))
    assert_equal(2, @testMineMap.mines_count_around(3))
    assert_equal(0, @testMineMap.mines_count_around(4))
    assert_equal(4, @testMineMap.mines_count_around(5))
    assert_equal(8, @testMineMap.mines_count_around(6))
    assert_equal(4, @testMineMap.mines_count_around(7))
    assert_equal(4, @testMineMap.mines_count_around(8))
    #..
    assert_equal(2, @testMineMap.mines_count_around(23))
    assert_equal(1, @testMineMap.mines_count_around(24))
  end

  def test_put_mines_counts
    x = @testMineMap.mine
    @testMineMap.instance_variable_set '@map', [ x,x,x,0,0,
                                                 x,0,x,0,0,
                                                 x,x,x,0,x,
                                                 0,0,x,0,0,
                                                 0,x,0,x,x ]
    correct_mines_counts_map = [ x,x,x,2,0,
                                 x,8,x,4,1,
                                 x,x,x,4,x,
                                 3,5,x,5,3,
                                 1,x,3,x,x ]
    @testMineMap.put_mines_counts(+1)
    assert_equal(correct_mines_counts_map, @testMineMap.instance_variable_get('@map'))
  end
end