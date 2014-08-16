---
---
w = window

# Function computes the state for the next generation of n in the world
w.outOfBounds = (i, max) -> if i > max or i < 0 then true else false

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

conway = (s) ->

  s.setup = ->
    s.createCanvas 900, 700

  # s.draw = ->
    # console.log 'draw'

new p5(conway)