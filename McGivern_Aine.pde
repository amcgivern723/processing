PImage img;
Table table;
float wheelCount = 0;
float lastClick = millis();
//Pan & Zoom Varibles
float minScale, maxScale;
float scale = 0.1;
float xPan, yPan;
//float tx, ty;
float xOffset = 0.0;
float yOffset = 0.0;
boolean zoomIn = false;
boolean zoomOut = false;
boolean panUp = false;
boolean panDown = false ;
boolean panLeft = false;
boolean panRight = false;
float panSpeed = 5;
float zoomSpeed = 0.01;

float rotx = PI/4;
float roty = PI/4;

float x,y,z;
float w, h;

boolean filter = false;

boolean census1991 = false;
boolean census2001 = false;
boolean census2011 = false;

int bX, bY;
int bSize = 40;
color bColor;

void setup() {
  size(600, 600, P3D);
  
  table = loadTable ("Data.csv", "header");

  img = loadImage("uk-admin.jpg");
  
  textureMode(NORMAL);
  
  bColor = color(0);
  
  bX = width-(bSize*2);
  bY = height-(bSize*2);
  
  for (TableRow row : table.rows()) {
    int No = row.getInt("No");
    String City = row.getString("City");
    String Census1991 = row.getString("Census1991");
    String Census2001 = row.getString("Census2001");
    String Census2011 = row.getString("Census2011");
    
    println(No);
    println(City);
    println("Census 1991:", Census1991);
    println("Census 2001:", Census2001);
    println("Census 2011:", Census2011);
  }
  println("Use the arrow keys to pan around the map");
  println("Press 'Z' to Zoom In and 'O' to Zoom Out");
  println("Left Click the mouse while moving it to Pan");
  println("Use the Mouse Wheel to zoom in and out");
  println("Press '1' to view the Census from 1991");
  println("Press '2' to view the Census from 2001");
  println("Press '3' to view the Census from 2011");
  println("Double Click the left mouse button to take a snapshot");
  println("Press the Filter button to only show Census Values over 95000");
  println("Press 'r' to remove Census data from the map");
  println("Scroll up in the console to view the exact population figures for each city in each Census");
  //minumum scale is calculated to prevent texture wrapping
  minScale = 0.1;//max((float(width) / img.width), (float(height) / img.height));
  maxScale = 5;
 }

