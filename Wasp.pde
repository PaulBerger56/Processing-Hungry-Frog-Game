class Wasp extends Bug {

  float x; // x coordinate
  float y; // y coordinate
  float wingsUpWidth; // width of the image when the wings up costume is used
  float wingsUpHeight; // height of the image when the wings up costume is used
  float wingsDownWidth; // width of the image when the wings down costume is used
  float wingsDownHeight; // height of the image when the wings down costume is used
  float w; // width
  float h; // height
  float speed; // movement speed

  PImage img_wasp_wings_up; // wings up image
  PImage img_wasp_wings_down; // wings down image

  int costume_id; // id to contol which costume is used

  boolean immobile; // checks if the wasp is able to move or not
  int animationDelay; // number of frames used to delay animation
  
  boolean allowUp; // checks if the wing up costume can be used
  boolean movingUp; // checks if the wasp is moving up while moving across the screen
  boolean wingsUp; // used to change the height and width depending on if the wings are up or down

  boolean hitByTongue; // checks if the frog's tongue has hit the wasp
  boolean isEaten; // used to flag when the wasp gets eaten by the frog
  boolean isVisible; // used to go invisible when eaten

  boolean movingRight; // checks if the wasp is movingRight or not

  int fireballDropRate; // used to drop random fireballs

  // takes in x, y, speed, and movingRight so that the Gamecontroller can set it to start on either the right or left side of screen
  Wasp(float x, float y, float speed, boolean movingRight) {
    this.x = x;
    this.y = y;
    // these width and heights were chosen by using trial and error
    this.wingsUpWidth = 100; 
    this.wingsUpHeight = 150;
    this.wingsDownWidth = 150;
    this.wingsDownHeight = 90;
    this.w = 0;
    this.h = 0;
    this.speed = speed;
    this.img_wasp_wings_up = loadImage("wasp_wings_up.png");
    this.img_wasp_wings_down = loadImage("wasp_wings_down.png");
    this.costume_id = 0;
    this.immobile = false;
    this.animationDelay = 9;    
    this.allowUp = true;
    this.movingUp = true;
    this.wingsUp = true;
    this.hitByTongue = false;
    this.isEaten = false;
    this.movingRight = movingRight;
    this.isVisible = true;
    this.fireballDropRate = int(random(40, 80)); // random droprate between 40 and 80 frames
  }

  // displays the image and change the width and height depending on if the wings are up or down
  void display() {
    if (isVisible) {
      imageMode(CENTER);
      if (wingsUp) {
        w = wingsUpWidth;
        h = wingsUpHeight;
      } else if (!wingsUp) {
        w = wingsDownWidth;
        h = wingsDownHeight;
      }

      image(useCostume(), x, y, w, h);
    }
  }

  // returns costume image depending on current costume_id
  PImage useCostume() {
    switch(costume_id) {
    case 0:
      return img_wasp_wings_up;
    case 1:
      return img_wasp_wings_down;
    default:
      return null;
    }
  }
  
  // calls the appropriate moveLeft or moveRight method.  Made this here to reduce code inside of GameController
  void move() {
    if (movingRight) {
      moveRight();
    } else {
      moveLeft();
    }
  }

  // moves the wasp left and triggers animation
  void moveLeft() {
    if (!immobile) {
      x -= speed;

      if (frameCount % animationDelay == 0) {
        switch(costume_id) {
        case 0:
          costume_id = 1;
          wingsUp = false;
          break;
        case 1:
          costume_id = 0;
          wingsUp = true;
          break;
        }
      }
    }
  }
  
  // moves the wasp right and triggers animation
  void moveRight() {
    if (!immobile) {
      x += speed;

      if (frameCount % animationDelay == 0) {
        switch(costume_id) {
        case 0:
          costume_id = 1;
          wingsUp = false;
          break;
        case 1:
          costume_id = 0;
          wingsUp = true;
          break;
        }
      }
    }
  }

  // switches hitByTongue to true when the user clicks on the wasp and imobilizes it before moving
  void hitByTongue() {
    immobile = true;
    hitByTongue = true;
  }

  // checks for tongue hit
  boolean isHit(float tongueX, float tongueY, float tongueRadius) {
    float distance = dist(x, y, tongueX, tongueY); // calculates the distance between the bug and the tongue
    return distance < min(w, h) / 2 + tongueRadius; // if the tongue is touching, return true, so the tongue has hit the bug
  }

  
  // moves the fly to the frog when it has been hit by the tongue
  void moveToFrog(float frogX, float frogY, float tongueSpeed) {
    float dx = frogX - x; // x distance to frog
    float dy = frogY - y; // y distance to frog
    float distance = dist(x, y, frogX, frogY); // total distance using x and y positions

    // calculate the speed of movement based on the tongue speed so they match up movement
    if (distance > tongueSpeed) {
      float angle = atan2(dy, dx);
      x += cos(angle) * tongueSpeed;
      y += sin(angle) * tongueSpeed;
    } else {
      // returned to frog
      x = frogX;
      y = frogY;
      isEaten = true; // Set flag to true when reaching frog
      isVisible = false; // turn invisible when hitting frog
    }
  }
}
