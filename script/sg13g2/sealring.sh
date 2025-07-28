#!/bin/bash

FOOTPRINT=script/sg13g2/footprint.tcl

SEALRING_MARGIN=60

DIE_MARGIN_X=$(grep -E "^set DIE_MARGIN_X" "$FOOTPRINT" | awk '{print $3}')
DIE_MARGIN_Y=$(grep -E "^set DIE_MARGIN_Y" "$FOOTPRINT" | awk '{print $3}')
CORE_HEIGHT=$(grep -E "^set CORE_HEIGHT" "$FOOTPRINT" | awk '{print $3}')
CORE_WIDTH=$(grep -E "^set CORE_WIDTH" "$FOOTPRINT" | awk '{print $3}')

DIE_HEIGHT=$(echo "scale=2; 2 * $DIE_MARGIN_Y + $CORE_HEIGHT" | bc)
DIE_WIDTH=$(echo "scale=2; 2 * $DIE_MARGIN_X + $CORE_WIDTH" | bc)

SEALRING_HEIGHT=$(echo "scale=2; 2 * $SEALRING_MARGIN + $DIE_HEIGHT" | bc)
SEALRING_WIDTH=$(echo "scale=2; 2 * $SEALRING_MARGIN + $DIE_WIDTH" | bc)

echo "CORE WIDTH: $CORE_WIDTH CORE HEIGHT: $CORE_HEIGHT"
echo "MARGIN X: $DIE_MARGIN_X MARGIN Y: $DIE_MARGIN_Y"
echo "DIE WIDTH: $DIE_WIDTH DIE HEIGHT: $DIE_HEIGHT"
echo "SEALRING WIDTH: $SEALRING_WIDTH SEALRING HEIGHT: $SEALRING_HEIGHT"

klayout -n sg13g2 -zz -r script/sg13g2/sealring.py -rd width=$SEALRING_WIDTH -rd height=$SEALRING_HEIGHT -rd output=script/sg13g2/sealring.gds -rd offset_x=-$SEALRING_MARGIN -rd offset_y=-$SEALRING_MARGIN
