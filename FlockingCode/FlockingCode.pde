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
    v.applyBehaviors(vehicles);
    v.update();
  }
}

void mousePressed() {
  vehicles.add(new Vehicle(mouseX, mouseY));
}

