ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
PVector target;

void setup() {
  size(500, 500);
  for (int i = 0; i < 20; i++) {
    vehicles.add(new Vehicle(random(width), random(height)));
  }
  target = new PVector();
}

void draw() {
  target.set(mouseX, mouseY);
  background(0);
  for (Vehicle v : vehicles) {
    v.display();
    v.seek(target);
    v.update();
  }
}

class Vehicle {
  PVector loc, vel, acc;
  int size;
  float theta;
  float topSpeed;
  float responsiveness;

  Vehicle(float x, float y) {
    loc = new PVector(x, y);
    vel = PVector.random2D();
    acc = new PVector(0, 0);
    theta = vel.heading();
    size = 20;
    topSpeed = 3;
    responsiveness = .03;
  }
  void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(theta);
    triangle(-size/2, -size/2, -size/2, size/2, size, 0);
    popMatrix();
  }

  void update() {
    vel.add(acc);
    theta = vel.heading();
    loc.add(vel);
    acc.set(0, 0);
  }

  void separate(ArrayList<Vehicle> veh) {
    float spacing = size*1.5;
    for (Vehicle other : vehicles) {
      float d = loc.dist(other.loc);
      if (d > 0 && d < spacing) {
        //figure out what to do to separate
      }
    }
  }


  void seek(PVector destination) {
    PVector desired = PVector.sub(destination, loc);
    desired.normalize();
    desired.mult(topSpeed);
    PVector steer = PVector.sub(desired, vel);
    //    steer.normalize();
    steer.mult(responsiveness);
    applyForce(steer);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }
}

