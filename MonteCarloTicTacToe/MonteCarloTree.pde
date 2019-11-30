import java.util.Arrays;

class MonteCarloTree {

  Node root;
  double runtime = 2000;
  int simulationsRan = 0;
  int player;

  MonteCarloTree(State inState) {
    root = new Node(inState, 0);
    player = inState.player;
  }


  State getBestMove() {

    Node selectedNode = select();
    selectedNode.getNewChildren();
    selectedNode = selectedNode.getRandomhild();
    int score = selectedNode.simulate();
    simulationsRan++;
    backPropogate(selectedNode, score);

    return getBestFromRoot().state;
  }

  Node getBestFromRoot() {
    return root.getBestChild();
  }

  Node select() {
    Node selected = root;
    while (selected.children.size() > 0) {
      //using UTC formula

      Node best = selected.children.get(0);
      double score = 0;
      for (int i = 0; i < selected.children.size(); i++) {
        if (selected.children.get(i).playedGames == 0) {
          return selected.children.get(i);
        }
        
        double exploitation = (float)selected.children.get(i).wonGames / selected.children.get(i).playedGames;
        double exploration = (float)selected.playedGames / selected.children.get(i).playedGames;
        double c = 0.01;
        
        //double possibleScore = exploitation + c * exploration;
        double possibleScore = (1-c)*exploitation + c * exploration;

        if (possibleScore > score) {
          best = selected.children.get(i);
          score = possibleScore;
        }
      }
      selected = best;
    }
    return selected;
  }

  void backPropogate(Node inNode, int inScore) {
      inNode.playedGames++;
      if (inScore == inNode.state.player) {
        inNode.wonGames ++;
      }
      else if(inScore == 2) {
        inNode.wonGames += 0.1;
      }
          if (inNode != root) {

      backPropogate(inNode.parent, inScore);
    }
  }
}
