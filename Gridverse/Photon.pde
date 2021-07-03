class Photon {

  Position position;
  PVector velocity; // velocity of desired
  color col;

  Photon(Node startNode, PVector vel, color _col) {
    position = new Position(startNode, new float[][]{{1, 0}, {0, 1}}, false);
    velocity = vel;
    col = _col;
  }

  void move() {
    // stop moving when we hit a solid object
    if (!position.node.solid()) {
      position.desired.add(velocity);
      position = position.move();
    }
  }
  
  void forceMove() {
      position.desired.add(velocity);
      position = position.move();
  }

  void display() {
    strokeWeight(10);
    stroke(col);
    PVector pos = position.node.displayPos;
    point(pos.x, pos.y, pos.z);
  }
}
