class IntVector {
  int x, y, z;

  IntVector(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  IntVector add(IntVector v) {
    return new IntVector(x + v.x, y + v.y, z + v.z);
  }

  IntVector sub(IntVector v) {
    return new IntVector(x - v.x, y - v.y, z - v.z);
  }

  IntVector addInt(int i) {
    return new IntVector(x+i, y+i, z+i);
  }

  IntVector mult(IntVector v) {
    return new IntVector(v.x * x, v.y * y, v.z * z);
  }

  IntVector multInt(int s) {
    return new IntVector(x*s, y*s, z*s);
  }

  IntVector divInt(int s) {
    return new IntVector(x/s, y/s, z/s);
  }

  PVector normalize() {
    return new PVector(x, y, z).normalize();
  }

  float dist(IntVector v) {
    return new PVector(x, y, z).dist(new PVector(v.x, v.y, v.z));
  }


  @Override public String toString() {
    return String.format("(%d, %d, %d)", x, y, z);
  }
}

IntVector[] orthogonalDeltas = new IntVector[]{ // helpful to have on hand
  new IntVector(0, 0, 1),
  new IntVector(0, 0, -1),
  new IntVector(0, 1, 0),
  new IntVector(0, -1, 0),
  new IntVector(1, 0, 0),
  new IntVector(-1, 0, 0)};

int randomWeighted(float[] weights) { // returns a random index using the given weights
  float sum = 0;
  for (float f : weights) {
    sum += f;
  }

  float choice  = random(sum);
  for (int i = 0; i < weights.length; i++) {
    if (choice <= weights[i]) {
      return i;
    }
    choice -= weights[i];
  }
  return 0; // should never happen
}

int maxWeighted(float[] weights) { // returns a random index using the given weights
  float max = -1;
  int index = -1;
  boolean allSame = true;
  for (int i = 0; i < weights.length; i++) {
    if (weights[i] >= max) {
      max = weights[i];
      index = i;
    }
    if (weights[i] != weights[0]) {
      allSame = false;
    }
  }
  
  if (allSame) {
   return int(random(weights.length)); 
  }
  return index;
}
