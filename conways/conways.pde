// Conway's Game of Life
// Steven Klise <http://skli.se>
// 2011-2012

Life life;

String logging;
int frameStart;

void setup() {
  size(900, 700);
  life = new Life();
  frameRate(12);
}

void draw() {
  noStroke();
  background(255);
  fill(0);
  frameRate(12);

  logging = "\nNEW FRAME: " + frameRate + "\n";
  frameStart = millis();

  life.run(width, height, frameCount);

  logging += "Timer: " + (millis() - frameStart) + "\n";
  // println(logging);
}

// Life: Conway's Game of Life wrapper.
class Life {
  // The center of the visible field. For now this will always be (0,0) until
  // translating screen postion is implemented.
  PVector focus = new PVector(0,0);
  // Pixel size of a cell. Must be >=1.
  int cellSize;
  // Is life paused?
  boolean paused;
  // Should gridlines be drawn?
  boolean showGrid;
  // Pixel size of grid.
  int gridThickness;
  // All the coordinates that are alive.
  HashMap<String,PVector> population;
  // A list of coordinates that have already been checked in update.
  ArrayList<String> checked;
  // All cells to kill.
  ArrayList<String> deathbed;

  // Dead cells that neighbor living cells
  HashMap<String,PVector> potentialBirths;

  // All cells to be born.
  ArrayList<PVector> nursery;
  // Number of generations.
  int ageOfWorld;
  // Number of frames per generation.
  float lengthOfGeneration;

  Life() {
    ageOfWorld = 0;
    cellSize = 20;
    lengthOfGeneration = 8;
    showGrid = false;
    paused = false;
    gridThickness = showGrid ? 1 : 0;

    population = new HashMap<String,PVector>(100);
    potentialBirths = new HashMap<String,PVector>(100);

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
    if (paused) {
      text("PAUSED", width/2, 15);
    } else if (totalFrames % lengthOfGeneration == 0) {
      ageOfWorld++;
      logging += "AGE: " + ageOfWorld;

      checkLivingCells();
      checkBirthConditions();
      kill();
      birth();
    }
  }

  // Private: Check population for kill or stagnate, and neighboring cells for
  // birthing.
  //
  // Returns nothing.
  private void checkLivingCells() {
    // Create an iterator on population and check every cell in the population.
    Iterator i = population.entrySet().iterator();

    while (i.hasNext()) {
      // Get the key and value from the HashMap entry.
      Map.Entry entry = (Map.Entry)i.next();
      PVector cell = (PVector)entry.getValue();
      String cellString = (String)entry.getKey();

      // Count the number of neighbors.
      int neighborCount = countNeighbors(cell, cellString, true);
      // Mark the cell for death.
      if (neighborCount < 2 || neighborCount > 3) { deathbed.add(cellString); }
    }
  }

  private void checkBirthConditions() {
    logging += "BirthCondition Pool: " + potentialBirths.size() + "\n";

    Iterator i = potentialBirths.entrySet().iterator();

    while (i.hasNext()) {
      Map.Entry entry = (Map.Entry)i.next();
      PVector cell = (PVector)entry.getValue();
      String cellString = (String)entry.getKey();

      int neighborCount = countNeighbors(cell, cellString, false);
      if (neighborCount == 3) { nursery.add(cell); }
    }

    potentialBirths.clear();
  }

  // Private: Removes all cells in deathbed from population. Clears deathbed.
  //
  // Returns nothing.
  private void kill() {
    logging += "Deathbed size: " + deathbed.size() + "\n";

    // Remove cell from population.
    for (String cellString : deathbed) { population.remove(cellString); }
    // Empty the ArrayList.
    deathbed.clear();
  }

  // Private: add nursery to population.
  private void birth() {
    for (PVector cell : nursery) { addPVectorToHashMap(cell, population); }
    nursery.clear();
  }

