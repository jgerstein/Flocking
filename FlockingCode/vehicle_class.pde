class Vehicle {
  PVector loc, vel, acc;
  int size;
  float theta;
  float maxSpeed, responsiveness;

  Vehicle(float x, float y) {
    loc =  new PVector(x, y);
    vel = PVector.random2D();
    acc = new PVector(0, 0);
    size = 7;
    theta = vel.heading();
    maxSpeed = 3;
    responsiveness = .01;
  }

  void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(theta);
    noFill();
    stroke(220);
    triangle(-size/2, -size/2, -size/2, size/2, size, 0);
    popMatrix();
  }

  void update() {
    vel.add(acc);
    theta = vel.heading();
    loc.add(vel); 
    //    vel.limit(maxSpeed);
    wrap();
    acc.set(0, 0);
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

  void applyBehaviors(ArrayList<Vehicle> veh) {
    PVector separate = avoid(vehicles);
    PVector cohere = cohere(vehicles);
    PVector seek = seek(mouse);
    PVector align = align(vehicles);
    separate.mult(1.2);
    cohere.mult(2);
    align.mult(1);
    seek.mult(0);
    applyForce(separate);
    applyForce(cohere);
    applyForce(seek);
    applyForce(align);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  PVector align(ArrayList<Vehicle> veh) {
    PVector steer = new PVector();
    float neighborhood =100;
    int count = 0;
    PVector sum = new PVector(0, 0);
    for (Vehicle other : veh) {
      float d = loc.dist(other.loc);
      if (d > 0 && d < neighborhood) {
        sum.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
    }

    steer = PVector.sub(sum, vel);
    steer.normalize();
    steer.mult(responsiveness);
    return steer;
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, vel);
    steer.normalize();
    steer.mult(responsiveness);
    return steer;
  }

  PVector avoid(ArrayList<Vehicle> veh) {
    PVector steer = new PVector();
    float neighborhood = 50;
    PVector sum = new PVector();
    int count = 0;
    for (Vehicle other : veh) {
      float d = loc.dist(other.loc);
      if (d > 0 & d < neighborhood) {
        PVector diff = PVector.sub(loc, other.loc);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
      steer = PVector.sub(sum, vel);
      steer.mult(responsiveness);
    }
    return steer;
  }

  PVector cohere(ArrayList<Vehicle> veh) {
    PVector steer = new PVector();
    float separation = size*5;
    float neighborhood = size*10;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Vehicle other : veh) {
      float d = loc.dist(other.loc);
      if (d > separation && d < neighborhood) {
        PVector desired = PVector.sub(other.loc, loc);
        desired.normalize();
        desired.mult(d);
        sum.add(desired);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      
    }
    return seek(sum);
  }
}

