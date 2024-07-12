class Crosshair {

  float x; // x coordinate
  float y; // y coordinate
  float w; // width
  float h; // height
  PImage img_crosshair; // crosshair image
  
  // instantiates the crosshair, shows the image, and sets it to the middle of the screen
  Crosshair() {
    this.x = width/2;
    this.y = height/2;
    this.w = 90;
    this.h = 104;
    img_crosshair = loadImage("crosshair.png");
  }

  // shows the crosshair
  void display() {
    imageMode(CENTER);
    image(img_crosshair, x, y, w, h);
  }

  //follows the mouse movement
  void move() {
    this.x = mouseX;
    this.y = mouseY;
  }
}
