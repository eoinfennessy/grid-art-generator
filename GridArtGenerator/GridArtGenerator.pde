import javax.swing.*;

int noOfColumns = 5;
int noOfRows = 3;
int paddingSize = 10;
int backgroundColour = 0;
int stripeWidth = 25;
int alpha = 255;
float probabilityOfFurtherGridDivisions = 0.6;
float tileSideLength;
float horizontalMargin, verticalMargin;
String validTileFillTypes = "AELRT";
String tileFillTypes = validTileFillTypes;
String filename;

void setup() {
  size(1280, 720);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  frameRate(0.5);

  // Set size of grid elements and margins
  setTileSideLength();
  setHorizontalMargin();
  setVerticalMargin();
  
  // Gets initial filename
  filename = getNewFileName();
}

void draw() {
  // Saves frame at start of every draw using the same filename each time (right-click changes name)
  save(filename + ".PNG");
  background(backgroundColour);
  drawGrid();
  
  // Turns off the cursor when it is on the screen and not moving
  noCursor();
}

/*
* Draws a grid of tiles using global variables noOfColumns and noOfRows,
 * randomly generates a hue for each column,
 * gets a random fill type for each tile,
 * then calls function to divide and fill each tile
 */
void drawGrid() {
  for (int i = 0; i < noOfColumns; i++) {
    float hue = random(360);
    for (int j = 0; j < noOfRows; j++) {
      char fillType = getRandomFillType(tileFillTypes);
      divideTile(tileSideLength*i + paddingSize*(i + 1) + horizontalMargin,
                 tileSideLength*j + paddingSize*(j + 1) + verticalMargin,
                 tileSideLength, tileSideLength, fillType, hue);
    }
  }
}

/*
* Recursively divides tile until each division becomes too small or a random value condition
 * with a given probability is met and then calls a function to fill the current division.
 */
void divideTile(float x, float y, float gridWidth, float gridHeight, char fillType, float hue) {
  // Base case: If grid becomes too small or if random value is greater than given probability
  if (gridWidth < 10 || gridHeight < 10 || (random(1) >= probabilityOfFurtherGridDivisions)) {
    // Fill the current division and return
    fillDivision(x, y, gridWidth, gridHeight, fillType, hue);
    return;
  }

  float newGridWidth = gridWidth / 2;
  float newGridHeight = gridHeight / 2;

  // Recursively divide grid or current division into quarters
  divideTile(x, y, newGridWidth, newGridHeight, fillType, hue);
  divideTile(x+newGridWidth, y, newGridWidth, newGridHeight, fillType, hue);
  divideTile(x, y+newGridHeight, newGridWidth, newGridHeight, fillType, hue);
  divideTile(x+newGridWidth, y+newGridHeight, newGridWidth, newGridHeight, fillType, hue);
}

// Selects and calls appropriate fill function using fillType parameter
void fillDivision(float x, float y, float tileWidth, float tileHeight, char fillType, float hue) {
  if (fillType == 'R') {
    fillWithRectangles(x, y, tileWidth, tileHeight, hue);
  } else if (fillType == 'E') {
    fillWithEllipses(x, y, tileWidth, tileHeight, hue);
  } else if (fillType == 'T') {
    fillWithTriangles(x, y, tileWidth, tileHeight, hue);
  } else if (fillType == 'A') {
    fillWithArcs(x, y, tileWidth, tileHeight, hue);
  } else if (fillType == 'L') {
    fillWithLines(x, y, tileWidth, tileHeight, hue);
  }
}

/*
 * Draws a solid rectangle of random colour similar to hue parameter
 * then recursively calls itself with a smaller width and height until
 * either the width or height becomes less than or equal to zero
 */
void fillWithRectangles(float x, float y, float rectWidth, float rectHeight, float hue) {
  if (rectWidth <= 0 || rectHeight <= 0) {
    return;
  }
  
  // Sets fill to randomly created colour using the hue parameter
  fill((hue + random(-20, 20)) % 360, random(80, 100), random(80, 100), alpha);
  rect(x, y, rectWidth, rectHeight);
  
  /* Recursively calls itself with stripeWidth added to x and y and stripeWidth * 2 subtracted 
  from rectWidth and rectHeight */
  fillWithRectangles(x+stripeWidth, y+stripeWidth,
                     rectWidth-(stripeWidth*2), rectHeight-(stripeWidth*2), hue);
}

