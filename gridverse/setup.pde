
void setupEuclidianTorus() {
  // init nodes first
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      nodes[i][j] = new Node(i * displayDis, j * displayDis);
    }
  }
  // then add edges
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      float angle = 0;
      angle = int(random(4)) * PI / 2;
      nodes[i][j].addEdge(PVector.fromAngle(angle), nodes[mod(i + 1, nodes.length)][j]);
      nodes[i][j].addEdge(PVector.fromAngle(angle + PI), nodes[mod(i - 1, nodes.length)][j]);
      nodes[i][j].addEdge(PVector.fromAngle(angle + PI / 2), nodes[i][mod(j + 1, nodes[i].length)]);
      nodes[i][j].addEdge(PVector.fromAngle(angle - PI / 2), nodes[i][mod(j - 1, nodes[i].length)]);
    }
  }
}

void setup3DGrid() {
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
  // init nodes first
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      nodes[i][j] = new Node(random(width), random(height));
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
        nodes[i][j].displayPos = pmod(nodes[i][j].displayPos, width, height);
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
          inRadius |= PVector.dist(pmod(nodes[i][j].displayPos, width, height), nodes[k][l].displayPos) < radius;
          inRadius |= PVector.dist(nodes[i][j].displayPos, pmod(nodes[k][l].displayPos, width, height)) < radius;
          if ((i != k || j != l) && inRadius) {
            PVector delta = PVector.sub(nodes[i][j].displayPos, nodes[k][l].displayPos);
            nodes[i][j].addEdge(delta, nodes[k][l]);
          }
        }
      }
    }
  }
}


void setupSphere() {

  // generate points using fibinacchi point placing

  float radius = 500.0;

  float phi = 2.39996322972865332; // the golden angle
  int samples = nodes.length * nodes.length;

  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      int n = i * nodes.length + j;

      float y = 1 - (n / float(samples - 1)) * 2;
      float yradius = sqrt(1 - y * y);

      float theta = phi * n;

      float x = cos(theta) * yradius;
      float z = sin(theta) * yradius;

      nodes[i][j] = new Node(x * radius, y * radius, z * radius);
    }
  }

  // then add edges
  generateEdgesFor3DEmbedding(radius/2.5);
}
