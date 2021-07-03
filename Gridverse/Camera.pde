
class Camera {
  PVector moveDelta;

  Mass mass; // well also use mass to keep track of position

  Camera(Node startNode, PVector _moveDelta) {
    mass = new Mass(startNode, new PVector(0, 0), color(200, 200, 100));
    moveDelta = _moveDelta;
  }




  void move() {
    if (keyPressed && key == CODED) {
      if (keyCode == UP) {
        mass.position.desired.add(moveDelta);
      } else if (keyCode == DOWN) {
        mass.position.desired.sub(moveDelta);
      } else if (keyCode == LEFT) {
        moveDelta.rotate(-PI/64);
      } else if (keyCode == RIGHT) {
        moveDelta.rotate(PI/64);
      }
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
      photon.position.desired = PVector.sub(mass.position.desired, mass.position.current);
      photon.forceMove(); // take a ste so our own body doesnt block

      color col = color(0, 0, 0);

      int timeout = 1000;
      int viewDistance = 1000;
      int counter = 0;
      while (photon.position.current.mag() < viewDistance && counter < timeout) {
        if (photon.position.node.solid()) {
          col = photon.position.node.col();
          break;
        }
        photon.move();
        counter++;
      }

      // apply projection distance so we dont get fisheye effect
      // ok, so. Close up to a wall, many photons end on the same node, but since the nodes arrive at different angles, we get the cos(angle) messes up the height
      float dis = photon.position.current.mag()*cos(angle);

      noStroke();

      if (photon.position.node.solid()) {
        float shadingDis = moveDelta.mag()*30;
        col = color(red(col)/max(1, dis/shadingDis), green(col)/max(1, dis/shadingDis), blue(col)/max(1, dis/shadingDis));
        fill(col);
        float w = float(width)/pixelCount;
        float x = i*w;
        float y =  moveDelta.mag()*height/dis;
        rect(x, height/2 -y, x+w, height/2+y);
      }
    }

    cam.endHUD();
  }

  void display() {
    stroke(100, 200, 100);
    PVector pos = camera.mass.position.node.displayPos;
    point(pos.x, pos.y, pos.z);

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