/*
 * Draws a solid ellipse of random colour similar to hue parameter
 * then recursively calls itself with a smaller width and height until
 * either the width or height becomes less than or equal to zero
 */
void fillWithEllipses(float x, float y, float ellipseWidth, float ellipseHeight, float hue) {
  if (ellipseWidth <= 0 || ellipseHeight <= 0) {
    return;
  }
  // Sets fill to randomly created colour using the hue parameter
  fill((hue + random(-20, 20)) % 360, random(80, 100), random(80, 100), alpha);
  ellipse(x + (ellipseWidth/2), y + (ellipseHeight/2), ellipseWidth, ellipseHeight);
  
  /*
  * Recursively calls itself with stripeWidth added to x and y and (stripeWidth * 2)
  * subtracted from ellipseWidth and ellipseHeight
  */
  fillWithEllipses(x+stripeWidth, y+stripeWidth,
                   ellipseWidth-(stripeWidth*2), ellipseHeight-(stripeWidth*2), hue);
}

/*
 * Draws a solid triangle of random colour similar to hue parameter
 * then recursively calls itself with a smaller width and height until
 * either the width or height becomes less than or equal to zero
 */
void fillWithTriangles(float x, float y, float triangleWidth, float triangleHeight, float hue) {
  if (triangleWidth <= 0 || triangleHeight <= 0) {
    return;
  }
  // Sets fill to randomly created colour using the hue parameter
  fill((hue + random(-20, 20)) % 360, random(80, 100), random(80, 100), alpha);
  triangle(x + (triangleWidth/2), y, x, y + triangleHeight, x + triangleWidth, y + triangleHeight);
  
  /*
  * Recursively calls itself with stripeWidth added to x and y and (stripeWidth * 2)
  * subtracted from ellipseWidth and ellipseHeight
  * TODO: Work out proper formula for this: *1.38 is an arbitrary number that looks about right
  */
  fillWithTriangles(x+stripeWidth, y+(stripeWidth*1.38),
                    triangleWidth-(stripeWidth*2), triangleHeight-(stripeWidth*2), hue);
}

// Randomly selects and then calls function to draw one of four different quarter-ellipses
void fillWithArcs(float x, float y, float arcWidth, float arcHeight, float hue) {
  float randomNumber = random(1);
  if (randomNumber >= 0.75) {
    // Draw arcs from three o'clock to six o'clock
    drawArcs(x, y, arcWidth*2, arcHeight*2, 0, PI/2, hue);
  } else if (randomNumber >= 0.5) {
    // Draw arcs from six o'clock to nine o'clock
    drawArcs(x + arcWidth, y, arcWidth*2, arcHeight*2, PI/2, PI, hue);
  } else if (randomNumber >= 0.25) {
    // Draw arcs from nine o'clock to twelve o'clock
    drawArcs(x + arcWidth, y + arcHeight, arcWidth*2, arcHeight*2, PI, PI*1.5, hue);
  } else {
    // Draw arcs from twelve o'clock to three o'clock
    drawArcs(x, y + arcHeight, arcWidth*2, arcHeight*2, PI*1.5, TWO_PI, hue);
  }
}

/*
 * Draws a solid arc of random colour similar to hue parameter
 * then recursively calls itself with a smaller width and height until
 * either the width or height becomes less than or equal to zero
 */
void drawArcs(float x, float y, float arcWidth, float arcHeight,
              float angleA, float angleB, float hue) {
  if (arcWidth <= 0 || arcHeight <= 0) {
    return;
  }
  // Sets fill to randomly created colour using the hue parameter
  fill((hue + random(-20, 20)) % 360, random(80, 100), random(80, 100), alpha);
  arc(x, y, arcWidth, arcHeight, angleA, angleB);
  // Recursively calls itself with stripeWidth * 2 subtracted from arcWidth and arcHeight
  drawArcs(x, y, arcWidth-(stripeWidth*2), arcHeight-(stripeWidth*2), angleA, angleB, hue);
}

