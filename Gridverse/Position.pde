
class Position {

  Node node;

  PVector desired;
  float[][] orientation; // for easy transformation
  boolean flipped; // not necessary, orientation keeps track of this, but makes it conceptual easier

  Position(Node _node, float[][] _orientation, boolean _flipped) {
    node = _node;
    orientation = _orientation;
    flipped = _flipped;
    desired = new PVector(0, 0);
  }


  Position move() {
    Position newPos = this;
            Position oldPos ;
    // step until we dont move to a new node
    do {
      oldPos = newPos;
      newPos = oldPos.step();
    } while (newPos.node != oldPos.node);
    return newPos;
  }

  Position step() {
    // setup a copy of the current pos
    Position newPos = new Position(node, orientation, flipped);
    newPos.desired = desired.copy();

    Edge outEdge = null;
    PVector outVector = null;
    PVector bestNextPos = new PVector(0,0);

    for (int i = 0; i < node.edges.length; i++) {
      PVector rotatedEdge = applyMatrix(orientation, node.edges[i].connection);
      if (PVector.dist(rotatedEdge, desired) < PVector.dist(bestNextPos, desired)) {
        outEdge = node.edges[i];
        bestNextPos = rotatedEdge;
        outVector = rotatedEdge;
      }
    }

    if (outEdge  != null) {
      // get angle into next node
      PVector inVector = null; // every edge should have an inverse edge
      for (int i = 0; i < outEdge.to.edges.length; i++) {
        if (outEdge.to.edges[i].to == node) {
          inVector = outEdge.to.edges[i].connection;
        }
      }


      if (outEdge.flipped) {
        newPos.flipped = !newPos.flipped;
      }

      // match inEdge to orientation
      PVector delta = inVector;
      if (!newPos.flipped) {
        delta = inverseAngle(delta);
      }
      PVector rotationDelta = rotateVector(PVector.mult(outVector, -1), delta);
      newPos.orientation = matrixXTo(rotationDelta, newPos.flipped);

      newPos.node = outEdge.to;
      newPos.desired = PVector.sub(desired, outVector);
    }
    return newPos;
  }
}


// helpful math functions

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
