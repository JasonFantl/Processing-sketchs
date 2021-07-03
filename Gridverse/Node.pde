class Edge {
  PVector connection;
  boolean flipped;
  Node to;

  Edge(PVector _connection, Node node, boolean _flipped) {
    connection = _connection;
    to = node;
    flipped = _flipped;
  }
}

class Node {

  Edge[] edges;
  ArrayList<Mass> masses;

  PVector displayPos;

  Node(float x, float y, float z) {
    masses = new ArrayList<Mass>();

    displayPos = new PVector(x, y, z);
    edges = new Edge[0];
  }

  boolean solid() {
    return !masses.isEmpty();
  }
  color col() {
    if (solid()) {
      return masses.get(0).col;
    }
    return color(0, 0, 0);
  }

  void addEdge(PVector connection, Node node, boolean flipped) {
    Edge[] newEdges = new Edge[edges.length + 1];
    newEdges[0] = new Edge(connection, node, flipped);
    for (int i = 0; i < edges.length; i++) {
      newEdges[i + 1] = edges[i];
    }

    edges = newEdges;
  } 

  void displayNode() {
    stroke(100, 100, 100, 100);
    strokeWeight(10);
    if (solid()) {
      stroke(masses.get(0).col, 255);
    }
    point(displayPos.x, displayPos.y, displayPos.z);

    boolean invalid  =false;
    //debugging
    for (Edge edgeOut : edges) {
      boolean connected = false;
      for (Edge edgeIn : edgeOut.to.edges) {
        if (edgeIn.to == this) {
          connected = true;
        }
      }
      if (!connected) {
        invalid = true;
      }
    }

    if (invalid) {
      strokeWeight(20);
      stroke(255, 100, 100);
      point(displayPos.x, displayPos.y, displayPos.z);
    }
  }

  void displayEdges() {
    strokeWeight(1);
    for (int i = 0; i < edges.length; i++) {
      stroke(200, 200, 200, 100);
      if (edges[i].flipped) {
        stroke(10, 20, 150);
      }
      if (displayPos.dist(edges[i].to.displayPos) < 200) {
        line(displayPos.x, displayPos.y, displayPos.z, edges[i].to.displayPos.x, edges[i].to.displayPos.y, edges[i].to.displayPos.z);
      }
    }
  }
}