/*
* Randomly selects one of the four diagonal halves of the division and fills it with 
* diagonal lines, starting with the longest diagonal. Each line will be a new random colour
* similar to the hue parameter, and adjacent lines will be drawn (stripeWidth * 2) pixels apart.
*/
void fillWithLines(float x, float y, float lineWidth, float lineHeight, float hue) {
  float newX, newY;
  float randomNumber = random(1);
  
  strokeWeight(3);
  
  if (randomNumber >= 0.75) {
    newX = x;
    newY = y + lineHeight;
    while (newX <= x+lineWidth && newY >= y) {
      stroke((hue + random(-20, 20)) % 360, random(80, 100), random(80, 100), alpha);
      line(newX, y, x + lineWidth, newY);
      newX += (stripeWidth*2);
      newY -= (stripeWidth*2);
    }
  } else if (randomNumber >= 0.5) {
    newX = x;
    newY = y;
    while (newX <= x + lineWidth && newY <= y + lineHeight) {
      stroke((hue + random(-20, 20)) % 360, random(80, 100), random(80, 100), alpha);
      line(newX, y + lineHeight, x + lineWidth, newY);
      newX += (stripeWidth*2);
      newY += (stripeWidth*2);
    }
  } else if (randomNumber >= 0.25) {
    newX = x + lineWidth;
    newY = y + lineHeight;
    while (newX >= x && newY >= y) {
      stroke((hue + random(-20, 20)) % 360, random(80, 100), random(80, 100), alpha);
      line(newX, y + lineHeight, x + lineWidth, newY);
      newX -= (stripeWidth*2);
      newY -= (stripeWidth*2);
    }
  } else {
    newX = x + lineWidth;
    newY = y;
    while (newX >= x && newY <= y + lineHeight) {
      stroke((hue + random(-20, 20)) % 360, random(80, 100), random(80, 100), alpha);
      line(x, newY, newX, y+lineHeight);
      newX -= (stripeWidth*2);
      newY += (stripeWidth*2);
    }
  }
  noStroke();
}

/* 
* Sets the tiles' side lengths to be as large as possible given
* the window width, padding size, and number of columns and rows
*/
void setTileSideLength() {
  tileSideLength = min((width - paddingSize * (noOfColumns + 1)) / noOfColumns,
                       (height - paddingSize * (noOfRows + 1)) / noOfRows);
}

/* Sets an even margin size for the sides of the window given
* the window size, tile side length, padding size and number of columns
*/
void setHorizontalMargin() {
  horizontalMargin = (width - (tileSideLength * noOfColumns
                      + paddingSize * (noOfColumns + 1))) / 2;
}

/* Sets an even margin size at the top and bottom of the window
* given the window size, tile side length, padding size and number of rows
*/
void setVerticalMargin() {
  verticalMargin = (height - (tileSideLength * noOfRows
                    + paddingSize * (noOfRows + 1))) / 2;
}

// Bundles together three commonly-used-together functions for setting grid dimensions
void resetGrid() {
  setTileSideLength();
  setHorizontalMargin();
  setVerticalMargin();
}

// Returns a char from the fillTypes parameter representing a random fill type 
char getRandomFillType(String fillTypes) {
  return fillTypes.charAt(floor(random(fillTypes.length())));
}

// Changes the global filename when the right mouse button is pressed
void mousePressed() {
  if (mouseButton == RIGHT) {
    filename = getNewFileName();
  }
}

/*
* Prompts user for next image's filename and returns it
* If the user hits cancel or closes the window, returns the current filename with a one appended
*/
String getNewFileName() {
  String newFilename = JOptionPane.showInputDialog("Enter a filename for the next image capture:");
  // TODO: Improve filename-checking and auto-increment filename if it stays the same
  if (newFilename == null) {
    return filename + "1";
  }
  return newFilename;
}

//// Calls function to save image as .PNG when mouse is right-clicked
//void mousePressed() {
//  if (mouseButton == RIGHT) {
//    saveImage(".PNG");
//    //filename = JOptionPane.showInputDialog("Enter an filename for your next image capture:");
//  }
//}

