class IterativeSolution {
  private ArrayList<String> kSolutionList;
  private char[] kCharBuffer;
  private int kSolutionIndex;
  private int kNumCharacters;
  private int kNumSolutions;
  private String kSortedFilepath;
  public IterativeSolution (String kSortedFilepath, int kNumCharacters, String kCharBuffer) {
    kSolutionList = new ArrayList<String>();
    kSolutionIndex = 0;
    this.kSortedFilepath = kSortedFilepath;
    this.kNumCharacters = kNumCharacters;
    this.kCharBuffer = kCharBuffer.toCharArray();
  }

  private boolean isSolution(String line) {
    for (int i = 0; i < kNumCharacters; i++) {
      if (kCharBuffer[i] == ' ') continue;
      char bufferCharacter = Character.toLowerCase(kCharBuffer[i]);
      if (line.charAt(i) != bufferCharacter) return false;
    }
    return true;
  }

  private final String kDefaultDataFile = "/words.data";
  private final String kShortPrefix = "0";
  private final int kNamingThreshold = 10;
  public int findAllPossibleSolutions() {
    int num = kNumCharacters;
    String dataFilepath = num < kNamingThreshold ? kShortPrefix + Integer.toString(num) : Integer.toString(num);
    String inputPath = kSortedFilepath + dataFilepath + kDefaultDataFile;
    BufferedReader reader = createReader(inputPath);
    String line = null;
    try {
      while ((line = reader.readLine()) != null) {
        if (isSolution(line)) {
          kSolutionList.add(line);
        }
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
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
