//Define Constants
float rotationX = 0;
float rotationY = 0;
float rotationZ = 0;

//Center Island and set Zoom
float translationX = 800;
float translationY = 450;
float translationZ = 0;

float zoom = .8;

//Determine Increment for Noise Generation
float increment = 0.01;

//Assign Boolean Values
boolean spin = false; // If set to true 3D model automatically rotates
boolean first = true; //Set to false after first time Draw() is called, allows 2D to be displayed

//Preset Colors
color blue = color(65, 105, 225, 60);
color beach = color(238, 214, 175);
color green = color(34, 140, 34); //34, 139, 34
color darkgreen = color(34, 100, 34);
color mountain = color(139, 137, 137);
color snow = color(255, 240, 255);

//Set 3D Model Parameters
int cols, rows;
int scl = 20;
int w = 1600;
int h = 1600;

//Determines Z-Value of ocean()
float sealevel = 120; //100

//2D array to hold elevation values
float[][] terrain;

void setup() {
  size(800, 800, P3D);
  stroke(200, 30, 30);
  
  //Set map size
  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];
  
  loadPixels();
  
  //Generate Noise
  float xoff = 0.0;
  float detail = map(width/1.3, 0, width, 0.1, 0.6);
  noiseDetail(8, detail);
  
  for(int x = 0; x < width; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < height; y++) {
      yoff += increment;
      
      float brightness = noise(xoff,yoff) * 255;
      
/** Each of the equations below results in a different 'style' of map.
    Uncomment the relevant line to use, or feel free to experiment **/      
      
      //Archipelago
      //brightness = brightness + (0.25 * sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));
      
      //Coastline? Needs some work.
      //brightness = brightness + (0.1 * sqrt(pow(x - width, 2)));
         
      //Big lake in the middle?
      //brightness = brightness + (10000 / sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));
      
      //Island
      brightness -= (200 - sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));; //Originally 100...
      
      //Crater
      //brightness += (200 - sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));;
      
      if(brightness <= 20) {
        pixels[x+y*width] = snow;
      } else if (brightness > 20 && brightness <= 30) {
        pixels[x+y*width] = mountain;
      } else if (brightness > 30 && brightness <= 70) {
        pixels[x+y*width] = darkgreen;
      } else if (brightness > 70 && brightness <= 120) {
        pixels[x+y*width] = green;
      } else if (brightness > 120 && brightness <= 125) {
        pixels[x+y*width] = beach;
      } else {
        pixels[x+y*width] = blue;
      }
      
      //Assign values from map to 3D model
      int sc = 10;
      
      if(x % sc == 0 && y % sc == 0) {
        terrain[(int)x / sc][(int)y / sc] = 260 - (brightness);
          if(x == 0 || y == 0 || x == width - 10 || y == width - 10) {
            terrain[(int)x / sc][(int)y / sc] = -200; //110
          }
      }
      
    }
  }
 updatePixels();
}

void draw() {

  //Displays 2D map, then transitions to 3D
  if(first) {
    delay(3000);
    first = false;
  }
  background(0);
  noStroke();
  noFill();

  //Translations and Rotations
  translate(width/2, height/2);
  rotateX(PI / 3);
  translate(-w/2, -h/2);
  translate(translationX, translationY);
  rotateZ(rotationZ);
  scale(zoom, zoom, zoom);
  
  //Allows for automatic rotation of 3D model
  if(spin) {
    rotationZ += PI/400;
  }
  
  //Draw 3D model
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      
      fill(y, terrain[x][y] - 100, 100); 
      
      vertex(x*scl - width, y*scl - width, terrain[x][y]);
      vertex(x*scl - width, (y+1)*scl - width, terrain[x][y+1]);
    }
    endShape();
  }
  ocean();
}

// Key Controls and Commands
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
  } else if (key == 'p' && spin == false) {
    spin = true;
  } else if (key == 'p' && spin == true) {
    spin = false;
  }
}

//Draws Transparent Rectangle at sealevel, represents 'water'
void ocean() {
  fill(blue);
  beginShape(QUADS);
    vertex(-width,-width,sealevel);
    vertex(-width, width,sealevel);
    vertex( width, width,sealevel);
    vertex( width,-width,sealevel);
  endShape();
}