class Photon {

  Node location;

  PVector velocity; // velocity of desired
  PVector desired;
  PVector current; // to keep track of delta from desired
  float[][] orientation; // for easy transformation
  boolean flipped; // not necessary, orientation keeps track of this, but makes it conceptual easier
  
  Photon(Node startNode, PVector vel) {
    location = startNode;
    velocity = vel;
    desired = new PVector(0, 0);
    current = new PVector(0, 0);
    orientation = new float[][]{{1, 0}, {0, 1}}; // start by facing "forward", "forward" being for the start node
    flipped = false;
  }

  void move() {
    if (location.solid) {
      return;
    }
    
    desired.add(velocity);


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
    }
  }

  PVector inverseAngle(PVector in) {
    return new PVector(in.x, -in.y);
  }

  PVector rotateVector(PVector toRotate, PVector rotation) {
    rotation = rotation.normalize();
    // Construct rotation matrix
    // M =  [  rotation.x  -rotation.y  ]
    //      [  rotation.y  rotation.x  ]
    // then left multiply to toRotate to get result
    PVector multiplied = new PVector(rotation.x * toRotate.x - rotation.y * toRotate.y, rotation.y * toRotate.x + rotation.x * toRotate.y);
    return multiplied.normalize();
  }

  PVector applyMatrix(float[][] matrix, PVector vector) {
    float x = matrix[0][0]*vector.x + matrix[0][1]*vector.y;
    float y = matrix[1][0]*vector.x + matrix[1][1]*vector.y;

    return new PVector(x, y);
  }

  float[][] multMatrix(float[][] m1, float[][] m2) {
    float[] xRow = {m1[0][0]*m2[0][0] + m1[0][1]*m2[1][0], m1[0][0]*m2[0][1] + m1[0][1]*m2[1][1]};
    float[] yRow = {m1[1][0]*m2[0][0] + m1[1][1]*m2[1][0], m1[1][0]*m2[0][1] + m1[1][1]*m2[1][1]};
    return new float[][]{xRow, yRow};
  }

  float[][] matrixXTo(PVector dir, boolean flip) {
    // Construct identity matrix
    float[] Ix = {1, 0};
    float[] Iy = {0, 1};
    if (flip) { 
      Iy[1] = -1;
    }
    float[][] I = {Ix, Iy};


    // Construct rotation matrix
    // rotates x axis to match vector
    // M =  [  rotation.x  -rotation.y  ]
    //      [  rotation.y  rotation.x  ]
    //float[][] rotationMatrix = {{dir.y, dir.x}, {-dir.x, dir.y}};
    float[][] rotationMatrix = {{dir.x, -dir.y}, {dir.y, dir.x}};

    return multMatrix(rotationMatrix, I);
  }

  void display() {

    noStroke();
    fill(100, 100, 250);
    if (location.solid) {
      fill(200, 200, 250);
    }
    // circle(location.displayPos.x, location.displayPos.y, displayDis/2);
    pushMatrix();
    translate(location.displayPos.x, location.displayPos.y, location.displayPos.z);
    sphere(displayDis);
    popMatrix();
  }


  void printArray(float[][] arr) {
    for (int i = 0; i < arr.length; i++) {
      for (int j = 0; j < arr[i].length; j++) {
        if (abs(arr[i][j]) < 0.0001) {
          print("0.0", " ");
        } else {
          print(arr[i][j], " ");
        }
      } 
      println();
    }
  }


  void printVector(PVector vec) {
    printArray(new float[][]{vec.array()});
  }
}
