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

//Image stuff
PImage img;
int imageAlpha = 0;
boolean soundReactiveAlpha = true;


//Sort letters
String joinedText;
String alphabet = "ABDEFGHIJKLMNOPQRSTUVYÆØÅ,.;:!?$ "; //OBS missing characthers due to specific poem
int[] counters = new int[alphabet.length()];

float charSize;
color charColor = 0;
int posX, posY;

//boolean drawAlpha = true;

int scale=1;
float moveY = 0;
char divisionChar = ' ';

float ampMultiplyLerp = 0;

float sortAmount = 0;


// Text on a curve
float x = 0, y = 0;
float stepSize = 5.0;

PFont font;
String letters = "Sie hören nicht die folgenden Gesänge, Die Seelen, denen ich die ersten sang, Zerstoben ist das freundliche Gedränge, Verklungen ach! der erste Wiederklang.";
int fontSizeMin = 10;
float angleDistortion = 0.0;

int counter = 0;


void setup()
{
  size(1280, 720);  

  minim = new Minim(this);
  audioIn = minim.getLineIn();

  fft = new FFT(audioIn.bufferSize(), audioIn.sampleRate()); 

  // calculate averages based on a miminum octave width of 22 Hz
  // split each octave into a number of bands
  fft.logAverages(22, bandsPerOctave); 
  dB = new float[fft.avgSize()];
  rectMode(CORNERS);

  f = createFont("Times", 150, true);
  textFont(f, 16);

  // Anagrams
  anagrams = new StringList();
  snakeAnagrams = new StringList();
  loadText(0);
  background(0);
  noCursor();

  frameRate(30);

  //Image
  img = loadImage("8.jpg");

  //Sort letters
  String[] lines = loadStrings("texts.txt");
  //joinedText = join(lines, divisionChar);
  joinedText = join(lines, divisionChar);
  countCharacters();
  
  println(joinedText);
  println(joinedText.length());
}

void draw()
{   
  surface.setTitle(int(frameRate) + " fps");

  fft.forward(audioIn.left); 
  drawRTA(false);

  if (gate_isTriggered == 1 && trig_switch != gate_isTriggered) {
    trig_pulse = true; // used to do something once pr. trigger
    trig_switch = gate_isTriggered;
  }  

  drawBackground(200); //draw black rect every 200 ms

  if (perlinLetters_OnOff) drawPerlinLetters();
  if (anagrams_OnOff) drawAnagrams();
  if (lineSeq_OnOff)  drawLineSeq();
  if (snake_OnOff) drawSnake();
  if (imageAsText_OnOff) drawImageAsText();  
  if (sortingLetters_OnOff) drawSortingLetters();
  if (lettersOnCurve_onOff) drawLettersOnCurve();


  trig_pulse = false;

  //println(ampMultiply);
}  



/// MODE 1: perlinLetters_OnOff 
void drawPerlinLetters() { 

  if (trig_pulse) {
    /* for each trigger, increment which words is 
     displayed by 1 word, and go through the sentences */

    wordsY = wordsY + 1;
    wordsY = wordsY % (words[wordsX].length); 

    if (wordsY == 0) {
      wordsX = wordsX + 1;  
      wordsX = wordsX % (words.length-1);
    }
  }

  if ((millis() - timePass) > timeThres) {
    //Former moveMouse function stuff put in here //moveMouse(); 

    mX = map(noise(tx), 0, 1, 0, width);
    mY = map(noise(ty), 0, 1, 0, height);

    tx = tx + 0.1;
    ty = ty + 0.4; 

    if (mX < 0     ) { 
      mX = 0;
    }
    if (mX > width ) { 
      mX = width;
    }
    if (mY > height) { 
      mY = 0;
    }
    if (mY < 0     ) { 
      mY = height;
    }


    fill(random(30, 60)*ampMultiply);
    float fontSize = random(45, 75) * map(ampMultiply, 1, 10, 1, 2);
    textFont(f, fontSize);

    // text(str(words[wordsX][wordsY].charAt(0)) , random(10,100), random(50,250));
    text(str(words[wordsX][wordsY].charAt(int(random(0, words[wordsX][wordsY].length())))), 
      mX + random(0, radiusFromMouse * 2) - radiusFromMouse, 
      mY + random(0, radiusFromMouse * 2) - radiusFromMouse
      );

    timePass = millis();
  }
}



