var widthCount = 160;
var heightCount = 90;
var renderedCellSize = 7;

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
gol.census = function (world, w, h) {
  var newNeighborCounts = gol.buildArray(w, h, function() { return 0; });
  world.forEach(function(rowArray, yIndex) {
    rowArray.forEach(function(cellState, xIndex) {
      newNeighborCounts[yIndex][xIndex] = gol.sumNeighbors(world, w, h, xIndex, yIndex);
    });
  });

  return newNeighborCounts;
}

var drawWorld = function () {
  fill(0,0,0);
  world.forEach(function(rowArray, yIndex) {
    rowArray.forEach(function(cellState, xIndex) {
      if (cellState === 1) {
        rect(xIndex * renderedCellSize, yIndex * renderedCellSize, renderedCellSize, renderedCellSize);
      }
    });
  });
}

var world;

function setup() {
  world = gol.buildArray(widthCount, heightCount, gol.populate(0.35));
  createCanvas(widthCount * renderedCellSize, heightCount * renderedCellSize);
  frameRate(10);
}

function draw() {
  fill(255,255,255);
  background();
  drawWorld();
  var neighborCounts = gol.census(world, widthCount, heightCount);
  world.forEach(function(rowArray, yIndex) {
    rowArray.forEach(function(cellState, xIndex) {
      var count = neighborCounts[yIndex][xIndex];
      var cellState = world[yIndex][xIndex];
      if (count == 3) {
        world[yIndex][xIndex] = 1;
      } else if (cellState === 1 && (count < 2 || count > 3)) {
        world[yIndex][xIndex] = 0;
      }
    });
  });
}