void draw() {
  background(#a8cdea);
  imageMode (CENTER);
  translate(width*0.5, height*0.5, 10);//translate the transformation point to the centre of the screen
  translate(-xPan, -yPan);
  rotateX(-PI/4);//apply a rotation about the x axis to tilt the plane we will be drawing to
  scale(scale);//you can apply a scaling factor here to suit the size of your img

  translate(-img.width/2, 0, -img.height/2);

  beginShape();
  texture(img);
  vertex(0, 0, 0, 0, 0);//texture uv coordinates are the last two numbers
  vertex(img.width, 0, 0, 1, 0);
  vertex(img.width, 0, img.height, 1, 1);
  vertex(0, 0, img.height, 0, 1);
  endShape();
  
  if (zoomIn) {
    scale +=zoomSpeed;
  }
  if (zoomOut) {
    scale -=zoomSpeed;
  }
  if (panUp) {
    yPan -=panSpeed;
  }
  if (panDown) {
    yPan +=panSpeed;
  }
  if (panLeft) {
    xPan -=panSpeed;
  }
  if (panRight) {
    xPan +=panSpeed;
  }
  
  if (scale < minScale){
    scale = minScale;
  } else if (scale > maxScale){
    scale = maxScale;
  }
  
  if (census1991) {
    for (TableRow row : table.rows()) { 
      float lat = row.getFloat("Latitude");
      float lon = row.getFloat("Longitude");
      float Census1991 = row.getFloat("Census1991");
      float h = Census1991;
      float maxh = pow(10, 7);
      h = map(h, 0, maxh, 10, 100);
      x = lat;
      y = lon;
      z = 0;
      if (filter) {
        if (h < 95000){
          continue;
        }
      }
      pushMatrix();
      translate(y, -z, x);
      fill(255,60,50);
      box(10, h, 10); 
      popMatrix();
    }
  } else if (census2001) {
    for (TableRow row : table.rows()) {
      float lat = row.getFloat("Latitude");
      float lon = row.getFloat("Longitude");
      float Census2001 = row.getFloat("Census2001");
      float h = Census2001;
      float maxh = pow(10, 7);
      h = map(h, 0, maxh, 10, 100);
      x = lat;
      y = lon;
      z = 0;
      if (filter) {
        if (h < 95000){
          continue;
        }
      }
      pushMatrix();
      translate(y, -z, x);
      fill(100,60,50);
      box(10, h, 10);
      popMatrix();
    }
  } else if (census2011) {
    for (TableRow row : table.rows()) {
      float lat = row.getFloat("Latitude");
      float lon = row.getFloat("Longitude");
      float Census2011 = row.getFloat("Census2011");
      float h = Census2011;
      float maxh = pow(10, 7);
      h = map(h, 0, maxh, 10, 100);
      x = lat;
      y = lon;
      z = 0;
      if (filter) {
        if (h < 95000){
          continue;
        }
      }
      pushMatrix();
      translate(y, -z, x);
      fill(205,78,80);
      box(10, h, 10);
      popMatrix();
    }
  }
  fill(bColor);
  stroke(255);
  rect(bX, bY, bSize, bSize);
}      
  // Pan & Zoom Controls
boolean buttonClicked()  {
  if (mouseX >= bX && mouseX <= bX+bSize && 
      mouseY >= bY && mouseY <= bY+bSize) {
    return true;
  } else {
    return false;
  }
}

void keyPressed() {
 if (key == 'Z') {
   zoomIn= true;
   zoomOut= false;
   }
 if (key =='O') {
   zoomIn = false;
   zoomOut = true;
 }
 if (keyCode ==UP) {
   panUp = true;
   panDown= false;
 }
 if (keyCode == DOWN) {
   panDown = true;
   panUp= false;
 }
 if (keyCode == LEFT) {
   panLeft = true;
   panRight= false;
   }
 if (keyCode == RIGHT) {
   panRight = true;
   panLeft= false;
     }

if (key == '1') {
   census1991 = true;
   census2001 = false;
   census2011 = false;

 }
 
 if (key == '2') {
   census1991 = false;
   census2001 = true;
   census2011 = false;

 }
 
 if (key == '3') {
   census1991 = false;
   census2001 = false;
   census2011 = true;

 }
 
 if (key == 'r') {
    census1991 = false;
    census2001 = false; 
    census2011 = false; 
  }
}
//Stops Pan & Zoom when keys are released.
 void keyReleased() {
  if(key == 'Z') {
    zoomIn = false;
  }
    if (key == 'O'){
    zoomOut = false;
  }
     if (keyCode == UP) {
    panUp = false;
  }
    if (keyCode == DOWN) {
    panDown = false;
  }   
    if (keyCode == LEFT) {
    panLeft = false;
  }
   if (keyCode == RIGHT) {
    panRight = false;
    }
}

void doubleClicked(){
  float thisClick = millis();
  if ((thisClick - lastClick) < 200){
    snapView(); 
  }
  lastClick = thisClick;
}

void snapView(){
  PImage slice = createImage(500, 500, ARGB);
  slice = get(mouseX, mouseY, 500, 500);
  slice.save("snapview.png");
  println("Saved");
}

void mousePressed(){
  if (buttonClicked()){
    filter = !filter;
  } else {
    doubleClicked();
    xOffset = mouseX - xPan;
    yOffset = mouseY - yPan;
  }
}

void mouseDragged() {
  //move left-top texcoord using scaled mouse delta 
  xPan = xOffset- mouseX;
  yPan = yOffset - mouseY;
}

void mouseWheel(MouseEvent event) {
  //zoom factor needs to be between about 0.99 and 1.01 to be able to multiply so add 1
  scale += (event.getCount() * zoomSpeed);
}
