// Conway's Game of Life
// Steven Klise <http://skli.se>
// 2011-2012

Life newWorld;

void setup() {
  size(500, 508);
  newWorld = new Life();
  frameRate(12);
}

void draw() {
  noStroke();
  background(255);
  fill(0);
  frameRate(12);

  newWorld.run(width, height, frameCount);
}

// Life: Conway's Game of Life wrapper.
class Life {
  // The center of the visible field. For now this will always be (0,0) until
  // translating screen postion is implemented.
  PVector focus = new PVector(0,0);
  // Pixel size of a cell. Must be >=1.
  int cellSize;
  // Should gridlines be drawn?
  boolean gridLines;
  // Pixel size of grid.
  int gridThickness;
  // All the coordinates that are alive.
  HashMap<String,PVector> population;
  // A list of coordinates that have already been checked in update.
  ArrayList<String> checked;
  // All cells to kill.
  ArrayList<String> deathbed;
  // All cells to be born.
  ArrayList<PVector> nursery;
  // Number of generations.
  int ageOfWorld;
  // Number of frames per generation.
  float lengthOfGeneration;

  Life() {
    ageOfWorld = 0;
    cellSize = 9;
    lengthOfGeneration = 18;
    gridLines = true;
    gridThickness = gridLines ? 1 : 0;

    population = new HashMap<String,PVector>();

    deathbed = new ArrayList<String>();
    checked = new ArrayList<String>();

    nursery = new ArrayList<PVector>();

    population.put("-4.0,-6.0", new PVector(-4,-6));
    population.put("-4.0,-5.0", new PVector(-4,-5));
    population.put("-3.0,-6.0", new PVector(-3,-6));
    population.put("-3.0,-5.0", new PVector(-3,-5));
    population.put("0.0,0.0", new PVector(0.0, 0.0));
    population.put("1.0,0.0", new PVector(1, 0.0));
    population.put("2.0,0.0", new PVector(2, 0.0));
  }

  // Public: Run Life. Renders visually and ages the system.
  //
  // windowWidth - integer of window width from size().
  // windowHeight - integer of window height from size().
  // totalFrames - integer value from global frameCount.
  //
  // Returns nothing.
  public void run(int windowWidth, int windowHeight, int totalFrames) {
    render(windowWidth, windowHeight);
    age(totalFrames);
  }

  // Public: Age, the verb. Move the system forward in time. Checks for
  // creation of new generation and if so triggers actions to create a new
  // generation.
  //
  // totalFrames - integer value from global frameCount.
  //
  // Returns nothing.
  public void age(int totalFrames) {
    if (totalFrames % lengthOfGeneration == 0) {
      ageOfWorld++;

      checkCells();
      kill();
      birth();
    }
  }

  // Private: Check population for kill or stagnate, and neighboring cells for
  // birthing.
  //
  // Returns nothing.
  private void checkCells() {
    Iterator i = population.entrySet().iterator();

    while (i.hasNext()) {
      Map.Entry entry = (Map.Entry)i.next();
      PVector cell = (PVector)entry.getValue();
      String cellString = (String)entry.getKey();

      int neighborCount = countNeighbors(cell, cellString);

      if (neighborCount < 2 || neighborCount > 3) { deathbed.add(cellString); }
    }
  }

