require './mine_map'
require './miner_game_config'

# Game processor is a multy-session, persisted instance.
# It contains isolated Games entities, and responsible for it
class MinerGameProcessor
  include MineMap
  attr_accessor(:rows, :cols, :bombs, :zoom, :map, :sess_key, :started)
  CELL = { mine: 'x' }
  def initialize(sess_key)
    @sess_key= sess_key
  end
  def minedCell c
    c==CELL[:mine]
  end
  def mine
    CELL[:mine]
  end
  
  # Construct new game map with specified attributes:
  # <r> - map rows count, <c> - map columns count, <b> - mines count per map, <z> - cell zoom factor (px)
  def init_game(r, c, b, z)
    r ||= MinerGameConfig::DEFAULTS[:map_rows]
    c ||= MinerGameConfig::DEFAULTS[:map_cols]
    b ||= MinerGameConfig::DEFAULTS[:map_bombs]
    z ||= MinerGameConfig::DEFAULTS[:map_cell_px]
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
  
  def init_map
    @map = Array.new(@rows*@cols){ |index| index}
    put_mines(@bombs)
    #put numbers
    @map.each_with_index do |x, i|
      next if minedCell(x)
      @map[i] = -mines_count_around(i)
    end
  end
  
  def click_to(index)
    @map[index] = -@map[index] if @map[index].to_i < 0
  end
end