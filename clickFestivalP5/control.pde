//Functions for manually deciding what gets shown

// Key states
boolean perlinLetters_OnOff = true;
boolean anagrams_OnOff = false;
boolean lineSeq_OnOff = false;
boolean snake_OnOff = false;

void keyPressed() {
  if(key == '1') { perlinLetters_OnOff  = !perlinLetters_OnOff; }
  if(key == '2') { anagrams_OnOff       = !anagrams_OnOff; }
  if(key == '3') { lineSeq_OnOff        = !lineSeq_OnOff; }
  if(key == '4') { snake_OnOff          = !snake_OnOff; }
}