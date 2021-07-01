import peasy.PeasyCam;
PeasyCam cam;

Node[][] nodes;
Photon[] photons;

int displayDis = 30;

void setup() {
  //size(600, 600, P3D);
  size(600, 600);

  cam = new PeasyCam(this, 400);

  rectMode(CORNERS);

  // nodes should be approximatly 1 distance apart
  setupEuclidianTorus();
  //setupBump();
  //setupRandom();
  //setupSphere();
  //setup3DGrid();
  //setupCylinder();


  // setup solids, depends on the setup
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

  // create photons
  photons = new Photon[20];
  for (int i = 0; i < photons.length; i++) {
    photons[i] = new Photon(nodes[i][0], new PVector(0.5, 0.8));  // velocity should be around mag of 1, probably less
  }

}

int mod(int a, int b) {
  int c = a % b;
  if (c < 0) {
    return b + c;
  }
  return c;
}

PVector pmod(PVector vec, int m, int n) {
  return new PVector(mod(int(vec.x), m), mod(int(vec.y), n));
}

PVector camPos = new PVector(0, 0);
float camRot = 0;
float moveMag = 10;

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      camPos.add(PVector.fromAngle(camRot).mult(moveMag));
    } else if (keyCode == DOWN) {
      camPos.sub(PVector.fromAngle(camRot).mult(moveMag));
    } else if (keyCode == LEFT) {
            camRot -= PI/16;
    } else if (keyCode == RIGHT) {
      camRot += PI/16;
    } 
  }
}

void draw() {
    takePicture(camPos, camRot);

  //// translate( - width / 2, -height / 2);
  //background(51);
  //lights();

  //for (int i = 0; i < nodes.length; i++) {
  //  for (int j = 0; j < nodes[i].length; j++) {
  //    nodes[i][j].displayNode();
  //    nodes[i][j].displayEdges();
  //  }
  //}

  //for (int i = 0; i < photons.length; i++) {

  //  photons[i].move();
  //  photons[i].display();
  //}
}
