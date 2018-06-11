// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  int size;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.01);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    location = l;
    lifespan = random(10, 255);
    size = (int)random(2, 10);
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0;
  }

  // Method to display
  void display() {
    //stroke(255,lifespan);
    //fill(255,lifespan);
    //ellipse(location.x,location.y,8,8);

    offscreen.stroke(255, lifespan);
    offscreen.fill(255, lifespan);

    if (cycle) {   
      offscreen.stroke((frameCount*0.2)%255, 255, lifespan);
      offscreen.fill((frameCount*0.2)%255, 255, lifespan);
    }

    offscreen.ellipse(location.x, location.y, size, size);

  }


    // Is the particle still useful?
    boolean isDead() {
      if (lifespan < 0.0) {
        return true;
      } else {
        return false;
      }
    }
  }