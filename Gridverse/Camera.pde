
class Camera {
  Node location;

  PVector desired;
  PVector current;
  float[][] orientation; // for easy transformation
  boolean flipped; // not necessary, orientation keeps track of this, but makes it conceptual easier

  PVector moveDelta;

  Camera(Node startNode, PVector _moveDelta) {
    location = startNode;
    moveDelta = _moveDelta;
    desired = new PVector(0, 0);
    current = new PVector(0, 0);
    orientation = new float[][]{{1, 0}, {0, 1}}; // start by facing "forward", "forward" being for the start node
    flipped = false;
  }




  void move() {
    if (keyPressed && key == CODED) {
      if (keyCode == UP) {
        desired.add(moveDelta);
      } else if (keyCode == DOWN) {
        desired.sub(moveDelta);
      } else if (keyCode == LEFT) {
        moveDelta.rotate(-PI/32);
      } else if (keyCode == RIGHT) {
        moveDelta.rotate(PI/32);
      }
    }

    while (true) {
      Edge outEdge = null;
      PVector outVector = null;
      PVector bestNextPos = current;

      for (int i = 0; i < location.edges.length; i++) {
        PVector rotatedEdge = applyMatrix(orientation, location.edges[i].connection);
        PVector nextPos = PVector.add(current, rotatedEdge);
        if (PVector.dist(nextPos, desired) < PVector.dist(bestNextPos, desired)) {
          outEdge = location.edges[i];
          bestNextPos = nextPos;
          outVector = rotatedEdge;
        }
      }

      if (outEdge  != null) {
        // get angle into next node
        PVector inVector = null; // every edge should have an inverse edge
        for (int i = 0; i < outEdge.to.edges.length; i++) {
          if (outEdge.to.edges[i].to == location) {
            inVector = outEdge.to.edges[i].connection;
          }
        }


        if (outEdge.flipped) {
          flipped = !flipped;
        }

        // match inEdge to orientation
        PVector delta = inVector;
        if (!flipped) {
          delta = inverseAngle(delta);
        }
        PVector rotationDelta = rotateVector(PVector.mult(outVector, -1), delta);
        orientation = matrixXTo(rotationDelta, flipped);

        location = outEdge.to;
        current = bestNextPos;
      } else {
        break;
      }
    }
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

      PVector dir = moveDelta.copy().rotate(angle).normalize();
      Photon photon = new Photon(location, dir);
      photon.orientation = orientation;
      photon.flipped = flipped;

      color col = color(0, 0, 0);

      int timeout = 100000;
      int viewDistance = 5000;
      int counter = 0;
      while (photon.current.mag() < viewDistance && counter < timeout) {
        if (photon.location.solid) {
          col = photon.location.col;
          break;
        }
        photon.move();
        counter++;
      }

      // apply projection distance so we dont get fisheye effect
      // ok, so. Cloe up to a wall, many photons end on the same node, but since the nodes arrive at different angles, we get the cos(angle) messes up the height
      float dis = photon.current.mag()*cos(angle);

      noStroke();

      if (photon.location.solid) {
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
    point(camera.location.displayPos.x, camera.location.displayPos.y, camera.location.displayPos.z);

    // get direction
    PVector dir = moveDelta.copy().normalize();
    Photon photon = new Photon(location, dir);
    photon.orientation = orientation;
    photon.flipped = flipped;

    for (int i = 0; i < 10; i++) {
      photon.move();
      photon.display();
    }
  }
}
