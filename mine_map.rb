# map array methods
module MineMap

  CELL = { mine: 'x', opened_empty: ' ', closed_empty: 0 }
  def mine
    CELL[:mine]
  end
  def minedCell(c)
    c == mine
  end
  def closed_empty_cell?(c)
    c == CELL[:closed_empty]
  end
  def opened_cell?(index)
    cell = @map[index]
    cell != mine && (cell == CELL[:opened_empty] || cell.to_i > 0)
  end
  def open(index)
    return if index < 0 || index >= @rows*@cols
    return if minedCell(@map[index])
    return if opened_cell?(index)
    @map[index] = closed_empty_cell?(@map[index]) ? CELL[:opened_empty] : @map[index].abs
    if @map[index] == CELL[:opened_empty]
      row = index/@cols
      open(index-1) if !mine_at(index-1, row)
      open(index+1) if !mine_at(index+1, row)
      open(index-@cols) if !mine_at(index-@cols, row-1)
      open(index+@cols) if !mine_at(index+@cols, row+1)
    end
  end

  # put 'n' mines in random cells
  def put_mines(n)
    n.times do
      free_indexes = @map.map.with_index{|x, i| i unless minedCell(x)}.compact
      raise 'No mine place' if free_indexes.empty?
      rand_index = rand(free_indexes.size)
      @map[free_indexes[rand_index]] = mine
    end
  end

  def mine_at(index, exact_row)
    return false if index/@cols != exact_row
    row = index/@cols
    row < 0 || row >= @rows || index < 0 || index > @rows*@cols || !minedCell(@map[index]) ? false : true
  end

  # calculate mines around cell with index 'i'
  def mines_count_around(index)
    count = 0
    row = index/@cols
    count += 1 if mine_at(index-1, row) # left, same row
    count += 1 if mine_at(index+1, row) # right, same row
    count += 1 if mine_at(index-@cols, row-1) # top, row above
    count += 1 if mine_at(index+@cols, row+1) # bottom, row below
    count += 1 if mine_at(index-@cols-1, row-1) # top-left, row above
    count += 1 if mine_at(index-@cols+1, row-1) # top-right, row above
    count += 1 if mine_at(index+@cols-1, row+1) # bottom-left, row below
    count += 1 if mine_at(index+@cols+1, row+1) # bottom-right, row below
    count
  end

  def put_mines_counts(sign = -1)
    @map.each_with_index do |x, i|
      next if minedCell(x)
      @map[i] = mines_count_around(i) * sign
    end
  end

  def mines_count
    @map.select{|c| minedCell(c) }.size
  end
end