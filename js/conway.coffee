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

  _.each world, (row, index) ->
    if cell
      sketch.fill 0
      coords = getCellCoords index, width
      sketch.rect(coords[0]*cellSize, coords[1]*cellSize,cellSize,cellSize)
      true
    else
      sketch.fill 255
      coords = getCellCoords index, width
      sketch.rect(coords[0]*cellSize, coords[1]*cellSize,cellSize,cellSize)
      true

w.conway = (s) ->

  width = height = 40
  paused = false
  speed = 8

  world = [
    [no, no, yes],
    [no, yes, yes],
    [yes, yes, yes]
  ]
  console.log advanceWorld(world,3,3)

  # Generate a blank world
  world = _.map _.range(1600), -> return no

  s.setup = ->
    s.createCanvas 600, 600
    s.frameRate(speed)

    # Gosper's Glider Guns
    aliveCells = [
      [1,24],[1,25],
      [2,24],[2,27],
      [3,10],[3,12],[3,28],
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
    s.frameRate(1)
    s.background(255)
    renderWorld(s, world, width, height, 15)

    # unless paused
      # world = advanceWorld(world,width,height)

  s.mouseClicked = ->
    console.log s.mouseX, s.mouseY