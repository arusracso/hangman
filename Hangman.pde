static final String kDefaultFilepath = "./metadata";
static final int kDefaultWidth = 600;
static final int kDefaultHeight = 600;

void setup() {
  size(600, 600);
  smooth(8);
  background(0, 221, 225);
  importMetadata(kDefaultFilepath);
}

static final char kIgnoreChar = '$';
static int kNumCharacters = 0;
static char[] kCharBuffer;
void importMetadata(String filename) {
  BufferedReader reader = createReader(filename);
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      if (line.charAt(0) != kIgnoreChar) {
        String[] tokens = split(line, ' ');
        switch (tokens[0]) { 
        case "lexiconPrivate":
          buildlexiconPrivate(tokens[1]);
          break;
        case "charnum": 
          kNumCharacters = Integer.parseInt(tokens[1]);
          break;
        default: 
          break;
        }
      }
    }
    setupCharacters();
    drawCharacters();
    setupLayout();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

void setupCharacters() {
  kCharBuffer = new char[kNumCharacters];
  for (int i = 0; i < kNumCharacters; i++) {
    kCharBuffer[i] = ' ';
  }
}

static ArrayList<String> lexiconPrivate = new ArrayList<String>();
static int totalWords = 0;
void buildlexiconPrivate(String lexiconPrivateFilepath) {
  BufferedReader reader = createReader(lexiconPrivateFilepath);
  String word = null;
  int wordCount = 0;
  try {
    while ((word = reader.readLine()) != null) {
      lexiconPrivate.add(word.toLowerCase());
      wordCount++;
    }
    totalWords = wordCount;
    println("[Hangman] Successfully read " + wordCount + " words from: " + lexiconPrivateFilepath + ".");
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

static final int kPixelBuffer = 50;
static final int kPixelSpace = 25;
static final int kNumArrows = 2;
static final String kImageDirectory = "./images/";
static final char[] kCharSet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ' '};
static final int kNumCharInSet = kCharSet.length;
static int kCharX = 0;
static int kCharY = 0;
static boolean[] kDownClicked;
static boolean[] kUpClicked;
static Point[] kDownPoints;
static Point[] kUpPoints;
PImage[] kArrowUpImages = new PImage[kNumArrows];
PImage[] kArrowDownImages = new PImage[kNumArrows];
PImage kGoImage;
PImage letterA;
static Point kGoPoint;
static boolean first = true;
void setupLayout() {
  if (first) {
    letterA = loadImage(kImageDirectory + "a-unclicked.png");
    kDownPoints = new Point[kNumCharacters];
    kUpPoints = new Point[kNumCharacters];
    kGoImage = loadImage(kImageDirectory + "go.png");
    kArrowUpImages[0] = loadImage(kImageDirectory + "arrow-up-clicked.png");
    kArrowUpImages[1] = loadImage(kImageDirectory + "arrow-up-unclicked.png");
    kArrowDownImages[0] = loadImage(kImageDirectory + "arrow-down-clicked.png");
    kArrowDownImages[1] = loadImage(kImageDirectory + "arrow-down-unclicked.png");
  }
  stroke(255);
  int lastX = kPixelBuffer;
  int lastY = height - kPixelBuffer;
  if (first) imageMode(CENTER);
  if (first) kGoPoint = new Point(25, 25);
  image(kGoImage, 25, 25);
  int charWidth = (width - (2*kPixelBuffer) - ((kNumCharacters - 1)*kPixelSpace)) / kNumCharacters;
  for (int i = 0; i < kNumCharacters; i++) {
    line(lastX, lastY, lastX + charWidth, lastY);
    image(kArrowUpImages[1], lastX + (charWidth / 2), lastY - kMappedTextSize - 25);
    image(kArrowDownImages[1], lastX + (charWidth / 2), lastY + 25);
    if (first) kDownPoints[i] = new Point(lastX + (charWidth / 2), lastY + 25);
    if (first) kUpPoints[i] = new Point(lastX + (charWidth / 2), lastY - (int)kMappedTextSize - 25);
    lastX += charWidth + kPixelSpace;
  }
  first = false;
}

void drawLines() {
  stroke(255);
  int lastX = kPixelBuffer;
  int lastY = height - kPixelBuffer;
  int charWidth = (width - (2*kPixelBuffer) - ((kNumCharacters - 1)*kPixelSpace)) / kNumCharacters;
  for (int i = 0; i < kNumCharacters; i++) {
    line(lastX, lastY, lastX + charWidth, lastY);
    lastX += charWidth + kPixelSpace;
  }
}

static final int kDefaultTextSize = 16;
static final int kMinChars = 0;
static final int kMaxChars = 16;
static final int kCharSpace = 10;
static float kMappedTextSize = 0;
void drawCharacters() {
  int lastX = kPixelBuffer;
  int lastY = height - (kPixelBuffer + kCharSpace);
  int charWidth = (width - (2*kPixelBuffer) - ((kNumCharacters - 1)*kPixelSpace)) / kNumCharacters;
  kMappedTextSize = map(kNumCharacters, kMinChars, kMaxChars, kDefaultTextSize * 4, kDefaultTextSize);
  fill(255);
  textSize(kMappedTextSize);
  textAlign(CENTER);
  for (int i = 0; i < kNumCharacters; i++) {
    //line(lastX, lastY - kMappedTextSize, lastX + charWidth, lastY - kMappedTextSize);
    text(kCharBuffer[i], lastX + (charWidth/2), lastY);
    lastX += charWidth + kPixelSpace;
  }
}

static final int maxRadius = 13;
boolean clickedButton() {
  int x = mouseX;
  int y = mouseY;
  for (int i = 0; i < kNumCharacters; i++) {
    //println("Mouse: (" + x + ", " + y + ")" + " Button: (" + kDownPoints[i].x + ", " + kDownPoints[i].y + ")");
    if (dist(x, y, kDownPoints[i].x, kDownPoints[i].y) < maxRadius) {
      char ch = kCharBuffer[i];
      if (ch == ' ') {
        kCharBuffer[i] = 'Z';
        return true;
      }
      int charIndex = (ch - 'A') - 1;
      if (charIndex < 0) charIndex = kNumCharInSet - 1;
      kCharBuffer[i] = kCharSet[charIndex];
      return true;
    } else if (dist(x, y, kUpPoints[i].x, kUpPoints[i].y) < maxRadius) {
      char ch = kCharBuffer[i];
      if (ch == ' ') {
        kCharBuffer[i] = 'A';
        return true;
      }
      int charIndex = ch - 'A';
      kCharBuffer[i] = kCharSet[(charIndex + 1) % kNumCharInSet];
      return true;
    } else if (dist(x, y, kGoPoint.x, kGoPoint.y) < maxRadius) {
      println("[Hangman] Finding possible solutions...");
      solutions.clear();
      findAllPossibleSolutions(0, new String(kCharBuffer));
      println("[Hangman] Found all solutions: " + solutions.size());
      for (String str : solutions) {
        println("solution: " + str);
      }
      kNumSolutions = solutions.size();
      return true;
    }
  }
  return false;
}

ArrayList<String> solutions = new ArrayList<String>();
static boolean setup = false;
static int kSolutionIndex = 0;
static int kNumSolutions;
void findAllPossibleSolutions(int depth, String word) {
  setup = true;
  if (depth == kNumCharacters - 1) {
    String lower = word.toLowerCase();
    if (lexiconPrivate.contains(lower)) solutions.add(lower);
    return;
  } else {
    if (kCharBuffer[depth] != ' ') {
      findAllPossibleSolutions(depth + 1, word);
    } else {
      char[] charArray = word.toCharArray();
      for (int i = 0; i < kNumCharInSet - 1; i++) {
        charArray[depth] = kCharSet[i];
        findAllPossibleSolutions(depth + 1, new String(charArray));
      }
    }
  }
}

void clear() {
  for (int i = 0; i < kNumCharacters; i++) {
    kCharBuffer[i] = ' ';
  }
}

static boolean loop = true;
void keyPressed() {
  if (key == 'q') {
    loop = (!loop);
    if (loop) {
      loop();
    } else {
      noLoop();
    }
  }
  if (key == 'x') clear();
  if (!setup) return;
  println("[Hangman] Key pressed...");
  if (keyCode == RIGHT) {
    kSolutionIndex = (kSolutionIndex + 1) % kNumSolutions;
    println("Solution index: " + kSolutionIndex);
  } else if (keyCode == LEFT) {
    if (kSolutionIndex == 0) kSolutionIndex = kNumSolutions;
    kSolutionIndex--;
    println("Solution index: " + kSolutionIndex);
  }
  if (kSolutionIndex > solutions.size()) return;
  String solution = solutions.get(kSolutionIndex);
  for (int i = 0; i < solution.length(); i++) {
    kCharBuffer[i] = Character.toUpperCase(solution.charAt(i));
  }
  println("After change buffer is: " + new String(kCharBuffer));
}

void mousePressed() {
  if (clickedButton()) {
  }
}

void draw() {
  background(0, 221, 255);
  setupLayout();
  drawCharacters();
}

class Point {
  int x, y;
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  Point() {
    this.x = 0;
    this.y = 0;
  }
}
