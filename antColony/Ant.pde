class Ant {

  IntVector position;
  IntVector prevPosition; // used to make sure we don't follow our own pheromone trail

  PVector direction; // used to weight posistions in front of the ant as greator

  Ant(int x, int y, int z) {
    position = new IntVector(x*2+1, y*2+1, z*2);
    prevPosition = position;
    direction = PVector.random3D();
  }

  void update() {
    env.addPheromone(position, 0.7); // don't use 1.0 pheromone so that multiple ants on one spot will have an effect
    move();
  }


  void move() {
    ArrayList<IntVector> possibleMoves = getPossibleMoves(position);

    prevPosition = position; // update pre position before overwritting new pos

    if (possibleMoves.size() > 0) {
      
      // weight the possible moves
      float[] weights = new float[possibleMoves.size()];
      for (int i = 0; i < possibleMoves.size(); i++) {
        weights[i] = 0.1; // dont want all zero, otherwise random picking wont work. The larger this value, the more exploritory an ant is
        
        // consider pheromones
        //weights[i] += pheromone(possibleMoves.get(i)); // from 0.0 to 1.0
        
        // consider direction
        IntVector d = possibleMoves.get(i).sub(position);
        float dDirection = direction.dist(new PVector(d.x, d.y, d.z)); // distance between current direction and direction we walked as unit vectors. 
        // technically could be anywhere from 0.0 to 2.0, but most of the time will be from 0.0 to sqrt(2)
        weights[i] += 2 - dDirection;
      }
      int index = randomWeighted(weights);
      
      // update position
      position = possibleMoves.get(index);
      
      // update direction
      IntVector delta = position.sub(prevPosition);
      float s = 0.1; // how quickly to change direction
      direction = direction.mult(1.0-s).add(new PVector(delta.x, delta.y, delta.z).mult(s));
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

      // can't move to the edges of the map
      if (checking.x <= 0 || checking.y <= 0 || checking.z <= 0 ||
        checking.x >= env.size*2 || checking.y >= env.size*2 ||checking.z >= env.size*2) {
        continue;
      }

      // can't move to where we just came from
      if (checking.x == prevPosition.x && checking.y == prevPosition.y && checking.z == prevPosition.z) {
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
        if (center != null && earth(center.addInt(-1).divInt(2))) {
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

  float pheromone(IntVector p) {
    if (p.x >= 0 && p.y >= 0 && p.z >= 0 &&
      p.x < env.size*2+1 && p.y < env.size*2+1 && p.z < env.size*2+1) {
      return env.trackingPheromone[p.x][p.y][p.z];
    }
    return 0.0; // outside of simulation is air
  }
}