//// Prompts user for imageName and concatenates it with fileSuffix before saving
//void saveImage(String fileSuffix) {
//  String imageName = JOptionPane.showInputDialog("Enter an image name:");
//  // TODO: Add better filename-checking
//  if (imageName != null) {
//    save(imageName + fileSuffix);
//  }
//}


// Calls function to open settings when mouse is left-clicked
void mouseClicked() {
  if (mouseButton == LEFT) {
    openSettings();
  }
}

// Shows the mouse cursor when the mouse is moved (works in tandem with noCursor() in draw())
void mouseMoved() {
  cursor();
}

// Turning the mouse wheel changes the tone of the background and prints the result to console
void mouseWheel(MouseEvent event) {
  backgroundColour -= event.getCount();
  backgroundColour = constrain(backgroundColour, 0, 360);
  println("Background colour:", backgroundColour);
}

// Opens the settings menu, where the user can change many parameters
void openSettings() {
  String menuSetting = JOptionPane.showInputDialog("Settings Menu\n\nT - Change tile types\n"
          + "C - Set number of columns in main grid\nR - Set number of rows in main grid\n"
          + "P - Set probability of each tile subdividing\nG - Set gap/padding between tiles\n"
          + "B - Set band/stripe size for shapes\nA - Set alpha value\n");
      
  // Handles user closing settings window or pressing cancel
  if (menuSetting == null) {
    return;
  }
  menuSetting = formatUserInput(menuSetting);

  // TODO: Improve validation and error handling
  if (menuSetting.equals("T")) {
    tileFillTypes = getNewTileFillTypes();
  } else if (menuSetting.equals("C")) {
    int newNoOfColumns = getNewNoOfColumns();
    if (newNoOfColumns != noOfColumns) {
      noOfColumns = newNoOfColumns;
      resetGrid();
    }
  } else if (menuSetting.equals("R")) {
    int newNoOfRows = getNewNoOfRows();
    if (newNoOfRows != noOfRows) {
      noOfRows = newNoOfRows;
      resetGrid();
    }
  } else if (menuSetting.equals("P")) {
    probabilityOfFurtherGridDivisions = getNewProbabilityOfFurtherGridDivisions();
  } else if (menuSetting.equals("G")) {
    int newPaddingSize = getNewPaddingSize();
    if (newPaddingSize != paddingSize) {
      paddingSize = newPaddingSize;
      resetGrid();
    }
  } else if (menuSetting.equals("B")) {
    stripeWidth = getNewStripeWidth();
  } else if (menuSetting.equals("A")) {
    alpha = getNewAlphaValue();
  } else {
    // Calls this function again if string does not match any of the cases above
    openSettings();
  }
}

/*
* Prompts user to give list of tile fill types and returns this list if it is valid, otherwise
* calls the function again. Returns old list of tile fill types if the user hits cancel or
* closes the window, and returns all valid tile fill types if the user enters "all".
*/
String getNewTileFillTypes() {
  String newTileFillTypes;
  do {
    newTileFillTypes = JOptionPane.showInputDialog("Enter a list of letters corresponding to the "
            + "types of tile pattern you wish to appear on the grid\n\nA - Arcs\nR - Rectangles"
            + "\nE - Ellipses\nL - Lines\nT - Triangles\n\nEntering \"All\" will use every "
            + "available tile pattern");
    // If user hits cancel or close
    if (newTileFillTypes == null) {
      // Returns old tile fill types
      return tileFillTypes;
    }
    // Loop continues if user input is empty
  } while (newTileFillTypes.isEmpty());
  newTileFillTypes = formatUserInput(newTileFillTypes);
  // If user input is valid
  if (containsValidTileFillTypes(newTileFillTypes)) {
    if (newTileFillTypes.equals("ALL")) {
      // Return list of all possible fill types
      return validTileFillTypes;
    } else {
      return newTileFillTypes;
    }
  } else {
    // Call function again if input is not valid
    return getNewTileFillTypes();
  }
}

// Returns str parameter converted to uppercase with leading and trailing whitespace removed
String formatUserInput(String str) {
  return str.trim().toUpperCase();
}

