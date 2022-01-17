import peasy.PeasyCam;

PeasyCam cam;

int s = 6;

int[][] cache;

void setup() {
  size(800, 800, P3D);
  cam = new PeasyCam(this, 400);

  cache = new int[s][s];
  for (int i = 0; i < s; i++) {
    cache[i][0] = 1;
    cache[0][i] = 1;
  }
  for (int i = 1; i < s; i++) {
    for (int j = 1; j < s; j++) {
      cache[i][j] = cache[i][j-1] + cache[i-1][j];
    }
  }


  // print triangle
  for (int i = 0; i < s; i++) {
    for (int j = 0; j < s; j++) {
      print(f(cache[i][j]), " ");
    }
    println();
  }

  // print prev height
  for (int i = 0; i < s; i++) {
    for (int j = 0; j < s; j++) {
      float prev = 0;
      if (i != 0 && j != 0) {
        int cp = min(cache[i-1][j], cache[i][j-1]);
        prev = max(0, f(cp)-1);
      }
      print(f(cache[i][j]) - prev, " ");
    }
    println();
  }
}

float f(int x) {
  return pow(x, 0.5);
}

void draw() {
  background(51);
  
  // wood to work with : 120
  float woodTotal = 0;
  
  for (int i = 0; i < s; i++) {
    for (int j = 0; j < s; j++) {
      fill(100);
      if (cache[i][j] %2 == 0) {
        fill(250);
      }

      // find delta below
      int prev = 0;
      if (i != 0 && j != 0) {
        prev = min(cache[i-1][j], cache[i][j-1]);
      }
      
      // normalize
      float zp = max(0, f(prev)-1);
      float z = f(cache[i][j]);
      woodTotal += z - zp;
      
      drawBox(i, j, zp, z);
    }
  }
  
  println(woodTotal);
}


int choose(long total, long choose) {
  if (total < choose)
    return 0;
  if (choose == 0 || choose == total)
    return 1;
  return choose(total-1, choose-1)+choose(total-1, choose);
}


void drawBox(int x, int y, float zp, float z) {
  float size = 50;


  pushMatrix();
  translate(x*size, y*size, size*(zp+z)/2);
  //translate(0,0,yb);
  box(size, size, size*(z-zp));
  popMatrix();
}
