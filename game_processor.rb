# Data Module, Miner config
module MinerGameConfig
  DEFAULTS = { map_rows: 10, map_cols: 10, map_bombs: 10, map_cell_px: 32   }
  MAP_MAX_COLS = 30
  MAP_MAX_ROWS = 30
  MAX_GAME_INSTANCES = 100 # INFO: limitation value
end

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

# Game processor is a multy-session, persisted instance.
# It contains isolated Game entity, and responsible for it
class MinerGameProcessor
  attr_accessor(:rows, :cols, :bombs, :zoom, :map, :sess_key, :started)
  
  CELL = { mine: 'x' }

  def initialize(sess_key)
    @sess_key= sess_key
  end
  
  # Construct new game map with specified attributes:
  # <r> - map rows count, <c> - map columns count, <b> - mines count per map, <z> - cell zoom factor (px)
  def init_game(r, c, b, z)
    attr_exists =  !!(r && c && b && z)
    map_rows_range = (1..MinerGameConfig::MAP_MAX_ROWS)
    map_cols_range = (1..MinerGameConfig::MAP_MAX_COLS)
    attr_range_match = map_rows_range.include?(r) && map_cols_range.include?(c) && r*c>1 && (1..r*c-1).include?(b)

    raise '[ERROR:GameProcessor] Initialization parameters are not correct' unless attr_exists
    raise '[ERROR:GameProcessor] Init params out of range ' unless attr_range_match
    
    @rows, @cols, @bombs, @zoom = r, c, b, z

    init_map
    @started = true
  end
  
  #private
  
  def bomb_at(index, exact_row=nil)
    return false if exact_row && index/@cols != exact_row
    row = index/@cols
    row < 0 || row >= @rows || index < 0 || index > @rows*@cols || @map[index] != CELL[:mine] ? false : true
  end

  def bombs_count_around(index)
    count = 0
    row = index/@cols
    count += 1 if bomb_at(index-1, row) # left, same row
    count += 1 if bomb_at(index+1, row) # right, same row
    count += 1 if bomb_at(index-@cols, row-1) # top, row above
    count += 1 if bomb_at(index+@cols, row+1) # bottom, row below
    count += 1 if bomb_at(index-@cols-1, row-1) # top-left, row above
    count += 1 if bomb_at(index-@cols+1, row-1) # top-right, row above
    count += 1 if bomb_at(index+@cols-1, row+1) # bottom-left, row below
    count += 1 if bomb_at(index+@cols+1, row+1) # bottom-right, row below
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
      @map[i] = -bombs_count_around(i)
    end
  end
  
  def click_to(index)
    @map[index] = -@map[index] if @map[index].to_i < 0
  end

end