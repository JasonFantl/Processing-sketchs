class DNA {

  PVector[] instructions;
Population myPop;
  DNA (Population inPop) {
    myPop = inPop;
    instructions = new PVector[instrLength];

    for (int i = 0; i < instructions.length; i++) {
      instructions[i] = PVector.random2D().mult(thrustPower);
    }
  }

  Rocket Crossover (Rocket inVector1, Rocket inVector2) {
    float mid = random(instrLength);
    Rocket childVector = new Rocket(myPop);

    for (int i = 0; i < instrLength - 1; i++) {
      if (i < mid) {
        childVector.rocketDNA.instructions[i] = inVector1.rocketDNA.instructions[i];
        //childVector.rocketDNA.instructions[i] = new PVector(0.01, 0.01);
      } else {
        childVector.rocketDNA.instructions[i] = inVector2.rocketDNA.instructions[i];
        //childVector.rocketDNA.instructions[i] = new PVector(0.01, 0.01);
      }
    }
    return childVector;
  }

  void Mutate () {   
    if (mutateDynamic) {
      if (random(100) > myPop.averageFit()) {
        for (int i = (int)random(instructions.length); i < random(instructions.length); i ++) {
          instructions[(int)random(instructions.length - 1)] = PVector.random2D();
        }
      }
    }
    else {
          for(int i = 0; i < myPop.mutateRate * 100; i++) {
          instructions[(int)random(instructions.length - 1)] = PVector.random2D();
      }
    }
  }
}
