

var world = {
  width: 160,
  height: 90,
  renderedCellSize: 8,
  paused: false,
  cells: []
};

// When you drag the mouse, we want to use the state of the cell you first clicked on as the inverse value to set for all other cells.
var initiallyClickedCellState = 1;

// Javascript doesn't have a proper "modulo" operator see: https://developer.mozilla.org /en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Remainder_()
// When % is passed a negative number for the divisor, the result is negative. For
// looping around arrays we always need positive values.
//
// example:
//    var widthCount = 15;
//    -1 % 15 === -1; // Desired result is 14
//    actualModulo(-1, 15) === 14
function actualModulo(divisor, dividend) {
  var fakeMod = divisor % dividend;

  if (fakeMod < 0) {
    return dividend + fakeMod;
  } else {
    return fakeMod;
  }
}

var gol = {};

// Create a two dimensional array given two dimensions and a function to fill the array
gol.buildArray = function (w, h, pred) {
  var arr = Array(h);
  for (var i = 0; i < h; i += 1) {
    var arrRow = Array(w);
    for (var j = 0; j < w; j += 1) {
      arrRow[j] = pred(j,i);
    }
    arr[i] = arrRow;
  }
  return arr;
}

// Random (and soon hopefully something like a Perlin Noise thing) make cells. Give it a coefficient for likelihood that the cell is alive, between 0 and 1. A value closer to 1 means more living cells.
//
// Returns a closure that generates 1s and 0s.
gol.populate = function (coefficient) {
  return function (x, y) {
    if (Math.random() < coefficient) { return 1; } else { return 0;}
  }
}

// Get the sum of the neighbors of a cell. Given the entire world array, width and
// height precomputed to save on lenght lookups and the x and y coordinate of the cell.
// Loops around the edges.
gol.sumNeighbors = function (world, w, h, x, y) {
  return world[y][actualModulo(x - 1, w)]
    + world[y][actualModulo(x + 1, w)]
    + world[actualModulo(y - 1, h)][x]
    + world[actualModulo(y + 1, h)][x]
    + world[actualModulo(y - 1, h)][actualModulo(x - 1, w)]
    + world[actualModulo(y - 1, h)][actualModulo(x + 1, w)]
    + world[actualModulo(y + 1, h)][actualModulo(x - 1, w)]
    + world[actualModulo(y + 1, h)][actualModulo(x + 1, w)];
}

// Count up neighbors;
gol.census = function (world) {
  var newNeighborCounts = gol.buildArray(world.width, world.height, function() { return 0; });
  world.cells.forEach(function(rowArray, yIndex) {
    rowArray.forEach(function(cellState, xIndex) {
      newNeighborCounts[yIndex][xIndex] = gol.sumNeighbors(world.cells, world.width, world.height, xIndex, yIndex);
    });
  });

  return newNeighborCounts;
}

gol.nextGeneration = function (world, neighborCounts) {
  world.cells.forEach(function(rowArray, yIndex) {
    rowArray.forEach(function(cellState, xIndex) {
      var count = neighborCounts[yIndex][xIndex];
      var cellState = world.cells[yIndex][xIndex];
      if (count == 3) {
        world.cells[yIndex][xIndex] = 1;
      } else if (cellState === 1 && (count < 2 || count > 3)) {
        world.cells[yIndex][xIndex] = 0;
      }
    });
  });

  return world;
}

// resets a world's cells with the provided density and returns the world.
gol.populateWorld = function(world, density) {
  world.cells = gol.buildArray(world.width, world.height, gol.populate(density));
  return world;
}

gol.clearWorld = function (world) {
  world.cells = gol.buildArray(world.width, world.height, function () { return 0; });
  return world;
}

var drawWorld = function (world) {
  fill(0,0,0);
  world.cells.forEach(function(rowArray, yIndex) {
    rowArray.forEach(function(cellState, xIndex) {
      if (cellState === 1) {
        rect(xIndex * world.renderedCellSize, yIndex * world.renderedCellSize, world.renderedCellSize, world.renderedCellSize);
      }
    });
  });
}

var isMouseInBounds = function(world) {
  var w = world.width * world.renderedCellSize;
  if (mouseX > 0 && mouseY > 0 && mouseX <= w, mouseY <= world.height * world.renderedCellSize) {
    return true;
  } else {
    return false;
  }
}

var posToCellCoords = function (cellSize, x) {
  return x - x%cellSize;
}

function setup() {
  noStroke();
  frameRate(20);
  world = gol.populateWorld(world, 0.35);

  var pauseButton = createButton('Pause');
  pauseButton.mousePressed(function () {
    world.paused = !world.paused;
  });

  var clearButton = createButton('Clear');
  clearButton.mousePressed(function () {
    world = gol.clearWorld(world);
  });

  var generateButton = createButton('Regenerate');
  generateButton.mousePressed(function () {
    world = gol.populateWorld(world, sl.value()/ 100);
  });

  var sl = createSlider(0,100,35);

  createCanvas(world.width * world.renderedCellSize, world.height * world.renderedCellSize);
}

function draw() {
  fill(255,255,255);
  background();
  drawWorld(world);
  // Update the world only if the world is not paused.
  if (!world.paused) {
    var neighborCounts = gol.census(world);
    world = gol.nextGeneration(world, neighborCounts);
  }

  if (isMouseInBounds(world)) {
    var xx = posToCellCoords(world.renderedCellSize,mouseX);
    var yy = posToCellCoords(world.renderedCellSize,mouseY);
    fill(0, 0, 255, 128);
    rect(xx, yy, world.renderedCellSize, world.renderedCellSize);

    if (mouseIsPressed) {
      var xx = posToCellCoords(world.renderedCellSize,mouseX);
      var yy = posToCellCoords(world.renderedCellSize,mouseY);
      world.cells[yy / world.renderedCellSize][xx / world.renderedCellSize] = initiallyClickedCellState;
    }
  }

}

function mousePressed() {
  var xx = posToCellCoords(world.renderedCellSize,mouseX);
  var yy = posToCellCoords(world.renderedCellSize,mouseY);
  initiallyClickedCellState = world.cells[yy / world.renderedCellSize][xx / world.renderedCellSize] ? 0 : 1;
}

function keyPressed(e) {
  if (key === ' ') {
    e.preventDefault();
    world.paused = !world.paused;
  }
}