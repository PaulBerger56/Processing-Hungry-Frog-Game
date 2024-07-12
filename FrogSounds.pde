import processing.sound.*;

// used as a way to hold all the sounds and load them in seperately to keep code neater
class FrogSounds {
  ArrayList<SoundFile> hitSounds; // arrayList to hold sounds
  PApplet parent; // instance of the main window

  // instantiates frogsounds, takes in an instance of the main window, and adds the 5 hit sounds to the array
  FrogSounds(PApplet parent) {
    this.parent = parent;
    this.hitSounds = new ArrayList<>();
    this.hitSounds.add(new SoundFile(parent, "frog_hit_one.wav"));
    this.hitSounds.add(new SoundFile(parent, "frog_hit_two.wav"));
    this.hitSounds.add(new SoundFile(parent, "frog_hit_three.wav"));
    this.hitSounds.add(new SoundFile(parent, "frog_hit_four.wav"));
    this.hitSounds.add(new SoundFile(parent, "frog_hit_five.wav"));
  }
  
  // returns the arraylist of hit sounds
  ArrayList<SoundFile> getFrogHitSounds() {
    return this.hitSounds;
  }
  
  // reads in and returns the gulp sound when the frog eats
  SoundFile getGulpSound() {
    return new SoundFile(parent, "gulp.wav");
  }
}
