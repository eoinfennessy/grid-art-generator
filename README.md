# grid-art-generator
Uses Java in [Processing 3](URL "https://processing.org/") to create colourful generative grids from user-specified parameters

![SweetShop](https://user-images.githubusercontent.com/85010533/165533827-0c700248-e0e5-424a-ba03-0e7e3f15452a.PNG)
 
### How it works:
- Creates a grid of tiles, each of which is recursively divided into randomly-created irregular grids.
- Each division is then filled with a variety of randomly picked patterns.
- Most of these patterns are simple shapes which are recursively drawn again and again, but smaller each time, creating a striped effect.
- A new hue is randomly generated for each column. Each pattern uses variations on this hue as well as saturation and brightness to create self-similar colours for the column.
- The user can control many parameters through the menu (Left Click or Enter) or using keys on the keyboard

### The user has control over the following:
- The types of tile fill-patterns that appear in the image
    - Using the settings menu (Left Click or Enter)
- The number of tiles in each column and row
    - Using keys Q, A, W and S or the settings menu (Left Click or Enter)
- The probability of each tile and its divisions further dividing
    - Using keys E and D or the settings menu (Left Click or Enter)
- The padding between tiles
    - Using keys R and F or the settings menu (Left Click or Enter)
- The size of the pattern stripes
    - Using keys T and G or the settings menu (Left Click or Enter)
- The alpha value of all colours
    - Using keys Y and H or the settings menu (Left Click or Enter)
- The background colour
    - Using the mouse scroll wheel
- Saving a .PNG image
    - Using Right Click

### Some settings to try experimenting with:
- Try using different combinations of tile patterns, or just use one at a time - "EA", "RLL", and "T" are a few that I like.
- Try upping the number of columns to 25 and rows to 14, or setting both to 1
- Try changing probablility of tile division - a high setting shows lots of division whereas a low setting usually just shows one shape, and is useful for experimenting with stripe width

![ezgif com-gif-maker](https://user-images.githubusercontent.com/85010533/165538585-1c6efeeb-b48f-41f4-8cad-0cc73fe80287.gif)
