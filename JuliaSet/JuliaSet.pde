
// click down to set c
// let go to see max iterations increase, means more detailed, but lose more points


Complex c = new Complex(0.35, 0.364);
int maxIters = 10;

void setup() {
  size(800, 800);  
  stroke(255);
}


void draw() {
  background(0);

  //c.real += 0.01;
  //println(c.real);

  maxIters+=10;
  println(maxIters);

  drawJuliaSet();
}

void mouseDragged() {
  maxIters = 10;
 c = new Complex(map(mouseX, 0, width, -1, 1), map(mouseY, 0, height, -1, 1));
 println(c.real, " ", c.img);
}

Complex juliaFunction(Complex z) {
  // normal julia set
  //return z.mult(z).add(c);
  
  //return new Complex(1, 0).sub(z).mult(z).mult(c);
  
  
  Complex z2 = z.mult(z);
  Complex z3 = z2.mult(z);
  Complex z4 = z3.mult(z);
  
  Complex t1 = z4;
  Complex t2 = z3.div(z.sub(new Complex(1, 0)));
  Complex t3 = z2.div(z3.add(z2.scale(4)).add(new Complex(5, 0)));
  return t1.add(t2).add(t3).add(c);
}

void drawJuliaSet() {
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {

      float x = map(i, 0, width, -2, 2);
      float y = map(j, 0, height, -2, 2);
      
      // for mandlebrot
      //c.real = x;
      //c.img = y;
      
      if (converges(new Complex(x, y))) {
        point(i, j);
      }
    }
  }
}

boolean converges(Complex z) {
  int n = 0;

  while (n < maxIters) {
    z = juliaFunction(z);
    if (z.mag() > 4) {
      return false;
    }
    n++;
  }

  return true;
}
