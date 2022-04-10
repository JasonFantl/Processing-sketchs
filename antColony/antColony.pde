
import peasy.PeasyCam;
PeasyCam cam;

Environment env;


IntVector[] orthogonalDeltas = new IntVector[]{ // helpful to have on hand
  new IntVector(0, 0, 1),
  new IntVector(0, 0, -1),
  new IntVector(0, 1, 0),
  new IntVector(0, -1, 0),
  new IntVector(1, 0, 0),
  new IntVector(-1, 0, 0)};

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
}


void draw() {
  background(51);
  translate( -env.size / 2, -env.size / 2, -env.size / 2);
  lights();

  env.update();
  env.display();
}
