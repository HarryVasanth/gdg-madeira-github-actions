#!/bin/bash

# Array storing the dice faces
dice_faces=(
"+-------+
|       |
|   o   |
|       |
+-------+"
"+-------+
| o     |
|       |
|     o |
+-------+"
"+-------+
| o     |
|   o   |
|     o |
+-------+"
"+-------+
| o   o |
|       |
| o   o |
+-------+"
"+-------+
| o   o |
|   o   |
| o   o |
+-------+"
"+-------+
| o o o |
|       |
| o o o |
+-------+"
)

# Roll the dice and display the result
roll=$((RANDOM % 6))
echo "${dice_faces[$roll]}"