/* 
* Returns false if any of the characters in str are not contained in the global list of tile types
* Otherwise returns true and will also return true if str is "ALL".
*/
boolean containsValidTileFillTypes(String str) {
  if (str.equals("ALL")) {
    return true;
  }
  for (int i = 0; i < str.length(); i++) {
    // If char at index i in str parameter is not also in validTileFillTypes
    if (validTileFillTypes.indexOf(str.charAt(i)) == -1) {
      return false;
    }
  }
  return true;
}

/*
* Prompts user to enter a number to be used as the new number of columns
* Converts the string to an integer and returns this number if it is valid, otherwise calls
* itself again. Returns current value for noOfColumns if user hits cancel or closes the window.
*/
int getNewNoOfColumns() {
  String newNoOfColumnsStr = JOptionPane.showInputDialog("Set number of columns in main grid\n\n"
          + "Enter a whole number greater than zero:");

  // If the user hits cancel or closes the window
  if (newNoOfColumnsStr == null) {
    return noOfColumns;
  }
  int newNoOfColumns = parseInt(newNoOfColumnsStr);
  if (newNoOfColumns <= 0) {
    return getNewNoOfColumns();
  }
  return newNoOfColumns;
}

// Returns the value of noOfColumns incremented by i if it is greater than zero, else noOfColumns
int getNewNoOfColumns(int i) {
  if (noOfColumns + i <= 0) {
    return noOfColumns;
  }
  return noOfColumns + i;
}

/*
* Prompts user to enter a number to be used as the new number of rows
* Converts the string to an integer and returns this number if it is valid, otherwise calls
* itself again. Returns current value for noOfRows if user hits cancel or closes the window.
*/
int getNewNoOfRows() {
  String newNoOfRowsStr = JOptionPane.showInputDialog("Set number of rows in main grid\n\n"
          + "Enter a whole number greater than zero:");

  // If the user hits cancel or closes the window
  if (newNoOfRowsStr == null) {
    return noOfRows;
  }
  int newNoOfRows = parseInt(newNoOfRowsStr);
  if (newNoOfRows <= 0) {
    return getNewNoOfRows();
  }
  return newNoOfRows;
}

// Returns the value of noOfRows incremented by i if it is greater than zero, else noOfRows
int getNewNoOfRows(int i) {
  if (noOfRows + i <= 0) {
    return noOfRows;
  }
  return noOfRows + i;
}

/*
* Prompts user to enter a number to be used as the new probability percentage of grid divisions
* Converts the string to an integer and if it is valid, returns the number divided by 100.0,
* otherwise it calls itself again. Returns the current value of probabilityOfFurtherGridDivisions
* if user hits cancel or closes window.
*/
float getNewProbabilityOfFurtherGridDivisions() {
  String newProbability = JOptionPane.showInputDialog("Set the percentage probability of each"
          + " tile and its subdivisions subdividing\n\n"
          + "Enter a whole number between 0 and 100 inclusive:");

  // If the user hits cancel or closes the window
  if (newProbability == null) {
    return probabilityOfFurtherGridDivisions;
  }
  int newProbabilityInt = parseInt(newProbability);
  if (newProbabilityInt >= 0 && newProbabilityInt <= 100) {
    return newProbabilityInt / 100.0;
  } else {
    return getNewProbabilityOfFurtherGridDivisions();
  }
}

/*
* Returns the value of probabilityOfFurtherGridDivisions incremented by i if it is between zero
* and one inclusive, otherwise returns either zero if it is less than zero, or one if it is greater
* than one.
*/
float getNewProbabilityOfFurtherGridDivisions(float i) {
  if (probabilityOfFurtherGridDivisions + i < 0) {
    return 0;
  } else if (probabilityOfFurtherGridDivisions + i > 1) {
    return 1;
  }
  return probabilityOfFurtherGridDivisions + i;
}

/*
* Prompts user to enter a number to be used as the new padding size
* Converts the string to an integer and returns this number if it is valid, otherwise calls
* itself again. Returns current value for newPaddingSize if user hits cancel or closes the window.
*/
int getNewPaddingSize() {
  String newPaddingSizeStr = JOptionPane.showInputDialog("Sets padding size (pixels)\n\n"
          + "Enter a number greater than or equal to zero:");

  // If the user hits cancel or closes the window
  if (newPaddingSizeStr == null) {
    return paddingSize;
  }
  int newPaddingSize = parseInt(newPaddingSizeStr);
  if (newPaddingSize >= 0) {
    return newPaddingSize;
  } else {
    return getNewPaddingSize();
  }
}

