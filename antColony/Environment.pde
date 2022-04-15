class Environment {

  int size;
  boolean[][][] earth;
  boolean[][][] displayMask;

  float[][][][] pheromones;
  // 0 : food
  // 1 : building
  int[][][] food;
  ArrayList<IntVector> foodLookup; // for faster displaying, does not contain food count

  ArrayList<Ant> ants;
  ArrayList<Ant> antsBuffer; // we cant modify ants during the frame, so we buffer them and add them once the frame is done

  IntVector home;

   int pheromoneDisplay = 0;
   
  Environment(int size) {
    this.size = size;

    earth = new boolean[size][size][size];
    displayMask = new boolean[size][size][size];
    pheromones = new float[size*2+1][size*2+1][size*2+1][2]; // ants operate on a finer grid
    food = new int[size*2+1][size*2+1][size*2+1]; // ants operate on a finer grid
    foodLookup = new ArrayList<IntVector>();
    ants = new ArrayList<Ant>();
    antsBuffer = new ArrayList<Ant>();

    home = new IntVector(size, size, size); // in terms of ant grid, center

    // init pheromones
    for (int i = 0; i < size*2+1; i++) {
      for (int j = 0; j < size*2+1; j++) {
        for (int k = 0; k < size*2+1; k++) {
          pheromones[i][j][k][0] = random(0.1);
          //foodPheromone[i][j][k] = ((i + j+k)) / (3.0*size*2+1);
        }
      }
    }

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
        if (random(1.0) > 0.95) {
          //if (i == size/2 && j == size/2) {
          ants.add(new Ant(i*2+1, j*2+1, groundHeight*2));
        }
        if (random(1) > 0.999) {
          addFood(new IntVector(i*2+1, j*2+1, groundHeight*2), 20);
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
    for (int i = 0; i < size*2+1; i++) {
      for (int j = 0; j < size*2+1; j++) {
        for (int k = 0; k < size*2+1; k++) {
          pheromones[i][j][k][0] *= 0.997;
          pheromones[i][j][k][1] *= 0.997;
        }
      }
    }

    // update ants
    for (Ant ant : ants) {
      ant.update();
    }

    // move ant buffer to ants
    for (Ant ant : antsBuffer) {
      ants.add(ant);
    }
    antsBuffer = new ArrayList<Ant>();

    // maybe drop some food
    if (random(1) > 0.99) {
      addFood(ants.get(int(random(ants.size()))).position, 20);
    }
  }

  void display() {

    // display earth
    for (int i = 0; i < env.size; i++) {
      for (int j = 0; j < env.size; j++) {
        for (int k = 0; k < env.size; k++) {
          if (earth[i][j][k] && displayMask[i][j][k]) {
            // to show pheromone strength
            // get average pheromone
            float p = 0;
            for (int dx = -1; dx < 2; dx++) {
              for (int dy = -1; dy < 2; dy++) {
                p += pheromones[i*2+1+dx][j*2+1+dy][k*2+2][pheromoneDisplay];
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

    // display foood
    for (IntVector p : foodLookup) {
      int v = food[p.x][p.y][p.z];
      if (v> 0) {
        pushMatrix();
        translate((p.x-1)/2.0, (p.y-1)/2.0, (p.z-1)/2.0);
        fill(250, 100, 100);
        box(0.5 + v / 127.0);
        popMatrix();
      }
    }

    // display ants
    for (Ant ant : ants) {
      ant.display();
    }
  }

  void updateVoxelDisplay(IntVector pos) {
    if (pos.x >= 0 && pos.y >= 0 && pos.z >= 0 &&
      pos.x < size && pos.y < size && pos.z < size) {
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
  }

  void removeVoxel(IntVector pos) {
    if (pos.x >= 0 && pos.y >= 0 && pos.z >= 0 &&
      pos.x < size && pos.y < size && pos.z < size) {
      earth[pos.x][pos.y][pos.z] = false;
      displayMask[pos.x][pos.y][pos.z] = false;

      for (IntVector delta : orthogonalDeltas) {
        updateVoxelDisplay(pos.add(delta));
      }
    }
  }

  void addVoxel(IntVector pos) {
    if (pos.x >= 0 && pos.y >= 0 && pos.z >= 0 &&
      pos.x < size && pos.y < size && pos.z < size) {
      earth[pos.x][pos.y][pos.z] = true;
      displayMask[pos.x][pos.y][pos.z] = true;

      for (IntVector delta : orthogonalDeltas) {
        updateVoxelDisplay(pos.add(delta));
      }
    }
  }

  void addPheromone(IntVector pos, float amount, int type) {
    if (pos.x >= 0 && pos.y >= 0 && pos.z >= 0 &&
      pos.x < size*2+1 && pos.y < size*2+1 && pos.z < size*2+1) {
      float current = pheromones[pos.x][pos.y][pos.z][0];
      pheromones[pos.x][pos.y][pos.z][type] += (1.0-current)*amount;
    }
  }

  void addFood(IntVector pos, int amount) {
    // only change loopup if there is no food
    if (food[pos.x][pos.y][pos.z] <= 0) {
      foodLookup.add(pos);
    }
    food[pos.x][pos.y][pos.z] += amount;
  }

  void removeFood(IntVector pos, int amount) {
    food[pos.x][pos.y][pos.z] -= amount;
    // only change loopup if there is no more food
    if (food[pos.x][pos.y][pos.z] <= 0) {
      foodLookup.remove(pos);
    }
  }
}
