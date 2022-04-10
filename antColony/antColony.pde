
import peasy.PeasyCam;
PeasyCam cam;

Environment env;

void setup() {
  size(600, 600, P3D);
  cam = new PeasyCam(this, 400);
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height),
    cameraZ/100.0, cameraZ*10.0);

  noStroke();

  env = new Environment(100);

  println("finished initializing");
  
  for (int i = 0; i < 100; i ++) {
  print(randomWeighted(new float[]{0.5, 5.0, 3.0, 0.1}));
  if ((i+1)%10 == 0) {
    println();
  }
  }
}


void draw() {
  background(51);
  translate( -env.size / 2, -env.size / 2, -env.size / 2);
  lights();

  env.update();
  env.display();
}
