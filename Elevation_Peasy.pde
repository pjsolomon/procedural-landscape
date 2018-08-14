// Import PeasyCam Library, available here: http://mrfeinberg.com/peasycam/
import peasy.*;
PeasyCam cam;

//Determine Increment for Noise Generation
float increment = 0.01;

//Assign Boolean Values
boolean spin = false; // If set to true 3D model automatically rotates
boolean first = true; //Set to false after first time Draw() is called, allows 2D to be displayed
boolean stroked = false; //Set stroke

//Preset Colors
color blue = color(65, 105, 225, 80);
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
float sealevel = 100; //100

//2D array to hold elevation values
float[][] terrain;
int[] pixelsCopy = new int[640000];

void setup() {
  size(800, 800, P3D);
  cam = new PeasyCam(this, 1000);
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
      //brightness += (0.25 * sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));
      
      //Coastline? Needs some work.
      //brightness += (0.1 * sqrt(pow(x - width, 2)));
         
      //Big lake in the middle?
      //brightness += (10000 / sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));
      
      //Island
      //brightness -= (200 - sqrt(pow(x - (width / 2), 2) + pow(y - (height / 2), 2)));;

      //Island 2
      //IMPLEMENT CODE FOR SPHERICAL DISTANCE?

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
  for(int w = 1; w < 640000; w++) {
   pixelsCopy[w] = pixels[w];
 }
  
 updatePixels();
}

void draw() {
  background(0); 
//Displays 2D map, then transitions to 3D
if(first) {  
  if(stroked) {
    stroke(200);
  } else {
    noStroke();
  }
  noFill();

  //Draw 3D model
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      
      fill(60, (terrain[x][y]) / 2, 60); 
      
      vertex(x*scl - width, y*scl - width, terrain[x][y]);
      vertex(x*scl - width, (y+1)*scl - width, terrain[x][y+1]);
    }
    endShape();
  }
  ocean();
} else {
  loadPixels();
  for(int w = 0; w < 640000; w++) {
    pixels[w] = pixelsCopy[w];
  }
  updatePixels();
}
}

// Key Controls and Commands
// 's' to toggle stroke, 'm' to toggle 2D/3D view
void keyPressed() {
  if (key == 's' && stroked == false) {
    stroked = true;
  } else if (key == 's' && stroked == true) {
    stroked = false;
  } else if (key == 'm' && first == false) {
    first = true;
  } else if (key == 'm' && first == true) {
    first = false;
  }
}

//Draws Transparent Rectangle at sealevel, represents 'water'
void ocean() {
  fill(blue);
  pushMatrix();
  translate(0,0,-25);
  box(2 * (-width),2* width, 320);
  popMatrix();
  
  fill(65, 105, 225);
  pushMatrix();
  translate(0,0,-200);
  box(2*width, 2*width, 2);
  popMatrix();
}