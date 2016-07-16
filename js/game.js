// TODO:
// - Document all functions
// - Experiment with the size of the rendered world
//   - Detect screen size and draw accordingly
//   - Render entire size, and have overlays
// - Minify/uglify/gzip?
// - Perlin noise
// - Fix frame rate thing

//## p5

//### World

// This is the object that holds all of the state for the simulation. When something
// changes in the simulation we change it here. We initialize this object first and at
// the beginning of the file so that `setup` and `draw` can access it.

// - width: An integer of the number of cells across
// - height: An integer of the number of cells from top to bottom
// - renderedCellSize: An integer for how large to draw the cells
// - paused: A boolean value for whether the simulation is paused or not
// - cells: A two dimensional array of integers with values 1 or 0 for cell states
// - initiallyClickedCellState: An integer for what state to switch clicked cells to, usage for this property is explained in the `changeCellState` function

var world = {
  width: 160,
  height: 90,
  renderedCellSize: 7,
  paused: false,
  cells: [],
  initiallyClickedCellState: 0
};

//## Setup
function setup() {
  noStroke();

  // TODO: Run at 60fps but change the speed with which the world advances, keeping in
  // mind that frames can be dropped, so just using "frameCount" will not produce a
  // smooth simulation
  frameRate(20);

  // Populate the world with a default percentage filled
  world = populateWorld(world, 0.35);

  //### Interface buttons

  // Add a pause button that when clicked flips the value of `world.pause`
  var pauseButton = createButton('Pause');
  pauseButton.mousePressed(function () {
    world.paused = !world.paused;
  });

  // Add a button to clear set all cells to 0
  var clearButton = createButton('Clear');
  clearButton.mousePressed(function () {
    world = clearWorld(world);
  });

  // Add a button to wipe and reset the world randomly
  var generateButton = createButton('Regenerate');
  generateButton.mousePressed(function () {
    world = populateWorld(world, sl.value()/ 100);
  });

  // Add a slider to adjust the percentage of the grid to fill with live cells when
  // regenerating. This value is between 0 and 100, however values closer to 100 tend to
  // lead to a very quick die off.
  var sl = createSlider(0,100,35);

  // With all of the buttons and interface created, create the canvas with the world
  // width and height
  createCanvas(world.width * world.renderedCellSize, world.height * world.renderedCellSize);
}

//## Draw
function draw() {
  fill(255,255,255);
  background();
  drawWorld(world);
  // Update the world only if the world is not paused.
  if (!world.paused) {
    var neighborCounts = census(world);
    world = nextGeneration(world, neighborCounts);
  }

  if (isMouseInBounds(world)) {
    var xx = posToCellCoords(world.renderedCellSize,mouseX);
    var yy = posToCellCoords(world.renderedCellSize,mouseY);
    drawHoveredCell(xx, yy, world.renderedCellSize);

    if (mouseIsPressed) {
      changeCellState(world, xx / world.renderedCellSize, yy / world.renderedCellSize);
    }
  }

}

//## P5 Interactions
function mousePressed() {
  if (isMouseInBounds(world)) {
    var xx = posToCellCoords(world.renderedCellSize,mouseX);
    var yy = posToCellCoords(world.renderedCellSize,mouseY);
    world.initiallyClickedCellState = world.cells[yy / world.renderedCellSize][xx / world.renderedCellSize] ? 0 : 1;
  }
}

function keyPressed(e) {
  if (key === ' ') {
    e.preventDefault();
    world.paused = !world.paused;
  }
}

//## Drawing helper methods

//### drawHoveredCell

// Use this function to draw a highlighted cell at a given `x` and `y` coordinate in the
// p5 sketch. The function sets its own fill color to a semi-transulecent blue.

//##### Arguments:
// - x : An integer of the x coordinate to draw the `rect` at
// - y : An integer of the y coordinate to draw the `rect` at
// - side : An integer for the width and height of the `rect`
function drawHoveredCell(x, y, side) {
  fill(0, 0, 255, 128);
  rect(x, y, side, side);
}

//### drawWorld

// Draws black squares for all cells in `world` that have a value of 1.

//##### Arguments:
// - world : A world object, as defined above
function drawWorld(world) {
  fill(0,0,0);
  // Loop through the `world.cells` to get each row and then each cell, setting
  // variables for the yIndex and xIndex which are used to position the rectangle.
  world.cells.forEach(function(rowArray, yIndex) {
    rowArray.forEach(function(cellState, xIndex) {
      // If the cell is alive, draw a rectangle. Set the x position to be the number of
      // cells from the left times the width of each cell and the y position as the
      // number of cells from the top times the width of each cell.
      if (cellState === 1) {
        rect(xIndex * world.renderedCellSize, yIndex * world.renderedCellSize, world.renderedCellSize, world.renderedCellSize);
      }
    });
  });
}