// Returns the value of paddingSize incremented by i if it is greater than zero, else zero
int getNewPaddingSize(int i) {
  if (paddingSize + i < 0) {
    return 0;
  }
  return paddingSize + i;
}

/*
* Prompts user to enter a number to be used as the new stripe width
* Converts the string to an integer and returns this number if it is valid, otherwise calls
* itself again. Returns current value for newStripeWidth if user hits cancel or closes the window.
*/
int getNewStripeWidth() {
  String newStripeWidthStr = JOptionPane.showInputDialog("Set the width in pixels of stripes on"
          + " striped shapes and distance between lines\n\nEnter a whole number greater than 0:");

  // If the user hits cancel or closes the window
  if (newStripeWidthStr == null) {
    return stripeWidth;
  }
  int newStripeWidth = parseInt(newStripeWidthStr);
  if (newStripeWidth > 0) {
    return newStripeWidth;
  } else {
    return getNewStripeWidth();
  }
}

// Returns the value of paddingSize incremented by i if it is greater than zero, else one
int getNewStripeWidth(int i) {
  if (stripeWidth + i <= 0) {
    return 1;
  }
  return stripeWidth + i;
}

/*
* Prompts user to enter a number to be used as the new alpha value
* Converts the string to an integer and returns this number if it is valid, otherwise calls
* itself again. Returns current value for alpha if user hits cancel or closes the window.
*/
int getNewAlphaValue() {
  String newAlphaValueStr = JOptionPane.showInputDialog("Set the alpha value for all colours\n\n"
          + "Enter a whole number between 1 and 255 inclusive:");

  // If the user hits cancel or closes the window
  if (newAlphaValueStr == null) {
    return alpha;
  }
  int newAlphaValue = parseInt(newAlphaValueStr);
  if (newAlphaValue >= 0 && newAlphaValue <= 255) {
    return newAlphaValue;
  } else {
    return getNewAlphaValue();
  }
}

/*
* Returns the value of alpha incremented by i if it is between zero and 255 inclusive,
* otherwise returns either zero if it is less than zero, or 255 if it is greater than 255
*/
int getNewAlphaValue(int i) {
  if (alpha + i < 0) {
    return 0;
  } else if (alpha + i > 255) {
    return 255;
  }
  return alpha + i;
}

// Handles all key-presses
void keyPressed() {
  if (key == 'q' || key == 'Q') {
    noOfColumns = getNewNoOfColumns(1);
    resetGrid();
  } else if (key == 'a' || key == 'A') {
    noOfColumns = getNewNoOfColumns(-1);
    resetGrid();
  } else if (key == 'w' || key == 'W') {
    noOfRows = getNewNoOfRows(1);
    resetGrid();
  } else if (key == 's' || key == 'S') {
    noOfRows = getNewNoOfRows(-1);
    resetGrid();
  } else if (key == 'e' || key == 'E') {
    probabilityOfFurtherGridDivisions = getNewProbabilityOfFurtherGridDivisions(0.1);
  } else if (key == 'd' || key == 'D') {
    probabilityOfFurtherGridDivisions = getNewProbabilityOfFurtherGridDivisions(-0.1);
  } else if (key == 'r' || key == 'R') {
    paddingSize = getNewPaddingSize(1);
    resetGrid();
  } else if (key == 'f' || key == 'F') {
    paddingSize = getNewPaddingSize(-1);
    resetGrid();
  } else if (key == 't' || key == 'T') {
    stripeWidth = getNewStripeWidth(1);
  } else if (key == 'g' || key == 'G') {
    stripeWidth = getNewStripeWidth(-1);
  } else if (key == 'y' || key == 'Y') {
    alpha = getNewAlphaValue(10);
  } else if (key == 'h' || key == 'H') {
    alpha = getNewAlphaValue(-10);
  } else if (key == ENTER || key == RETURN) {
    openSettings();
  }
}
