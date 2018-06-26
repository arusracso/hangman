class HangmanSolution {
  private ArrayList<String> kSolutionList;
  private ArrayList<String> lexicon;
  private char[] kCharBuffer;
  private int kSolutionIndex;
  private int kNumSolutions;
  private int kNumCharacters;
  private int kDefaultCharNum = 26;
  private final char[] kCharSet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ' '};
  public HangmanSolution(ArrayList<String> lexicon, int kNumCharacters, String buffer) {
    kSolutionList = new ArrayList<String>();
    kSolutionIndex = 0;
    kCharBuffer = buffer.toCharArray();
    this.lexicon = lexicon;
    this.kNumCharacters = kNumCharacters;
  }

  private void findPossibleSolutions(String word, int depth) {
    if (depth == kNumCharacters) {
      String lower = word.toLowerCase();
      if (lexicon.contains(lower)) {
        kSolutionList.add(lower);
        println("found: " + lower);
      }
      return;
    }
    if (kCharBuffer[depth] != ' ') {
      findPossibleSolutions(word, depth + 1);
    } else {
      char[] charArray = word.toCharArray();
      for (int i = 0; i < kDefaultCharNum; i++) {
        charArray[depth] = kCharSet[i];
        findPossibleSolutions(new String(charArray), depth + 1);
      }
    }
  }

  public int findAllPossibleSolutions() {
    findPossibleSolutions(new String(kCharBuffer), 0);
    kNumSolutions = kSolutionList.size();
    println("Found this many: " + kNumSolutions);
    return kNumSolutions;
  }

  public ArrayList<String> getAllPossibleSolutions() {
    return kSolutionList;
  }

  public String getNextSolution() {
    kSolutionIndex = (kSolutionIndex + 1) % kNumSolutions;
    return kSolutionList.get(kSolutionIndex);
  }

  public String getPreviousSolution() {
    if (kSolutionIndex == 0) kSolutionIndex = kNumSolutions;
    kSolutionIndex--;
    return kSolutionList.get(kSolutionIndex);
  }
}
