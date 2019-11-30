class Population {

  Rocket[] rockets;
float mutateRate;
int timer = 0;
int wins = 0;

  Population (float mutateRateIn) {
    mutateRate = mutateRateIn;
    rockets = new Rocket[numRockets + 1];
    for (int i = 0; i < rockets.length; i++) {
      rockets[i] = new Rocket(this);
    }
  }

  void update() {
    timer++;
    for (int j = 0; j < rockets.length; j++) {
      if (rockets[j].destroyed) {
        
      }
      rockets[j].UpdatePos();
      rockets[j].updateFitness();
      rockets[j].Display();
    }
  }

  void repopulate() {
    timer = 0;
    float maxFit = 0;
    int allFit = 0;

    for (int i = 0; i < rockets.length; i++) {//normalize fit and mutate


      rockets[i].rocketDNA.Mutate();
      if (rockets[i].fitness > maxFit) {
        maxFit = rockets[i].fitness;
      }
    }
    for (int i = 0; i < rockets.length; i++) {
      rockets[i].fitness =  (rockets[i].fitness / maxFit) * 10;
    }

    for (int i = 0; i < rockets.length; i++) {//percentigize fit between 0 and 100 
      for (int j = 0; j < rockets[i].fitness; j++) {
        allFit++;
      }
    }
    Rocket[] fitPopulation = new Rocket[allFit];

    int index = 0;
    for (int i = 0; i < rockets.length; i++) {//percentigize fit between 0 and 100 
      for (int j = 0; j < rockets[i].fitness; j++) {
        fitPopulation[index] = rockets[i];
        index++;
      }
    }

    for (int i = 0; i < rockets.length; i++) {
      Rocket parent1 = fitPopulation[(int)random(fitPopulation.length - 2)];
      Rocket parent2 = fitPopulation[(int)random(fitPopulation.length - 1)];

      rockets[i] = rockets[i].rocketDNA.Crossover(parent1, parent2);
    }
  }

  boolean stillAlive() {
    for (int i = 0; i < rockets.length; i++) {
      if (rockets[i].destroyed == false) {
        return true;
      }
    }
    return false;
  }

  void printFit() {
    float max = 0;
    float av = 0;
    for (int i = 0; i < rockets.length; i++) {
      av += rockets[i].fitness / rockets.length;
      if (rockets[i].fitness > max) {
        max = rockets[i].fitness;
      }
    }
    println("Mutate rate : " + mutateRate + ", wins: " + wins + ", Average fit = " + av);
  }
  float averageFit() {
    float av = 0;
    for (int i = 0; i < rockets.length; i++) {
      av += rockets[i].fitness / rockets.length;
    }
    return av;
  }

  float topFit() {
    float max = 0;
    for (int i = 0; i < rockets.length; i++) {
      if (rockets[i].fitness > max) {
        max = rockets[i].fitness;
      }
    }
    return max;
  }
}