//MODE 2: anagrams_OnOff
void drawAnagrams() {

  float textSize = random(36, 80) * map(ampMultiply, 1, 10, 1, 5);
  textSize(textSize);
  textFont(f, textSize);

  if (trig_switch == 0 ) {
    anaTimeMultiplier = 0;
  }

  if (millis() > anagramLastTime + anagramTime + (100 * (map(ampMultiply, 1, 10, 1, 5)) * anaTimeMultiplier)) {
    anagramLastTime = millis();
    anaTimeMultiplier = 1;

    if (anagramTxtX > width) {
      anagramTxtX =0;
    }

    anagramIndex += 1;

    if (anagramIndex == words[anaWordX][anaWordY].length()) { // every new word
      anagramIndex = 0;
      anaWordY += 1;

      anagramTxtY = anagramTxtY + textSize;
      if (anagramTxtY > height) anagramTxtY = textSize/2;

      if (anaWordY == words[anaWordX].length) { // every new sentence
        anaWordY = 0;
        anaWordX += 1;
      }
      if (anaWordX == words.length-1) { // loop poem
        anaWordX = 0;
        ;
      }  

      createAnagram(anaWordX, anaWordY);
    } 
    drawAnaString = anagrams.get(anagramIndex);  
    fill(random(180, 255));
    text(drawAnaString, anagramTxtX, anagramTxtY);
    anagramTxtX += textWidth(words[anaWordX][anaWordY].charAt(anagramIndex));
  }
}



