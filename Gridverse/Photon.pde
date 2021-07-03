class Photon {

  Position position;
  PVector velocity; // velocity of desired
  float traveled;
  color col;

  Photon(Node startNode, PVector vel, color _col) {
    position = new Position(startNode, new float[][]{{1, 0}, {0, 1}}, false);
    velocity = vel;
    col = _col;
    traveled = 0.0;
  }

  void move() {
    // stop moving when we hit a solid object
    if (!position.node.solid()) {
      position.desired.add(velocity);
            traveled += velocity.mag();
      position = position.move();
    }
  }
  
  void forceMove() {
      position.desired.add(velocity);
      traveled += velocity.mag();
      position = position.move();
  }

  void display() {
    strokeWeight(10);
    stroke(col);
    PVector pos = position.node.displayPos;
    point(pos.x, pos.y, pos.z);
  }
}
