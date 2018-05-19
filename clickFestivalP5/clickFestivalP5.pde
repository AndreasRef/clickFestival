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
int sortAlpha = 0;


//boolean drawAlpha = true;

int scale=1;
float moveY = 0;
char divisionChar = ' ';

float ampMultiplyLerp = 0;

float sortAmount = 0;


// Text on a curve
float x = 0, y = 0;
float stepSize = 2.0;

PFont font;
String letters = "Solen jagter os uden lyd eller bevægelse vi går sommeren i møde nærhed til solen slægtskab til solen vi går rundt i det høje græs I et syn jeg havde så jeg: vi gik ned til fyret Jeg var i tvivl om sandet kunne passe på os om det hvirvlede om sig med egne meninger hvis jeg havde haft kræfterne havde jeg animeret det og ladet det bære os hjem En knop i øjenbrynet strammer som en lille pupil der prøver at se der er brug for bevægelser til alle kroppe Hvis ikke vi befinder os i sengene flyder vi ud på plænerne rundt om huset ind i alle husets rum vi opbevarer væsker og mad i køleskabene vi lægger lort i kummerne vi skiller os af med hud i badene Lever man længere forstår man dagene bedre hvis man sidder lidt hver dag med øjnene åbne mod solen jeg vil fotografere alt Alle billeder er de første jeg tager at fotografere at tage bærrene langs vejen gennem hegnet bærrene i stykker mellem fingrene med lilla saft At tage også at tage til blive mere blive ved væsker er venlige alting afslører sig langsomt alting afslører sig langsomt i dryp der er brug for kroppen til alle bevægelser Vi gik aldrig ved vandet sandet behøver ikke vores livstegn Senere knitrer de snegle vi ikke får fjernet fra bålet jeg må se væk mine ben er kolde men jeg mærker det ikke det virker forfængeligt af natten at den efter at have været sort et stykke tid ændrer sig til blålig Her lugter af nyslået græs en lugt af sorg det er græsset der sørger der er andre dage JA for andre dage Det bidske er mit rige det indædte bearbejdede madvarer er uigennemskuelige appelsinerne taler et klarere sprog pluk mig pluk mig IDIOT jeg fratager appelsinerne skrællen trævlerne hengivelse er kaotisk og går aldrig kun én vej jeg kan samle mig til en sky af turkis Jeg har hjerter nok til en farm jeg har organer nok de yderste blade på træet er det dem som er mest forelskede? dem som når lyset først Gå i en lige linje over denne mark spis det strå gå i en lige linje ind til du når den næste planet et nyt skød fugt nok en sølvlignende hud Fødes der nok nye følelser her til at det kan bære bæres der nok nye følelser her til at det kan mærkes hvem hvem hvem danser mellem sætningerne hvem samler organer sammen til endnu et menneske for hvem er dagen et måltid skumringen de sidste stykke af stranden saml kernerne sammen og opbevar dem inderst i kroppen byg en metafor en bred nok tunge Nu skifter tiden til den næste følelse min fødselsdag jeg blærer mig med opretholdelsen Insekterne fører et liv i mine blinde vinkler gør mig usikker jeg tror de vil det for meget mandagen laver det mindste samfund ud af mig som bierne nakker og bygger landbrug af I græsset sorte snegle nemt og langsomt i hinandens slim jeg så græsset det lave krat briste ved skoven Jeg hader duften af græs jeg faldt i søvn og gentog jeg sover jeg sover jeg sover jeg sover Jeg blev født ud af en knude en blæsebælg på et strå jeg blev liggende længe forskellige ting fandt mig eller jeg blev liggende på en insisterende måde og omverdenen dvs. græsset tog sig af mig Ligesom træerne vokser jeg opad er det særligt menneskeligt hvad er det med højden sorter dig frem gennem det afgrundsdybe når nogen endelig får dig til at stønne nu er der nok penge jeg kan ligne en brud any time det skal være forkæl den næste følelse ved at mærke efter de hænder som følger dig gennem natten den spastiske orddeling i ekstasen forkæl den næste sætning ved at skrive den ned en form for husdyb afgrund en form for sælger-gen at jeg vil sige dig hvordan jeg har det Ind over plænerne ind over plænerne lykkelig jeg kalder en måge for skat i forbifarten ind gennem caféerne møder jeg nogen og maner akavetheden i jorden mine ben tager imod plænen meget kærligt jeg synker lidt ned med mine sko her i græsset min krop her i kroppen mit græs min gråd i det grønne det er så blødt så blødt jeg har et svar til plænen febertræet kan vokse i mig febertræet kan vokse i mig";
int fontSizeMin = 10;
float angleDistortion = 0.0;

