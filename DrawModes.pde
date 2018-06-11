void curveLine () {     //basic curve line 
  offscreen.colorMode(HSB);
  offscreen.noFill();
  offscreen.stroke(white);
  if (cycle)   offscreen.stroke((frameCount*0.2)%255, 255, 255); 

  offscreen.beginShape(); 

  for (int i = 0; i < points.size(); i++) { //iterate through points and add curve vertexes
    PVector temp = points.get(i);
    offscreen.curveVertex(temp.x, temp.y);
  }

  offscreen.endShape(); // close curved line
}

void curveLineCirclePoints () {      //draw line with ellipses at each vertex
  offscreen.colorMode(HSB);
  offscreen.noFill();
  offscreen.stroke(white);
  if (cycle)   offscreen.stroke((frameCount*0.2)%255, 255, 255); 

  for (int i = 0; i < points.size(); i++) { //iterate through points and draw ellipses
    PVector temp = points.get(i);
    offscreen.ellipse(temp.x, temp.y, 10, 10);
  }

  offscreen.beginShape(); 
  for (int i = 0; i < points.size(); i++) { //iterate through points and add curve vertexes
    PVector temp = points.get(i);
    offscreen.curveVertex(temp.x, temp.y);
  }

  offscreen.endShape(); // close curved line
}

void weld () {      //draw line with ellipses at each vertex
  offscreen.colorMode(HSB);
  offscreen.noFill();
  offscreen.stroke(white);
  if (cycle)   offscreen.stroke((frameCount*0.2)%255, 255, 255); 

  offscreen.beginShape(); 
  for (int i = 0; i < points.size(); i++) { //iterate through points and add curve vertexes
    PVector temp = points.get(i);
    offscreen.curveVertex(temp.x, temp.y);
  }

  offscreen.endShape(); // close curved line

  offscreen.ellipse(points.get(currentPoint).x, points.get(currentPoint).y, 10, 10); //draw ellipse at last point received

  ps.setOrigin(points.get(points.size()-1));
  ps.addParticle();
  ps.run();
}

void z() {      //melt in z space
  offscreen.colorMode(HSB);
  offscreen.stroke(white);
  offscreen.fill(white);
  if (cycle){   
    offscreen.stroke((frameCount*0.2)%255, 255, 255);
    offscreen.fill((frameCount*0.2)%255, 255, 255);
  }

  for (int i = 0; i < points.size(); i++) { //iterate through points and draw ellipses
    PVector temp = points.get(i);

    //offscreen.fill((frameCount*0.2)%255, 255, 255);
    offscreen.ellipse(temp.x, temp.y, sin(i)*12, sin(i)*12);

    //if (i==drip) {
    //  offscreen.line(temp.x, temp.y, temp.x, temp.y-((int)random(20)));
    //  drip=(int)random(100);
    //}
  }


  offscreen.beginShape(); 
  for (int i = 0; i < points.size(); i++) { //iterate through points and add curve vertexes
    PVector temp = points.get(i);
    offscreen.noFill();
    offscreen.curveVertex(temp.x, temp.y);
  }

  offscreen.endShape(); // close curved line

  offscreen.fill(0, 5);
  offscreen.noStroke();
  offscreen.rect(0, 0, offscreen.width, offscreen.height);
  //imageMode(CENTER);
  offscreen.image(offscreen.get(), -1, -1, offscreen.width+2, offscreen.height+2); //smoke effect
}