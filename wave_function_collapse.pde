import gifAnimation.*;

int N = 15;
int M = 20;
int TILE_SIZE = 30;  // pixels


//void settings() {
//  int w = M * TILE_SIZE;
//  int h = N * TILE_SIZE;
//  size(w, h);
//}


PFont font;
WFC wfc;
color[][] colorMap;

GifMaker gifExport;

void setup() {
  size(600, 450);  // N * TILE_SIZE,  M * TILE_SIZE
  //frameRate(60);

  font = createFont("Arial", 12);
  
  TilesDatabase db = new TilesDatabase(
    new Tile0(), new Tile1(), new Tile2(), new Tile3(), new Tile4(), new Tile5(), 
    new Tile6(), new Tile7(), new Tile8(), new Tile9(), new Tile10(), new Tile11()); 
    //, new Tile12(), new Tile13(), new Tile14());
  wfc = new WFC(N, M, db);
  colorMap = new color[N][M];
  
  for (int i = 0; i < N; i++)
    for (int j = 0; j < M; j++)
      colorMap[i][j] = color(random(0, 255), random(0, 255), random(0, 255));
  
  // draw bg grid and bg
  stroke(0); 
  noSmooth();
  background(0, 0, 100); 
  
  gifExport = new GifMaker(this, "wfc.gif");
  gifExport.setRepeat(0);        // make it an "endless" animation
  gifExport.setTransparent(0,0,0);  // black is transparent
  gifExport.setDelay(50);
}

int[] get_channels(color argb) {
  int a = (argb >> 24) & 0xFF;
  int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
  int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
  int b = argb & 0xFF;          // Faster way of getting blue(argb)
  return new int[]{a, r, g, b};
}

color avg_color(color[] colorArray, int size) {
  int[] res = new int[]{0, 0, 0, 0};
  int[] cArr = null;
  for (int i = 0; i < size; i++) {
    cArr = get_channels(colorArray[i]);
    res[0] += cArr[0];
    res[1] += cArr[1];
    res[2] += cArr[2];
    res[3] += cArr[3];
  }
  res[0] /= size;
  res[1] /= size;
  res[2] /= size;
  res[3] /= size;
  return color(res[1], res[2], res[3], res[0]);
}

String select_brush(Tile tile, int i, int j) {
  String repr;
  if (tile != null) {
    color[] colorArray = new color[]{colorMap[i][j], 0, 0, 0, 0};
    int count = 1;
    if (0 < i)
      colorArray[count++] = colorMap[i-1][j];
    if (i < N - 1)
      colorArray[count++] = colorMap[i+1][j];
    if (0 < j)
      colorArray[count++] = colorMap[i][j-1];
    if (j < M - 1)
      colorArray[count++] = colorMap[i][j+1];
    count--;
    fill(avg_color(colorArray, count));
    repr = tile.repr;
  } else {
    fill(10, 0, 0);
    repr = "░";
  }
  return repr;
}


void draw() {
  background(0, 0, 100);
  textFont(font);
  textSize(44);
  
  Tile tile;
  String tileName;
  String repr;
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < M; j++) {
      tile = wfc.collapsedWave[i][j];
      repr = select_brush(tile, i, j);
      text(repr, TILE_SIZE * j, TILE_SIZE * (i + 1));
    }
  }
  wfc.collapse_step();
  //delay(1);
  gifExport.addFrame();
}


void mousePressed() {
    gifExport.finish();          // write file
}
