ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
PVector wind = new PVector(.001, -.003);
PVector mouse = new PVector();

void setup() {
  size(500, 500);
  for (int i = 0; i < 50; i++) {
    vehicles.add(new Vehicle(random(width), random(height)));
  }
}

void draw() {
  mouse.set(mouseX, mouseY);
  background(0);
  for (Vehicle v : vehicles) {
    v.display();
    v.avoid(vehicles);
    v.cohere(vehicles);
    //    v.seek(mouse);
    v.applyForce(wind);
    v.update();
  }
}

void mousePressed(){
 vehicles.add(new Vehicle(mouseX,mouseY)); 
}


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

  void applyForce(PVector force) {
    acc.add(force);
  }

  void seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, vel);
    steer.normalize();
    steer.mult(responsiveness);
    applyForce(steer);
  }

  void avoid(ArrayList<Vehicle> veh) {
    float separation = size*3;
    PVector sum = new PVector();
    int count = 0;
    for (Vehicle other : veh) {
      float d = loc.dist(other.loc);
      if (d > 0 & d < separation) {
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
      PVector steer = PVector.sub(sum, vel);
      steer.mult(responsiveness);
      applyForce(steer);
    }
  }

  void cohere(ArrayList<Vehicle> veh) {
    float separation = 100;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Vehicle other : veh) {
      float d = loc.dist(other.loc);
      if (d > separation) {
        PVector desired = PVector.sub(other.loc, loc);
        desired.normalize();
        desired.mult(d);
        sum.add(desired);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum, vel);
      steer.mult(responsiveness);
      applyForce(steer);
    }
  }
}

