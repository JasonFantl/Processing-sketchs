

// might be a bit off, need to test plane and projection code
void generateEdgesFor3DEmbedding(float radius) {

  PVector [][][] planes = new PVector[nodes.length][][];

  // pre-calc planes of each node
  for (int i = 0; i < nodes.length; i++) {
    planes[i] = new PVector[nodes[i].length][4];
    for (int j = 0; j < nodes[i].length; j++) {
      ArrayList<Node> nearNodes = getNearbyNodes(nodes[i][j], radius);
      planes[i][j] = bestFitPlane(nodes[i][j], nearNodes);
    }
  }

  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < nodes[i].length; j++) {
      Node node = nodes[i][j];
      PVector[] plane = planes[i][j];

      for (int k = 0; k < nodes.length; k++) {
        for (int l = 0; l < nodes[k].length; l++) {
          Node otherNode = nodes[k][l];
          PVector[] otherPlane = planes[k][l];

          boolean inRadius = PVector.dist(node.displayPos, otherNode.displayPos) < radius;
          if (node != otherNode && inRadius) {

            // generate edges by projecting onto the plane
            // https://math.stackexchange.com/questions/3763054/projecting-3d-points-onto-2d-coordinate-system-of-a-plane
            // https://stackoverflow.com/questions/9605556/how-to-project-a-point-onto-a-plane-in-3d

            // project onto 3d plane
            PVector delta = PVector.sub(otherNode.displayPos, plane[0]);
            float dist = PVector.dot(delta, plane[1]);
            PVector rp = PVector.sub(delta, PVector.mult(plane[1], dist));

            // left multiply rp by projection matrix to get 2d vector
            // M =  [  bx.x  bx.y  bx.z ]
            //      [  by.x  by.y  by.z ]

            PVector projVec = new PVector(PVector.dot(plane[2], rp), PVector.dot(plane[3], rp));

            // then determine if axis is flipped
            // match 2 of the basis vectors
            boolean flipped = plane[1].dot(otherPlane[1]) < 0;
            node.addEdge(projVec.normalize(), otherNode, flipped);
          }
        }
      }
    }
  }
}

ArrayList<Node> getNearbyNodes(Node node, float radius) {
  ArrayList<Node> nearNodes = new ArrayList<Node>();

  for (int k = 0; k < nodes.length; k++) {
    for (int l = 0; l < nodes[k].length; l++) {
      boolean inRadius = PVector.dist(node.displayPos, nodes[k][l].displayPos) < radius;
      if (node != nodes[k][l] && inRadius) {
        nearNodes.add(nodes[k][l]);
      }
    }
  }

  return nearNodes;
}

// [0] = origin of the plane, [1] = normal of the plane, [2] = basis x, [3] = basis y
PVector[] bestFitPlane(Node center, ArrayList<Node> nodes) {
  PVector[] plane = new PVector[4];
  PVector centroid = center.displayPos;
  plane[0] = centroid;


  if (nodes.size() == 0) {
    plane[1] = new PVector(1, 0, 0); // just pick an arbritrary axis
  }
  if (nodes.size() == 1) {
    plane[1] = PVector.sub(nodes.get(0).displayPos, center.displayPos).normalize();
  } else {

    // Calc full 3x3 covariance matrix, excluding symmetries:
    float xx = 0.0; 
    float xy = 0.0; 
    float xz = 0.0;
    float yy = 0.0; 
    float yz = 0.0; 
    float zz = 0.0;

    for (Node node : nodes) {
      PVector r = PVector.sub(node.displayPos, centroid);
      xx += r.x * r.x;
      xy += r.x * r.y;
      xz += r.x * r.z;
      yy += r.y * r.y;
      yz += r.y * r.z;
      zz += r.z * r.z;
    }

    float det_x = yy*zz - yz*yz;
    float det_y = xx*zz - xz*xz;
    float det_z = xx*yy - xy*xy;

    float det_max = max(det_x, det_y, det_z);
    if (det_max <= 0.0) {
      println("could not find plane of best fit, determinate 0");
      return plane; // The points don't span a plane
    }

    PVector dir = new PVector(det_x, xz*yz - xy*zz, xy*yz - xz*yy);
    if (det_max == det_y) {
      dir = new PVector(xz*yz - xy*zz, det_y, xy*xz - yz*xx);
    }
    if (det_max == det_z) {
      dir = new PVector( xy*yz - xz*yy, xy*xz - yz*xx, det_z);
    }

    plane[1] = dir.normalize();
  }

  plane[2] = plane[1].cross(new PVector(1, 0, 0));
  if (plane[2].mag() < 0.00001) { // in case of floating point errors
    plane[2] = plane[1].cross(new PVector(0, 1, 0));
  }
  plane[2].normalize();
  plane[3] = plane[1].cross(plane[2]).normalize();

  return plane;
}
