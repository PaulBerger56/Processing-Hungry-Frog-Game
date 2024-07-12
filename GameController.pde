class GameController {
  ArrayList<Ant> ants; // used to hold the ants that are spawned
  ArrayList<Fly> flies; // used to hold the flies that are spawned
  ArrayList<Wasp> wasps; // used to hold the wasps that are spawned
  ArrayList<Fireball> fireballs; // used to hold the fireballs that are spawned

  FrogSounds frogSounds;  // used to hold all of the frog sounds

  float startingSpeed; // used as the top end of the speed when spawning bugs

  int antsEaten; // number of ants eaten by frog
  int fliesEaten; // number of flies eaten by frog
  int waspsEaten; // number of wasps eaten by frog

  int totalPoints; // total points from all eaten bugs
  int pointsPerAnt; // points per ant eaten
  int pointsPerFly; // points per fly eaten
  int pointsPerWasp; // points per wasp eaten
  int previousHealthPoints; // used to check if the user has passed 30 points so they can gain a missing heart back

  int spawnRate; // used as the rate at which random bugs are spawned
  int lastSpawnTime; // used to see how long since last bug spawned

  Health health; // used to display the hearts in the top left
  ScoreBoard scoreBoard; // used to show the score in the top right
  
  boolean gameOver; // tracks whether or not the game is over
  
  // Instantiates the GameController and takes in the PApplet which is the main window for the frogSounds
  GameController(PApplet parent) {
    this.ants = new ArrayList<>();
    this.flies = new ArrayList<>();
    this.wasps = new ArrayList<>();
    this.fireballs = new ArrayList<>();
    this.frogSounds = new FrogSounds(parent);
    this.startingSpeed = 10; // 10 is the max speed that a bug will be spawned with
    this.antsEaten = 0;
    this.fliesEaten = 0;
    this.waspsEaten = 0;
    this.totalPoints = 0;
    this.pointsPerAnt = 2;
    this.pointsPerFly = 1;
    this.pointsPerWasp = 3;
    this.previousHealthPoints = 0;
    this.spawnRate = 4000; // initial spawn rate in milliseconds
    this.lastSpawnTime = millis();
    this.health = new Health();
    this.scoreBoard = new ScoreBoard();
    this.gameOver = false;
  }
  
  // Generates a random bug, or set of bugs when the spawntimer counts down
  void bugGenerator() {
    // subtract the last spawn time from current time, and if it is greater than spawnrate
    // generate a bug
    if (millis() - lastSpawnTime > spawnRate) {
      int bugType = int(random(6));
      switch (bugType) {
        case 0:
          addAnt();
          break;
        case 1:
          addFly();
          break;
        case 2:
          addWasp();
          break;
        case 3:
          addAnt();
          addWasp();
          break;
        case 4:
          addAnt();
          addFly();
          break;
        case 5:
          addWasp();
          addFly();
          break;
      }
      lastSpawnTime = millis(); // sets the lastSpawnTime to current millis when a bug is generated
      adjustSpawnRate(); // calls adjustSpawnRate once every loop
    }
  }

  // adjusts the spawn rate as bugs get eaten
  void adjustSpawnRate() {
    int totalEaten = antsEaten + fliesEaten + waspsEaten; // total bugs eaten
    spawnRate = max(700, 4000 - totalEaten * 50); // Decrease spawn rate by 50 ms for each bug eaten, with a minimum of .7 seconds.
  }

  // adds an ant to the arrayList ants
  void addAnt() {
    // set the ant x to the left side of the window
    float antX = 0; // initial antX on the left side
    float antY = height - 30; // antY is always the same so it sits on the ground
    boolean isFacingRight = leftOrRight(); // calls isFacing right which randomly gives a true or false. If it is true, x is not changed.
    if (!isFacingRight) {
      // if isFacingRight is false, set antX to the right side of the window
      antX = width;
    }
    // add a new ant to the arraylist and pass in isFacingright so it knows which way to move.
    // pass in getSpeed() which gives a random speed between 5 and startingSpeed
    ants.add(new Ant(antX, antY, getSpeed(), isFacingRight));
  }

  // adds a fly to the arrayList flies
  void addFly() {
    float flyX = 0; // default fly to left side of window
    float flyY = random(height / 3, (height / 2) + 1); // give the fly a random y coordinate in the range
    boolean isFacingRight = leftOrRight();  // calls isFacing right which randomly gives a true or false. If it is true, x is not changed.
    if (!isFacingRight) {
      // if isFacingRight is false, set flyX to the right side of the window
      flyX = width;
    }
    // add a new fly to the arraylist and pass in isFacingright so it knows which way to move.
    // pass in getSpeed() which gives a random speed between 5 and startingSpeed
    flies.add(new Fly(flyX, flyY, getSpeed(), isFacingRight));
  }

  // adds a wasp to the arrayList wasps
  void addWasp() {
    float waspX = 0; // default wasp to left side of window
    float waspY = random(height / 3, height / 2 + 1); // give the wasp a random y coordinate in the range
    boolean isFacingRight = leftOrRight(); // calls isFacing right which randomly gives a true or false. If it is true, x is not changed.
    if (!isFacingRight) {
      // if isFacingRight is false, set waspX to the right side of the window
      waspX = width;
    }
    // add a new wasp to the arraylist and pass in isFacingright so it knows which way to move.
    // pass in getSpeed() which gives a random speed between 5 and startingSpeed
    wasps.add(new Wasp(waspX, waspY, getSpeed(), isFacingRight));
  }

  // adds a fireball to the arrayList fireballs
  // takes in the x and y value, which will be the wasps's x and y values since fireballs only fall from wasps
  void dropFireball(float x, float y) {
    // adds a new fireball to the arraylist
    fireballs.add(new Fireball(x, y, 5));
  }

  // returns a true or false to be used for the facingRight/movingRight variable in the bugs
  boolean leftOrRight() {
    int randomInt = int(random(2)); // sets randomInt to 0 or 1
    return randomInt == 0; // returns true if 0, false if 1
  }

  // returns a random number for speed between 5 and startingSpeed
  float getSpeed() {
    return random(5, startingSpeed);
  }

  // displays and moves all of the bugs and fireballs in the arraylists
  // the "brains" of the code controlling everything
  void update(Frog frog) {    
    // checks if the health is empty, and if so gameOver is set to true;
    if(!health.hasHealthLeft()){
      gameOver = true;
    }  
    
    // displays the health
    health.display();

    // displays the scoreboard and updates points
    scoreBoard.display();
    scoreBoard.updatePoints(totalPoints);

    // gets the currentHealthpoints to be used to check whenever the user passes 30 points
    int currentHealthPoints = totalPoints / 30;

    // if we've crossed 30 points, gain a heart
    if (currentHealthPoints > previousHealthPoints) {
      health.gainHealth(); // adds a heart to the health pool if one is missing
      previousHealthPoints = currentHealthPoints; // sets the new threshhold to count to the next 30 points
    }

    // if ants is not empty, display and move the ants. If any are eaten or hit the frog, remove them from the arraylist to get them off screen.
    if (ants.size() > 0) {
      for (int i = ants.size() - 1; i >= 0; i--) {
        // this is used to create a copy of the ant so that if it is eaten, we can safely remove it from the array
        Ant a = ants.get(i);
      
        // if the ant is eaten, add it to the points and play the frog gulp sound
        if (a.isEaten) {
          antsEaten += 1;
          totalPoints += pointsPerAnt;
          frogSounds.getGulpSound().play();
        }        
        
        // if the ant is eaten, hits the frog, or moves off screen, remove it.
        if (a.isEaten || a.hitFrog || a.x < -200 || a.x > width + 100) {
          ants.remove(i);
        } else {
          // show the ant and have it move
          a.display();
          a.move();
        }
        
        // if the ant collides with the frog and is not attached to the tongue, hit the frog
        if (a.checkCollisionWithFrog(frog) && !a.isHitByTongue) {
          a.hitByTongue(); // sets the ant to the hit animation.  Name is confusing because it has not been hit by the tongue here.
          frog.getHit(); // sets the frog to the hit animation and plays sound
          a.hitFrog = true; // ant's hitFrog is set to true
          health.loseHealth(); // remove one heart
        }
      }
    }
    
    // if there are any fireballs, show and move them
    for (int i = fireballs.size() - 1; i >= 0; i--) {
      // this is used to create a copy of the fireball so that if it hits anything it can be removed
      Fireball f = fireballs.get(i);
      
      // if the fireball hits the ground or the frog, remove it
      if (f.y > height) {
        f.hit();
        fireballs.remove(i);
      } else if (f.hitFrog) {        
        fireballs.remove(i);
      } else {
        // otherwise, display it and move it
        f.display();
        f.move();
      }
      
      // if the fireball hits the frog, play the animations, remove health, and remove the fireball from the arraylist
      if (f.checkCollisionWithFrog(frog)) {
        frog.getHit();
        f.hit();
        f.hitFrog = true;
        health.loseHealth();
        fireballs.remove(i);
      }
    }

    // if there are any flies in the arraylist, display and move them. If they are eaten, or go off screen, remove them.
    if (flies.size() > 0) {
      for (int i = flies.size() - 1; i >= 0; i--) {
        // this is used to create a copy of the fly so that if it hits anything it can be removed
        Fly f = flies.get(i);
        
        // if the fly goes off screen, remove it
        if (f.movingRight && f.x > width + 100) {
          flies.remove(i);
        } else if (!f.movingRight && f.x < -100) {
          flies.remove(i);
        } else if (f.isEaten) { // if the fly is eaten, add the points and play the gulp sound
          fliesEaten += 1;
          totalPoints += pointsPerFly;
          frogSounds.getGulpSound().play();
          flies.remove(i);
        } else {
          // otherwise, display and animate it
          f.display();
          f.move();
        }
      }
    }

    // if there are any wasps in the arraylist, display and move them. If they are eaten, or go off screen, remove them.
    if (wasps.size() > 0) {
      for (int i = wasps.size() - 1; i >= 0; i--) {
        // this is used to create a copy of the wasp so that if it hits anything it can be removed
        Wasp w = wasps.get(i);

        // removes the wasp if it goes off screen
        if (w.movingRight && w.x > width + 100) {
          wasps.remove(i);
        } else if (!w.movingRight && w.x < -100) {
          wasps.remove(i);
        } else if (w.isEaten) {
          // if the wasp is eaten, add the points, play the sound, and remove it
          waspsEaten += 1;
          totalPoints += pointsPerWasp;
          frogSounds.getGulpSound().play();
          wasps.remove(i);
        } else {
          // otherwise display and animate it
          w.display();
          w.move();

          // drops fireballs randomly if the wasp is not immobile
          if (frameCount % w.fireballDropRate == 0 && !w.immobile) {
            dropFireball(w.x, w.y);
          }
        }
      }
    }
  }

  // checks each bug for hit with tongue. If so, start the animation to pull them back to the frog.
  void hitChecker(Frog frog) {
    for (Ant a : ants) {
      if (tongue.checkForHit(a)) {
        a.hitByTongue();
        a.moveToFrog(frog.x, frog.y, tongue.speed);
      }
    }

    for (Fly f : flies) {
      if (tongue.checkForHit(f)) {
        f.hitByTongue();
        f.moveToFrog(frog.x, frog.y, tongue.speed);
      }
    }

    for (Wasp w : wasps) {
      if (tongue.checkForHit(w)) {
        w.hitByTongue();
        w.moveToFrog(frog.x, frog.y, tongue.speed);
      }
    }
  }  
}
