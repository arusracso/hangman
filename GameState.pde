public enum GameState {
  MainMenu, Settings, GamePlay;

  private PImage kBackgroundImage;
  private color kBackgroundColor;
  private boolean usingImage = false;
  private GameState() {
    kBackgroundImage = null;
  }

  public void setBackgroundImage(PImage image) {
    kBackgroundImage = image;
    usingImage = true;
  }
  
  public PImage getBackgroundImage() {
    return kBackgroundImage;
  }

  public void setBackgroundColor(color c) {
    kBackgroundColor = c;
  }

  public color getBackgroundColor() {
    return kBackgroundColor;
  }
  
  public void setImageState(boolean usingImage) {
    this.usingImage = usingImage;
  }

  public boolean getImageState() {
    return usingImage;
  }
}
