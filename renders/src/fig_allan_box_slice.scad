// The stock box's side wall, cut where fig_allan_fitment.scad cuts it and turned
// square to the head. Exported once with the stock box preset so both the before and
// after figures show the same, unchanged box.
include <../../amoled18_back_plate.scad>
show_part = false;
cut_x = 0;
m_inv = [[sc, 0, ss, -ss * stand_zh], [0, 1, 0, 0], [-ss, 0, sc, -sc * stand_zh], [0, 0, 0, 1]];
intersection() { multmatrix(m_inv) stand_box(); translate([cut_x - 0.2, 14.5, -5]) cube([0.4, 10, 20]); }
