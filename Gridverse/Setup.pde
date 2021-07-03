
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


      if (i > nodes.length*2/3 && i < nodes.length*4/5 && j > nodes[i].length*2/3 && j < nodes[i].length) {
        Mass newMass = new Mass(nodes[i][j], new PVector(0, 0), color(200, 100, 100));
      }
      if (i > nodes.length/3 && i < nodes.length/2 && j > nodes[i].length/2 && j < nodes[i].length*4/5) {
        Mass newMass = new Mass(nodes[i][j], new PVector(0, 0), color(200, 100, 200));
      }
    }
  }
}

void setupMobiusStrip() {
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
      if (i > 0) {
        nodes[i][j].addEdge(PVector.fromAngle( PI), nodes[i - 1][j], false);
      } 
      if (i < nodes.length-1) {
        nodes[i][j].addEdge(PVector.fromAngle(0), nodes[i + 1][j], false);
      } 
      if (i == 0) {
        nodes[i][j].addEdge(PVector.fromAngle( PI), nodes[nodes.length - 1][nodes[i].length - j - 1], true);
      } 
      if (i == nodes.length-1) {
        nodes[i][j].addEdge(PVector.fromAngle(0), nodes[0][nodes[i].length - j - 1], true);
      }

      if (j > 0) {
        nodes[i][j].addEdge(PVector.fromAngle( - PI / 2), nodes[i][j - 1], false);
      } 
      if (j < nodes[i].length-1) {
        nodes[i][j].addEdge(PVector.fromAngle(PI / 2), nodes[i][j + 1], false);
      } 
      //else if (j == 0) {
      //  nodes[i][j].addEdge(PVector.fromAngle( - PI / 2), nodes[i][j - 1], true);
      //} else if (j == nodes[i].length-1) {
      //  nodes[i][j].addEdge(PVector.fromAngle(PI / 2), nodes[i][j + 1], true);
      //}

            if (i > nodes.length*0.5 && i < nodes.length*0.8 && j > nodes[i].length*0.1 && j < nodes[i].length*0.2) {
        Mass newMass = new Mass(nodes[i][j], new PVector(0, 0), color(200, 100, 200));
      }
      if (i > nodes.length*0.2 && i < nodes.length*0.25 && j > nodes[i].length*0.7 && j < nodes[i].length*0.8) {
        Mass newMass = new Mass(nodes[i][j], new PVector(0, 0), color(20, 100, 20));
      }
      if (j == 0 || j == nodes[j].length-1) {
        Mass newMass = new Mass(nodes[i][j], new PVector(0, 0), color(100, 100, 200));
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
        z = exp(-1.0/(1-r*r))*nodes.length*displayDis*radius/2;
      }


      nodes[i][j] = new Node(x, y, z);

      if (i == 0 || i == nodes.length-1 || j == 0 || j == nodes[i].length - 1) {
        color col = color(200, 100, 100);
        if (i/4 %2 == 0 ) {
          col = color(100, 200, 100);
        }
        Mass newMass = new Mass(nodes[i][j], new PVector(0, 0), col);
      }
    }
  }

  generateEdgesFor3DEmbedding(displayDis*1.5-1);
}

void setupCylinder() {
  nodes = new Node[100][50];

  // init nodes first
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      float angle = (TWO_PI * i) / nodes.length;
      float x = sin(angle) * nodes.length*displayDis/TWO_PI;
      float y = cos(angle)* nodes.length*displayDis/TWO_PI;
      float z = (j - nodes[i].length/2) * displayDis;
      nodes[i][j] = new Node(x, y, z);

      if (j == 0 || j == nodes[i].length - 1) {
        color col = color(200, 100, 100);
        if (i/4 %2 == 0 ) {
          col = color(100, 200, 100);
        }
        Mass newMass = new Mass(nodes[i][j], new PVector(0, 0), col);
      }
    }
  }
  // then add edges
  generateEdgesFor3DEmbedding(displayDis+1);
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
        Mass newMass = new Mass(nodes[i][j], new PVector(0, 0), color(90, 10, 150));
      }
      if (theta > PI*4/3 && y > 0.5 && y < 0.7) {
        Mass newMass = new Mass(nodes[i][j], new PVector(0, 0), color(200, 10, 50));
      }
    }
  }

  // then add edges
  generateEdgesFor3DEmbedding(displayDis*5);
}
