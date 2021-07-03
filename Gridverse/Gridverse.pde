import peasy.PeasyCam;
PeasyCam cam;

boolean viewCamera = false;

Node[][] nodes;

Photon photon;
Mass mass;

Camera camera;

int displayDis = 10;


void setup() {
  size(900, 800, P3D);

  rectMode(CORNERS);
  cam = new PeasyCam(this, 400);


  // nodes should be approximatly 1 distance apart
  //setupEuclidianTorus();
  //setupSphere();
  //setupBump();
  setupCylinder();

  // random stuff for testing
  photon = new Photon(nodes[0][0], new PVector(0.1, 0.8), color(10, 100, 200));  // velocity should be around mag of 1, probably less
  mass = new Mass(nodes[10][0], new PVector(0.4, -0.3), color(200, 230, 230));
  
  camera = new Camera(nodes[1][1], new PVector(0.5, 0));
}

void draw() {
  background(51);
  camera.move();
  photon.move();
  mass.move();

  if (viewCamera) {
    camera.takePicture();
  } else {
    for (int i = 0; i < nodes.length; i++) {
      for (int j = 0; j < nodes[i].length; j++) {
        nodes[i][j].displayNode();
        nodes[i][j].displayEdges();
      }
    }

    photon.display();
    camera.display();
  }
}

void keyPressed() {
  if (keyPressed && key == CODED) {
    if (keyCode == ALT) {
      viewCamera = !viewCamera;
      println("switching view");
    }
  }
}
