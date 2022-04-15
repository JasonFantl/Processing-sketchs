public enum State {
  SEARCHING_FOOD, CARRYING_FOOD, CARRYING_EARTH, EXCAVATING
}

class Ant {

  IntVector position;
  IntVector prevPosition; // used to make sure we don't follow our own pheromone trail
  PVector direction; // used to weight posistions in front of the ant as greator

  float exploreCefficient; // from 0.0 to 1.0

  State state;

  Ant(int x, int y, int z) {
    position = new IntVector(x, y, z);
    prevPosition = position;
    direction = PVector.random3D();
    exploreCefficient = random(1);

    state = State.EXCAVATING;
    if (random(1) > 0.5) {
      state = State.SEARCHING_FOOD;
    }
  }

  void update() {

    if (state == State.CARRYING_FOOD) {
      dropPheromone(prevPosition, 1.0, 1, 0);

      if (env.home.dist(position) < 5) {
        state = State.SEARCHING_FOOD;

        // temp - the ant uses the food to make a new ant
        env.antsBuffer.add(new Ant(position.x, position.y, position.z));
      }
    } else if (state == State.SEARCHING_FOOD) {
      if (env.food[position.x][position.y][position.z] > 0) {
        env.removeFood(position, 1);
        state = State.CARRYING_FOOD;
      }
    } else if (state == State.EXCAVATING) {
      if (random(1) < (pheromone(position, 1) + 0.1/position.dist(env.home))) { // excavate where others have done so
        excavate();
      }
    } else if (state == State.CARRYING_EARTH) {
      if (random(1) < position.dist(env.home)/100.0-0.5) {
        build();
      }
    }

    // if in the air from ground underneath being removed, move down
    ArrayList<IntVector> possibleMoves = getPossibleMoves(position);

    if (possibleMoves.isEmpty()) {
      position = env.ants.get(int(random(env.ants.size()))).position; // teleport to another ant
    } else {
      move(possibleMoves);
    }
  }

  void display() {
    pushMatrix();
    translate((position.x-1)/2.0, (position.y-1)/2.0, (position.z-1)/2.0);
    fill(180, 80, 30);
    box(0.5);
    float d = 0.5;
    translate(direction.x*d, direction.y*d, direction.z*d);
    fill(50, 20, 10);
    box(0.5);
    popMatrix();
  }


  void move(ArrayList<IntVector> possibleMoves) {

    prevPosition = position; // update pre position before overwritting new pos

    if (possibleMoves.size() > 0) {

      // weight the possible moves
      float[] weights = new float[possibleMoves.size()];
      for (int i = 0; i < possibleMoves.size(); i++) {
        IntVector possibleMove = possibleMoves.get(i);
        weights[i] = valuePosition(possibleMove);
      }

      int index = 0;
      if (random(1) < exploreCefficient) {
        index = randomWeighted(weights);
      } else {
        index = maxWeighted(weights);
      }

      // update position
      position = possibleMoves.get(index);

      // update direction
      IntVector delta = position.sub(prevPosition);
      float s = 0.25; // how quickly to change direction
      direction = direction.mult(1.0-s).add(new PVector(delta.x, delta.y, delta.z).mult(s));
      direction.normalize();
    }
  }

  float valuePosition(IntVector possibleMove) {
    float weight = 0;

    // consider direction
    IntVector d = possibleMove.sub(position);
    float dDirection = direction.dist(new PVector(d.x, d.y, d.z)) / 2.0; // distance between current direction and direction we walk as unit vectors.
    // technically could be anywhere from 0.0 to 2.0, but most of the time will be from 0.0 to sqrt(2)
    weight += 1 - dDirection; // from 0.0 to 1.0

    if (state == State.SEARCHING_FOOD) {
      // consider pheromones
      // trying this strategy to solve the polarity of trails problem.
      // towards the food, the trail is a little less strong, but we dont want to go off the trail
      float p = pheromone(possibleMove, 0);
      float thresh = 0.1;
      if (p > thresh) {
        weight += (1-(p-thresh)/(1.0-thresh)); // from 0.0 to 1.0 (should we multiply by larger num?
      }
    } else if (state == State.CARRYING_FOOD) {
      // head home
      weight += new PVector(d.x, d.y, d.z).dist(position.sub(env.home).normalize()) / 2; // from 0.0 to 1.0
    } else if (state == State.EXCAVATING) {
      // head home
      weight += new PVector(d.x, d.y, d.z).dist(position.sub(env.home).normalize()) / 2; // from 0.0 to 1.0

      // head down
      weight += (d.z-1.0) / 4; // from 0.0 to 0.5

      // go towards where excavation is happening
      weight += pheromone(possibleMove, 1); // from 0.0 to 1.0
    } else if (state == State.CARRYING_EARTH) {

      // if underground, head up, therwise head away
      if (position.z < env.home.z - 10) {
        // head up
        weight += (d.z+1.0) / 2; // from 0.0 to 1.0
      } else {
        // head away from home
        weight += 1 - new PVector(d.x, d.y, d.z).dist(position.sub(env.home).normalize()) / 2; // from 0.0 to 1.0
      }
    }

    return weight;
  }


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

