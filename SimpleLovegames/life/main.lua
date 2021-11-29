function love.load()
  love.graphics.setBackgroundColor(1, 1, 1)
  cellSize = 5
  gridXCount = 160
  gridYCount = 120
  
  grid = {}
  for y = 1, gridYCount do
    grid[y] = {}
    for x = 1, gridXCount do
      grid[y][x] = false
    end
  end
end

function love.update()
  selectedX = math.min(math.floor(love.mouse.getX() / cellSize) + 1, gridXCount)
  selectedY = math.min(math.floor(love.mouse.getY() / cellSize) + 1, gridYCount)
  if love.mouse.isDown(1) then
    grid[selectedY][selectedX] = true
  end
end

function love.keypressed()
  local nextGrid = {}
  
  for y = 1, gridYCount do
    nextGrid[y] = {}
    for x = 1, gridXCount do
    
    local neighborCount = 0
      for dy = -1, 1 do
        for dx = -1, 1 do
          if not (dy == 0 and dx == 0)
          and grid[y + dy]
          and grid[y + dy][x + dx] then
            neighborCount = neighborCount + 1
          end
        end
      end
      
      nextGrid[y][x] = neighborCount == 3
        or (grid[y][x] and neighborCount == 2)
    end
  end
  
  grid = nextGrid
end

function love.draw()
  for y = 1, gridYCount do
    for x = 1, gridXCount do
      local cellDrawSize = cellSize - 1
      
      if x == selectedX and y == selectedY then
        love.graphics.setColor(0, 1, 1)
      elseif grid[y][x] then
        love.graphics.setColor(1, 0, 1)
      else
        love.graphics.setColor(.86, .86, .86)
      end
      
      love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
    end
  end
end

    