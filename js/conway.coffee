---
---
w = window

# Function computes the state for the next generation of n in the world
w.outOfBounds = (i, w, h) ->
  if i[0] < 0 or i[1] < 0 or i[0] >= h or i[1] >= w then true else false

w.getNeighborIndeces = (x,y) ->
  [
    [x-1,y-1], [x,y-1], [x+1,y-1],
    [x-1,y], [x+1,y],
    [x-1,y+1], [x,y+1], [x+1,y+1]
  ]

w.checkNeighbors = (x, y, world, width, height) ->
  neighborCount = 0
  currentNeighborIndex = 0

  neighbors = getNeighborIndeces(x,y)

  while currentNeighborIndex < 8
    neighbor = neighbors[currentNeighborIndex]
    # Short circuit if we are over
    break if neighborCount > 3

    if !outOfBounds(neighbor,width,height) and world[neighbor[1]][neighbor[0]]
      neighborCount += 1

    currentNeighborIndex += 1

  neighborCount

# n is false so look for neighbors equal to 3
nextFromDead = (x, y, world, width, height) ->
  neighborCount = checkNeighbors(x,y,world,width,height)
  if neighborCount is 3 then true else false

# n is true so look for for neighbor count of 2 or 3
nextFromLiving = (x, y, world, width, height) ->
  neighborCount = checkNeighbors(x,y,world,width,height)
  if neighborCount < 2 or neighborCount > 3 then false else true

w.nextGeneration = (x, y, world) ->
  width = world[0].length
  height = world.length
  if world[y][x] is true
    nextFromLiving(x,y,world, width, height)
  else
    nextFromDead(x,y, world, width, height)

w.advanceWorld = (world, width, height) ->
  _.map world, (row,y) ->
    _.map row, (cell,x) ->
      nextGeneration(x,y,world)

# Render helpers
w.getCellCoords = (index, width) -> [index % width,index // width]

w.renderWorld = (sketch, world, width, height, cellSize) ->
  sketch.stroke 200

  _.each world, (row, y) ->
    _.each row, (cell, x) ->
      if cell
        sketch.fill 0

        sketch.rect(x*cellSize, y*cellSize,cellSize,cellSize)
        true
      else
        sketch.fill 255
        sketch.rect(x*cellSize, y*cellSize,cellSize,cellSize)
        true

w.cellSize = 15

w.conway = (s) ->
  s.previousCell = []
  width = height = 40
  paused = false
  speed = 1

  # Generate a blank world
  rows = _.map _.range(40), -> return no
  world = _.map rows, -> _.map(_.range(40),-> no)

  s.setup = ->
    s.createCanvas 600, 600
    s.frameRate(speed)

    # Gosper's Glider Guns
    aliveCells = [
      [24,1],[25,1],
      [24,2],[27,2],
      [10,3],[12,3],[28,3],
     # 168,172,175,176,177,188,195,196
     # 208,228,235,236,
     # 241,242,247,252,260,261,264,267,
     # 281,282,288,296,298,301,304,305,
     # 328,332,338,339,340,
     # 370,372
    ]

    _.each aliveCells, (a) -> world[a[1]][a[0]] = on

    pauseButton = s.createButton("Play/Pause")
    pauseButton.mouseClicked -> paused = !paused

    slowDown = s.createButton("-")
    slowDown.mouseClicked ->
      speed = Math.max(1,speed-1)
      frameRate.html("#{speed} generations/second")

    speedUp = s.createButton("+")
    speedUp.mouseClicked ->
      speed = Math.min(60, speed+1)
      frameRate.html("#{speed} generations/second")

    frameRate = s.createSpan("#{speed} generations/second")

  s.draw = ->
    s.frameRate(speed)
    s.background(255)
    renderWorld(s, world, width, height, cellSize)

    unless paused
      world = advanceWorld(world,width,height)

  s.mouseClicked = (e) ->
    if e.toElement.tagName is "CANVAS"
      x = s.mouseX // cellSize
      y = s.mouseY // cellSize

      world[y][x] = !world[y][x]

  s.mouseDragged = (e) ->
    if e.toElement.tagName is "CANVAS"
      x = s.mouseX // cellSize
      y = s.mouseY // cellSize

      # check to see if the place we are dragging is different than the last
      # drag event
      if x isnt s.previousCell[0] or y isnt s.previousCell[1]
        s.previousCell = [x,y]
        world[y][x] = !world[y][x]
        renderWorld(s, world, width, height, cellSize)
