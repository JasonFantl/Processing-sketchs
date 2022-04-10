class Environment {

  int size;
  boolean[][][] earth;
  boolean[][][] displayMask;

  float[][][] trackingPheromone;

  ArrayList<Ant> ants;

  Environment(int size) {
    this.size = size;

    earth = new boolean[size][size][size];
    displayMask = new boolean[size][size][size];
    trackingPheromone = new float[size*2+1][size*2+1][size*2+1]; // ants operate on a finer grid

    ants = new ArrayList<Ant>();

    // use noise to fill
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        int mountainHeight = size / 10;
        float smoothness = 10;
        int offset = (size - mountainHeight) / 2;
        int groundHeight = offset + int(noise(i / smoothness, j / smoothness) * mountainHeight);
        groundHeight = min(groundHeight, size);

        for (int k = 0; k < size; k++) {
          if (k < groundHeight) {
            earth[i][j][k] = true;
          } else {
            earth[i][j][k]= false;
          }
        }

        // maybe create an ant
        if (random(1.0) > 0.99) {
        //if (i == size/2 && j == size/2) {
          ants.add(new Ant(i, j, groundHeight));
        }
      }
    }

    // remove unseen box's
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        for (int k = 0; k < size; k++) {
          updateVoxelDisplay(new IntVector(i, j, k));
        }
      }
    }
  }

  void update() {

    // update pheromones
    // could it be more efficient to have the ants update cells when they walk on them?
    for (int i = 0; i < env.size*2+1; i++) {
      for (int j = 0; j < env.size*2+1; j++) {
        for (int k = 0; k < env.size*2+1; k++) {
          trackingPheromone[i][j][k] *= 0.98;
        }
      }
    }


    // update ants
    for (Ant ant : ants) {
      ant.update();
      ant.display();
    }
  }

  void display() {
    for (int i = 0; i < env.size; i++) {
      for (int j = 0; j < env.size; j++) {
        for (int k = 0; k < env.size; k++) {
          if (earth[i][j][k] && displayMask[i][j][k]) {
            // to show pheromone strength
            // get average pheromone
            float p = 0;
            for (int dx = -1; dx < 2; dx++) {
              for (int dy = -1; dy < 2; dy++) {
                p += trackingPheromone[i*2+1+dx][j*2+1+dy][k*2+2];
              }
            }
            p /= 9.0;
            fill(50 + 50*p, 100 +100*p, 50 +50*p);
            pushMatrix();
            translate(i, j, k);
            box(1);
            popMatrix();
          }
        }
      }
    }
  }

  void updateVoxelDisplay(IntVector pos) {
    if (earth[pos.x][pos.y][pos.z]) {
      int sum = 0;
      int counted = 0;
      for (IntVector delta : orthogonalDeltas) {
        IntVector checking = pos.add(delta);
        if (checking.x >= 0 && checking.y >= 0 && checking.z >= 0 &&
          checking.x < size && checking.y < size && checking.z < size) {
          counted++;
          if (earth[checking.x][checking.y][checking.z]) {
            sum++;
          }
        }
      }
      boolean surrounded = sum == counted;
      if (surrounded) {
        displayMask[pos.x][pos.y][pos.z] = false;
      } else {
        displayMask[pos.x][pos.y][pos.z] = true;
      }
    }
  }

  void removeVoxel(IntVector pos) {
    if (pos.x >= 0 && pos.y >= 0 && pos.z >= 0 &&
      pos.x < size && pos.y < size && pos.z < size) {
      earth[pos.x][pos.y][pos.z] = false;
      for (IntVector delta : orthogonalDeltas) {
        updateVoxelDisplay(pos.add(delta));
      }
    }
  }

  void addVoxel(IntVector pos) {
    if (pos.x >= 0 && pos.y >= 0 && pos.z >= 0 &&
      pos.x < size && pos.y < size && pos.z < size) {
      earth[pos.x][pos.y][pos.z] = true;
      for (IntVector delta : orthogonalDeltas) {
        updateVoxelDisplay(pos.add(delta));
      }
    }
  }

  void addPheromone(IntVector pos, float amount) {
    if (pos.x >= 0 && pos.y >= 0 && pos.z >= 0 &&
      pos.x < size*2+1 && pos.y < size*2+1 && pos.z < size*2+1) {
      float current = trackingPheromone[pos.x][pos.y][pos.z];
      trackingPheromone[pos.x][pos.y][pos.z] += (1.0-current)*amount;
    }
  }
}
