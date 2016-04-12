import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture cam;
OpenCV opencv;
PImage src, currentImg, snapshot;
boolean[] markerCells;

int roiX = 200;
int roiY = 75;
int roiWidth = 100;
int roiHeight = 375;

int sample;

void setup() {
  //Camera set up for live processing, need to revisit
  size(640, 480);
  cam = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  
  //start camera
  cam.start();
}

void draw() {
  opencv.loadImage(cam);
  
  //set range of interest
  opencv.setROI(roiX, roiY, roiWidth, roiHeight);
  
  //blur and add threshold
  opencv.blur(35);
  opencv.threshold(80);
  
  //set ROI image
  currentImg = opencv.getOutput();
  
  image(currentImg, 0, 0);

  //if ((millis() % 10) == 0) {
  //  snapshot = opencv.getSnapshot();
  //  scanImage();
  //}
}

void mouseClicked() {
  snapshot = opencv.getSnapshot();
  scanImage();
}

//Uses the ROI to determine the binary message
void scanImage() {
  float cellSize = roiHeight/10;
  String output = "";
  
  //square indicates sample region
  //stroke(204, 102, 0);
  //noFill();
  
  for (int row = 0; row < 10; row++) {
    sample = snapshot.get(roiX + int(cellSize/2), roiY + int(cellSize/2));
    //rect(roiX, roiY, cellSize, cellSize);
    
    println(row + 1);
    
    if (sample == -1) {
      println("white");
      output += "0";
    }
    
    else {
      println("black");
      output += "1";
    }
    
    roiY += cellSize;
    
    println(output);
    println();
  }
}

//Handles camera
void captureEvent(Capture c) {
  c.read();
}