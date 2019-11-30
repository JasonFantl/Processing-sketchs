class Node {

  float wonGames = 0;
  int playedGames = 0;
  State state;
  int level;

  Node parent;
  ArrayList<Node> children;


  Node(State inState, int inLevel)
  {
    state = inState;
    wonGames = 0;
    playedGames = 0;
    state = inState;
    level = inLevel;
    children = new ArrayList<Node>();
  }


  void getNewChildren() {
    children = state.getLegalMoves();
    for (Node c : children) {
      c.parent = this;
      c.level = level+1;
    }
  }

  Node getRandomhild() {
    if (children.size() > 0) {
      return children.get((int)random(children.size()));
    }
    return this;
  }

  int simulate() {
    State testState = new State(state.board, state.player);
    while (testState.checkWin() == 0) {
      testState.placeRandom();
    }

    return testState.checkWin();
  }

  void display() {
    state.display();
  }


  Node getBestChild() {
    Node best = getRandomhild();
    for (Node c : children) {
      if (best.playedGames < c.playedGames) {
        best = c;
      }
    }
    return best;
  }
}
