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
  console.log neighbors

  while currentNeighbor < 8
    console.log currentNeighbor, neighbors[currentNeighbor], world[neighbors[currentNeighbor]]
    # Short circuit if we are over
    break if neighborCount > 3

    if !outOfBounds(neighbors[currentNeighbor], worldSize) and world[neighbors[currentNeighbor]]
      neighborCount += 1

    currentNeighbor += 1

  neighborCount

# n is false so look for neighbors equal to 3
nextFromDead = (n, world, width, height) ->
  console.log "\nnext from dead"
  neighborCount = checkNeighbors(n,world,width,height)
  console.log "=", neighborCount
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


# Tests
world = [
  no, no, no,
  no, yes, no,
  yes, yes, yes
]

console.log(true, nextGeneration(4, world, 3, 3))

world2 = [
  no, no, yes,
  no, yes, yes,
  yes, yes, yes
]

console.log(false, nextGeneration(4, world2, 3, 3))

world3 = [
  yes, no, no,
  no, no, yes,
  no, no, yes
]

console.log(true, nextGeneration(4, world3, 3, 3))

world3 = [
  yes, no, no,
  no, no, no,
  no, no, yes
]

console.log(false, nextGeneration(4, world3, 3, 3))

conway = (s) ->

  s.setup = ->
    console.log 'setup'
    s.createCanvas 900, 700

  # s.draw = ->
    # console.log 'draw'

new p5(conway)