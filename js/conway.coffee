---
---
w = window

# Function computes the state for the next generation of n in the world
w.outOfBounds = (i, w, h) ->
  if i[0] < 0 or i[1] < 0 or i[0] > h or i[1] > w
    true
  else
    false

w.getNeighborIndeces = (n, width) ->
  [
    n-width-1,
    n-width,
    n-width+1,
    n-1,
    n+1,
    n+width-1,
    n+width,
    n+width+1
  ]

checkNeighbors = (n,world,width,height) ->
  neighborCount = 0
  currentNeighbor = 0
  worldSize = width * height - 1

  neighbors = getNeighborIndeces(n, width)

  while currentNeighbor < 8
    # Short circuit if we are over
    break if neighborCount > 3

    if !outOfBounds(neighbors[currentNeighbor], worldSize) and world[neighbors[currentNeighbor]]
      neighborCount += 1

    currentNeighbor += 1

  neighborCount

# n is false so look for neighbors equal to 3
nextFromDead = (n, world, width, height) ->
  neighborCount = checkNeighbors(n,world,width,height)
  if neighborCount is 3 then true else false

# n is true so look for for neighbor count of 2 or 3
nextFromLiving = (n, world, width, height) ->
  neighborCount = checkNeighbors(n,world,width,height)
  if neighborCount < 2 or neighborCount > 3 then false else true

w.nextGeneration = (n, world, width, height) ->
  if world[n] is true
    nextFromLiving(n,world, width, height)
  else
    nextFromDead(n, world, width, height)

w.advanceWorld = (world, width, height) ->
  _.map world, (cell, i) -> nextGeneration(i,world,width,height)


# Render helpers
w.getCellCoords = (index, width) -> [index % width,index // width]

w.renderWorld = (sketch, world, width, height, cellSize) ->
  sketch.fill 0
  sketch.stroke 255

  _.each world, (cell, index) ->
    if cell
      coords = getCellCoords index, width
      sketch.rect(coords[0]*cellSize, coords[1]*cellSize,cellSize,cellSize)
      true

w.conway = (s) ->

  width = height = 40
  paused = false
  speed = 8

  # Generate a blank world
  world = _.map _.range(1600), -> return no

  s.setup = ->
    s.createCanvas 602, 602
    s.frameRate(speed)

    # Gosper's Glider Guns
    aliveCells = [64,65
     104,107,
     130,132,148,
     168,172,175,176,177,188,195,196
     208,228,235,236,
     241,242,247,252,260,261,264,267,
     281,282,288,296,298,301,304,305,
     328,332,338,339,340,
     370,372
    ]

    _.each aliveCells, (a) -> world[a] = on

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
    renderWorld(s, world, width, height, 15)

    unless paused
      world = advanceWorld(world,width,height)