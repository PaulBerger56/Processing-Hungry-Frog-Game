class Fireball {
  float x; // x coordinate
  float y; // y coordinate
  float h; // height
  float w; // width
  float speed; // movement speed
  
  PImage img_fireball; // main fireball image
  PImage img_fireball_hit; // hit image for collision

  boolean immobile; // used to allow or stop movement
  boolean hitFrog; // used to check if there is a collision with frog
 
  int costume_id; // used to change costume 
  boolean isVisible; // used to show or hide image

  int animationDelay; // used to set a number of frames between costume switches

  // instantiates the fireball, takes in x and y from the wasp's location, and movement speed
  Fireball(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.h = 46;
    this.w = 28;
    this.speed = speed;
    this.img_fireball = loadImage("fireball.png");
    this.img_fireball_hit = loadImage("fireball_hit.png");
    this.immobile = false;
    this.costume_id = 0;
    this.isVisible = true;
    this.animationDelay = 7;
    this.hitFrog = false;
  }
  
  // displays the image if isVisible is true
  void display() {
    if (isVisible) {
      imageMode(CENTER);
      image(useCostume(), x, y, w, h);
    }
  }

  // returns costume image depending on current costume_id
  PImage useCostume() {
    switch(costume_id) {
    case 0:
      return img_fireball;
    case 1:
      return img_fireball_hit;
    default:
      return null;
    }
  }

  // moves the fireball from the wasp to the ground if immobile is false
  void move() {
    if (!immobile) {
      y += speed;
      if (y >= height) {
        hit(); // causes a hit if the fireball hits the ground
      }
    }
  }

  // Sets the fireball immobile and changes the costume to the hit version
  void hit() {
    immobile = true;
    costume_id = 1;
    hitFrog = true;
  }

  // checks for collision with frog
  boolean checkCollisionWithFrog(Frog frog) {
    float frogLeft = frog.x - frog.w / 2; // left side of frog
    float frogRight = frog.x + frog.w / 2; // right side of frog
    float frogTop = frog.y - frog.h / 2; // top of frog
    float frogBottom = frog.y + frog.h / 2; // bottom of frog

    float fireballLeft = x - w / 2; // left side of fireball
    float fireballRight = x + w / 2; // right side of fireball
    float fireballTop = y - h / 2; // top of fireball
    float fireballBottom = y + h / 2; // bottom of fireball
  
    // returns true if any of the sides overlap with each other
    return !(frogLeft > fireballRight || frogRight < fireballLeft || frogTop > fireballBottom || frogBottom < fireballTop);
  }
}
