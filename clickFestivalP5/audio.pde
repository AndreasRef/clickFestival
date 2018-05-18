//Functions in this tab run in the background an do audio stuff

// Audio
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput audioIn;

FFT fft;

// GATE / AUDIO TRIGGER
float[] dB;
float noiseThreshold = 70;
float noiseFloor = 283;
int gate_hysteresis = 30;
int gate_offTime = 0;
int gate_onTime = 0;
int gate_isTriggered = 0;
boolean trig_pulse = false;  // used to do something once pr. trigger
int trig_switch = 0;

// AUDIO GFX
int bandsPerOctave = 3; 
int barSpacing = 3;
float ampMultiply = 1;


void drawRTA(boolean drawRta) {

  int w = int((width/4)/fft.avgSize());
  for(int i = 0; i < fft.avgSize(); i++) {

      // get the amplitude of the frequency band
      float amplitude = fft.getAvg(i);
  
      // convert the amplitude to a DB value. 
      // this means values will range roughly from 0 for the loudest
      // bands to some negative value.
      float bandDB = 20 * log(2 * amplitude / fft.timeSize());
      // so then we want to map our DB value to the height of the window
      // given some reasonable range
      dB[i] = bandDB;
      if(bandDB < -280) bandDB = -280;
      float bandHeight = map(bandDB, 0, -150, 0, height/4);
      if(bandHeight > height/4) bandHeight = height/4;
  
      gate(15,25);
  
      if(drawRta == true) {
        fill(0, 20);
        rect(0,0, width/4, height/4);
        fill(255);
        // draw a rectangle for the band
        rect(i*w, height/4, i*w + w - barSpacing, bandHeight);  
      }
  }
}

void gate(int bandL, int bandH) { // FFT filterbank; high-pass og low-pass
  
  float avg = 0;
  for(int i = bandL; i <= bandH; i++) {
    avg = dB[i] + avg;
  }
  
  avg = avg / (bandH - bandL) + noiseFloor;
  
  if(avg < noiseThreshold && gate_isTriggered == 1 && millis() > gate_onTime + gate_hysteresis) {
    avg = 0;
    gate_isTriggered = 0;
    trig_switch = 0;
    gate_offTime = millis();
    ampMultiply = 1;
    mSpeed = mSpeed * ampMultiply;
    timeThres = timeThresDefault;
   
  }
  if(avg > noiseThreshold && millis() > gate_offTime + gate_hysteresis) {
    gate_isTriggered = 1;
    gate_onTime = millis();
    ampMultiply = avg/15;
    if(ampMultiply < 1) ampMultiply = 1;
    mSpeed = mSpeed * ampMultiply;
    timeThres = timeThresDefault - 15*ampMultiply; 
    
  }
}