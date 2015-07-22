# Data Module, Miner config
module MinerGameConfig
  DEFAULTS = { map_rows: 10, map_cols: 10, map_bombs: 10, map_cell_px: 32   }
  MAP_MAX_COLS = 30
  MAP_MAX_ROWS = 30
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
# It contains isolated Game entity, and responsible for it
class MinerGameProcessor
  attr_accessor(:rows, :cols, :bombs, :map, :sess_key)
  
  CELL = { mine: -1 }

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
    
    init_map
  end
  
  #private
  
  def bomb_at(index)
    row = index/@cols
    row < 0 || row >= @rows || index < 0 || index > @rows*@cols || @map[index] != CELL[:mine] ? false : true
  end

  def bombs_count_around(index)

    count = 0
    count += 1 if bomb_at(index-1) # left, same row
    count += 1 if bomb_at(index+1) # right, same row
    count += 1 if bomb_at(index-@cols) # top, row above
    count += 1 if bomb_at(index+@cols) # bottom, row below
    count += 1 if bomb_at(index-@cols-1) # top-left, row above
    count += 1 if bomb_at(index-@cols+1) # top-right, row above
    count += 1 if bomb_at(index+@cols-1) # bottom-left, row below
    count += 1 if bomb_at(index+@cols+1) # bottom-right, row below
    count
  end
  
  def init_map
    @map = Array.new(@rows*@cols){ |index| index}
    #put mines
    @bombs.times do
      free_indexes = @map.map.with_index{|x, i| i if x!=CELL[:mine]}.compact
      rand_index = rand(free_indexes.size)
      @map[rand_index] = CELL[:mine]
    end
    #put numbers
    @map.each_with_index do |x, i|
      next if x == CELL[:mine]
      @map[i] = bombs_count_around(i)
    end
  end

end