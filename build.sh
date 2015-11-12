#!/bin/bash

# Let's see if we can come up with a build and deploy system for this project.

# Publish all the org-mode files into HTML files useable by the probject.
emacs -Q --batch -l build.el

# Combine and compile the coffeescript files into JavaScript files.
#
# If I had to do this a third time, I would turn this into a loop, but
# I really want the "ada.coffee" at the top level, since that is the
# secondary learning exercise...

OBJ=js/ada-int.coffee
cat js/hardware-pre.coffee ada.coffee js/hardware.coffee > $OBJ
coffee -o js -c $OBJ
mv js/ada-int.js js/ada.js
rm $OBJ

OBJ=js/tutorial-int.coffee
cat js/hardware-pre.coffee ada.coffee js/tutorial.coffee > $OBJ
coffee -o js -c $OBJ
mv js/tutorial-int.js js/tutorial.js
rm $OBJ

rsync -avz * $DEST
