interface ButtonAction {
  void performAction();
}

abstract class Button implements ButtonAction {
  private Position position;
  private Dimension dimension;
  private String text;

  public Button(Position position, Dimension dimension, String text) {
    this.position = position;
    this.dimension = dimension;
    this.text = text;
  }

  public Position getPosition() {
    return position;
  }

  public Dimension getDimension() {
    return dimension;
  }

  public String getText() {
    return text;
  }

  public void display() {
    rectMode(CENTER);
    rect(position.getX(), position.getY(), dimension.getWidth(), dimension.getHeight());
    fill(0);
    textSize(15);
    textAlign(CENTER, CENTER);
    text(text, position.getX(), position.getY());
    fill(255);
  }
}

abstract class Point {
  private float x;
  private float y;

  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }
}

class Point2D extends Point {
  public Point2D(float x, float y) {
    super(x, y);
  }
}

class Point3D extends Point {
  private float z;

  public Point3D(float x, float y, float z) {
    super(x, y);
    this.z = z;
  }

  public float getZ() {
    return z;
  }
}

class Position {
  private float x;
  private float y;

  public Position(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }
}

class Dimension {
  private float width;
  private float height;

  public Dimension(float w, float h) {
    this.width = w;
    this.height = h;
  }

  public float getWidth() {
    return this.width;
  }

  public float getHeight() {
    return this.height;
  }
}

class ButtonCreateShape extends Button {
  public ButtonCreateShape(Position position, Dimension dimension, String text) {
    super(position, dimension, text);
  }

  public void performAction() {
    LocalDateTime dateTime = LocalDateTime.now();
    DateTimeFormatter format = DateTimeFormatter.ofPattern("dd-MM-yyyy_HH-mm-ss");
    String formattedDate = dateTime.format(format);
    
    translate(width/2, height/2);
    genFigure = createShape();
    genFigure.beginShape(TRIANGLE_STRIP);
    ArrayList<ArrayList<Point3D>> rotatedPoints = new ArrayList<ArrayList<Point3D>>();
    for (int theta = 0; theta <= 360; theta++) {
      rotatedPoints.add(new ArrayList<Point3D>());
      for (Point3D point : points) {
        float x1 = point.getX();
        float y1 = point.getY();
        float z1 = point.getZ();
        float x2 = x1 * cos(theta) - z1 * sin(theta);
        float z2 = x1 * sin(theta) + z1 * cos(theta);
        ArrayList<Point3D> aux = rotatedPoints.get(theta);
        aux.add(new Point3D(x2, y1, z2));
      }
    }

    for (int i = 0; i < rotatedPoints.size()-1; i++) {
      boolean isEven = false;
      if (i % 2 == 0) isEven = true;
      for (int j = 0; j < points.size(); j++) {
        float x1, y1, z1;
        float x2, y2, z2;
        if (isEven) {
          x1 = rotatedPoints.get(i).get(j).getX();
          y1 = rotatedPoints.get(i).get(j).getY();
          z1 = rotatedPoints.get(i).get(j).getZ();
          x2 = rotatedPoints.get(i+1).get(j).getX();
          y2 = rotatedPoints.get(i+1).get(j).getY();
          z2 = rotatedPoints.get(i+1).get(j).getZ();
        } else {
          x1 = rotatedPoints.get(i).get(points.size()-1 - j).getX();
          y1 = rotatedPoints.get(i).get(points.size()-1 - j).getY();
          z1 = rotatedPoints.get(i).get(points.size()-1 - j).getZ();
          x2 = rotatedPoints.get(i+1).get(points.size()-1 - j).getX();
          y2 = rotatedPoints.get(i+1).get(points.size()-1 - j).getY();
          z2 = rotatedPoints.get(i+1).get(points.size()-1 - j).getZ();
        }

        genFigure.vertex(x1, y1, z1);
        genFigure.vertex(x2, y2, z2);
      }
    }
    genFigure.endShape(CLOSE);
    lights();
    beginRecord("nervoussystem.obj.OBJExport", "data/" + formattedDate + ".obj");
    box(100);
    endRecord();
    points = new ArrayList<Point3D>();
  }
}

class ButtonCleanShapes extends Button {
  public ButtonCleanShapes(Position position, Dimension dimension, String text) {
    super(position, dimension, text);
  }

  public void performAction() {
    background(100);
    points = new ArrayList<Point3D>();
  }
}

class ButtonLoadShape extends Button {
  public ButtonLoadShape(Position position, Dimension dimension, String text) {
    super(position, dimension, text);
  }

  public void performAction() {
    background(100);
    points = new ArrayList<Point3D>();
    selectInput("Select a .obj shape", "fileSelected", dataFile("data/"));
  }
}

void fileSelected(File file) {
  if (file != null) {
    println(file.getAbsolutePath());
    genFigure = loadShape(file.getAbsolutePath());
    println(genFigure);
    lights();
    shape(genFigure);
  }
}
