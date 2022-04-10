class Ant {

  IntVector position;

  Ant(int x, int y, int z) {
    position = new IntVector(x*2+1, y*2+1, z*2);
  }

  void update() {
    move();
  }


  void move() {
    ArrayList<IntVector> possibleMoves = getPossibleMoves(position);

    if (possibleMoves.size() > 0) {
      IntVector choice = possibleMoves.get(int(random(possibleMoves.size())));
      position = choice;
    }
  }

  void display() {
    pushMatrix();
    translate((position.x-1)/2.0, (position.y-1)/2.0, (position.z-1)/2.0);
    fill(0);
    box(0.5);
    popMatrix();
  }


  // in dire need of refactoring
  ArrayList<IntVector> getPossibleMoves(IntVector pos) {
    ArrayList<IntVector> possibleMoves = new ArrayList<IntVector>();

    for (IntVector delta : orthogonalDeltas) {
      IntVector checking = pos.add(delta);
      if (checking.x <= 0 || checking.y <= 0 || checking.z <= 0 ||
        checking.x >= env.size*2 || checking.y >= env.size*2 ||checking.z >= env.size*2) {
        continue;
      }
      
      IntVector parity = new IntVector(checking.x%2, checking.y%2, checking.z%2);
      IntVector parityInverse = parity.multInt(-1).addInt(1); // helpful value to have
      int paritySum = parity.x+parity.y+parity.z;

      int blockCount = 0;
      IntVector[] centers = new IntVector[8]; // 8 is the max, may be less
      
      if (paritySum == 0) { // corner
        blockCount = 8;
        for (int i = 0; i < 8; i++) {
          centers[i] = checking.add(new IntVector(i%2, (i/2)%2, i/4).multInt(2).addInt(-1));
        }
      } else if (paritySum == 1) { // edge
        blockCount = 4;
        centers = new IntVector[]{
          checking.add(parityInverse),
          checking.add(parityInverse.multInt(-1)),
          checking.add(parityInverse).add(new IntVector(parity.y, parity.z, parity.x).multInt(-2)),
          checking.add(parityInverse.multInt(-1)).add(new IntVector(parity.z, parity.x, parity.y).multInt(2))
        };
      } else if (paritySum == 2) { // face
        blockCount = 2;
        centers = new IntVector[]{
          checking.add(parityInverse),
          checking.add(parityInverse.multInt(-1))
        };
      }
      int sum = 0;
      for (IntVector center : centers) {
        if (earth(center.addInt(-1).divInt(2))) {
          sum++;
        }
      }

      if (sum > 0 && sum < blockCount) { // there must be at least one block and opening
        possibleMoves.add(checking);
      }
    }

    return possibleMoves;
  }

  boolean earth(IntVector p) {
    if (p.x >= 0 && p.y >= 0 && p.z >= 0 &&
      p.x < env.size && p.y < env.size && p.z < env.size) {
      return env.earth[p.x][p.y][p.z];
    }
    return false; // outside of simulation is air
  }
}
