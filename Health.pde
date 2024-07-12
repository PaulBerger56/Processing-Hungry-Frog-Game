class Health {

  float x; // x coordinate
  float y; // y coordinate
  float w; // width
  float h; // height
  float heartW; // heart image width
  float heartH; // heart image height
  int maxHearts; // max hearts, in this case constantly set to 3
  int currentHealth; // current amount of hearts
  ArrayList<Heart> hearts; // arraylist to hold the hearts

  // instantiates the Health class and fils hearts with the inital 3 hearts
  Health() {
    this.x = 20;
    this.y = 20;
    this.w = 300;
    this.h = 120;
    this.heartW = 80;
    this.heartH = 80;
    this.maxHearts = 3;
    this.currentHealth = maxHearts;
    this.hearts = new ArrayList<>();
    initializeHearts();
  }
  
  // adds the initial 3 hearts and adds them to the hearts array
  void initializeHearts() {
    float heartSpacing = (w - maxHearts * heartW) / (maxHearts - 1); // calculates the amount of space to put between hearts
    for (int i = 0; i < maxHearts; i++) {
      // adds new hearts while calculating the space between each
      hearts.add(new Heart(x + i * (heartW + heartSpacing), y, heartW, heartH));
    }
  }

  // displays the hearts in the hearts array
  void display() {
    // only displays the hearts up to the currentHealth number
    // instead of adding and removing hearts, we just display up to the currentHealth
    for (int i = 0; i < currentHealth; i++) {
      hearts.get(i).display();
    }
  }
  
  // loses a heart as long as there is at least 1 left
  void loseHealth() {
    if (currentHealth > 0) {
      currentHealth--;
    }
  }
  
  // gains a heart as long as there is 1 missing
  void gainHealth() {
    if (currentHealth < maxHearts) {
      currentHealth++;
    }
  }
  
  // returns a true or false whether or not there is more than 0 hearts left
  boolean hasHealthLeft(){
    return currentHealth > 0;
  }
}
