class Bird {
  PVector loc, vel, acc;
  int size;
  float maxspeed;
  float maxforce;

  Bird(float x, float y) {
    loc = new PVector(x, y);
    vel = PVector.random2D();
    acc = new PVector();
    size = 10;
    maxspeed = 5;
    maxforce = .06;
  }

  void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(vel.heading());
    stroke(255);
    strokeWeight(3);
    fill(150);
    triangle(-size/2, -size/2, -size/2, size/2, size, 0);
    popMatrix();
  }
  void update() {
    maxspeed =map(bars[3].position(), 0, 1, 0, 15);
    maxforce = map(bars[4].position(),0,1,0,.4);
    vel.add(acc);
    vel.limit(maxspeed);
    loc.add(vel);
    wrap();
    acc.set(0, 0);
  }

  void flock(ArrayList<Bird> everyone) {

    PVector coh = cohere(everyone);
    PVector avo = avoid(everyone);
    PVector ali = align(everyone);

    coh.mult(map(bars[0].position(), 0, 1, 0, 2.5));
    avo.mult(map(bars[1].position(), 0, 1, 0, 2.5));
    ali.mult(map(bars[2].position(), 0, 1, 0, 2.5));

    applyForce(coh);
    applyForce(avo);
    applyForce(ali);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(maxspeed); 
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce);
    return steer;
  }
  PVector avoid(ArrayList<Bird> everybody) {
    int count = 0;
    int neighborhood = 50;
    PVector sum = new PVector();
    for (Bird other : birds) {
      float d = loc.dist(other.loc);
      if (d > 0 && d < neighborhood) {
        PVector diff = PVector.sub(loc, other.loc);
        diff.normalize();
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxforce);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }
  PVector align(ArrayList<Bird> everybody) {
    int count = 0;
    int neighborhood = 100;
    PVector sum = new PVector();
    for (Bird other : birds) {
      float d = loc.dist(other.loc);
      if (d > 0 && d < neighborhood) {
        sum.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxforce);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }

  PVector cohere(ArrayList<Bird> everybody) {
    int count = 0;
    int neighborhood = 100;
    PVector sum = new PVector();
    for (Bird other : birds) {
      float d = loc.dist(other.loc);
      if (d > 0 && d < neighborhood) {
        sum.add(other.loc);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      PVector desired = PVector.sub(sum, loc);
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxforce);
      return steer;
    }
    else {
      return new PVector(0, 0);
    }
  }

  void wrap() {
    if (loc.x < 0) {
      loc.x = width;
    }
    if (loc.x > width) {
      loc.x = 0;
    }
    if (loc.y < 0) {
      loc.y = height;
    }
    if (loc.y > height) {
      loc.y = 0;
    }
  }
}

