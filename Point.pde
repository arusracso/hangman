class Point {
  private int x, y;
  
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  Point() {
    this.x = 0;
    this.y = 0;
  }
  
  public boolean inBounds(int x1, int y1, int x2, int y2) {
    if ((x < x1) || (x > x2) || (y < y1) ||(y > y2)) return false;
    return true;
  }
}
