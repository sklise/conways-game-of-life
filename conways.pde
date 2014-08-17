// Life: Conway's Game of Life wrapper.
class Life {

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

  public void slowDown() { lengthOfGeneration++; }

  public void speedUp() {
    lengthOfGeneration = lengthOfGeneration <= 1 ? 1 : lengthOfGeneration - 1;
  }

  public void zoomOut() {
    if (cellSize > 1) {
      if (cellSize > width/20) {
        cellSize -= 4;
      } else {
        cellSize--;
      }
    }
  }

  public void zoomIn() {
    if (cellSize < min(width, height)) {
      if (cellSize > width/20) {
        cellSize += 4;
      } else {
        cellSize++;
      }
    }
  }

  public void pause() { paused = !paused; }

  public void addOrDestroyAtScreenCoord(int x, int y) {
    // Turn mouse position into life coordinates
    PVector coordinates = lifeCoordinates(new PVector(x, y));

    String coordKey = coordinates.x + "," + coordinates.y;

    if (population.containsKey(coordKey) && killOnClick) {
      population.remove(coordKey);
    } else if (!killOnClick) {
      population.put(coordKey, coordinates);
    }
  }

  public boolean isAliveAtMouse(int x, int y) {
    PVector coordinates = lifeCoordinates(new PVector(x, y));
    String coordKey = coordinates.x + "," + coordinates.y;
    return population.containsKey(coordKey) ? true : false;
  }

  public void addMode(int x, int y) {
    killOnClick = isAliveAtMouse(mouseX, mouseY);
  }
}

void mouseClicked() { life.addOrDestroyAtScreenCoord(mouseX, mouseY); }

void mouseDragged() { life.addOrDestroyAtScreenCoord(mouseX, mouseY); }

void mousePressed() { life.addMode(mouseX, mouseY); }

void keyTyped() {
  switch(key) {
    case '-' : life.zoomOut(); break;
    case '=' : life.zoomIn(); break;
    case '+' : life.zoomIn(); break;
    case ' ' : life.pause(); break;
    default: break;
  }
}

void keyPressed() {
  switch(keyCode) {
    case UP   : life.speedUp(); break;
    case DOWN : life.slowDown(); break;
  }
}