  // Public: Given a cell, determine how many alive neighbors the cell has.
  //
  // cell - PVector coordinates of the cell.
  // cellString - String of a comma separated float of the cell's coordinates.
  //
  // Returns an integer value between 0 and 8.
  public int countNeighbors(PVector cell, String cellString) {
    int neighborCount = 0;
    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++ ) {
        String neighborKey = (cell.x + x) + "," + (cell.y + y);
        if (!neighborKey.equals(cellString) &&
          population.containsKey(neighborKey)) {
          neighborCount++;
        }
      }
    }
    return neighborCount;
  }

  // Private: Removes all cells in deathbed from population. Clears deathbed.
  //
  // Returns nothing.
  private void kill() {
    println(deathbed);
    // Remove cell from population.
    for (String cellString : deathbed) { population.remove(cellString); }
    // Empty the ArrayList.
    deathbed.clear();
  }

  // Private: add nursery to population.
  private void birth() {

  }

  // Private: Draw all grid lines and living cells that fit inside the window.
  private void render(int windowWidth, int windowHeight) {

    int[] domainAndRange = onScreenDomainAndRange(windowWidth, windowHeight);

    if (gridLines) { drawGrid(windowWidth, windowHeight); }

    drawCells(domainAndRange);

    text(ageOfWorld, 0, 15);
  }

  private void drawGrid(int windowWidth, int windowHeight) {
    stroke(230, 230, 230, 255);

    // Find how many cells fit on screen.
    PVector cellsOnScreen = new PVector(
      cellsFit(windowWidth),
      cellsFit(windowHeight));

    // Find partial cell size and evenly distribute around edges of screen.
    PVector edgeCell = new PVector(
      (cellsOnScreen.x - floor(cellsOnScreen.x)) * (float)cellSize / 2,
      (cellsOnScreen.y - floor(cellsOnScreen.y)) * (float)cellSize / 2);

    // Draw vertical grid lines.
    for (int i=0; i < cellsOnScreen.x; i++) {
      line(edgeCell.x + i * (cellSize + gridThickness), 0, edgeCell.x + i *
        (cellSize + gridThickness), height);
    }

    // Draw horizontal grid lines.
    for (int i=0; i < cellsOnScreen.y; i++) {
      line(0, edgeCell.y + i * (cellSize + gridThickness), width,edgeCell.y + i
       * (cellSize + gridThickness));
    }

    // println(onScreenDomainAndRange(windowWidth, windowHeight));
    line(0, height/2, width, height/2);
    line(width/2, 0, width/2, height);
  }

  private void drawCells(int[] domainAndRange) {
    noStroke();

    Iterator i = population.entrySet().iterator();

    while (i.hasNext()) {
      Map.Entry entry = (Map.Entry)i.next();

      PVector cell = (PVector)entry.getValue();

      if (cell.x >= domainAndRange[0] && cell.x < domainAndRange[1]
        && cell.y >= domainAndRange[2] && cell.y < domainAndRange[3]) {
        PVector cellOnScreen = screenCoordinates(cell);
        rect(cellOnScreen.x, cellOnScreen.y, cellSize, cellSize);
      }
    }
  }

  // Private: Converts cell coordinates to screen coordinates.
  private PVector screenCoordinates(PVector cellCoordinates) {
    PVector s = new PVector(
      width/2 + cellCoordinates.x * (cellSize + gridThickness) + gridThickness,
      height/2 + cellCoordinates.y * (cellSize + gridThickness) + gridThickness
    );
    return s;
  }

  private float cellsFit(int fitSize) {
    return (float)fitSize / (cellSize + gridThickness);
  }

  // Private: Calculate the domain and range coordinates that fit on the screen
  // These values are based on screen size, cell size, focus location and
  // whether grid lines are drawn or not.
  //
  // windowWidth - interger value of width of window set by size()
  // windowHeight - interger value of height of window set by size()
  //
  // Returns an array of 4 integers, [min_x, max_x, min_y, max_y],
  // corresponding to the visible domain and range of Life.
  private int[] onScreenDomainAndRange(int windowWidth, int windowHeight) {
    // Divide screen width by cell size and grid state.
    float cellFitAcross = cellsFit(windowWidth);
    float cellFitDown = cellsFit(windowHeight);

    int[] domainAndRange = new int[4];
    domainAndRange[0] = (int)focus.x - ceil(cellFitAcross / 2);
    domainAndRange[1] = (int)focus.x + ceil(cellFitAcross / 2);
    domainAndRange[2] = (int)focus.y - ceil(cellFitDown / 2);
    domainAndRange[3] = (int)focus.y + ceil(cellFitDown / 2);

    return domainAndRange;
  }
}

// dragging the mouse is different than clicking. Requires mousePressed() for
// initial condition.
// void mouseDragged()
// {
//   if (mouseX > board.tx && mouseX < board.bx && mouseY < board.by && mouseY
// > board.ty) {
//     PVector t = board.toGrid(mouseX, mouseY);
//     if (!kill) {
//       world[(int)t.x][(int)t.y][0] = 1;
//     } else {
//       world[(int)t.x][(int)t.y][0] = 0;
//     }
//   }
// }

// void mousePressed() // Did the user press on a live or dead cell?
// {
//   if (mouseX > board.tx && mouseX < board.bx && mouseY < board.by && mouseY
// > board.ty) {
//     PVector l = board.toGrid(mouseX, mouseY);
//     if (world[(int)l.x][(int)l.y][0] != 1) {
//       kill = false;
//     } else {
//       kill = true;
//     }
//   }
// }

// Single cell birth or death, as well as placing patterns.
// void mouseClicked()
// {
// Check bounds of grid
//   if (mouseX > board.tx && mouseX < board.bx && mouseY < board.by && mouseY
//      > board.ty)
//   {
// Mouse location to grid position
//     PVector l = board.toGrid(mouseX, mouseY);
//     if (mouseButton == LEFT) // Only on Left click
//     {
//         world[(int)l.x][(int)l.y][0] = (world[(int)l.x][(int)l.y][0]+1)%2;
//     }
//   }
// }

//   PVector toGrid(int x, int y) // Convert a pixel number to a grid number
//   {
//     int gridx = (x - tx)/res;
//     int gridy = (y - ty)/res;
//     PVector v = new PVector(gridx,gridy);
//     return v;
//   }

// void placeForm(int mx, int my)
// {
// String form = Pattern.name;
// int[] intvals = int(split(Pattern.shape,','));
// int dx = Pattern.width;
// int dy = Pattern.height;
// for (int x = 0; x<dx; x++)
// {
//   for (int y = 0; y<dy; y++)
//   {
//     world[mx+x][my+y][0] = intvals[x+dx*y];
//   }
// }
// }