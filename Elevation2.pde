float rotationX = 1;
float rotationY = 0;
float rotationZ = 0;

float translationX = 0;
float translationY = 0;
float translationZ = 0;

float zoom = 1;

float increment = 0.01;
int value;

color blue = color(65, 105, 225);
color beach = color(238, 214, 175);
color green = color(34, 140, 34); //34, 139, 34
color darkgreen = color(34, 100, 34);
color mountain = color(139, 137, 137);
color snow = color(255, 240, 255);

int cols, rows;
int scl = 20; //20
int w = 1600; //1600
int h = 1600; //1600

float[][] terrain;

//String name;

void setup() {
  size(800, 800, P3D);
  stroke(200, 30, 30);
  
  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];
  
  loadPixels();
  
  float xoff = 0.0; //Starting the xoff at 0
  float detail = map(width/1.3, 0, width, 0.1, 0.6);
  noiseDetail(8, detail);
  
  for(int x = 0; x < width; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < height; y++) {
      yoff += increment;
      
      float brightness = noise(xoff,yoff) * 255;
      
      //Archipelago
      //brightness = brightness + (0.25 * sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));
      
      //Coastline? Needs some work.
      //brightness = brightness + (0.1 * sqrt(pow(x - width, 2)));
         
      //Big lake in the middle?
      //brightness = brightness + (10000 / sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));
      
      //Island
      brightness -= (200 - sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));; //Originally 100...
      
      
      if(brightness <= 50) {
        pixels[x+y*width] = snow;
      } else if (brightness > 50 && brightness <= 60) {
        pixels[x+y*width] = mountain;
      } else if (brightness > 60 && brightness <= 90) {
        pixels[x+y*width] = darkgreen;
      } else if (brightness > 90 && brightness <= 120) {
        pixels[x+y*width] = green;
      } else if (brightness > 120 && brightness <= 125) {
        pixels[x+y*width] = beach;
      } else {
        pixels[x+y*width] = blue;
      }
      
      int sc = 10;
      
      if(x % sc == 0 && y % sc == 0) {
        terrain[(int)x / sc][(int)y / sc] = 260 - (brightness);
        //if(brightness > 105) {
          //terrain[(int)x / sc][(int)y / sc] = 105; //110
        //}
      }
      
    }
  }
 updatePixels();
}

void draw() {

  background(0);
  stroke(220);
  noFill();

  translate(width/2, height/2); //translate(width/2, height/2+50);
  rotateX(PI / 3);
  translate(-w/2, -h/2); //(-w/2, -h/2);
  translate(translationX, translationY);
  rotateZ(rotationZ);
  rotationZ += PI/400;
  scale(zoom, zoom, zoom);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP); //beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      
      fill(100, 300 - terrain[x][y], 100); 
      
      setColor(terrain[x][y]);
      
      vertex(x*scl - width, y*scl - width, terrain[x][y]);
      vertex(x*scl - width, (y+1)*scl - width, terrain[x][y+1]);
    }
    endShape();
  }
  fill(blue);
  beginShape(QUADS);
    vertex(-width * 100,-width * 100,100);
    vertex(-width * 100, width * 100,100);
    vertex( width * 100, width * 100,100);
    vertex( width * 100,-width * 100,100);
  endShape();
}

void keyPressed() {
  if(key == 'w') {
    translationY += 50;
  } else if (key == 's') {
    translationY -= 50;
  } else if (key == 'a') {
    translationX += 50;
  } else if (key == 'd') {
    translationX -= 50;
  } else if (key == 'q') {
    //translationX = width / 2;
    rotationZ += PI/12;
  } else if (key == 'e') {
    rotationZ -= PI/12;
  } else if (key == 'z') {
    zoom += 0.1;
  } else if (key == 'x') {
    zoom -= 0.1;
  }
}

void setColor(float h) {
  if(h >= 250) {
        fill(snow);
      } else if (h > 200 && h <= 250) {
        fill(mountain);
      } else if (h > 140 && h <= 200) {
        fill(darkgreen);
      } else if (h > 110 && h <= 140) {
        fill(green);
      } else if (h > 105 && h <= 110) {
        fill(beach);
      } else {
        fill(beach);
      }
}