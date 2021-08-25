class Complex {
  float real;   // the real part
  float img;   // the imaginary part

  public Complex(float real, float img) {
    this.real = real;
    this.img = img;
  }

  public Complex mult(Complex b) {
    float real = this.real * b.real - this.img * b.img;
    float img = this.real * b.img + this.img * b.real;
    return new Complex(real, img);
  }
  
  public Complex div(Complex b) {
    Complex n = this.mult(b.conjugate());
    float d = b.mult(b.conjugate()).real;
    
    return n.scale(1/d);
  }

  public Complex add(Complex b) {
    return new Complex(this.real + b.real, this.img + b.img);
  }

  public Complex sub(Complex b) {
    return new Complex(this.real - b.real, this.img - b.img);
  }

  public Complex pow(int n) {
    Complex z = this;
    for (int i = 1; i < n; i++) {
      z = z.mult(z);
    }
    return z;
  }

  public Complex scale(float s) {
    return new Complex(this.real *s, this.img *s);
  }
  
  public Complex conjugate() {
    return new Complex(this.real, -this.img);
  }

  public float mag() {
    return sqrt(this.real*this.real + this.img*this.img);
  }
}
