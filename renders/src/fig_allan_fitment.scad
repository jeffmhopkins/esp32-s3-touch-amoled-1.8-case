// The Allan fitment, before and after: one side wall of the desk stand cut
// square to the head, away from the lock screws. The box is the stock box
// (unchanged, cut from the stock box preset); the head is built from whichever preset is passed in. The
// front shell's inner step depth is not measured: shell_depth is an
// assumption, used only to show how a shorter rim lets the shell land.
include <../../amoled18_back_plate.scad>
use <annot.scad>
show_part = false;
$fn = 64; $k = 0.12;
title = "";
shell_depth = 1.5;     // assumed: how far the rim can go into the shell before it bottoms out
cut_x = 0;             // between the lock screws
v = "right"; t = 0.3;
m_inv = [[sc, 0, ss, -ss * stand_zh], [0, 1, 0, 0], [-ss, 0, sc, -sc * stand_zh], [0, 0, 0, 1]];
module slice() intersection() { children(); translate([cut_x - 0.2, 14.5, -5]) cube([0.4, 10, 20]); }

oy = plate_y / 2;                      // case outline = box's outside
hy = head_y / 2;                       // head's side
ry = rim_out_y / 2;                    // rim's outside
rim_top = body_h + lip_h;
seat_z = max(body_h, rim_top - shell_depth);   // where the shell's edge ends up
proud = seat_z - body_h;

// Made by fig_allan_box_slice.scad from the stock box preset.
color("SteelBlue") import("allan_box_slice.stl");
color("LightSteelBlue") render() slice() back_plate();

// Front shell (ghost): its skirt over the band, and the inner step the rim stops against.
sy = lip_outer_y / 2;                  // shell wall's inside
sw = oy - sy;
color("DimGray", 0.55) translate([cut_x - 0.1, 0, seat_z]) {
    translate([0, oy - sw, 0]) cube([0.3, sw, 4.5]);
    translate([0, sy - 3, shell_depth]) cube([0.3, 3 + 0.01, 0.7]);
}

x = cut_x + 2.6;
label([x, 19.0, 9.6], title, v, 0.5, "center");

// Rim height
dim([x, ry - 2.2, body_h], [x, ry - 2.2, rim_top], "", view = v);
label([x, ry - 2.6, (body_h + rim_top) / 2], str("rim ", lip_h, " mm"), v, t, "right");
// Shell landing
if (proud > 0.01) {
    dim([x, oy + 0.9, body_h], [x, oy + 0.9, seat_z], "", view = v, c = "Red");
    label([x, oy + 1.4, (body_h + seat_z) / 2 + 0.2], str("shell held ", proud, " mm"), v, t, "left", c = "Red");
    label([x, oy + 1.4, (body_h + seat_z) / 2 - 0.55], "above the band", v, t, "left", c = "Red");
} else {
    callout([x, oy - 0.5, body_h], [x, oy + 1.4, body_h + 0.3], "shell lands on the band", v, t, "left", c = "DarkGreen");
}
callout([x, ry - 1.5, seat_z + shell_depth + 0.35], [x, oy + 1.4, seat_z + shell_depth + 1.8],
        str("shell step, assumed ", shell_depth, " deep"), v, t * 0.85, "left", c = "DimGray");
// Side gaps
callout([x, ry + lip_slop / 2, rim_top - 0.4], [x, oy + 1.4, rim_top + 3.6],
        str("lip_slop ", lip_slop, " rim-shell"), v, t * 0.85, "left");
callout([x, hy + pocket_clear / 2, 1.8], [x, oy + 1.4, 1.6],
        str("pocket_clear ", pocket_clear, " head-box"), v, t * 0.85, "left");
label([x, 18.4, -1.6], "box (unchanged)", v, t, "right", c = "SteelBlue");
label([x, 17.6, 2.2], "head", v, t, c = "SlateGray");
dim([x, 15.6, 0], [x, 15.6, body_h], "", view = v, c = "DimGray");
label([x, 15.2, body_h / 2], str("body ", body_h, " mm"), v, t * 0.85, "right", c = "DimGray");
