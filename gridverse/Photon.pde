class Photon {
  
  Node location;
  
  PVector velocity;
  PVector desired;
  PVector current;
  PVector orientation;
  
  Photon(Node startNode, PVector vel) {
    location = startNode;
    velocity = vel;
    desired = new PVector(0, 0);
    current = new PVector(0, 0);
    orientation = new PVector(0, 1); // start by facing "forward", "forward" being for the start node
  }
  
  void move() {
    desired.add(velocity);
    
    
    Edge outEdge = null;
    PVector outVector = null;
    PVector bestNextPos = current;
    
    for (int i = 0; i < location.edges.length; i++) {
      PVector rotatedEdge = rotateVector(location.edges[i].connection, orientation);
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
      
      
      // match inEdge to orientation
      orientation = rotateVector(PVector.mult(outVector, -1), new PVector( -inVector.x, inVector.y));
      
      
      location = outEdge.to;
      current = bestNextPos;
    }
  }
  
  PVector rotateVector(PVector toRotate, PVector rotation) {
    rotation = rotation.normalize();
    // Construct rotation matrix
    // M =  [  rotation.y   rotation.x  ]
    //      [  -rotation.x  rotation.y  ]
    // then left multiply to toRotate to get result
    PVector multiplied = new PVector(rotation.y * toRotate.x + rotation.x * toRotate.y, rotation.y * toRotate.y - rotation.x * toRotate.x);
    return multiplied.normalize();
  }
  
  void display() {
    
    noStroke();
    fill(100, 100, 250);
    // circle(location.displayPos.x, location.displayPos.y, displayDis/2);
    pushMatrix();
    translate(location.displayPos.x, location.displayPos.y, location.displayPos.z);
    sphere(displayDis);
    popMatrix();
  }
}
