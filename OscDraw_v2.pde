/* ==================================================
 
 OSC Drawing sketch - Tim Rolls 2016 - timrolls.com
 
 Draws based on OSC X,Y values. 
 
 Up/Down arrows to set curve tightness
 space to clear output
 
 ================================================== */

import oscP5.*;
import netP5.*;
//import codeanticode.syphon.*;
//SyphonServer server;
import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

OscP5 oscP5;
NetAddress myRemoteLocation;
PVector blobLoc;

ArrayList<PVector> points;
float tightness = 0;
int drawMode = 1;
int currentPoint;

boolean mouseMode=true;
int drip =(int)random(100);

color white=color(255, 255, 255);
color hue=white;
boolean cycle= false;

ParticleSystem ps;

void setup() {
  //size(1280, 720, P3D);
  fullScreen(P3D, 1 ); 
  background(0);
  smooth();
  stroke(255);
  noFill();
  textSize(18);

  //server = new SyphonServer(this, "Processing Syphon");

  points = new ArrayList<PVector>(); 

  // start oscP5, listening for incoming messages at port 12000
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);

  blobLoc= new PVector(0, 0);

  ps = new ParticleSystem();

  //set up keystone
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(height, height, 20);

  // We need an offscreen buffer to draw the surface we
  // want projected
  // note that we're matching the resolution of the
  // CornerPinSurface.
  // (The offscreen buffer can be P2D or P3D)
  offscreen = createGraphics(height, height, P3D);

  offscreen.stroke(hue);
  offscreen.strokeWeight(1);
  offscreen.noFill();
}

void draw() {
  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the 
  // surface from your screen. 
  PVector surfaceMouse = surface.getTransformedMouse();
  offscreen.colorMode(HSB);

  // Draw the scene, offscreen
  offscreen.beginDraw();
  //offscreen.scale(-1, 1); //flip horiz
  //offscreen.translate(-offscreen.width,0);

  if (drawMode!=4)offscreen.background(0);
  if (ks.isCalibrating()) { //draw mouse on shape for calibration

    offscreen.fill(20, 255, 255, 100);
    offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75);
  }

  //if (mouseMode==true) {
  //  points.add(new PVector((mouseX/width)*offscreen.width, (mouseY/height)*offscreen.height));
  //}

  if (points.size()>0) { //if arraylist has points
    switch(drawMode) {

    case 1:
      curveLine();
      break;

    case 2:
      curveLineCirclePoints();
      break;

    case 3:
      weld();
      break;

    case 4:
      z();
      break;
    }
  }

  //offscreen.image(offscreen.get(), 0,0,offscreen.width+2,offscreen.height+2);

  offscreen.endDraw();

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);

  offscreen.curveTightness(tightness);

  //scale(-1, -1); //flip both
  //translate(-width,-height);

  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);

  //frame.setTitle("Tightness: "+tightness+" || Points: "+points.size()+" || FPS: "+(int)frameRate);
}


void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  if (theOscMessage.checkAddrPattern("/blobLoc")==true  && theOscMessage.checkTypetag("ff")) {
    /* check if the typetag is the right one. */

    /* parse theOscMessage and extract the values from the osc message arguments. */
    blobLoc=new PVector( theOscMessage.get(0).floatValue()*offscreen.width, theOscMessage.get(1).floatValue()*offscreen.height);
    //if(frameCount%2==1){

    points.add(blobLoc); //add to arraylist 
    currentPoint= points.size()-1;


    //print("### received an osc message /blobLoc with typetag ff.");
    //println(" values: "+blobLoc.x+", "+blobLoc.y);
    return;
  }

  if (theOscMessage.checkAddrPattern("/blobLocCal")==true  && theOscMessage.checkTypetag("ff")) {
    /* check if the typetag is the right one. */

    /* parse theOscMessage and extract the values from the osc message arguments. */
    blobLoc=new PVector( theOscMessage.get(0).floatValue()*offscreen.width, theOscMessage.get(1).floatValue()*offscreen.height);
    //if(frameCount%2==1){

    points.add(blobLoc); //add to arraylist
    currentPoint= points.size()-1 ;

    //print("### received an osc message /blobLocCal with typetag ff.");
    //println(" values: "+blobLoc.x+", "+blobLoc.y);
    return;
  }

  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}


// ==================================================
// keyPressed()
// ==================================================

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;

  case 'h':
    // switch between hue shift and white
    cycle= !cycle;
    break;  

  case ' ':
    // clear (space)
    for (int i = points.size() - 1; i >= 0; i--) {
      points.remove(i);
    }
    break;

  case 'm':
    // toggle mouse mode
    mouseMode=!mouseMode;
    break;

  case '1':
    // Draw mode 1
    drawMode=1;
    break;

  case '2':
    // Draw mode 2
    drawMode=2;
    break;

  case '3':
    // Draw mode 3
    drawMode=3;
    break;

  case '4':
    // Draw mode 4
    drawMode=4;
    break;
  }


  if (keyCode == UP) tightness+=0.5 ;
  if (keyCode == DOWN && tightness>-5) tightness-=0.5 ;

  if (keyCode == ENTER) offscreen.save("output/"+frameCount+".png") ;
}

void mouseDragged() { 
  // use for testing drawmodes (not in live performance
  if (mouseMode)points.add(surface.getTransformedMouse());
}