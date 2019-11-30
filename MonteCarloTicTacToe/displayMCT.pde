
class displayMCT {
  int maxY;

  int[] nodesInLevel;
  int[] nodeIndex;

  void display(Node inNode) {
    maxY = maxDepth(inNode);

    nodeIndex = new int[maxY];
    nodesInLevel = new int[maxY];
    for (int i = 0; i < nodesInLevel.length; i++) {
      nodesInLevel[i] = getWidth(inNode, i+1);
    }
    displayLevel(inNode, 1);
  }


  PVector displayLevel(Node inNode, int level) {
    int xSize = width/(nodesInLevel[level - 1] + 1)/2;
    int ySize = height/nodeIndex.length/2;
    int size = (xSize < ySize) ? xSize : ySize;
    int xOff = width/2 + (width/min(width,nodesInLevel[level - 1])) * (nodeIndex[level - 1] - nodesInLevel[level - 1]/2);
    if (nodesInLevel[level - 1] % 2 ==0) xOff += width/nodesInLevel[level - 1]/2;
    int yOff = height/(maxY+1) * level;

    //inNode.state.display(size, size, xOff, yOff, inNode.wonGames*255/(inNode.playedGames+1));
    inNode.state.display(size, size, xOff, yOff);

    nodeIndex[level - 1]++;
    for (Node c : inNode.children) {
      PVector toPoint = displayLevel(c, level + 1); 
      strokeWeight(min(pow(c.playedGames, 0.5), 10));
      stroke(min(c.wonGames, 255));
      line(xOff, yOff, toPoint.x, toPoint.y);
    }
    return new PVector(xOff, yOff);
  }

  int maxDepth(Node node)  
  { 
    if (node == null) 
      return 0; 
    else 
    { 
      ArrayList<Node> nodes = node.children;
      int max = 0;
      for (int i = 0; i < nodes.size(); i++) {
        int out = maxDepth(nodes.get(i));
        if (out > max) max = out;
      }
      /* use the larger one */
      return max + 1;
    }
  }

  int getWidth(Node node, int level)  
  { 
    if (node == null) {
      return 0;
    }
    if (level == 1) {
      return 1;
    }
    int returnVal = 0;
    for (Node c : node.children) {
      returnVal += getWidth(c, level - 1);
    }
    return returnVal;
  }


  void displayMinMax(Node inNode) {
    int ySep = countMinMax(inNode) + 1;
    displayMinMaxRec(inNode, 1, ySep);
  }

  void displayMinMaxRec(Node inNode, int index, int sep) {
    int fakeSep = 6;
    int size = height / fakeSep / 2;
    int xOff = width/2;
    int yOff = height/fakeSep/2 * index;
    inNode.state.display(size, size, xOff, yOff);
    if (inNode.children.size() > 0) {
      displayMinMaxRec(inNode.getBestChild(), index + 1, sep);
    }
  }

  int countMinMax(Node inNode) {
    if (inNode.children.size() > 0) return countMinMax(inNode.getBestChild()) + 1;
    return 0;
  }
}
