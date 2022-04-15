
import peasy.PeasyCam;
PeasyCam cam;

Environment env;

void setup() {
  size(900, 900, P3D);
  cam = new PeasyCam(this, 400);
  noiseSeed(int(random(999)));

  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height),
    cameraZ/100.0, cameraZ*10.0);

  noStroke();

  env = new Environment(100);
  env.pheromoneDisplay = 1;

  println("finished initializing");
}


void draw() {
  background(51);
  translate( -env.size / 2, -env.size / 2, -env.size / 2);
  lights();

env.update();
  env.display();
}

void keyPressed() {
   //env.pheromoneDisplay = (env.pheromoneDisplay + 1) % env.pheromones[0][0][0].length;
}