  // Private: Draw all grid lines and living cells that fit inside the window.
  private void render(int windowWidth, int windowHeight) {

    int[] domainAndRange = onScreenDomainAndRange(windowWidth, windowHeight);

    if (showGrid) { drawGrid(windowWidth, windowHeight); }

    drawCells(domainAndRange);

    text(ageOfWorld, 0, 15);
    text(frameRate, 0, 30);
  }

  // ### RENDER METHODS

  private void drawGrid(int windowWidth, int windowHeight) {
    stroke(230, 230, 230, 255);

    // Find how many cells fit on screen.
    PVector cellsOnScreen = new PVector(
      cellsFit(windowWidth),
      cellsFit(windowHeight));

    // Find partial cell size and evenly distribute around edges of screen.
    PVector edgeCell = new PVector(
      (cellsOnScreen.x - floor(cellsOnScreen.x)) * (float)cellSize / 2,
      (cellsOnScreen.y - ceil(cellsOnScreen.y)) * (float)cellSize / 2);

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

    stroke(255, 0, 0, 150);
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

  // ### UTILITY METHODS

  // Public: Given a cell, determine how many alive neighbors the cell has.
  //
  // cell - PVector coordinates of the cell.
  // cellString - String of a comma separated float of the cell's coordinates.
  //
  // Returns an integer value between 0 and 8.
  public int countNeighbors(PVector cell, String cellString,
    boolean checkForBirths) {
    int neighborCount = 0;
    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++ ) {
        String neighborKey = (cell.x + x) + "," + (cell.y + y);

        // If this neighboring cell is alive increase the neighborCount.
        // Otherwise add the cell to list of potential births.
        if (!neighborKey.equals(cellString) &&
          population.containsKey(neighborKey)) {
          neighborCount++;
        } else {
          if (checkForBirths) {
            potentialBirths.put(neighborKey, new PVector(cell.x + x,
              cell.y + y));
          }
        }
      }
    }
    return neighborCount;
  }

  public void addPVectorToHashMap(PVector vector, HashMap map) {
    String key = vector.x + "," + vector.y;
    map.put(key, vector);
  }

  // Private: Converts cell coordinates to screen coordinates.
  private PVector screenCoordinates(PVector cellCoordinates) {
    PVector s = new PVector(
      width/2 + (cellCoordinates.x - focus.x) * (cellSize + gridThickness)
        + gridThickness,
      height/2 + (cellCoordinates.y - focus.y)* (cellSize + gridThickness)
        + gridThickness
    );
    return s;
  }

  public PVector lifeCoordinates(PVector mouse) {
    PVector coordinates = new PVector(
      floor((mouse.x - width/2) / (cellSize + gridThickness)),
      floor((mouse.y - height/2) / (cellSize + gridThickness))
      );

    return coordinates;
  }

  // Private: Calculates how many cells will fit within the given dimension.
  //
  // fitSize - Integer pixel value, intended to be width or height.
  //
  // Returns a float of the solution to the calculation.
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

  // ### EVENTS

  public void zoomOut() {
    if (cellSize > 1) {
      cellSize -= (cellSize > width/20) ? 4 : 1;
    }
  }

  public void zoomIn() {
    if (cellSize < min(width, height)) {
      cellSize += (cellSize > width/20) ? 4 : 1;
    }
  }

  public void pause() { paused = !paused; }

  public void addOrDestroyAtScreenCoord(int x, int y) {
    // Turn mouse position into life coordinates
    PVector coordinates = lifeCoordinates(new PVector(x, y));

    String coordKey = coordinates.x + "," + coordinates.y;

    if (population.containsKey(coordKey)) {
      population.remove(coordKey);
    } else {
      population.put(coordKey, coordinates);
    }
  }
}

void mouseClicked() {
  life.addOrDestroyAtScreenCoord(mouseX, mouseY);
}

void mouseDragged() {
  // TODO: Remove flickering...
  life.addOrDestroyAtScreenCoord(mouseX, mouseY);
}

void keyTyped() {
  switch(key) {
    case '-' : life.zoomOut(); break;
    case '=' : life.zoomIn(); break;
    case '+' : life.zoomIn(); break;
    case ' ' : life.pause(); break;
    default: break;
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