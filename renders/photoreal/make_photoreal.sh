#!/usr/bin/env bash
# Rebuilds the photoreal shots on the README, ../hero-<plate|stand>-<orange|black>.jpg: the
# recommended back plate and the recommended desk stand, each in two filaments, rendered in
# Blender (Cycles) with the display from Waveshare's STEP and the pet on the glass.
#
# Heavy and optional: make_renders.sh does not call it, and a model change only needs it if the
# change shows from outside. Needs python3.11 (bpy 4.2 is built for it), OpenSCAD 2021+, a C
# compiler, and the network once for the two venvs, which go into $CACHE.
# Usage: ./make_photoreal.sh   (from this folder; WIDTH and SAMPLES override 1600 and 256,
#        SHOTS="stand" renders only the stand)
#
# The screen images in screens/ are the pet from the JBrain2 firmware
# (https://github.com/jeffmhopkins/JBrain2/tree/main/firmware), one frame drawn by its face.c.
# With FIRMWARE pointing at a checkout's firmware/main they are redrawn from source instead.
set -euo pipefail
cd "$(dirname "$0")"
MODEL=../../amoled18_back_plate.scad
PRESETS=../../amoled18_back_plate.json
CACHE=${PHOTOREAL_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/amoled18-photoreal}
WIDTH=${WIDTH:-1600}
SAMPLES=${SAMPLES:-256}
STEP_ZIP=../../reference/waveshare-3d-model.zip   # Waveshare's, unmodified; see reference/
STEP_SHA=d0b65e213ab8de39b4d0e04684d2b8a06b389c501685b091c8d42252f2cfd4e4
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$CACHE" "$WORK/plate" "$WORK/stand"

# Two venvs: bpy and OCP each pin their own native libraries.
if [ ! -x "$CACHE/blender/bin/python" ]; then
  python3.11 -m venv "$CACHE/blender"
  "$CACHE/blender/bin/pip" install -q "bpy==4.2.23"
fi
if [ ! -x "$CACHE/tools/bin/python" ]; then
  python3.11 -m venv "$CACHE/tools"
  "$CACHE/tools/bin/pip" install -q "cadquery-ocp==8.0.1.0.0" "trimesh==5.1.0" "networkx==3.6.1" \
    "pillow==12.3.0"
fi

echo "Display module (Waveshare's STEP)"
if [ ! -f "$CACHE/module.glb" ]; then
  echo "$STEP_SHA  $STEP_ZIP" | sha256sum -c --quiet
  unzip -o -q "$STEP_ZIP" -d "$CACHE"
  "$CACHE/tools/bin/python" step2glb.py "$CACHE/ESP32-S3-Touch-AMOLED-1.8-3D.stp" "$CACHE/module.glb"
fi
cp "$CACHE/module.glb" "$WORK/"

echo "Parts (OpenSCAD)"
export_part() {  # <shot> <preset> <which> [extra openscad args]
  openscad -o "$WORK/$1/$3.stl" -p "$PRESETS" -P "$2" -D "which=\"$3\"" "${@:4}" parts.scad 2>&1 \
    | grep -iE "warning|error" || true
}
PLATE="103035 1000mAh on edge (default)"
STAND="Desk stand: box for 103035 on edge"
# The stand's head is the one that ships, with the collar (the same values as the preset
# "Desk stand: head (fits every box)"); the box is the same with either head, so it comes
# from the box preset alone.
HEAD=(-D lip_h=1.5 -D tower_drop=2.0 -D pocket_clear=0.05 -D lip_slop=0.05 -D stock_clear=3.4
      -D stand_ledge=1.1 -D lock_pad=1.1 -D lock_block_join=true -D collar_h=3)
for w in plate marker_plate shell buttons; do export_part plate "$PLATE" $w & done
for w in box screws marker_box; do export_part stand "$STAND" $w & done
for w in plate marker_head marker_seam shell buttons; do export_part stand "$STAND" $w "${HEAD[@]}" & done
wait
"$CACHE/tools/bin/python" marker.py "$WORK/plate/poses.json" "$WORK/plate/marker_plate.stl"
"$CACHE/tools/bin/python" marker.py "$WORK/stand/poses.json" \
  "$WORK/stand/marker_box.stl" "$WORK/stand/marker_head.stl" "$WORK/stand/marker_seam.stl"

echo "Screen"
if [ -n "${FIRMWARE:-}" ]; then
  cc -O2 -I"$FIRMWARE" -o "$WORK/pet_frame" pet_frame.c \
    "$FIRMWARE"/{face,emotion,rig,variants,font}.c -lm
  "$WORK/pet_frame" 1 "$WORK/pet_up.ppm" 0          # colour 1, the ostrich
  "$WORK/pet_frame" 1 "$WORK/pet_side.ppm" 0 side
  "$CACHE/tools/bin/python" screens.py "$WORK"
else
  cp screens/screen_portrait.png screens/screen_landscape.png "$WORK/"
fi

echo "Rendering ($WIDTH px, $SAMPLES samples)"
# The stand's head, collar and all, prints in a second colour so the collar shows: teal on the
# orange box, orange on the black one.
for shot in ${SHOTS:-plate stand}; do
  for colour in orange black; do
    out=hero-$shot-$colour
    if [ $shot = stand ]; then
      if [ $colour = orange ]; then export HEAD_COLOUR=teal; else export HEAD_COLOUR=orange; fi
    else unset HEAD_COLOUR; fi
    "$CACHE/blender/bin/python" hero.py $shot $colour "$WORK" "$WORK/$out.png" "$WIDTH" "$SAMPLES" \
      2>&1 | grep -iE "error|traceback" || true
    "$CACHE/tools/bin/python" -c "import sys; from PIL import Image; \
Image.open(sys.argv[1]).convert('RGB').save(sys.argv[2], quality=90, optimize=True)" \
      "$WORK/$out.png" "../$out.jpg"
    echo "  ../$out.jpg"
  done
done