//## Misc. Helper Functions

//### actualModulo
// Javascript doesn't have a proper "modulo" operator see [here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators#Remainder)
// When % is passed a negative number for the divisor, the result is negative. For
// looping around arrays we always need positive values.

// example:

//     -1 % 15 === -1; // Desired result is 14
//     actualModulo(-1, 15) === 14
function actualModulo(divisor, dividend) {
  var fakeMod = divisor % dividend;

  if (fakeMod < 0) {
    return dividend + fakeMod;
  } else {
    return fakeMod;
  }
}

//### isMouseInBounds
// Passed a world object, returns a boolean of whether or not the mouse is inside the
// edges of the simulation or not.
var isMouseInBounds = function(world) {
  var w = world.width * world.renderedCellSize;
  var h = world.height * world.renderedCellSize;

  if (mouseX > 0 && mouseY > 0 && mouseX < w && mouseY < h) {
    return true;
  } else {
    return false;
  }
}

//### posToCellCoords
var posToCellCoords = function (cellSize, n) {
  return n - n % cellSize;
}

//## Game of Life

//### buildArray
// Create a two dimensional array given two dimensions and a function to fill the array
// the predicate function is passed the x and y coordinates of the array position.
function buildArray(w, h, pred) {
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

//### populate
// Random (and soon hopefully something like a Perlin Noise thing) make cells. Give it a
// coefficient for likelihood that the cell is alive, between 0 and 1. A value closer to
// 1 means more living cells.
// TODO: Switch to 2d Perlin noise when I'm back on the internet.
//
// Returns a closure that generates 1s and 0s.
function populate(coefficient) {
  return function (x, y) {
    if (Math.random() < coefficient) {
      return 1;
    } else {
      return 0;
    }
  }
}

//### sumNeighbors
// Get the sum of the neighbors of a cell. Given the entire world array, width and
// height precomputed to save on lenght lookups and the x and y coordinate of the cell.
// Loops around the edges.
function sumNeighbors(cells, w, h, x, y) {
  return cells[y][actualModulo(x - 1, w)] + cells[y][actualModulo(x + 1, w)] + cells[actualModulo(y - 1, h)][x] + cells[actualModulo(y + 1, h)][x] + cells[actualModulo(y - 1, h)][actualModulo(x - 1, w)] + cells[actualModulo(y - 1, h)][actualModulo(x + 1, w)] + cells[actualModulo(y + 1, h)][actualModulo(x - 1, w)] + cells[actualModulo(y + 1, h)][actualModulo(x + 1, w)];
}

//### census
// Count up neighbors;
function census(world) {
  var newNeighborCounts = buildArray(world.width, world.height, function() { return 0; });
  world.cells.forEach(function(rowArray, yIndex) {
    rowArray.forEach(function(cellState, xIndex) {
      newNeighborCounts[yIndex][xIndex] = sumNeighbors(world.cells, world.width, world.height, xIndex, yIndex);
    });
  });

  return newNeighborCounts;
}

//### nextGeneration
function nextGeneration(world, neighborCounts) {
  world.cells.forEach(function(rowArray, yIndex) {
    rowArray.forEach(function(cellState, xIndex) {
      var count = neighborCounts[yIndex][xIndex];
      var cellState = world.cells[yIndex][xIndex];
      // If the cell has the proper number of neighbors to turn from dead to alive set
      // the cell to alive. Else, if the cell is currently alive and meets the
      // requirements to die, set the cell to dead. In all other cases do not update the
      // state of the cell.
      if (count == 3) {
        world.cells[yIndex][xIndex] = 1;
      } else if (cellState === 1 && (count < 2 || count > 3)) {
        world.cells[yIndex][xIndex] = 0;
      }
    });
  });

  return world;
}

//### changeCellState
function changeCellState(world, x, y) {
  world.cells[y][x] = world.initiallyClickedCellState;
}

//### populateWorld
// resets a world's cells with the provided density and returns the world.
function populateWorld(world, density) {
  world.cells = buildArray(world.width, world.height, populate(density));
  return world;
}

//### clearWorld
// Replaces `world.cells` with a two dimensional array filled only with 0's
function clearWorld(world) {
  world.cells = buildArray(world.width, world.height, function () { return 0; });
  return world;
}
