
// recursive patch to problem

PVector indexToAltCord(int n) {
  // derived from the governing equations
  // n = x + (x + m)(x + m + 1)/2
  // m = y + (y + z)(y + z + 1)/2
  int l1 = floor((-1 + sqrt(1 + 8*n))/2);
  int x = n - l1*(l1+1)/2;
  int m = l1 - x;
  int l2 = floor((-1 + sqrt(1 + 8*m))/2);
  int y = m - l2*(l2+1)/2;
  int z = l2 - y;
  
  return new PVector(x, y, z);
}

int altCordToIndex(PVector pos) {
   int m = floor(pos.y + (pos.y + pos.z)*(pos.y + pos.z + 1)/2);
   int n = floor(pos.x + (pos.x + m)*(pos.x + m + 1)/2);
   
   return n;
}
