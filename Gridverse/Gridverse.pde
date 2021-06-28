import peasy.PeasyCam;
PeasyCam cam;

Node[][] nodes;
Photon photon;

int displayDis = 30;

void setup() {
  size(600, 600, P3D);
  cam = new PeasyCam(this, 400);
    
  // nodes should be approximatly 1 distance apart
   //setupEuclidianTorus();
   setupBump();
   //setupRandom();
  //setupSphere();
  //setup3DGrid();
  //setupCylinder();
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



void draw() {
  // translate( - width / 2, -height / 2);
  background(51);
  lights();
  
  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      nodes[i][j].displayNode();
      nodes[i][j].displayEdges();
    }
  }
  
  photon.move();
  photon.display();
}
