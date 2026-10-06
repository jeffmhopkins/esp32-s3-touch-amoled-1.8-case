// The Allan fitment, second fix: a cut through the head at x = screw_dx, which
// passes through one screw tower and one lock block. The seam is where the front
// shell's edge lands on the box. The board, its standoff and the gap under the board
// are drawn for illustration (the standoff's real length isn't measured).
include <../../amoled18_back_plate.scad>
use <annot.scad>
show_part = false;
$fn = 64; $k = 0.12;
title = "";
cut_x = screw_dx;
v = "right"; t = 0.3;
x = cut_x + 4;
module slice() intersection() { children(); translate([cut_x - 0.2, -23, -2]) cube([0.4, 18, 12]); }

seam = body_h;
good = "DarkGreen"; bad = "Red";
drop = seam - tower_top;
proud = 0.5;   // illustrative: a standoff that ends this far past the shell's edge

color(collar_h > 0 ? "DarkOrange" : "LightSteelBlue") render() slice() back_plate();
// The box's band beside the head, drawn straight from its outline.
color("SteelBlue") render() slice() translate([0, 0, -1]) linear_extrude(height = pocket_h + 1) pocket_ring_2d();

// Seam line across the cut
color("Black") translate([cut_x, -23, seam - 0.02]) cube([0.1, 19, 0.04]);
label([x, -4.6, seam + 0.25], "seam: the front shell's edge lands here", v, t * 0.8, "right");

// Ghost standoff (on the board), reaching proud of the seam
color("Goldenrod", 0.7) translate([cut_x - 0.1, -screw_dy - 1.75, seam - proud]) cube([0.3, 3.5, 3.5 + proud]);
// Ghost board
color("DarkGreen", 0.45) translate([cut_x - 0.1, -22, seam + 3.5]) cube([0.3, 17.5, 1.2]);
label([x, -12, seam + 4.1], "board (ghost)", v, t, c = "White");
if (collar_h > 0)
    callout([x, -screw_dy + 1, seam + 2.2], [x, -12.5, seam + 2.2], "brass standoff", v, t * 0.85, "left", c = "DarkGoldenrod");
else
    callout([x, -screw_dy, seam + 1.8], [x, -20.6, seam + 2.6], "brass standoff", v, t * 0.85, "right", c = "DarkGoldenrod");

label([x, -13.8, seam + 6.1], title, v, 0.5, "center");
label([x, -11, 1.0], "lock block", v, t * 0.85, c = collar_h > 0 ? "SaddleBrown" : "SlateGray");
label([x, -18, 1.0], "tower", v, t * 0.85, c = collar_h > 0 ? "SaddleBrown" : "SlateGray");

if (collar_h > 0) {
    label([x, -22.9, pocket_h + collar_h / 2 + 0.3], str("collar ", collar_h, " mm"), v, t * 0.85, "right", c = "DarkOrange");
    label([x, -22.9, pocket_h + collar_h / 2 - 0.3], "(part of the head)", v, t * 0.75, "right", c = "DarkOrange");
    label([x, -22.9, pocket_h / 2], "box", v, t * 0.85, "right", c = "SteelBlue");
    dim([x, -6.2, lock_block_top], [x, -6.2, seam], "", view = v, c = good);
    label([x, -6.6, (lock_block_top + seam) / 2], str("lock blocks ", seam - lock_block_top, " mm below"), v, t * 0.75, "right", c = good);
    dim([x, -16.2, tower_top], [x, -16.2, seam], "", view = v, c = good);
    label([x, -15.9, seam - 0.9], str("towers ", drop, " mm below the seam"), v, t * 0.75, "left", c = good);
} else if (drop < 0.01) {
    dim([x, -16.2, seam - proud], [x, -16.2, seam], "", view = v, c = bad);
    label([x, -15.9, seam - 0.9], str("standoff ", proud, " mm past the shell edge"), v, t * 0.75, "left", c = bad);
    label([x, -15.9, seam - 1.4], "hits the tower top first: shell held up", v, t * 0.75, "left", c = bad);
    callout([x, -9, seam], [x, -8.5, seam + 1.6], "block top at the seam too", v, t * 0.75, "right", c = bad);
} else {
    dim([x, -16.2, tower_top], [x, -16.2, seam], "", view = v, c = good);
    label([x, -15.9, seam - 0.9], str("towers and blocks ", drop, " mm below the seam"), v, t * 0.75, "left", c = good);
    label([x, -15.9, seam - 1.4], "the shell lands first; the screw pulls the rest", v, t * 0.75, "left", c = good);
}