int counter = 0;


void setup()
{
  //size(1280, 720);
  fullScreen(2);

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
  
  //println(joinedText);
  //println(joinedText.length());
  
  println("1: perlinLetters_OnOff: " + perlinLetters_OnOff);
  println("2: anagrams_OnOff: " + anagrams_OnOff);
  println("3: lineSeq_OnOff: " + lineSeq_OnOff);
  println("4: snake_OnOff: " + snake_OnOff);
  println("5: imageAsText_OnOff: " + imageAsText_OnOff);
  println("6: sortingLetters_OnOff: " + sortingLetters_OnOff);
  println("7: lettersOnCurve_onOff: " + lettersOnCurve_onOff);
  println();
  
  println(displayWidth);
  println(displayHeight);
  
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

    //Original (big and visable when talking)
    //fill(random(30, 60)*ampMultiply);
    //float fontSize = random(45, 75) * map(ampMultiply, 1, 10, 1, 2);
    
    //Reversed (big and visable when not talking)
    fill(random(30, 60)*(10-ampMultiply));
    float fontSize = random(45, 75) * map(ampMultiply, 1, 10, 4, 0);
    
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
  
  //Original (big and visable when talking)
  //float textSize = random(36, 80) * map(ampMultiply, 1, 10, 1, 5);
  
  //Reversed (big and visable when not talking)
  float textSize = random(36, 80) * map(ampMultiply, 1, 10, 3, 1);
  
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
    
    //Original (big and visable when talking)
    //fill(random(180, 255));
    
    //Reversed (big and visable when not talking)
    fill(random(180, 255),255-ampMultiply*25);
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
    
    //Original
    //fill(255);
    
    //New (visable when talking)
    fill(255, 255 - ampMultiply*25);
    
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


//MODE 6: sortingLetters_OnOff
void drawSortingLetters() {

  ampMultiplyLerp = lerp(ampMultiplyLerp, ampMultiply, 0.01*abs(ampMultiply-5));
  //println(ampMultiply);


  if (ampMultiply>3) {
    sortAmount-=0.001*ampMultiply;
  } else {
    sortAmount+=0.01;
  }

  sortAmount = constrain(sortAmount, 0, 1);

  sortAlpha++;
  sortAlpha = constrain(sortAlpha, 0, 255);

  background(0,sortAlpha);
  
  
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

    fill(255, min(ampMultiplyLerp*(25 + (i%3)*20)-50, 255));

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
    float d = dist(x, y, mouseX, mouseY)+ampMultiply*10;
    //float d = ampMultiply*5;
    textFont(f, fontSizeMin+d);
    //textFont(f, fontSizeMin+ampMultiply*30);
    //if (joinedText.charAt(counter) == ' ') {
    //  counter++;
    //}
    char newLetter = letters.charAt(counter);
    
    stepSize = textWidth(newLetter);

    if (d > stepSize) {
      float angle = atan2(mouseY-y, mouseX-x); 

      pushMatrix();
      translate(x, y);
      rotate(angle + random(angleDistortion));
      text(newLetter, 0, 0);
      //println(newLetter);
      popMatrix();

      counter++;
      if (counter > letters.length()-1) counter = 0;

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