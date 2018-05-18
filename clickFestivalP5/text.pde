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

void createSnakeAnagram(int thisX, int thisY) {
      snakeAnagrams.clear();
      for(int i = 0; i < words[thisX][thisY].length(); i++) {
        snakeAnagrams.append(str(words[thisX][thisY].charAt(i)));
      }
      snakeAnagrams.shuffle(); 
}

void createAnagram(int thisX, int thisY) {
      anagrams.clear();
      for(int i = 0; i < words[thisX][thisY].length(); i++) {
        anagrams.append(str(words[thisX][thisY].charAt(i)));
      }
      anagrams.shuffle(); 
}