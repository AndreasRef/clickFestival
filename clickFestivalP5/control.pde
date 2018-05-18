//Functions for manually deciding what gets shown

// Key states
boolean perlinLetters_OnOff = false;
boolean anagrams_OnOff = false;
boolean lineSeq_OnOff = false;
boolean snake_OnOff = false;
boolean imageAsText_OnOff = false;
boolean sortingLetters_OnOff = true;

void keyPressed() {
  if(key == '1') { perlinLetters_OnOff  = !perlinLetters_OnOff; }
  if(key == '2') { anagrams_OnOff       = !anagrams_OnOff; }
  if(key == '3') { lineSeq_OnOff        = !lineSeq_OnOff; }
  if(key == '4') { snake_OnOff          = !snake_OnOff; }
  if(key == '5') { 
  imageAsText_OnOff= !imageAsText_OnOff; 
  imageAlpha = 0;
}
  if (key == '6') { sortingLetters_OnOff = !sortingLetters_OnOff; }
  if (key == 'a' || key == 'A') {soundReactiveAlpha = !soundReactiveAlpha; }
  if (key == 'c' || key == 'C') {background(0); }
  
  
  
  println("1: perlinLetters_OnOff: " + perlinLetters_OnOff);
  println("2: anagrams_OnOff: " + anagrams_OnOff);
  println("3: lineSeq_OnOff: " + lineSeq_OnOff);
  println("4: snake_OnOff: " + snake_OnOff);
  println("5: imageAsText_OnOff: " + imageAsText_OnOff);
  println();
}