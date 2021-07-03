class Mass {

  Position position;
  PVector velocity; // velocity of desired
  color col;
  int radius;


  Mass(Node startNode, PVector vel, color _col) {
    position = new Position(startNode, new float[][]{{1, 0}, {0, 1}}, false);
    velocity = vel;
    col = _col;
    radius = 1;
    for (Node node : breadthSearch(startNode, radius)) {
      node.masses.add(this);
    }
  }

  Mass(Node startNode, PVector vel, color _col, int _radius) {
    position = new Position(startNode, new float[][]{{1, 0}, {0, 1}}, false);
    velocity = vel;
    col = _col;
    radius = _radius;
    for (Node node : breadthSearch(startNode, radius)) {
      node.masses.add(this);
    }
  }

  void move() {
    // remove self from the all nodes masses list
    for (Node node : breadthSearch(position.node, radius)) {
      node.masses.remove(this);
    }

    position.desired.add(velocity);
    position = position.move();

    // add self to new nodes masses
    for (Node node : breadthSearch(position.node, radius)) {
      node.masses.add(this);
    }
  }

  void display() {
    strokeWeight(10);
    stroke(col);
    PVector pos = position.node.displayPos;
    point(pos.x, pos.y, pos.z);
  }
}


ArrayList<Node> breadthSearch(Node start, int depth) {
  ArrayList<Node> nodes = new ArrayList<Node>();
  ArrayList<Node> horizon = new ArrayList<Node>();
  horizon.add(start);

  while (!horizon.isEmpty() && depth > 0) {
    ArrayList<Node> newHorizon = new ArrayList<Node>();
    for (Node node : horizon) {
      if (!nodes.contains(node)) {
        nodes.add(node);
        for (int i = 0; i < node.edges.length; i++) {
          newHorizon.add(node.edges[i].to);
        }
      }
    }
    horizon = newHorizon;
    depth--;
  }

  return nodes;
}
