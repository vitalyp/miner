require_relative './miner_game_config'
require_relative './game_processor'

# Contains and Produces isolated Game entities
class MinerGameContainer
  @@data = []
  def self.find_or_create_by_sess_key(sess_key)
    game = @@data.find{|g| g.sess_key == sess_key}
    unless game
      game = MinerGameProcessor.new(sess_key)
      @@data.push(game)
      @@data.shift if @@data.size >= MinerGameConfig::MAX_GAME_INSTANCES # Hard remove first game
    end
    game
  end
  def self.delete_by_sess_key(sess_key)
    @@data.delete_if{|g| g.sess_key == sess_key}
  end
  def self.get_games
    @@data
  end
end