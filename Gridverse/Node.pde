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
  
  boolean solid;
  color col;
  
  PVector displayPos;
  
  Node(float x, float y) {
    displayPos = new PVector(x, y);
    edges = new Edge[0];
  }
  
  Node(boolean _solid, color _col, float x, float y, float z) {
    solid = _solid;
    col = _col;
    
    displayPos = new PVector(x, y, z);
    edges = new Edge[0];
  }
  
    Node(float x, float y, float z) {
    solid = false;
    col = color(0,0,0);
    
    displayPos = new PVector(x, y, z);
    edges = new Edge[0];
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
    noStroke();
    fill(100, 100, 100, 100);
    if (solid) {
      fill(col);
    }
    
    // circle(displayPos.x, displayPos.y, displayDis/2);
    pushMatrix();
    translate(displayPos.x, displayPos.y, displayPos.z);
    sphere(displayDis / 4);
    popMatrix();
  }
  
  void displayEdges() {
    stroke(150);
    strokeWeight(1);
    for (int i = 0; i < edges.length; i++) {
      stroke(200, 200, 200);
      if (edges[i].flipped) {
       stroke(10, 20, 150); 
      }
      if (displayPos.dist(edges[i].to.displayPos) < 200) {
      // line(displayPos.x, displayPos.y, edges[i].to.displayPos.x, edges[i].to.displayPos.y);
      line(displayPos.x, displayPos.y, displayPos.z, edges[i].to.displayPos.x, edges[i].to.displayPos.y, edges[i].to.displayPos.z);
    }
    }
  }
}
