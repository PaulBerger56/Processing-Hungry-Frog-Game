import processing.sound.*; // import to be able to play sounds

PImage img_pond; // pond background image

Crosshair crosshair;  // crosshair object
Frog frog; // frog object
Tongue tongue; // tongue object
GameController gameController; // gameController object

Fly fly; // fly object used in gameOver screen
Ant ant; // ant object used in gameOver screen
Wasp wasp; // wasp object used in gameOver screen

int timeSurvived;  // time the player survived
int startTime; // time when the game starts
int endTime; // time when the game ends

int screenIndex; // number used to control which screen is shown

SoundFile game_over_sound; // game over sounds used for gameOver screen

// setup the window and set up the variables
void setup() {
  size(1200, 700);
  frameRate(60);
  noCursor(); // hides the mouse
  img_pond = loadImage("pond.png");  
  crosshair = new Crosshair();
  frog = new Frog(this);
  tongue = new Tongue(frog.x, frog.y);
  gameController = new GameController(this);
  screenIndex = 0; // set the index to the starting screen
  fly = new Fly(width/2 - 50, height/2, 0, false);
  ant = new Ant(width/2 - 50, height/2 + 100, 0, false);
  wasp = new Wasp(width/2 - 50, height/2 + 250, 0, false);
  timeSurvived = 0;
  startTime = 0;
  endTime = 0;
  this.game_over_sound = new SoundFile(this, "game_over.mp3");
}

// continuously draws.  Calls the specific screen here and constantly refreshes it
void draw() {  
  if (screenIndex == 0) {
    startScreen();
  } else if (screenIndex == 1) {
    gameScreen();
  } else if(screenIndex == 2) {
    gameOverScreen();
  }  
}

// actual game screen where playing happens
void gameScreen() {  
  imageMode(CORNER);
  image(img_pond, 0, 0, width, height);

  // calls the tongue methods
  tongueUpdater();

  // calls the gameController methods
  gameControllerUpdater();

  // calls the frog methods
  frogUpdater();

  // crosshair always needs to be drawn last so that it covers other images
  crosshairUpdater();
}

// screen you are greeted with on game start
void startScreen() {
  background(0); // black background so the user can easily read the instructions

  // Display "Hungry Frog" at the top center
  fill(255);
  textAlign(CENTER, TOP);
  textSize(80);
  text("Hungry Frog", width/2, 50);

  // Display "Press Enter to start game" in the middle
  textSize(40);
  text("Press Enter to start game", width/2, height - 200);

  // Display Instructions
  
  textSize(30);
  text("Shoot your tongue to eat the bugs and score points.\n| Flies = 1 Point  |  Ants = 2 Points  |  Wasps = 3 Points |\nYou start with 3 Hearts in the top left.\nIf you get hit by an ant or fireball, you will lose one heart.\nLosing all three will result in a Game Over\nEvery 30 points gained will result in gaining a missing heart back\nSee how many points you can earn!", width/2, height/3.5);

  tongueUpdater();
  frogUpdater();
  crosshairUpdater();

  if (keyPressed && key == ENTER) {
    screenIndex = 1;  // Switch to game screen when mouse is pressed
    startTime = millis();
  }
}

void gameOverScreen() {
  imageMode(CORNER);
  image(img_pond, 0, 0, width, height);
  
  fill(255);
  textAlign(CENTER, TOP);
  textSize(80);
  text("Game Over", width/2, 50);
  
  textAlign(CENTER, TOP);
  textSize(30);
  text("Press Spacebar to start a new game", width/2, 130);
  
  timeSurvived = (endTime - startTime) / 1000;
  textSize(40);
  text("Total points: " + gameController.totalPoints + " x Time Survived: " + timeSurvived + "\n= " + gameController.totalPoints * timeSurvived + " Final Score!!!", width/2, height/3.5);
  
  fly.display();
  fly.move();  
  textAlign(LEFT, TOP);
  textSize(40);
  text("X " + gameController.fliesEaten, fly.x + 80, fly.y - 20);
  
  ant.display();
  ant.move();
  textAlign(LEFT, TOP);
  textSize(40);
  text("X " + gameController.antsEaten, ant.x + 80, ant.y);
  
  wasp.display();
  wasp.move();
  textAlign(LEFT, TOP);
  textSize(40);
  text("X " + gameController.waspsEaten, wasp.x + 80, wasp.y);

  crosshairUpdater();
  
  // if spacebar is pressed, reset all of the scores and instantiate a new gamecontroller to reset all of it's variables.
  if (keyPressed && key == ' ') {
    screenIndex = 0;  // return to startingScreen
    startTime = 0;
    endTime = 0;
    timeSurvived = 0;
    gameController = new GameController(this);
  }
}

// does all the frog updates
void frogUpdater() {
  // checks if the frog is in the mobile or immobile state every frame and displays it
  frog.immobileUpdate(tongue);
  frog.display();

  // putting this in draw rather than it's own keyPressed() method seems to reduce input delay
  if (keyPressed) {
    frog.moving = true;
    if (key == 'a' || key == 'A') {
      frog.moveLeft();
    } else if (key == 'd' || key == 'D') {
      frog.moveRight();
    }
  } else if (!keyPressed) {
    frog.moving = false;
  }
}

// does all the crosshair updates
void crosshairUpdater() {
  // displays the crosshair and calls the move method
  crosshair.display();
  crosshair.move();
}

// does all the tongue updates
void tongueUpdater() {
  if (mousePressed) {
    tongue.shootTo(mouseX, mouseY);
    frog.shootTongue();
  }

  tongue.updateFrogPosition(frog.x, frog.y);
  tongue.display();
}

// does all the gameController updates
void gameControllerUpdater() {
  
  // If gameOver is true, switch to the gameover screen and get the final millis
  if(gameController.gameOver){
    endTime = millis();
    game_over_sound.play();
    screenIndex = 2;    
  }
  // controls the bugs spawning
  gameController.update(frog);
  gameController.hitChecker(frog);
  gameController.bugGenerator();
}
