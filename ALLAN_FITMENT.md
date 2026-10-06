# Allan fitment: a snugger desk-stand head

A desk-stand head printed from the stock preset dropped into its box but was loose,
and the Waveshare front shell sat above the box face instead of landing on the
1.1 mm pocket band. A white strip of head shows between the black shell and the box:

| Side | USB-C edge | Corner |
|---|---|---|
| ![Side view](photos/allan-fitment-before-side.jpg) | ![USB-C edge](photos/allan-fitment-before-usb-edge.jpg) | ![Corner](photos/allan-fitment-before-corner.jpg) |

The fix is a new head only. **The box is unchanged.** Reprint the head and keep the box you already have.

## Files

| File | What it is |
|---|---|
| [`amoled18_stand_head_allan_fitment.stl`](amoled18_stand_head_allan_fitment.stl) | The new head, ready to print. It fits every stand box. |
| [`amoled18_back_plate.json`](amoled18_back_plate.json) | Preset **Desk stand: head, Allan fitment (snug)** |
| [`amoled18_back_plate.scad`](amoled18_back_plate.scad) | The model the preset runs in (unchanged) |
| [`amoled18_stand_head.stl`](amoled18_stand_head.stl) | The original head, for comparison |
| [`renders/allan-fitment-compare.png`](renders/allan-fitment-compare.png) | Before and after, cut through the side wall |
| [`renders/src/fig_allan_fitment.scad`](renders/src/fig_allan_fitment.scad), [`fig_allan_box_slice.scad`](renders/src/fig_allan_box_slice.scad) | The sources for those images |

## What changed

The preset starts from **Desk stand: head (fits every box)** and changes:

| Parameter | Stock | Allan fitment | Why |
|---|---|---|---|
| `lip_h` | 2.0 | 1.5 | The rim was holding the shell up; lowered 0.5 mm, not a full 1 mm, on this pass |
| `tower_drop` | 2.0 | 1.5 | Must equal `lip_h`, or the screw towers stand above the seam and hold the board off |
| `stock_clear` | 3.9 | 3.4 | In desk mode the body is `stock_clear - lip_h` tall. Lowering it with `lip_h` keeps the body at 3.5 mm, the depth of the box's pocket. Without it the body would grow to 4.0 mm and the head would stand 0.5 mm out of the box |
| `pocket_clear` | 0.15 | 0.05 | Head-to-box gap per side. Makes the head bigger; the box opening stays as it is |
| `lip_slop` | 0.15 | 0.05 | Rim-to-shell gap per side |

`pocket_wall` stays at 1.1.

| | Stock head | Allan fitment head |
|---|---|---|
| Footprint | 35.1 x 42.7 mm | 35.3 x 42.9 mm |
| Body and towers | 3.5 mm | 3.5 mm |
| Rim | 2.0 mm | 1.5 mm |
| Overall height | 5.5 mm | 5.0 mm |

F5 in OpenSCAD prints `All checks passed.` for this preset.

## Why it fits better

These images cut through one side wall of the stand, square to the head. The box is
the same stock 103035 box in both. Only the head changes.

![Before and after, cut through the side wall](renders/allan-fitment-compare.png)

- **The shell lands on the band.** The front shell has an inside step that the rim
  pushes against. If the rim is taller than that step is deep, the rim hits it first,
  and the shell's edge stops above the box's 1.1 mm band. That's the white strip in the
  photos. Lowering the rim from 2.0 to 1.5 mm lets the edge come down onto the band.
  Nobody has measured the step depth. The drawing assumes 1.5 mm
  (`shell_depth` in [`renders/src/fig_allan_fitment.scad`](renders/src/fig_allan_fitment.scad)),
  which matches the roughly 0.5 mm the shell sits too high in the photos.
- **The body didn't grow.** It stays 3.5 mm, the depth of the box's pocket, so the head
  still sits level with the band. Only the rim got shorter. That's why `stock_clear` drops
  along with `lip_h`.
- **Less play side to side.** The head is 0.1 mm wider each side (0.05 mm gap to the box
  instead of 0.15), and the rim is 0.1 mm wider each side (0.05 mm gap inside the shell
  instead of 0.15). The gap to the box is narrower in the after image. The rim-to-shell
  gap is too small to see at this scale.

Full-size images: [before](renders/allan-fitment-before.png),
[after](renders/allan-fitment-after.png). Regenerate them with
[`renders/make_renders.sh`](renders/make_renders.sh).

## Re-exporting

In OpenSCAD's Customizer pick **Desk stand: head, Allan fitment (snug)**, set
`smoothness` to 96, then F6 and export. `part` is already `plate` (the head only).
Or from the command line:

```
openscad -o amoled18_stand_head_allan_fitment.stl -p amoled18_back_plate.json \
  -P "Desk stand: head, Allan fitment (snug)" -D smoothness=96 amoled18_back_plate.scad
```

Don't scale the old STL instead. Scaling stretches the screw holes and towers too.

## If it still doesn't fit

The new head hasn't been printed yet. 0.05 mm gaps are tight, so:

- **Head won't go into the box:** raise `pocket_clear` to 0.1.
- **Shell won't press onto the rim:** raise `lip_slop` to 0.1.
- **Shell still sits above the box face:** lower `lip_h` again, and lower `tower_drop`
  and `stock_clear` by the same amount.

Don't set either gap to 0.