//MODE 3: lineSeq_OnOff
void drawLineSeq() {
  float textSize = random(36, 60);
  textSize(textSize);
  textFont(f, textSize);

  if (millis() > lineSeqLastTime + lineSeqTime) {
    lineSeqLastTime = millis();
    fill(255);
    text(words[wordsX][wordsY].charAt(lineSeqIndex), lineSeqTxtX, lineSeqTxtY);

    if (gate_isTriggered == 0) {
      lineSeqTxtX += textWidth(words[wordsX][wordsY].charAt(lineSeqIndex));
      lineSeqTxtY = random(height*0.3, height*0.66);
    }
    if (gate_isTriggered == 1) {
      lineSeqTxtX -= textWidth(words[wordsX][wordsY].charAt(lineSeqIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
      lineSeqTxtY = random(0, height-textSize);
    }

    if (lineSeqTxtX > width) lineSeqTxtX = 0;  
    if (lineSeqTxtX < 0) lineSeqTxtX = width;
  }
}




// MODE 4: snake_OnOff 
void drawSnake() {
  if (millis() > snakeLastTime + snakeTime + (100 * map(ampMultiply, 1, 10, 1, 5))) {
    snakeLastTime = millis();
    float textSize = random(36, 60) * map(ampMultiply, 1, 10, 1.7, 3);
    textSize(textSize);
    textFont(f, textSize);

    snakeIndex += 1;

    if (snakeIndex == words[snaWordX][snaWordY].length()) { // every new word
      snakeIndex = 0;
      snaWordY += 1;

      snakeTxtY = snakeTxtY + textSize;

      snake_dirUDLR = (int)random(0, 3);

      if (snakeTxtY > height) snakeTxtY = textSize/2;

      if (snaWordY == words[snaWordX].length) { // every new sentence
        snaWordY = 0;
        snaWordX += 1;
      }
      if (snaWordX == words.length-1) { // loop poem
        snaWordX = 0;
      }  

      createSnakeAnagram(snaWordX, snaWordY);
    } 

    drawSnaString = snakeAnagrams.get(snakeIndex);  

    if (snake_dirUDLR == 0) {
      snakeTxtY += textWidth(words[snaWordX][snaWordY].charAt(snakeIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
    }
    if (snake_dirUDLR == 1) {
      snakeTxtY -= textWidth(words[snaWordX][snaWordY].charAt(snakeIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
    }     
    if (snake_dirUDLR == 2) {
      snakeTxtX -= textWidth(words[snaWordX][snaWordY].charAt(snakeIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
    }      
    if (snake_dirUDLR == 3) {
      snakeTxtX += textWidth(words[snaWordX][snaWordY].charAt(snakeIndex)) * map(ampMultiply, 1, 10, 1.7, 3);
    }

    if (snakeTxtX > width) snakeTxtX = 0;  
    if (snakeTxtX < 0) snakeTxtX = width;  
    if (snakeTxtY > height) snakeTxtY = 0;  
    if (snakeTxtY < 0) snakeTxtY = height; 

    fill(random(180, 255));
    text(drawSnaString, snakeTxtX, snakeTxtY);
  }
}


//MODE 5: imageAsText_OnOff
void drawImageAsText() {

  tint(255, imageAlpha);
  image(img, 0, 0);

  if (soundReactiveAlpha) {

    if (ampMultiply > 2) {
      imageAlpha++;
    } else {
      imageAlpha--;
    }
  } else {
    if (frameCount % 10 == 0) imageAlpha++;
  }

  imageAlpha = constrain(imageAlpha, 0, 255);
}


//MODE 6: imageAsText_OnOff
void drawSortingLetters() {

  ampMultiplyLerp = lerp(ampMultiplyLerp, ampMultiply, 0.01*abs(ampMultiply-5));
  println(ampMultiply);


  if (ampMultiply>3) {
    sortAmount-=0.001*ampMultiply;
  } else {
    sortAmount+=0.005;
  }

  sortAmount = constrain(sortAmount, 0, 1);


  background(0);
  noStroke();
  smooth();

  float textSizeFactor = 1.5;
  int ySize = 31;
  int xSize = 26;

  posY = round(ySize*textSizeFactor)+30;
  posX = round(xSize*textSizeFactor)+30;

  // go through all characters in the text to draw them  
  for (int i = 0; i < joinedText.length(); i++) {
    // again, find the index of the current letter in the alphabet
    String s = str(joinedText.charAt(i)).toUpperCase();
    char uppercaseChar = s.charAt(0);
    int index = alphabet.indexOf(uppercaseChar);
    if (index < 0) continue;

    fill(255, min(ampMultiplyLerp*(50 + (i%3)*20)-50, 255));

    textSize(16*textSizeFactor);

    float sortY = index*20*textSizeFactor+40;
    float m = map(ampMultiplyLerp, 5, 1, 0, 1);
    //float m
    m = constrain(m, 0, 1);
    //float interY = lerp(posY, sortY, m);
    float interY = lerp(posY, sortY, sortAmount);

    //if (joinedText.charAt(i) != divisionChar)  
    text(joinedText.charAt(i), posX, interY);

    posX += textWidth(joinedText.charAt(i));
    if (posX >= width-150 && uppercaseChar == ' ') {
      posY += round(ySize*textSizeFactor);
      posX = round(xSize*textSizeFactor)+30;
    }
  }
}


//MODE 7: lettersOnCurve_OnOff
void drawLettersOnCurve() {
  //Make global variables?

  fill(255);

  if (mousePressed) {
    float d = dist(x, y, mouseX, mouseY);
    textFont(f, fontSizeMin+d);
    char newLetter = joinedText.charAt(counter);
    stepSize = textWidth(newLetter);

    if (d > stepSize) {
      float angle = atan2(mouseY-y, mouseX-x); 

      pushMatrix();
      translate(x, y);
      rotate(angle + random(angleDistortion));
      text(newLetter, 0, 0);
      popMatrix();

      counter++;
      if (counter > joinedText.length()-1) counter = 0;

      x = x + cos(angle) * stepSize;
      y = y + sin(angle) * stepSize;
    }
  }
  x = mouseX;
  y = mouseY;
  //println(counter);
}


void drawBackground (int ms) {
  if (millis() > bgLast + ms) {
    fill(0, 10); 
    rect(0, 0, width, height);
  }// fade to black slowly
}