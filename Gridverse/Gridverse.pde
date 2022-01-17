import peasy.PeasyCam;
PeasyCam cam;

boolean viewCamera = false;

Node[][] nodes;

Photon photon;
Mass mass;

Camera camera;

int displayDis = 10;


void setup() {
  size(1200, 1000, P3D);

  rectMode(CORNERS);
  cam = new PeasyCam(this, 400);

  //setupCylinder();
  //setupMobiusStrip();
    
  //setupTorus();
  //setupKlein();
  //setupProjectivePlane();
  
  //setupCone();
  setupSphere();
  //setupBump();
  
  //setupTardis();

  // random stuff for testing
  photon = new Photon(nodes[0][0], new PVector(0.1, 0.8), color(10, 100, 200));  // velocity should be around mag of 1, probably less
  mass = new Mass(nodes[5][5], new PVector(0.4, -0.2), color(200, 230, 230), 3);

  camera = new Camera(nodes[5][5], new PVector(2, 0)); // set move vec to different magnatude to make world "smalledr" or "bigger"
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

// to keep track of key presses
boolean[] keys = new boolean[4];
void keyPressed() {
  if (keyPressed && key == CODED) {
    if (keyCode == ALT) {
      viewCamera = !viewCamera;
      println("switching view");
    }

    if (keyCode == UP) {
      keys[0] = true;
    } else if (keyCode == DOWN) {
      keys[1] = true;
    } else if (keyCode == LEFT) {
      keys[2] = true;
    } else if (keyCode == RIGHT) {
      keys[3] = true;
    }
  }
}

void keyReleased() {    
  if (keyCode == UP) {
    keys[0] = false;
  } else if (keyCode == DOWN) {
    keys[1] = false;
  } else if (keyCode == LEFT) {
    keys[2] = false;
  } else if (keyCode == RIGHT) {
    keys[3] = false;
  }
}
