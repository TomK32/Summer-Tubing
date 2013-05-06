
# How to Make new Levels

First open your image editor and draw a race-course, make sure to keep
the river section in a separate layer for easy export.
Corona has a limit on how big textures can be so the game is happily
accepting images of a size like 200x800 and scales them up for a more
pixelated feeling.

Save the course, and in the second step that the river layer.
For this collision image you add a black background, cut back the
river banks a bit and change the river's colour into white.
Export this as a png and move it into the directory love2d.
In there you find main.lua, this is a love2d file because
corona doen't have getPixel() on the Image.
Change the image file of the image and file to whatever level you are now
and run the main.lua with love2d.
This will give you a lua file with a large table of values from 0 at the
places where the player can't move through to high values to 255 where
the river is.

You can test the level and debug the collision map inside the game.

The next step is to create a level file in levels.
See the existing files for reference.

