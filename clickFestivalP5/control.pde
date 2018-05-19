//Functions for manually deciding what gets shown

// Key states
boolean perlinLetters_OnOff = false;
boolean anagrams_OnOff = false;
boolean lineSeq_OnOff = false;
boolean snake_OnOff = false;
boolean imageAsText_OnOff = false;
boolean sortingLetters_OnOff = false;
boolean lettersOnCurve_onOff = true;

void keyPressed() {
  
  if(key == '0') { 
    perlinLetters_OnOff  = false;
    anagrams_OnOff  = false;
    lineSeq_OnOff  = false;
    snake_OnOff  = false;  
  }
  
  if(key == '1') { perlinLetters_OnOff  = !perlinLetters_OnOff; }
  if(key == '2') { anagrams_OnOff       = !anagrams_OnOff; }
  if(key == '3') { lineSeq_OnOff        = !lineSeq_OnOff; }
  if(key == '4') { snake_OnOff          = !snake_OnOff; }
  if(key == '5') { 
  imageAsText_OnOff= !imageAsText_OnOff; 
  imageAlpha = 0;
}
  if (key == '6') { 
  sortingLetters_OnOff = !sortingLetters_OnOff; 
  sortAlpha = 0;
  sortAmount = 0.5;
  //
  
  
  }
  if (key == '7') { lettersOnCurve_onOff = !lettersOnCurve_onOff; }
  
  if (key == 'a' || key == 'A') {soundReactiveAlpha = !soundReactiveAlpha; }
  if (key == 'c' || key == 'C') {background(0); }
  
  println("1: perlinLetters_OnOff: " + perlinLetters_OnOff);
  println("2: anagrams_OnOff: " + anagrams_OnOff);
  println("3: lineSeq_OnOff: " + lineSeq_OnOff);
  println("4: snake_OnOff: " + snake_OnOff);
  println("5: imageAsText_OnOff: " + imageAsText_OnOff);
  println("6: sortingLetters_OnOff: " + sortingLetters_OnOff);
  println("7: lettersOnCurve_onOff: " + lettersOnCurve_onOff);
  println();
}