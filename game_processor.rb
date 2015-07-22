module GameConstants
  CELL = { empty: 0, mine: -1 }
  MAP_RANGE = (1..30)
end

class GameProcessor
  attr_accessor :rows
  attr_accessor :cols
  attr_accessor :bombs
  attr_accessor :map

  # Construct new game map with specified attributes:
  # <r> - map rows count
  # <c> - map columns count
  # <b> - mines count per map
  #
  def init_game(r, c, b)
    attr_exists =  !!(r && c && b)

    attr_range_match = GameConstants::MAP_RANGE.include?(r) && GameConstants::MAP_RANGE.include?(c) && (1..r*c-1).include?(b)
    raise '[ERROR:GameProcessor] Initialization parameters are not correct' unless attr_exists
    raise '[ERROR:GameProcessor] Init params out of range ' unless attr_range_match

    @rows, @cols, @bombs = r, c, b
    @map = Array.new(@rows*@cols){ |index| index}
    @bombs.times do
      free_indexes = @map.collect{|i|i!=GameConstants::CELL[:mine]}
      rand_index = rand%free_indexes.size
      @map[rand_index] = GameConstants::CELL[:mine]
    end
  end

end