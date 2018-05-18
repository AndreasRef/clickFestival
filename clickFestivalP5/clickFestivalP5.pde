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

// Key states
boolean perlinLetters_OnOff = true;
boolean anagrams_OnOff = false;
boolean lineSeq_OnOff = false;
boolean snake_OnOff = false;

// GFX
int bgLast = 0;

// LETTERS GFX
PFont f;

String[] lines;
String[][] words;
int wordsX = 0; // indeholder array med sætninger i digt
int wordsY = 0;

int keyPressState = 0;
int timePass = 0;

float timeThres;
float timeThresDefault = 200;
int radiusFromMouse = 100;

float mX = width/2;
float tx = 0;
float mY = height/2;
float ty = 0;

float mSpeed = 1;

// Draw anagrams
float anagramTxtX = 0;
float anagramTxtY = 0;
float anagramTime = 150;
float anagramLastTime = 0;
float anaTimeMultiplier = 0;
int anagramIndex = 0;
int anaWordX = 0;
int anaWordY = 0;

StringList anagrams;
String drawAnaString;

// draw line seq
float lineSeqTxtX = 0;
float lineSeqTxtY = 0;
float lineSeqLastTime = 0;
float lineSeqTime = 50;
int lineSeqIndex = 0;

// draw snake
float snakeTxtX = 0;
float snakeTxtY = 0;
float snakeLastTime = 0;
float snakeTime = 50;
int snakeIndex = 0;
int snaWordX = 0;
int snaWordY = 0;
int snake_dirUDLR = 0;

StringList snakeAnagrams;
String drawSnaString;

void setup()
{
  size(1920, 1080, P2D);  

  minim = new Minim(this);
  audioIn = minim.getLineIn();
            
  fft = new FFT(audioIn.bufferSize(), audioIn.sampleRate()); 
  
  // calculate averages based on a miminum octave width of 22 Hz
  // split each octave into a number of bands
  fft.logAverages(22, bandsPerOctave); 
  dB = new float[fft.avgSize()];
  rectMode(CORNERS);
  
  f = createFont("Avenir", 150, true);

  // Anagrams
  anagrams = new StringList();
  snakeAnagrams = new StringList();
  loadText(0);
  background(0);
  //noCursor();
  
}
 
void draw()
{   
  fft.forward(audioIn.left); 
  drawRTA(true);
  
  if(gate_isTriggered == 1 && trig_switch != gate_isTriggered) {
    trig_pulse = true; // used to do something once pr. trigger
    trig_switch = gate_isTriggered;
    }  
  
  drawBackground(200); //draw black rect every 200 ms

  if(perlinLetters_OnOff) { drawPerlinLetters();  }
  if(anagrams_OnOff)      { drawAnagrams();       }
  if(lineSeq_OnOff)       { drawLineSeq();        }
  if(snake_OnOff)         { drawSnake();          }  

  trig_pulse = false;
}  

  /* ****************************
  *    OTHER FUNCTIONS
  ***************************** */
void drawAnagrams() {
  
  float textSize = random(36,80) * map(ampMultiply, 1, 10, 1, 5);
  textSize(textSize);
  textFont(f, textSize);

  if(trig_switch == 0 ) {anaTimeMultiplier = 0; 
  }

  if(millis() > anagramLastTime + anagramTime + (100 * (map(ampMultiply, 1, 10, 1, 5)) * anaTimeMultiplier)) {
    anagramLastTime = millis();
    anaTimeMultiplier = 1;
    
    if(anagramTxtX > width) {anagramTxtX =0; }

    anagramIndex += 1;
    
    if(anagramIndex == words[anaWordX][anaWordY].length()) { // every new word
      anagramIndex = 0;
      anaWordY += 1;

      anagramTxtY = anagramTxtY + textSize;
        if(anagramTxtY > height) anagramTxtY = textSize/2;

        if(anaWordY == words[anaWordX].length) { // every new sentence
        anaWordY = 0;
        anaWordX += 1;
        }
        if(anaWordX == words.length-1){ // loop poem
        anaWordX = 0;;
        }  

      createAnagram(anaWordX, anaWordY);   
    } 
    drawAnaString = anagrams.get(anagramIndex);  
    fill(random(180,255));
    text(drawAnaString, anagramTxtX, anagramTxtY);
    anagramTxtX += textWidth(words[anaWordX][anaWordY].charAt(anagramIndex));
    }
}

void createAnagram(int thisX, int thisY) {
      anagrams.clear();
      for(int i = 0; i < words[thisX][thisY].length(); i++) {
        anagrams.append(str(words[thisX][thisY].charAt(i)));
      }
      anagrams.shuffle(); 
}

