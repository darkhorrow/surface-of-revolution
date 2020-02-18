ArrayList<Point3D> points;
ArrayList<Button> buttons;
int pointsCount = 0;
PShape drawnShape;
PShape genFigure;

void setup() {
  size(1024, 768, P3D);
  points = new ArrayList<Point3D>();
  buttons = new ArrayList<Button>();
  genFigure = createShape();
  buttons.add(new ButtonCreateShape(new Position(width - 60, 30), new Dimension(100, 50), "Create shape"));
  buttons.add(new ButtonCleanShapes(new Position(width - 60, 100), new Dimension(100, 50), "Clear screen"));
}

void draw() {
  background(100);
  stroke(255);
  line(width/2, 0, width/2, height);
  displayButtons();
  
  pushMatrix();
  translate(width/2, height/2);
  lights();
  shape(genFigure);
  popMatrix();
  
}

void mouseClicked() {
  checkHoverButtons();
}

void drawLine() {
  if (points.size() > 1) {
    Point3D prevPoint = points.get(points.size()-2);
    Point3D newPoint = points.get(points.size()-1);
    drawnShape = createShape(LINE, prevPoint.getX(), prevPoint.getY(), newPoint.getX(), newPoint.getY());
    drawnShape.setStroke(color(255,0,0));
    translate(width/2, height/2);
    shape(drawnShape);
  }
}

void displayButtons() {
  for (Button button : buttons) {
    button.display();
  }
}

void checkHoverButtons() {
  boolean buttonPressed = false;
  for (Button button : buttons) {
    float x = button.getPosition().getX();
    float y = button.getPosition().getY();
    float w = button.getDimension().getWidth();
    float h = button.getDimension().getHeight();
    if (mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2) {
      button.performAction();
      buttonPressed = true;
    }
  }
  if (!buttonPressed) points.add(new Point3D(mouseX - width/2, mouseY - height/2, 0));
}
