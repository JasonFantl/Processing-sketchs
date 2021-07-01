


void takePicture(PVector nodePos, float dAngle) {
  // draw ground and sky
  fill(100, 100, 100);
  rect(0, 0, width, height/2);
  fill(50, 50, 50);
  rect(0, height/2, width, height);

  int viewDistance = 5000;

  int pixelCount = 100;
  for (int i = 0; i < pixelCount; i++) {
    // camera settings
    float screenDis = 10;
    float screenRadius = 10;
    
    float screenX = (float(i*2)/(pixelCount-1)-1)*screenRadius;
    float angle = atan2(screenX, screenDis);
    
    PVector dir = PVector.fromAngle(angle +dAngle);
    Photon photon = new Photon(nodes[mod(int(nodePos.x), nodes.length)][mod(int(nodePos.y), nodes[i].length)], dir);
    color col = color(0, 0, 0);
    int d = 0;

    while (d < viewDistance) {
      if (photon.location.solid) {
        col = photon.location.col;
        break;
      }
      photon.move();
      d++;
    }
    
    // apply projection distance so we dont get fisheye effect
    float dis = d*cos(angle);

    noStroke();

     col = color(red(col)/max(1, dis/200.0), green(col)/max(1, dis/200.0), blue(col)/max(1, dis/200.0));
    fill(col);
    float w = float(width)/pixelCount;
    float x = i*w;
    float y = 10000.0/dis;
    rect(x, height/2 -y, x+w, height/2+y);
  }
}
