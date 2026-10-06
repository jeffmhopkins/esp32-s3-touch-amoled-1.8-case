# Allan fitment: a snugger desk-stand head

## What to print

**Only the head:** [`amoled18_stand_head_allan_fitment.stl`](amoled18_stand_head_allan_fitment.stl).
Keep the box you already have. The box STLs are unchanged, and the one head fits all three:

| Battery | Box (unchanged, reprint not needed) |
|---|---|
| 103035 1000 mAh on edge | [`amoled18_stand_box_103035_edge.stl`](amoled18_stand_box_103035_edge.stl) |
| 802525 400 mAh flat | [`amoled18_stand_box_802525_flat.stl`](amoled18_stand_box_802525_flat.stl) |
| 104050 2400 mAh on end | [`amoled18_stand_box_104050_end.stl`](amoled18_stand_box_104050_end.stl) |

The new head was checked against each of these three box STLs in its seated position: it
doesn't overlap any of them anywhere. Its back rests on the box's ledge, the same as the
stock head. The screws are unchanged too.

## 1. The problem

A head printed from the stock preset had two problems:

- **The front shell doesn't sit down on the box.** The black front shell should land on
  the box's 1.1 mm band, flush with the box's outside. It stops above it instead, and
  a white strip of the head shows between them.
- **The head is loose in the box.** It drops in but can move around.

| Side | USB-C edge | Corner |
|---|---|---|
| ![Side view](photos/allan-fitment-before-side.jpg) | ![USB-C edge](photos/allan-fitment-before-usb-edge.jpg) | ![Corner](photos/allan-fitment-before-corner.jpg) |

## 2. Why it happened

The images below cut through one side wall of the stand, square to the head and between
the lock screws. Blue is the box, light blue is the head, dark gray is the front shell.

![Stock head cut through the side wall](renders/allan-fitment-before.png)

**The rim is too tall for the shell.** The head's rim goes up inside the front shell. The
shell has an inside step about 1.5 mm in from its edge. The stock rim is 2 mm tall, so it
hits that step while the shell's edge is still 0.5 mm above the box's band. The shell
can't come down any further, and the 0.5 mm of head below it is the white strip in the
photos.

Nobody has measured the step depth. The 1.5 mm in the drawing is an assumption
(`shell_depth` in the figure source). It matches the roughly 0.5 mm the shell sits too
high in the photos.

**The gaps are too wide for this print.** Up close, with the gaps drawn to scale:

![Close-up of the gaps, before (left) and after (right)](renders/allan-fitment-gaps.png)

On the left (before), the head has 0.15 mm of gap to the box on every side, and the rim
has 0.15 mm to the shell. Those defaults are deliberately loose so a head fits from
most printers. On this print they left up to 0.3 mm of play across the head (0.15 mm on
each side), enough to feel. The red bar on the right is the
0.5 mm the shell is held up.

## 3. The fix

New preset **Desk stand: head, Allan fitment (snug)** in
[`amoled18_back_plate.json`](amoled18_back_plate.json). It starts from
**Desk stand: head (fits every box)** and changes these values:

| Parameter | Stock | Allan fitment | What it does |
|---|---|---|---|
| `lip_h` | 2.0 | 1.5 | Lowers the rim 0.5 mm, so it no longer holds the shell up. Lowered by 0.5 mm this pass, not a full 1 mm |
| `tower_drop` | 2.0 | 1.5 | Must equal `lip_h`, or the screw towers stand above the seam and hold the board off |
| `stock_clear` | 3.9 | 3.4 | Keeps the head's body 3.5 mm tall, the depth of the box's pocket (see below) |
| `pocket_clear` | 0.15 | 0.05 | Head-to-box gap each side. Makes the head bigger; the box opening stays the same |
| `lip_slop` | 0.15 | 0.05 | Rim-to-shell gap each side |
| `lock_pad`, `stand_ledge` | 1.0 | 1.1 | Makes the head's lock-screw notches 0.1 mm deeper (see below) |

`pocket_wall` stays at 1.1. Neither gap is 0.

### Why the notches get deeper

