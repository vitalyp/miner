module MineMap
  # put 'n' mines in random cells
  def put_mines(n)
    n.times do
      free_indexes = @map.map.with_index{|x, i| i unless minedCell(x)}.compact
      rand_index = rand(free_indexes.size)
      @map[free_indexes[rand_index]] = mine
    end
  end

  def mine_at(index, exact_row=nil)
    return false if exact_row && index/@cols != exact_row
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
end