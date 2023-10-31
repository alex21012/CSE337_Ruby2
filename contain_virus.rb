#Alex Porokhin
#113423484
def contain_virus(grid)
    total_rows = grid.size
    total_cols = grid[0].size
    walls = 0
  
    for row in 0...total_rows
        for col in 0...total_cols
            if grid[row][col] == 1
                # Top 
                walls += 1 if row.zero? || grid[row - 1][col].zero?
                # Bottom 
                walls += 1 if row == total_rows - 1 || grid[row + 1][col].zero?
                # Left 
                walls += 1 if col.zero? || grid[row][col - 1].zero?
                # Right
                walls += 1 if col == total_cols - 1 || grid[row][col + 1].zero?
            end
        end
    end
    walls
end
  
isInfected = [[0,1,0,0], [1,1,1,0], [0,1,0,0], [1,1,0,0]]
  
result = contain_virus(isInfected)
puts "Number of walls needed: #{result}"
  
