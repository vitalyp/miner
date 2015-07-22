# Data Module, Miner config
module MinerGameConfig
  DEFAULTS = { map_rows: 10, map_cols: 10, map_bombs: 10, map_cell_px: 32   }
  MAP_MAX_COLS = 30
  MAP_MAX_ROWS = 30
  CELL = { empty: 0, mine: -1 }
end

# Contains and Produces isolated Game entities
class MinerGameContainer
  MAX_DATA_ITEMS = 100 # INFO: noMemory limitation fix in perspective
  @@data = []
  def self.find_or_create_by_sess_key(sess_key)
    game = @@data.find{|g| g.sess_key == sess_key}
    game = MinerGameProcessor.new(sess_key) unless game
    game
  end
end

# Game processor is a multy-session, persisted instance.
# takes control
# It contains isolated Game entity, and responsible for it
class MinerGameProcessor
  attr_accessor(:rows, :cols, :bombs, :map, :sess_key)

  def initialize(sess_key)
    @sess_key == sess_key
  end
  # Construct new game map with specified attributes:
  # <r> - map rows count, <c> - map columns count, <b> - mines count per map
  def init_game(r, c, b)
    attr_exists =  !!(r && c && b)

    map_rows_range = (1..MinerGameConfig::MAP_MAX_ROWS)
    map_cols_range = (1..MinerGameConfig::MAP_MAX_COLS)
    attr_range_match = map_rows_range.include?(r) && map_cols_range.include?(c) && r*c>1 && (1..r*c-1).include?(b)

    raise '[ERROR:GameProcessor] Initialization parameters are not correct' unless attr_exists
    raise '[ERROR:GameProcessor] Init params out of range ' unless attr_range_match

    @rows, @cols, @bombs = r, c, b
    @map = Array.new(@rows*@cols){ |index| index}
    @bombs.times do
      free_indexes = @map.collect{|i|i!=MinerGameConfig::CELL[:mine]}
      rand_index = rand%free_indexes.size
      @map[rand_index] = MinerGameConfig::CELL[:mine]
    end
  end

end