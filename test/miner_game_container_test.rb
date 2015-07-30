require 'minitest/autorun'
require_relative '../miner_game_container'

class TestMinerGameContainer <  Minitest::Test

  def test_find_or_create_by_sess_key
    game_000f = MinerGameContainer.find_or_create_by_sess_key('000f')
    game_00ff = MinerGameContainer.find_or_create_by_sess_key('00ff')
    assert_equal(game_000f, MinerGameContainer.find_or_create_by_sess_key('000f'))
    assert_equal(2, MinerGameContainer.get_games.size)
  end

end