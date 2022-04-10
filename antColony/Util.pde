class IntVector {
  int x, y, z;

  IntVector(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  IntVector add(IntVector v) {
    return new IntVector(v.x + x, v.y + y, v.z + z);
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

  @Override public String toString() {
    return String.format("(%d, %d, %d)", x, y, z);
  }
}
