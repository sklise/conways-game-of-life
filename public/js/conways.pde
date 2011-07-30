// Conway's Game of Life
// Steven Klise <http://stevenklise.com>
// 2011

Grid board;
//boolean running;
int[][][] world;
boolean kill = false;

void setup()
{
  size(window.sketchWidth, window.sketchHeight);
  frameRate(window.speed);
  board = new Grid(10, 10, width-10, height-3, 10);
  world = new int[board.gw][board.gh][2];
}

void draw()
{
  background(0);
  board.render();
  frameRate(window.speed);
  for (int x=0; x<board.gw; x++) // draw and update.
  {
    for (int y=0; y<board.gh; y++)
    {
      if (world[x][y][0] == 1)
      {
        PVector l = board.toScreen(x, y);
        rect(l.x, l.y, board.res, board.res);
      }
      int n = neighbors(x, y);
      if ((n < 2 || n > 3) && world[x][y][0] == 1)
      {
        world[x][y][1] = -1;
      }
      else if (n == 3 && world[x][y][0] == 0)
      {
        world[x][y][1] = 1;
      }
      else
      {
        world[x][y][1] = 0;
      }
    }
  }
  if (window.running)
  {
    for (int x=0; x<board.gw; x++)
    {
      for (int y=0; y<board.gh; y++)
      {
        if (world[x][y][1] == 1 || (world[x][y][1] == 0 && world[x][y][0] == 1))
        {
          world[x][y][0] = 1;
        }
        else if (world[x][y][1] == -1)
        {
          world[x][y][0] = 0;
        }
      }
    }
  }
  ifClear();
  //println("running");
}

void ifClear() // Function to clear the entire world.
{
  if(window.cleargrid)
  {
    for (int x=0; x<board.gw; x++)
    {
      for (int y=0; y<board.gh; y++)
      {
        world[x][y][0] = 0;
        world[x][y][1] = 0;
      }
    }
    window.running = false;
    $('#conway_running').val('RUN');
    window.cleargrid = false;
  }
}

void mouseDragged() // dragging the mouse is different than clicking. Requires mousePressed() for initial condition.
{
  if (mouseX > board.tx && mouseX < board.bx && mouseY < board.by && mouseY > board.ty && (window.patternName == "single" || window.patternName == undefined))
  {
    PVector t = board.toGrid(mouseX, mouseY);
    if (!kill)
    {
      world[(int)t.x][(int)t.y][0] = 1;
    }
    else
    {
      world[(int)t.x][(int)t.y][0] = 0;
    }
  }
}

void mousePressed() // Did the user press on a live or dead cell?
{
  if (mouseX > board.tx && mouseX < board.bx && mouseY < board.by && mouseY > board.ty)
  {
    PVector l = board.toGrid(mouseX, mouseY);
    if (world[(int)l.x][(int)l.y][0] != 1)
    {
      kill = false;
    }
    else
    {
      kill = true;
    }
  }
}

void mouseClicked() // Single cell birth or death, as well as placing patterns.
{
  if (mouseX > board.tx && mouseX < board.bx && mouseY < board.by && mouseY > board.ty) // Check bounds of grid
  {
    PVector l = board.toGrid(mouseX, mouseY); // Mouse location to grid position
    if (mouseButton == LEFT) // Only on Left click
    {
      if(window.patternName == "single" || window.patternName == undefined)
      {
        world[(int)l.x][(int)l.y][0] = (world[(int)l.x][(int)l.y][0]+1)%2;
      }
      else
      {
        placeForm((int)l.x,(int)l.y);
      }
    }
  }
}

int neighbors(int x, int y)
{
  if(window.edges)
  {
    int n =0;
    if (x+1 < board.gw)
    {
      n += world[(x + 1)][y][0];
      if (y+1 < board.gh)
      {
        n += world[(x + 1)][(y + 1)][0];
      }
      if (y-1 >= 0)
      {
        n += world[(x + 1)][(y - 1)][0];
      }
    }
    if (x-1 >= 0)
    {
      n += world[(x - 1) % board.gw][y][0];
      if (y+1 < board.gh)
      {
        n += world[(x - 1)][(y + 1)][0];
      }
      if (y-1 >= 0)
      {
        n += world[(x - 1)][(y - 1)][0];
      }
    }
    if (y-1 >= 0)
    {
      n += world[x][(y - 1)][0];
    }

    if ( y+1 < board.gh )
    {
      n += world[x][(y + 1)][0];
    }
    return n;
  }
  else
  {
    return world[(x + 1) % board.gw][y][0] + 
      world[x][(y + 1) % board.gh][0] + 
      world[(x + board.gw - 1) % board.gw][y][0] + 
      world[x][(y + board.gh - 1) % board.gh][0] + 
      world[(x + 1) % board.gw][(y + 1) % board.gh][0] + 
      world[(x + board.gw - 1) % board.gw][(y + 1) % board.gh][0] + 
      world[(x + board.gw - 1) % board.gw][(y + board.gh - 1) % board.gh][0] + 
      world[(x + 1) % board.gw][(y + board.gh - 1) % board.gh][0];
  }
}


class Grid
{
  int tx;
  int ty;
  int bx;
  int by;
  int gw;
  int gh;
  int res;

  Grid(int _tx, int _ty, int _bx, int _by, int _res)
  {
    tx = _tx; 
    ty = _ty; 
    bx = _bx; 
    by = _by; 
    res = _res;
    gw = int((bx-tx)/res);
    gh = int((by-ty)/res);
  }

  void render()
  {
    stroke(60,60,60,255);
    for (int x=tx; x<=bx; x += res)
    {
      line(x,ty,x,gh*res+ty);
    }
    for (int y=ty; y<=by; y += res)
    {
      line(tx,y,gw*res+tx,y);
    }
  }

  PVector toGrid(int x, int y) // Convert a pixel number to a grid number
  {
    int gridx = (x - tx)/res;
    int gridy = (y - ty)/res;
    PVector v = new PVector(gridx,gridy);
    return v;
  }

  PVector toScreen(int x, int y) // Convert a grid number to a pixel number
  {
    int sx = x*res+tx;
    int sy = y*res+ty;
    PVector v = new PVector(sx,sy);
    return v;
  }
}

void placeForm(int mx, int my)
{
  String form = window.patternName;
  int[] intvals = int(split(window.patternShape,','));
  int dx = window.patternWidth;
  int dy = window.patternHeight;
  for(int x = 0; x<dx; x++)
  {
    for(int y = 0; y<dy; y++)
    {
      world[mx+x][my+y][0] = intvals[x+dx*y];
    }
  }
}