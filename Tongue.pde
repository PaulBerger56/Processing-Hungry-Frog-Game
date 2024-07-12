class Tongue {
  float frogX; // frog's x coordinate
  float frogY; // frog's y coordinate
  float endX; // end of tongue x
  float endY; // end of tongue y
  float targetX; // target/crosshair x
  float targetY; // target/crosshair y
  float tongueRadius; // tongue is made up of circles, so this is the radius
  float segments; // number of segments making up the tongue
  float speed; // shooting speed
  boolean isShooting; // tracks whether or not the tongue is shooting
  boolean isRetracting; // tracks whether or not the tongue is retracting
  boolean isVisible; // tracks whether the tongue is shown or not
  
  
  // instantiates the tongue and takes in the initial frog x and y
  Tongue(float frogX, float frogY) {
    this.frogX = frogX;
    this.frogY = frogY;
    this.endX = frogX;
    this.endY = frogY;
    this.tongueRadius = 10;
    this.segments = 500;
    this.speed = 50;
    this.isShooting = false;
    this.isRetracting = false;
    this.isVisible = false;    
  }

  // takes in the mouseX and mouseY so the end of the tongue can be shot to the location
  void shootTo(float mouseX, float mouseY) {
    this.targetX = mouseX;
    this.targetY = mouseY;
    this.isShooting = true;
    this.isRetracting = false;
    this.isVisible = true;
  }

  // updates the tongue so that it can move to the mouse location.
  // also sets the isShooting and isRectracting variables to keep track of the motion
  void update() {
    if (isShooting) {
      float dx = targetX - endX; // distance between the target/crosshar x and the end of the tongue x
      float dy = targetY - endY; // distance between the target/crosshar y and the end of the tongue y
      float distance = dist(endX, endY, targetX, targetY); // distance using the x and y values
      
      // shoots the tongue at the proper angle towards the target
      if (distance > speed) {
        float angle = atan2(dy, dx); // gets the angle that the tongue needs to shoot
        endX += cos(angle) * speed; // moves the x times the speed
        endY += sin(angle) * speed; // moves the y times the speed
      } else {
        // when tongue hits it's destination, change it from shooting to retracting
        endX = targetX;
        endY = targetY;
        isShooting = false;
        isRetracting = true;
      }
    } else if (isRetracting) {
      // move the tongue back to the frog
      float dx = frogX - endX; // distance from the end of tongue x to the frog x
      float dy = frogY - endY; // distance from the end of tongue y to the frog y
      float distance = dist(endX, endY, frogX, frogY); // distance using the x and y values
      
      // brings the tongue back to the frog
      if (distance > speed) {
        float angle = atan2(dy, dx); // gets the angle that the tongue needs to retract
        endX += cos(angle) * speed; // moves the x times the speed
        endY += sin(angle) * speed; // moves the y times the speed
      } else {
        // when the tongue returns to the frog, set isRetracting and invisible to false so that the dot doesn't show when the frog moves
        endX = frogX;
        endY = frogY;
        isRetracting = false;
        isVisible = false;
      }
    }
  }

  // displays the tongue if isVisible is true.  This is done so the original dot does not stay on screen after the frog moves.
  void display() {
    if (!isVisible) {
      return;
    }

    update(); // calls the update method inside of display so that it is called every frame
    
    // creates the pink circles that overlap so that they look like a tongue
    for (int i = 0; i < segments; i++) {
      float t = i / (segments - 1.0); // get the amount
      float x = lerp(frogX, endX, t); // x coordinates of the dots between the frog and destination
      float y = lerp(frogY, endY, t); // y coordinates of the dots between the frog and destination
      fill(255, 182, 193);  // Light pink color
      noStroke(); // removes the border line
      ellipse(x, y, tongueRadius * 2, tongueRadius * 2); // draws the cirlces
    }
  }

  // the one function that utilizes the abstact bug class.  Made it easier than writing code to allow one of each type.
  // returns true if bug is hit
  boolean checkForHit(Bug bug) {
    return bug.isHit(endX, endY, tongueRadius);
  }

  // keeps updating the position so that even when invisible, the tongue follows the frog position
  // if not moved, it will sit in a spot invisible and an ant can hit it and trigger animations
  void updateFrogPosition(float newFrogX, float newFrogY) { // called in the main class
    this.frogX = newFrogX;
    this.frogY = newFrogY;
    if (!isShooting && !isRetracting) {
      this.endX = newFrogX;
      this.endY = newFrogY;
    }
  }
}
