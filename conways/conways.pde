// Conway's Game of Life
// Steven Klise <http://skli.se>
// 2011-2012

// Grid board;
// int[][][] world;
// boolean kill = false;
// boolean running = false;

Life newWorld;

void setup()
{
  size(100, 108);
  newWorld = new Life();
  frameRate(12);
  // board = new Grid(10, 10, width-10, height-3, 10);
  // world = new int[board.gw][board.gh][2];
}

void draw()
{
  noStroke();
  background(255);
  fill(0);
  newWorld.run(width, height, frameCount);

  frameRate(12);
  // draw and update.
  // for (int x=0; x<board.gw; x++) {
  //   for (int y=0; y<board.gh; y++)
  //   {
  //     if (world[x][y][0] == 1)
  //     {
  //       PVector l = board.toScreen(x, y);
  //       rect(l.x, l.y, board.res, board.res);
  //     }
  //     int n = neighbors(x, y);
  //     if ((n < 2 || n > 3) && world[x][y][0] == 1)
  //     {
  //       world[x][y][1] = -1;
  //     }
  //     else if (n == 3 && world[x][y][0] == 0)
  //     {
  //       world[x][y][1] = 1;
  //     }
  //     else
  //     {
  //       world[x][y][1] = 0;
  //     }
  //   }
  // }
  // if (running){
  //   for (int x=0; x<board.gw; x++)
  //   {
  //     for (int y=0; y<board.gh; y++)
  //     {
  //       if (world[x][y][1] == 1 || (world[x][y][1] == 0 && world[x][y][0] == 1))
  //       {
  //         world[x][y][0] = 1;
  //       }
  //       else if (world[x][y][1] == -1)
  //       {
  //         world[x][y][0] = 0;
  //       }
  //     }
  //   }
  // }
  // ifClear();
  //println("running");
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

// int neighbors(int x, int y)
// {
  // if(window.edges)
  // {
  //   int n =0;
  //   if (x+1 < board.gw)
  //   {
  //     n += world[(x + 1)][y][0];
  //     if (y+1 < board.gh)
  //     {
  //       n += world[(x + 1)][(y + 1)][0];
  //     }
  //     if (y-1 >= 0)
  //     {
  //       n += world[(x + 1)][(y - 1)][0];
  //     }
  //   }
  //   if (x-1 >= 0)
  //   {
  //     n += world[(x - 1) % board.gw][y][0];
  //     if (y+1 < board.gh)
  //     {
  //       n += world[(x - 1)][(y + 1)][0];
  //     }
  //     if (y-1 >= 0)
  //     {
  //       n += world[(x - 1)][(y - 1)][0];
  //     }
  //   }
  //   if (y-1 >= 0)
  //   {
  //     n += world[x][(y - 1)][0];
  //   }

  //   if ( y+1 < board.gh )
  //   {
  //     n += world[x][(y + 1)][0];
  //   }
  //   return n;
  // }
  // else
  // {
    // return world[(x + 1) % board.gw][y][0] +
    //   world[x][(y + 1) % board.gh][0] +
    //   world[(x + board.gw - 1) % board.gw][y][0] +
    //   world[x][(y + board.gh - 1) % board.gh][0] +
    //   world[(x + 1) % board.gw][(y + 1) % board.gh][0] +
    //   world[(x + board.gw - 1) % board.gw][(y + 1) % board.gh][0] +
    //   world[(x + board.gw - 1) % board.gw][(y + board.gh - 1) % board.gh][0] +
    //   world[(x + 1) % board.gw][(y + board.gh - 1) % board.gh][0];
  // }
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
  ArrayList population;
  // A list of coordinates that have already been checked in update.
  ArrayList checked;
  // Number of generations.
  int ageOfWorld;
  // Number of frames per generation.
  float lengthOfGeneration;

  Life() {
    ageOfWorld = 0;
    lengthOfGeneration = 12;
    population = new ArrayList();
    population.add(new PVector(-4,-6));
    population.add(new PVector(0,2));
    population.add(new PVector(0,0));
    population.add(new PVector(0,1));
    checked = new ArrayList();
    gridThickness = gridLines ? 1 : 0;
  }

  // Public: Run Life.
  public void run(int windowWidth, int windowHeight, int totalFrames) {
    render(windowWidth, windowHeight);
    age(totalFrames);
  }

  void age(int totalFrames) {
    if (totalFrames % lengthOfGeneration == 0) {
      ageOfWorld++;
      println("hi" + " " + totalFrames);
    }
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
    for(int i = 0; i < population.size(); i++) {
      PVector cell = (PVector)population.get(i);
      // Draw cells only if it is within the range.
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
    println(s);
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

// class Grid
// {

//   PVector toGrid(int x, int y) // Convert a pixel number to a grid number
//   {
//     int gridx = (x - tx)/res;
//     int gridy = (y - ty)/res;
//     PVector v = new PVector(gridx,gridy);
//     return v;
//   }

//   PVector toScreen(int x, int y) // Convert a grid number to a pixel number
//   {
//     int sx = x*res+tx;
//     int sy = y*res+ty;
//     PVector v = new PVector(sx,sy);
//     return v;
//   }
// }

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
