class box {
  int x;
  int y;
  float z;
  int goal;
  
  float zDisplayHeight;
  
  box(int xin, int yin, int ingoal) {
    x = xin;
    y = yin; 
    z = 0;
    zDisplayHeight = z;
    goal = ingoal;
  }
  float index = 0;
  //float index = random(1);
  void update () {
    float offset = noise(x * sharpness, y * sharpness, index) * steepness;
    index += speed;
    if (noiseOrImg) {
      z += ((goal-z) / 100);
    }
    zDisplayHeight = z + offset;
  }


  void displayBox() {
    pushMatrix(); 
    fill(zDisplayHeight);
    translate((x * boxSize) - width/2, (y * boxSize) - height/2, zDisplayHeight/2);
    box(boxSize, boxSize, zDisplayHeight);
    popMatrix();
  }
  void displayVertex() {
    vertex((x * boxSize) - width/2, (y * boxSize) - height/2, zDisplayHeight);
  }
}