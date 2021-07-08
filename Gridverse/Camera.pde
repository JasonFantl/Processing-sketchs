
class Camera {
  PVector moveDelta;

  Mass mass; // well also use mass to keep track of position

  Camera(Node startNode, PVector _moveDelta) {
    mass = new Mass(startNode, new PVector(0, 0), color(200, 200, 100), 2);
    moveDelta = _moveDelta;
  }




  void move() {
    if (keys[0]) {
      mass.position.desired.add(moveDelta);
    } 
    if (keys[1]) {
      mass.position.desired.sub(moveDelta);
    }
    if (keys[2]) {
      moveDelta.rotate(-PI/100);
    } 
    if (keys[3]) {
      moveDelta.rotate(PI/100);
    }

    mass.move();
  }

  void takePicture() {
    cam.beginHUD();

    // draw ground and sky
    fill(100, 100, 100);
    rect(0, 0, width, height/2);
    fill(50, 50, 50);
    rect(0, height/2, width, height);

    int pixelCount = 200;
    for (int i = 0; i < pixelCount; i++) {
      // camera settings
      float screenDis = 100;
      float screenRadius = 50;

      float screenX = (float(i*2)/(pixelCount-1)-1)*screenRadius;
      float angle = atan2(screenX, screenDis);

      // TODO
      // need the offset of desired and curent to match in photons, cylander setup shows the issue
      PVector dir = moveDelta.copy().rotate(angle).normalize();
      Photon photon = new Photon(mass.position.node, dir, color(0, 0, 0));
      photon.position.orientation = mass.position.orientation;
      photon.position.flipped = mass.position.flipped;
      photon.position.desired = mass.position.desired.copy();

      photon.forceMove(); // take a step so our own body doesnt block
      photon.forceMove(); // take a step so our own body doesnt block
      photon.forceMove(); // take a step so our own body doesnt block

      color col = color(0, 0, 0);

      int timeout = 1000;
      int viewDistance = 1000;
      int counter = 0;
      while (photon.traveled < viewDistance && counter < timeout) {
        if (photon.position.node.solid()) {
          col = photon.position.node.col();
          break;
        }
        photon.move();
        counter++;
      }

      // apply projection distance so we dont get fisheye effect
      // ok, so. Close up to a wall, many photons end on the same node, but since the nodes arrive at different angles, we get the cos(angle) messes up the height
      float dis = photon.traveled*cos(angle);

      noStroke();

      if (photon.position.node.solid()) {
        float shadingDis = 2*moveDelta.mag();
        float shading = shadingDis/sqrt(dis);
        col = color(red(col)*shading, green(col)*shading, blue(col)*shading);
        fill(col);
        float w = float(width)/pixelCount;
        float x = i*w;
        float y =  5*height/dis;
        rect(x, height/2 -y, x+w, height/2+y);
      }
    }

    cam.endHUD();
  }

  void display() {
    // get direction
    PVector dir = moveDelta.copy().normalize();
    Photon photon = new Photon(mass.position.node, dir, color(0, 0, 0));
    photon.position.orientation = mass.position.orientation;
    photon.position.flipped = mass.position.flipped;

    for (int i = 0; i < 10; i++) {
      photon.forceMove();
      photon.display();
    }
  }
}