The box has a pad on its inside at each of the six lock screws, and the head has a notch
in its edge that the pad sits in. The notch depth is measured from the head's edge, so
when the head grew 0.1 mm each side, its notches moved out with it. The 103035 and 802525
boxes have 1.0 mm pads, and those pads would then press 0.05 mm into the head. Setting
`lock_pad` and `stand_ledge` to 1.1 makes each notch 0.1 mm deeper, which leaves 0.05 mm
clear around every pad. When you export the head, these two values only set the notch
depth. The boxes are not changed.

### Why `stock_clear` changes too

In desk-stand mode the model holds the head's total height at `stock_clear`, so the body
is `stock_clear - lip_h` tall. Lowering only the rim makes the body taller by the same
0.5 mm:

![Rim lowered without stock_clear: the body grows and stands out of the box](renders/allan-fitment-trap.png)

The rim is shorter, but the head now stands 0.5 mm out of the box, so the shell is held
up just as high as before, this time by the head's body. Lowering `stock_clear` by the
same 0.5 mm keeps the body at 3.5 mm, level with the band. The space for the board
inside the head is unchanged.

## 4. Why it's fixed

![Before and after, cut through the side wall](renders/allan-fitment-compare.png)

- **The shell lands on the band.** With a 1.5 mm rim, the shell's edge reaches the box's
  band before the rim reaches the step, so the shell sits flush with the box.
- **The head is level with the band.** The body is still 3.5 mm, so the head sits on the
  box's ledge exactly where the stock head did.
- **No more play.** The close-up above (right side) shows both gaps down to 0.05 mm. The
  head is 0.1 mm wider each side (35.3 × 42.9 mm instead of 35.1 × 42.7 mm), and so is the rim.

| | Stock head | Allan fitment head |
|---|---|---|
| Footprint | 35.1 × 42.7 mm | 35.3 × 42.9 mm |
| Body and towers | 3.5 mm | 3.5 mm |
| Rim | 2.0 mm | 1.5 mm |
| Overall height | 5.5 mm | 5.0 mm |
| Gap to the box, each side | 0.15 mm | 0.05 mm |
| Gap to the shell, each side | 0.15 mm | 0.05 mm |

F5 in OpenSCAD prints `All checks passed.` for this preset. The new head hasn't been
printed yet.

## Files

| File | What it is |
|---|---|
| [`amoled18_stand_head_allan_fitment.stl`](amoled18_stand_head_allan_fitment.stl) | The new head, ready to print. It fits every stand box |
| [`amoled18_back_plate.json`](amoled18_back_plate.json) | Preset **Desk stand: head, Allan fitment (snug)** |
| [`amoled18_back_plate.scad`](amoled18_back_plate.scad) | The model (unchanged) |
| [`amoled18_stand_head.stl`](amoled18_stand_head.stl) | The original head, for comparison |
| [`renders/allan-fitment-before.png`](renders/allan-fitment-before.png), [`-trap.png`](renders/allan-fitment-trap.png), [`-after.png`](renders/allan-fitment-after.png), [`-compare.png`](renders/allan-fitment-compare.png) | The side-wall cuts |
| [`renders/allan-fitment-gaps.png`](renders/allan-fitment-gaps.png) ([before](renders/allan-fitment-gaps-before.png), [after](renders/allan-fitment-gaps-after.png)) | The close-ups of the gaps |
| [`renders/src/fig_allan_fitment.scad`](renders/src/fig_allan_fitment.scad), [`fig_allan_box_slice.scad`](renders/src/fig_allan_box_slice.scad) | The sources for those images. [`renders/make_renders.sh`](renders/make_renders.sh) regenerates them |

## Re-exporting the head

In OpenSCAD's Customizer pick **Desk stand: head, Allan fitment (snug)**, set
`smoothness` to 96, then F6 and export. `part` is already `plate` (the head only).
Or from the command line:

```
openscad -o amoled18_stand_head_allan_fitment.stl -p amoled18_back_plate.json \
  -P "Desk stand: head, Allan fitment (snug)" -D smoothness=96 amoled18_back_plate.scad
```

Don't scale the old STL instead. Scaling stretches the screw holes and towers too.

## If it still doesn't fit

0.05 mm gaps are tight, so:

- **Head won't go into the box:** raise `pocket_clear` to 0.1.
- **Shell won't press onto the rim:** raise `lip_slop` to 0.1.
- **Shell still sits above the box face:** lower `lip_h` again, and lower `tower_drop`
  and `stock_clear` by the same amount.

Don't set either gap to 0.
