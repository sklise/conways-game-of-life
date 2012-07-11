// Conway's Game of Life
// Steven Klise <http://skli.se>
// 2011-2012

Life newWorld;

void setup() {
  size(100, 108);
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

void ifClear() // Function to clear the entire world.
{
  // if(window.cleargrid)
  // {
  //   for (int x=0; x<board.gw; x++)
  //   {
  //     for (int y=0; y<board.gh; y++)
  //     {
  //       world[x][y][0] = 0;
  //       world[x][y][1] = 0;
  //     }
  //   }
  //   window.running = false;
  //   //$('#conway_running').val('RUN');
  //   window.cleargrid = false;
  // }
}

// void mouseDragged() // dragging the mouse is different than clicking. Requires mousePressed() for initial condition.
// {
//   if (mouseX > board.tx && mouseX < board.bx && mouseY < board.by && mouseY > board.ty) {
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
//   if (mouseX > board.tx && mouseX < board.bx && mouseY < board.by && mouseY > board.ty) {
//     PVector l = board.toGrid(mouseX, mouseY);
//     if (world[(int)l.x][(int)l.y][0] != 1) {
//       kill = false;
//     } else {
//       kill = true;
//     }
//   }
// }

// void mouseClicked() // Single cell birth or death, as well as placing patterns.
// {
//   if (mouseX > board.tx && mouseX < board.bx && mouseY < board.by && mouseY > board.ty) // Check bounds of grid
//   {
//     PVector l = board.toGrid(mouseX, mouseY); // Mouse location to grid position
//     if (mouseButton == LEFT) // Only on Left click
//     {
//         world[(int)l.x][(int)l.y][0] = (world[(int)l.x][(int)l.y][0]+1)%2;
//     }
//   }
// }

// Life: Conway's Game of Life wrapper.
class Life {
  // The center of the visible field.
  // For now this will always be (0,0) until translating screen postion is
  // implemented.
  PVector focus = new PVector(0,0);
  // Pixel size of a cell. Must be >=1.
  int cellSize = 9;
  // Should gridlines be drawn?
  boolean gridLines = true;
  // Pixel size of grid.
  int gridThickness;
  // All the coordinates that are alive.
  // HashMap population;
  ArrayList<PVector> population;
  // A list of coordinates that have already been checked in update.
  ArrayList checked;
  // All cells to kill.
  ArrayList deathbed;
  // All cells to be born.
  ArrayList nursery;
  // Number of generations.
  int ageOfWorld;
  // Number of frames per generation.
  float lengthOfGeneration;

  Life() {
    ageOfWorld = 0;
    lengthOfGeneration = 12;
    // population = new HashMap();
    population = new ArrayList<PVector>();

    // population.put("-4", saveY(-6));
    population.add(new PVector(-4,-6));
    population.add(new PVector(0,2));
    population.add(new PVector(0,0));
    population.add(new PVector(0,1));
    checked = new ArrayList();
    gridThickness = gridLines ? 1 : 0;
  }

  HashMap saveY(int ycoord) {
    HashMap hm = new HashMap();
    hm.put(Integer.toString(ycoord), 1);
    return hm;
  }


  // Public: Run Life.
  public void run(int windowWidth, int windowHeight, int totalFrames) {
    render(windowWidth, windowHeight);
    age(totalFrames);
  }

  void age(int totalFrames) {
    if (totalFrames % lengthOfGeneration == 0) {
      ageOfWorld++;

      checkCells();
      kill();
      birth();
    }
  }

  // Private: Check population for kill or stagnate, and neighboring cells for
  // birthing.
  private void checkCells() {
    for(PVector cell : population) {
      println(cell);
    }
  }

  // Private: remove deathbed from population.
  private void kill() {

  }

  // Private: add nursery to population.
  private void birth() {

  }

  // Private: Draw all grid lines and living cells that fit inside the window.
  private void render(int windowWidth, int windowHeight) {

    int[] domainAndRange = onScreenDomainAndRange(windowWidth, windowHeight);

    if(gridLines) { drawGrid(windowWidth, windowHeight); }

    drawCells(domainAndRange);

    text(ageOfWorld, 0, 15);
  }

  private void drawGrid(int windowWidth, int windowHeight) {
    stroke(230, 230, 230, 255);

    // Find how many cells fit on screen.
    PVector cellsOnScreen = new PVector(
      cellsFitWidth(windowWidth),
      cellsFitHeight(windowHeight));

    // Find partial cell size and evenly distribute around edges of screen.
    PVector edgeCell = new PVector(
      (cellsOnScreen.x - floor(cellsOnScreen.x)) * (float)cellSize / 2,
      (cellsOnScreen.y - floor(cellsOnScreen.y)) * (float)cellSize / 2);

    // Draw vertical grid lines.
    for(int i=0; i < cellsOnScreen.x; i++) {
      line(edgeCell.x + i * (cellSize + gridThickness), 0, edgeCell.x + i *
        (cellSize + gridThickness), height);
    }

    // Draw horizontal grid lines.
    for(int i=0; i < cellsOnScreen.y; i++) {
      line(0, edgeCell.y + i * (cellSize + gridThickness), width,edgeCell.y + i
       * (cellSize + gridThickness));
    }

    // println(onScreenDomainAndRange(windowWidth, windowHeight));
    line(0, height/2, width, height/2);
    line(width/2, 0, width/2, height);
  }

  private void drawCells(int[] domainAndRange) {
    noStroke();

    for(PVector cell : population) {
        if (cell.x >= domainAndRange[0] && cell.x < domainAndRange[1]
          && cell.y >= domainAndRange[2] && cell.y < domainAndRange[3]) {
          PVector cellOnScreen = screenCoordinates(cell);
          rect(cellOnScreen.x, cellOnScreen.y, cellSize, cellSize);
        }
    }

    // Iterator i = population.entrySet().iterator();  // Get an iterator

    // while (i.hasNext()) {
    //   Map.Entry row = (Map.Entry)i.next();

    //   HashMap x = (HashMap) row.getValue();

    //   Iterator j = x.entrySet().iterator();

    //   while (j.hasNext()) {
    //     Map.Entry column = (Map.Entry)j.next();
    //     println(row.getKey() + " " + column.getKey());

    //     PVector cell = hashValuesToPVector(row.getKey(), column.getKey());

    //     if (cell.x >= domainAndRange[0] && cell.x < domainAndRange[1]
    //       && cell.y >= domainAndRange[2] && cell.y < domainAndRange[3]) {
    //       PVector cellOnScreen = screenCoordinates(cell);
    //       rect(cellOnScreen.x, cellOnScreen.y, cellSize, cellSize);
    //     }
    //   }

      // print(me.getKey() + " is ");
      // println(me.getValue());
    // }

  }

  PVector hashValuesToPVector(Object row, Object column) {
    int x = Integer.parseInt((String)row);
    int y = Integer.parseInt((String)column);
    return new PVector(x,y);
  }

  // Private: Converts cell coordinates to screen coordinates.
  private PVector screenCoordinates(PVector cellCoordinates) {
    PVector s = new PVector(
      width/2 + cellCoordinates.x * (cellSize + gridThickness) + gridThickness,
      height/2 + cellCoordinates.y * (cellSize + gridThickness) + gridThickness
    );
    return s;
  }

  private float cellsFitWidth(int windowWidth) {
    return ((float)windowWidth / (cellSize + gridThickness));
  }

  private float cellsFitHeight(int windowHeight) {
    return ((float)windowHeight / (cellSize + gridThickness));
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
    float cellFitAcross = cellsFitWidth(windowWidth);
    float cellFitDown = cellsFitHeight(windowHeight);

    int[] domainAndRange = new int[4];
    domainAndRange[0] = (int)focus.x - ceil(cellFitAcross / 2);
    domainAndRange[1] = (int)focus.x + ceil(cellFitAcross / 2);
    domainAndRange[2] = (int)focus.y - ceil(cellFitDown / 2);
    domainAndRange[3] = (int)focus.y + ceil(cellFitDown / 2);

    return domainAndRange;
  }
}

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
// for(int x = 0; x<dx; x++)
// {
//   for(int y = 0; y<dy; y++)
//   {
//     world[mx+x][my+y][0] = intvals[x+dx*y];
//   }
// }
// }