void drawLineSeq() {
  float textSize = random(36,60);
  textSize(textSize);
  textFont(f, textSize);

  if(millis() > lineSeqLastTime + lineSeqTime) {
    lineSeqLastTime = millis();
    fill(255);
    text(words[wordsX][wordsY].charAt(lineSeqIndex), lineSeqTxtX, lineSeqTxtY);
    
      if(gate_isTriggered == 0) {
        lineSeqTxtX += textWidth(words[wordsX][wordsY].charAt(lineSeqIndex));
        lineSeqTxtY = random(height*0.3, height*0.66); 
        }
      if(gate_isTriggered == 1) {
        lineSeqTxtX -= textWidth(words[wordsX][wordsY].charAt(lineSeqIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
        lineSeqTxtY = random(0, height-textSize); 
      }

    if(lineSeqTxtX > width) lineSeqTxtX = 0;  
    if(lineSeqTxtX < 0) lineSeqTxtX = width;  
    
  } 
}

void drawSnake() {
  if(millis() > snakeLastTime + snakeTime + (100 * map(ampMultiply, 1, 10, 1, 5))) {
    snakeLastTime = millis();
    float textSize = random(36,60) * map(ampMultiply, 1, 10, 1.7, 3);
    textSize(textSize);
    textFont(f, textSize);

    snakeIndex += 1;
    
      if(snakeIndex == words[snaWordX][snaWordY].length()) { // every new word
        snakeIndex = 0;
        snaWordY += 1;

        snakeTxtY = snakeTxtY + textSize;

        snake_dirUDLR = (int)random(0,3);

        if(snakeTxtY > height) snakeTxtY = textSize/2;

        if(snaWordY == words[snaWordX].length) { // every new sentence
          snaWordY = 0;
          snaWordX += 1;
        }
        if(snaWordX == words.length-1){ // loop poem
          snaWordX = 0;
        }  

      createSnakeAnagram(snaWordX, snaWordY);   
    } 

    drawSnaString = snakeAnagrams.get(snakeIndex);  
    
      if(snake_dirUDLR == 0) {
        snakeTxtY += textWidth(words[snaWordX][snaWordY].charAt(snakeIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
        }
      if(snake_dirUDLR == 1) {
        snakeTxtY -= textWidth(words[snaWordX][snaWordY].charAt(snakeIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
      }     
      if(snake_dirUDLR == 2) {
        snakeTxtX -= textWidth(words[snaWordX][snaWordY].charAt(snakeIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
        }      
      if(snake_dirUDLR == 3) {
      snakeTxtX += textWidth(words[snaWordX][snaWordY].charAt(snakeIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
      }

      if(snakeTxtX > width) snakeTxtX = 0;  
      if(snakeTxtX < 0) snakeTxtX = width;  
      if(snakeTxtY > height) snakeTxtY = 0;  
      if(snakeTxtY < 0) snakeTxtY = height; 

      fill(random(180,255));
      text(drawSnaString, snakeTxtX, snakeTxtY);
  } 
}

void createSnakeAnagram(int thisX, int thisY) {
      snakeAnagrams.clear();
      for(int i = 0; i < words[thisX][thisY].length(); i++) {
        snakeAnagrams.append(str(words[thisX][thisY].charAt(i)));
      }
      snakeAnagrams.shuffle(); 
}

void drawPerlinLetters() {
      
  if(trig_pulse) {
    /* for each trigger, increment which words is 
    displayed by 1 word, and go through the sentences */
    
    wordsY = wordsY + 1;
    wordsY = wordsY % (words[wordsX].length); 
    
    if(wordsY == 0) {
      wordsX = wordsX + 1;  
      wordsX = wordsX % (words.length-1); 
    }
  }
  
  if((millis() - timePass) > timeThres) {
    moveMouse(); 

    fill(random(30,60)*ampMultiply);
    float fontSize = random(45, 75) * map(ampMultiply, 1, 10, 1, 2);
    textFont(f, fontSize);
    
    // text(str(words[wordsX][wordsY].charAt(0)) , random(10,100), random(50,250));
    text(str(words[wordsX][wordsY].charAt(int(random(0, words[wordsX][wordsY].length())))), 
             mX + random(0,radiusFromMouse * 2) - radiusFromMouse, 
             mY + random(0,radiusFromMouse * 2) - radiusFromMouse
             );
       
    timePass = millis();
  } 
}
  
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

void loadText(int t) { 
  // use function to replace filename dynamically,
  // and update text, words and letters arrays
 
  String fileName = str(t) + ".txt";
  
  lines = loadStrings(fileName);
  words = new String[lines.length][];

  for(int i = 1; i < lines.length; i++){ // i == 1, avoid ? as first pos in array 
     words[i-1] = split(lines[i], ' '); // create 2d array from [each line][words in line]
  }
  createAnagram(0, 0); // init anagram string list
  createSnakeAnagram(0, 0); // init anagram string list

  println("new text loaded");
}

void moveMouse() { // fake mouse position w. perlin noise
  
  mX = map(noise(tx), 0, 1, 0, width);
  mY = map(noise(ty), 0, 1, 0, height);
  
  tx = tx + 0.1;
  ty = ty + 0.4; 
 
   if(mX < 0     ){ mX = 0;     }
   if(mX > width ){ mX = width; }
   if(mY > height){ mY = 0;     }
   if(mY < 0     ){ mY = height;}
}

void keyPressed() {
  if(key == '1') { perlinLetters_OnOff  = !perlinLetters_OnOff; }
  if(key == '2') { anagrams_OnOff       = !anagrams_OnOff; }
  if(key == '3') { lineSeq_OnOff        = !lineSeq_OnOff; }
  if(key == '4') { snake_OnOff          = !snake_OnOff; }
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

void drawBackground (int ms) {
  if(millis() > bgLast + ms) {
      fill(0, 10); 
      rect(0,0, width, height); 
      }// fade to black slowly
}
