class Mass {

  Position position;
  PVector velocity; // velocity of desired
  color col;
  
  Mass(Node startNode, PVector vel, color _col) {
    startNode.masses.add(this);
    position = new Position(startNode, new float[][]{{1, 0}, {0, 1}}, false);
    velocity = vel;
        col = _col;
  }

  void move() {
    // remove self from the nodes masses list
    position.node.masses.remove(this);

      position.desired.add(velocity);
      position = position.move();

    // add self to new nodes masses
    position.node.masses.add(this);
  }

  void display() {
    strokeWeight(10);
    stroke(col);
    PVector pos = position.node.displayPos;
    point(pos.x, pos.y, pos.z);
  }
}
