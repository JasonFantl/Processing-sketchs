
// True symmetric problem

// linear with n
PVector iterateCord(PVector pos) {
  PVector next = PVector.add(pos, new PVector(1, -1, 0));

  if (next.y < 0) {
    next = new PVector(0, next.x, next.z-1);
  } 
  if (next.z < 0) {
    next= new PVector(0, 0, next.y);
  }

  return next;
}


// solved using OEIS
PVector toCord(int n) { //<>//
  
 float t = pow(81*n + 3*sqrt(729*n*n - 3), 1.0/3.0); // overflows at n = 1717 //<>//
 int A056556 = floor(t/3.0 + 1.0/t - 1); //<>//
 int A056557 = floor((sqrt(8.0*(n-A056556*(A056556+1)*(A056556+2)/6.0)+1.0)-1.0)/2.0); //<>//
 int A056558 = floor(n-A056556*(A056556+1)*(A056556+2)/6.0-A056557*(A056557+1)/2.0); //<>//
 int A056559 = A056556 - A056557; //<>//
 int A056560 = A056557 - A056558; //<>//
 
return new PVector(A056558, A056560, A056559);
}

int toIndex(PVector pos) {
  float i = pos.x;
  float j = pos.x + pos.y;
  float k = pos.x + pos.y + pos.z;

  float n = i + j*(j+1)/2 + k*(k+1)*(k+2)/6; // it will be an int, trust me

  return int(n);
}
