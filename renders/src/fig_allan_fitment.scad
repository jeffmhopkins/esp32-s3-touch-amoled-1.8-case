// The Allan fitment: one side wall of the desk stand cut square to the head,
// between the lock screws. The box is always the stock box (cut once from the
// stock box preset by fig_allan_box_slice.scad); the head is built from whatever
// parameters are passed in, so the same figure shows the problem, the fix and the
// trap in between.
//
// detail = false: the whole wall, with where the front shell ends up.
// detail = true:  a close-up of the top of the wall, with the two side gaps sized.
//
// The front shell's inner step depth is not measured: shell_depth is an
// assumption, used only to show how the rim's height decides where the shell lands.
include <../../amoled18_back_plate.scad>
use <annot.scad>
show_part = false;
$fn = 64;
title = "";
detail = false;
shell_depth = 1.5;     // assumed: how far the rim can go into the shell before it bottoms out
band_z = 3.5;          // top of the stock box's band, in head coordinates (the stock body height)
cut_x = 0;             // between the lock screws
f = detail ? 0.16 : 1; // text and line scale
$k = 0.12;
v = "right"; t = 0.3 * f;
module slice() intersection() { children(); translate([cut_x - 0.2, 14.5, -5]) cube([0.4, 10, 20]); }

oy = plate_y / 2;                      // case outline = box's outside = shell's outside
hy = head_y / 2;                       // head's side
ry = rim_out_y / 2;                    // rim's outside
sy = lip_outer_y / 2;                  // shell wall's inside
by = oy - pocket_wall;                 // box's inside at the band (fixed by the stock box)
rim_top = body_h + lip_h;
seat_z = max(band_z, body_h, rim_top - shell_depth);   // where the shell's edge ends up
proud = seat_z - band_z;
head_proud = body_h - band_z;
r2 = function(n) round(n * 100) / 100;

// A tick-ended dimension for the close-up, where annot's arrowheads are larger than the gaps.
module tdim(a, b, c) {
    w = 0.008;
    color(c) {
        hull() { translate(a) cube(w, center = true); translate(b) cube(w, center = true); }
        for (p = [a, b]) translate(p) cube(a[1] == b[1] ? [w, 0.12, w] : [w, w, 0.12], center = true);
    }
}

color("SteelBlue") import("allan_box_slice.stl");
color("LightSteelBlue") render() slice() back_plate();

// Front shell (ghost): its skirt over the band, and the inner step the rim stops against.
color("DimGray", 0.6) translate([cut_x - 0.1, 0, seat_z]) {
    translate([0, sy, 0]) cube([0.3, oy - sy, 4.5]);
    translate([0, sy - 3, shell_depth]) cube([0.3, 3 + 0.01, 0.7]);
}

x = cut_x + 2.6;
good = "DarkGreen"; bad = "Red";

if (!detail) {
    label([x, 19.0, 9.6], title, v, 0.5, "center");
    // Heights
    dim([x, ry - 2.2, body_h], [x, ry - 2.2, rim_top], "", view = v);
    label([x, ry - 2.6, (body_h + rim_top) / 2], str("rim ", lip_h, " mm"), v, t, "right");
    dim([x, 15.6, 0], [x, 15.6, body_h], "", view = v, c = head_proud > 0.01 ? bad : "DimGray");
    label([x, 15.2, body_h / 2], str("body ", body_h, " mm"), v, t * 0.85, "right",
          c = head_proud > 0.01 ? bad : "DimGray");
    // Where the shell lands
    if (proud > 0.01) {
        dim([x, oy + 0.9, band_z], [x, oy + 0.9, seat_z], "", view = v, c = bad);
        label([x, oy + 1.4, band_z + 0.75], str("shell held ", r2(proud), " mm"), v, t, "left", c = bad);
        label([x, oy + 1.4, band_z + 0.2], "above the band", v, t, "left", c = bad);
        label([x, oy + 1.4, band_z - 0.35],
              head_proud > 0.01 ? "the head's body is too tall for the box"
                                : "the rim hits the shell's step first",
              v, t * 0.75, "left", c = bad);
    } else {
        callout([x, oy - 0.5, band_z], [x, oy + 1.4, band_z + 0.3], "shell lands on the band", v, t, "left", c = good);
    }
    callout([x, sy - 1.5, seat_z + shell_depth + 0.35], [x, oy + 1.4, seat_z + shell_depth + 1.8],
            str("shell step, assumed ", shell_depth, " deep"), v, t * 0.85, "left", c = "DimGray");
    callout([x, hy + pocket_clear / 2, 1.8], [x, oy + 1.4, 1.6],
            str("pocket_clear ", pocket_clear, " head-box"), v, t * 0.85, "left");
    label([x, 18.4, -1.6], "box (unchanged)", v, t, "right", c = "SteelBlue");
    label([x, 17.6, 2.2], "head", v, t, c = "SlateGray");
} else {
    // Close-up: the gap between head and box, and between rim and shell, to scale.
    label([x, 20.75, 3.3], title, v, t * 1.4, "center");
    gh = hy + pocket_clear;   // box's inside wall (same as by)
    tdim([x, hy, 2.6], [x, gh, 2.6], pocket_clear > 0.1 ? bad : good);
    label([x, gh + 0.08, 2.75], str(pocket_clear, " mm"), v, t, "left", c = pocket_clear > 0.1 ? bad : good);
    label([x, gh + 0.08, 2.5], "head to box", v, t * 0.8, "left", c = "DimGray");
    gz = seat_z + 0.35;
    if (gz < rim_top) {
        tdim([x, ry, gz], [x, sy, gz], lip_slop > 0.1 ? bad : good);
        label([x, ry - 0.08, gz + 0.15], str(lip_slop, " mm"), v, t, "right", c = lip_slop > 0.1 ? bad : good);
        label([x, ry - 0.08, gz - 0.1], "rim to shell", v, t * 0.8, "right", c = "DimGray");
    }
    label([x, 20.75, 2.95], "head", v, t, c = "SlateGray");
    label([x, 22.0, 2.9], "box", v, t, c = "White");
    label([x, 22.0, seat_z + 0.25], "shell", v, t, c = "White");
    if (proud > 0.01) {
        tdim([x, 22.35, band_z], [x, 22.35, seat_z], bad);
        label([x, 22.3, (band_z + seat_z) / 2], str("shell ", r2(proud), " mm up"), v, t * 0.8, "right", c = bad);
    }
}
