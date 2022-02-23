function love.load()
  love.graphics.setBackgroundColor(.14, .59, .75)
  
  player = '@'
  playerOnStorage = '+'
  box = '$'
  boxOnStorage = '*'
  storage = '.'
  wall = '#'
  empty = ' '
  
  levels = {
    {
      {' ', ' ', '#', '#', '#'},
      {' ', ' ', '#', '.', '#'},
      {' ', ' ', '#', ' ', '#', '#', '#', '#'},
      {'#', '#', '#', '$', ' ', '$', '.', '#'},
      {'#', '.', ' ', '$', '@', '#', '#', '#'},
      {'#', '#', '#', '#', '$', '#'},
      {' ', ' ', ' ', '#', '.', '#'},
      {' ', ' ', ' ', '#', '#', '#'},
    },
    {
      {'#', '#', '#', '#', '#'},
      {'#', ' ', ' ', ' ', '#'},
      {'#', '@', '$', '$', '#', ' ', '#', '#', '#'},
      {'#', ' ', '$', ' ', '#', ' ', '#', '.', '#'},
      {'#', '#', '#', ' ', '#', '#', '#', '.', '#'},
      {' ', '#', '#', ' ', ' ', ' ', ' ', '.', '#'},
      {' ', '#', ' ', ' ', ' ', '#', ' ', ' ', '#'},
      {' ', '#', ' ', ' ', ' ', '#', '#', '#', '#'},
      {' ', '#', '#', '#', '#', '#'},
    },
    {
      {' ', '#', '#', '#', '#', '#', '#', '#'},
      {' ', '#', ' ', ' ', ' ', ' ', ' ', '#', '#', '#'},
      {'#', '#', '$', '#', '#', '#', ' ', ' ', ' ', '#'},
      {'#', ' ', '@', ' ', '$', ' ', ' ', '$', ' ', '#'},
      {'#', ' ', '.', '.', '#', ' ', '$', ' ', '#', '#'},
      {'#', '#', '.', '.', '#', ' ', ' ', ' ', '#'},
      {' ', '#', '#', '#', '#', '#', '#', '#', '#'},
    },
  }
  currentLevel = 1
  
  function loadLevel()
    level = {}
    for y, row in ipairs(levels[currentLevel]) do
      level[y] = {}
      for x, cell in ipairs(row) do
        level[y][x] = cell
      end
    end
  end
  loadLevel()
end

function love.keypressed(key)
  if key == 'up' or key == 'down' or key == 'left' or key == 'right' then
    local playerX
    local playerY
    local dx = 0
    local dy = 0
    
    for testY, row in ipairs(level) do
      for testX, cell in ipairs(row) do
        if cell == player or cell == playerOnStorage then
          playerX = testX
          playerY = testY
        end
      end
    end
    
    if key == 'left' then
      dx = -1
    elseif key == 'right' then
      dx = 1
    elseif key == 'up' then
      dy = -1
    elseif key == 'down' then
      dy = 1
    end
    
    local current = level[playerY][playerX]
    local adjacent = level[playerY + dy][playerX + dx]
    local beyond
    if level[playerY + dy + dy] then
      beyond = level[playerY + dy + dy][playerX + dx + dx]
    end
    
    local nextAdjacent = {
      [empty] = player,
      [storage] = playerOnStorage,
    }
    local nextCurrent = {
      [player] = empty,
      [playerOnStorage] = storage,
    }
    local nextBeyond = {
      [empty] = box,
      [storage] = boxOnStorage,
    }
    local nextAdjacentPush = {
      [box] = player,
      [boxOnStorage] = playerOnStorage,
    }

    if nextAdjacent[adjacent] then
        level[playerY][playerX] = nextCurrent[current]
        level[playerY + dy][playerX + dx] = nextAdjacent[adjacent]
    
    elseif nextBeyond[beyond] and nextAdjacentPush[adjacent] then 
        level[playerY][playerX] = nextCurrent[current]
        level[playerY + dy][playerX + dx] = nextAdjacentPush[adjacent]
        level[playerY + dy + dy][playerX + dx + dx] = nextBeyond[beyond]
    end
    
    local complete = true
    
    for y, row in ipairs(level) do
      for x, cell in ipairs(row) do
        if cell == box then
          complete = false
        end
      end
    end
    
    if complete then
      currentLevel = currentLevel + 1
      if currentLevel > #levels then
        currentLevel = 1
      end
      loadLevel()
    end
    
  elseif key == 'r' then
    loadLevel()
  elseif key == '.' then
    currentLevel = currentLevel + 1
    if currentLevel > #levels then
      currentLevel = 1
    end
    loadLevel()
  elseif key == ',' then
    currentLevel = currentLevel - 1
    if currentLevel < 1 then
      currentLevel = #levels
    end
    loadLevel()
  end
end

function love.draw()
  for y, row in ipairs(level) do
    for x, cell in ipairs(row) do
      if cell ~= empty then
        local cellSize = 23
        
        local colors = {
          [player] = {.64, .53, 1},
          [playerOnStorage] = {.62, .47, 1},
          [box] = {1, .79, .49},
          [boxOnStorage] = {.59, 1, .5},
          [storage] = {.61, .9, 1},
          [wall] = {1, .58, .82},
        }
        
        love.graphics.setColor(colors[cell])
        love.graphics.rectangle('fill', (x-1) * cellSize, (y-1) * cellSize, cellSize, cellSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(level[y][x], (x-1) * cellSize, (y-1) * cellSize, cellSize, "center")
      end
    end
  end
end
