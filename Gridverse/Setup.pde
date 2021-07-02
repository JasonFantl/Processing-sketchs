
void setupEuclidianTorus() {
  nodes = new Node[100][100];

  // init nodes first
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      nodes[i][j] = new Node((i-nodes.length/2) * displayDis, (j-nodes[i].length/2) * displayDis, 0);
    }
  }
  // then add edges
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      float angle = 0;
      //angle = int(random(4)) * PI / 2;
      nodes[i][j].addEdge(PVector.fromAngle(angle), nodes[mod(i + 1, nodes.length)][j], false);
      nodes[i][j].addEdge(PVector.fromAngle(angle + PI), nodes[mod(i - 1, nodes.length)][j], false);
      nodes[i][j].addEdge(PVector.fromAngle(angle + PI / 2), nodes[i][mod(j + 1, nodes[i].length)], false);
      nodes[i][j].addEdge(PVector.fromAngle(angle - PI / 2), nodes[i][mod(j - 1, nodes[i].length)], false);
    }
  }
  
  // set solid state
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      boolean solid = false;
      color col = color(100, 100, 100, 100);
      if (i > nodes.length*2/3 && i < nodes.length*4/5 && j > nodes[i].length*2/3 && j < nodes[i].length) {
        solid = true;
        col = color(200, 100, 100);
      }
      if (i > nodes.length/3 && i < nodes.length/2 && j > nodes[i].length/2 && j < nodes[i].length*4/5) {
        solid = true;
        col = color(200, 100, 200);
      }

      if (solid) {
        nodes[i][j].col = col;
        nodes[i][j].solid = true;
      }
    }
  }
}

void setupBump() {
  // init nodes first
  nodes = new Node[100][100];

  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      // get x, y, z
      float x = (i - nodes.length/2) * displayDis;
      float y = (j - nodes[i].length/2) * displayDis;

      float x2 = (float(i)*2.0/nodes.length - 1.0);
      float y2 = (float(j)*2.0/nodes[i].length - 1.0);
      float r = pow(x2*x2+y2*y2, 0.5);
      float z = 0.0;

      float radius = 0.5;
      if (r < radius) {
        r /= radius;
        z = exp(-1.0/(1-r*r))*nodes.length*displayDis*radius;
      }


      nodes[i][j] = new Node(x, y, z);
      
      if (i == 0 || i == nodes.length-1 || j == 0 || j == nodes[i].length - 1) {
        nodes[i][j].solid = true;
        nodes[i][j].col = color(200, 10, 50);
      }
    }
  }

  generateEdgesFor3DEmbedding(displayDis*2);
}


void setup3DGrid() {
  nodes = new Node[20][20];

  // init nodes first
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      float x2 = (i - nodes.length/2) * displayDis;
      float y2 = (j - nodes[i].length/2) * displayDis;
      // M =  [  2  3  ]
      //      [  -1 0  ]
      //      [  4  -2 ]
      float x = 2*x2 + 3 * y2;
      float y = -1*x2 + 0*y2;
      float z = 4*x2 - 2*y2;
      nodes[i][j] = new Node(x, y, z);
    }
  }
  // then add edges
  generateEdgesFor3DEmbedding(displayDis*5);
}

void setupCylinder() {
  nodes = new Node[35][20];

  // init nodes first
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      float angle = (TWO_PI * i) / nodes.length;
      float x = sin(angle) * nodes.length*displayDis/TWO_PI;
      float y = cos(angle)* nodes.length*displayDis/TWO_PI;
      float z = (j - nodes[i].length/2) * displayDis;
      nodes[i][j] = new Node(x, y, z);
    }
  }
  // then add edges
  generateEdgesFor3DEmbedding(displayDis+1);
}


void setupRandom() {
  nodes = new Node[35][35];

  // init nodes first
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      nodes[i][j] = new Node(random(width), random(height), 0);
    }
  }

  // seperate nodes
  for (int u = 0; u < 40; u++) {
    for (int i = 0; i < nodes.length; i++) {
      for (int j = 0; j < nodes[i].length; j++) {
        // get closest
        PVector closest = null;
        for (int k = 0; k < nodes.length; k++) {
          for (int l = 0; l < nodes[k].length; l++) {
            if (i != k || j != l) {
              if (closest == null || PVector.dist(nodes[i][j].displayPos, nodes[k][l].displayPos) < PVector.dist(nodes[i][j].displayPos, closest)) {
                closest = nodes[k][l].displayPos;
              }
            }
          }
        }

        nodes[i][j].displayPos.add(PVector.sub(nodes[i][j].displayPos, closest).normalize());
      }
    }
  }

  // then add edges
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      // check for all withen radius
      float radius = 50.0;
      for (int k = 0; k < nodes.length; k++) {
        for (int l = 0; l < nodes[k].length; l++) {
          boolean inRadius = PVector.dist(nodes[i][j].displayPos, nodes[k][l].displayPos) < radius;
          if ((i != k || j != l) && inRadius) {
            PVector delta = PVector.sub(nodes[i][j].displayPos, nodes[k][l].displayPos);
            nodes[i][j].addEdge(delta, nodes[k][l], false);
          }
        }
      }
    }
  }
}


void setupSphere() {
  nodes = new Node[100][100];

  // generate points using fibinacchi point placing

  float radius = displayDis*100;

  float phi = 2.39996322972865332; // the golden angle
  int samples = nodes.length * nodes.length;

  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      int n = i * nodes.length + j;

      float y = 1 - (n / float(samples - 1)) * 2;
      float yradius = sqrt(1 - y * y);

      float theta = (phi * n) % TWO_PI;

      float x = cos(theta) * yradius;
      float z = sin(theta) * yradius;

      nodes[i][j] = new Node(x * radius, y * radius, z * radius);
      
      if (y > 0.9) {
       nodes[i][j].solid = true;
       nodes[i][j].col = color(90, 10, 150);
      }
      //if (theta > PI*4/3 && y > 0.5) {
      // nodes[i][j].solid = true;
      // nodes[i][j].col = color(200, 10, 50);
      //}
    }
  }

  // then add edges
  generateEdgesFor3DEmbedding(displayDis*5);
}