  void excavate() {
    IntVector parity = new IntVector(position.x%2, position.y%2, position.z%2);
    IntVector parityInverse = parity.multInt(-1).addInt(1); // helpful value to have
    int paritySum = parity.x+parity.y+parity.z;

    IntVector[] centers = new IntVector[8]; // 8 is the max, may be less

    if (paritySum == 0) { // corner
      for (int i = 0; i < 8; i++) {
        centers[i] = position.add(new IntVector(i%2, (i/2)%2, i/4).multInt(2).addInt(-1));
      }
    } else if (paritySum == 1) { // edge
      centers = new IntVector[]{
        position.add(parityInverse),
        position.add(parityInverse.multInt(-1)),
        position.add(parityInverse).add(new IntVector(parity.y, parity.z, parity.x).multInt(-2)),
        position.add(parityInverse.multInt(-1)).add(new IntVector(parity.z, parity.x, parity.y).multInt(2))
      };
    }

    ArrayList<IntVector> validCenters = new ArrayList<IntVector>();
    for (IntVector center : centers) {
      if (center != null && earth(center.addInt(-1).divInt(2))) {
        validCenters.add(center);
      }
    }

    if (validCenters.size() > 1) { // there must be at least two blocks
      // remove a random block below you
      IntVector toRemove = validCenters.get(int(random(validCenters.size())));
      env.removeVoxel(earthCords(toRemove));
      state = State.CARRYING_EARTH;
      dropPheromone(toRemove.add(new IntVector(0, 0, -2)), 0.8, 2, 1);
    }
  }



  void build() {
    IntVector parity = new IntVector(position.x%2, position.y%2, position.z%2);
    IntVector parityInverse = parity.multInt(-1).addInt(1); // helpful value to have
    int paritySum = parity.x+parity.y+parity.z;

    IntVector[] centers = new IntVector[8]; // 8 is the max, may be less

    if (paritySum == 0) { // corner
      for (int i = 0; i < 8; i++) {
        centers[i] = position.add(new IntVector(i%2, (i/2)%2, i/4).multInt(2).addInt(-1));
      }
    } else if (paritySum == 1) { // edge
      centers = new IntVector[]{
        position.add(parityInverse),
        position.add(parityInverse.multInt(-1)),
        position.add(parityInverse).add(new IntVector(parity.y, parity.z, parity.x).multInt(-2)),
        position.add(parityInverse.multInt(-1)).add(new IntVector(parity.z, parity.x, parity.y).multInt(2))
      };
    }

    ArrayList<IntVector> openCenters = new ArrayList<IntVector>();
    int earthSum = 0;
    for (IntVector center : centers) {
      if (center != null) {
        if (earth(center.addInt(-1).divInt(2))) {
          earthSum++;
        } else {
          openCenters.add(center);
        }
      }
    }

    if (earthSum > 0 && openCenters.size() > 0) {
      // remove a random block below you
      env.addVoxel(earthCords(openCenters.get(int(random(openCenters.size())))));
      state = State.EXCAVATING;
    }
  }

  boolean earth(IntVector p) {
    if (p.x >= 0 && p.y >= 0 && p.z >= 0 &&
      p.x < env.size && p.y < env.size && p.z < env.size) {
      return env.earth[p.x][p.y][p.z];
    }
    return false; // outside of simulation is air
  }

  float pheromone(IntVector p, int type) {
    if (p.x >= 0 && p.y >= 0 && p.z >= 0 &&
      p.x < env.size*2+1 && p.y < env.size*2+1 && p.z < env.size*2+1) {
      return env.pheromones[p.x][p.y][p.z][type];
    }
    return 0.0; // outside of simulation is air
  }

  void dropPheromone(IntVector pos, float val, int radius, int type) {
    //env.addPheromone(pos, val, type);

    for (int dx = -radius; dx <= radius; dx++) {
      for (int dy = -radius; dy <= radius; dy++) {
        for (int dz = -radius; dz <= radius; dz++) {
          env.addPheromone(pos.add(new IntVector(dx, dy, dz)), val, type);
        }
      }
    }
  }

  IntVector earthCords(IntVector p) {
    return p.addInt(-1).divInt(2);
  }
}
