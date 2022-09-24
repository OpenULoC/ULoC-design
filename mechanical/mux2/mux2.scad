use <../lib/octoid_gear_types.scad>
use <../lib/mesh_bevel_gear.scad>
use <../lib/involute_gear_types.scad>
use <../lib/mesh_parallel_gear.scad>

// 0 or undef for full assembly
// 1 - 7 for individual pieces
do_piece = undef;

/*
Piece   Count   Description
1       1       Bottom gear
2       1       Side gear
3       1       Side axis
4       1       Outer gear
5       1       Small gear
6       6       Output gear
7       1       Crown
*/

// set true for final render
// set false for faster viewing
high_detail = true;


$fs = high_detail ? 0.1 : $fs;
$fn = high_detail ? 100 : $fn;

module NEMA17_motor(length) {
    linear_extrude(length)
    polygon([
        /*[21.15, 15.5],
        [15.5, 21.15],
        [-15.5, 21.15],
        [-21.15, 15.5],
        [-21.15, -15.5],
        [-15.5, -21.15],
        [15.5, -21.15],
        [21.15, -15.5],*/
        [21.15, 16.5],
        [16.5, 21.15],
        [-16.5, 21.15],
        [-21.15, 16.5],
        [-21.15, -16.5],
        [-16.5, -21.15],
        [16.5, -21.15],
        [21.15, -16.5],
    ]);
    translate([0, 0, length])
    cylinder(2, d=22, false);
    translate([0, 0, length])
    difference() {
        cylinder(25, d=5, false);
        translate([4, 0, 15])
        cube([5, 5, 20], true);
    }
}

module bearing_606_2RS() {
    difference() {
        cylinder(6, d=17, false);
        translate([0, 0, -0.5])
        cylinder(7, d=6, false);
    }
}

angle = fn_bevel_angle_for_gear_ratio(1);
height = sin(angle) * 30;
radius = cos(angle) * 30;

coef = 1.4;

module double_gear(rotation = 0, reverse = false) {
    intersection() {
        mirror([0, 0, 1]) cylinder(44, 40, 0);
        rotate(rotation, [0, 0, 1])
        octoid_helical_gear(
            30, 0.7, false,
            reverse ? -1 : 1,
            angle, 17, addendum_coefficient = 0.6
        );
    }
    
    intersection() {
        mirror([0, 0, 1]) cylinder(32, 24, 0);
        rotate(rotation, [0, 0, 1])
        octoid_helical_gear(
            21, 0.5, false,
            reverse ? 1 : -1,
            angle, 17, addendum_coefficient = 0.6
        );
    }
}

module bottom_gear(rotation = 0) {
    difference() {
        union() {
            double_gear(rotation);
            
            translate([0, 0, -coef*height - 5])
            cylinder((coef-1)*height + 5, 0.9 * radius, 0.9 * radius);
        }
        
        translate([0, 0, -coef*height - 5 - 0.1])
            cylinder(25 + 0.1, 6/2, 6/2); // NEMA17 clearance hole
    }
}

gear_height = 20;

module side_gear(rotation = 0) {
    difference() {
        double_gear(rotation);
        
        translate([0, 0, -coef*height - 0.1])
        linear_extrude(gear_height + 0.1)
            square(4.5, center = true);
    }
}

contact_radius = 40;
segment_angle = 60;
segment_coeff = 0.7;
strip_width = contact_radius - coef*height;
strip_thickness = 4;

module side_axis(rotation = 0) {
    rotate(rotation, [0, 0, 1]) {
        translate([0, 0, -coef*height]) {
            linear_extrude(15 + 0.1)
                square(4, center = true);
        }
        rotate(90, [0, 1, 0])
        rotate(-segment_coeff * segment_angle / 2, [0, 0, 1])
        rotate_extrude(angle = segment_coeff * segment_angle)
        translate([coef*height, -2])
            square([strip_width - 0.5, strip_thickness]);
    }
}

fixator_height = 30;
outer_gear_height = 0.7 * gear_height;
outer_coef = 1.6;

module outer_gear() {
    difference() {
        translate([height + 3, 0, -fixator_height/2])
            cube([5, 20, fixator_height], center = true);
        rotate(90, [0, 1, 0])
        translate([0, 0, height + 0.1])
            cylinder(6, d=18, false);
    }
    translate([0, 0, -height - outer_gear_height - 1])
    difference() {
        involute_herringbone_gear(outer_gear_height, outer_coef*radius, false, 1, 4*17);
        cylinder(2*outer_gear_height + 0.1, 0.92*radius, 0.92*radius, center = true);
    }
}

module small_gear() {
    translate([0, 0, -height - outer_gear_height - 1])
    difference() {
        involute_herringbone_gear(outer_gear_height, (outer_coef/4)*radius, false, 1, 17);
        cylinder(outer_gear_height + 0.1, 6/2, 6/2); // NEMA17 clearance hole
    }
}

output_radius = 15;

module output_wheel(rotation = 0) {
    translate([0, 0, contact_radius - strip_width])
    rotate(rotation, [0, 0, 1])
    difference() {
        cylinder(strip_width + 2, output_radius, output_radius);
        translate([0, 0, strip_width/2])
            cube([5, 30 + 0.1, strip_width + 2], center = true);
    }
    translate([0, 0, contact_radius + 1])
    linear_extrude(15 + 0.1)
        square(4, center = true);
}

crown_apotheme = contact_radius + strip_width/2 - 1;
crown_height = 20;

module crown() {
    mirror([0, 0, 1])
    for(phi = [0:360/6:5*360/6]) {
        rotate(phi, [0, 0, 1])
        rotate(90, [0, 1, 0])
        translate([0, 0, crown_apotheme])
        linear_extrude(5)
        difference() {
            translate([-crown_height/2, 0, 0])
                square([crown_height, crown_apotheme / cos(30) + 5], center = true);
            circle(17/2 + 1);
            translate([-15, 0.8 * crown_apotheme / cos(30) / 2, 0])
                circle(2.75); // M5 clearance hole, normal fit
            translate([-15, -0.8 * crown_apotheme / cos(30) / 2, 0])
                circle(2.75); // M5 clearance hole, normal fit
        }
    }
}

/// FULL ANIMATED ASSEMBLY ///
if(!do_piece) {
    bottom_gear(360 * $t);
    mesh_bevel_gear(0, 1, 17) {
        side_gear(-360 * $t);
        side_axis(-360 * $t);
        color("pink")
        mirror([0, 0, 1])
        translate([0, 0, height + 0.1])
            bearing_606_2RS();
        mirror([0, 0, 1]) {
            output_wheel(-360 * $t);
            color("pink")
            translate([0, 0, contact_radius + strip_width/2 - 2])
                bearing_606_2RS();
        }
    }
    outer_gear();
    mesh_parallel_gear((outer_coef + outer_coef/4)*radius, 0, 4, false, 17)
        small_gear();
    for(phi = [360/6:360/6:5*360/6]) {
        rotate(phi, [0, 0, 1])
        rotate(90, [0, 1, 0]) {
            output_wheel(-360 * $t);
            color("pink")
            translate([0, 0, contact_radius + strip_width/2 - 2])
                bearing_606_2RS();
        }
    }
    color("pink")
    translate([0, 0, -39 - height - gear_height + 4])
        NEMA17_motor(39);
    color("pink")
    translate([outer_coef*1.25*radius, 0, -34 - height - gear_height])
        NEMA17_motor(34);
    crown();
}

/// PIECE 1 ///
if(do_piece == 1) {
    bottom_gear();
}

/// PIECE 2 ///
if(do_piece == 2) {
    side_gear();
}

/// PIECE 3 ///
if(do_piece == 3) {
    rotate(90, [0, -1, 0])
        side_axis();
}

/// PIECE 4 ///
if(do_piece == 4) {
    outer_gear();
}

// PIECE 5
if(do_piece == 5) {
    small_gear();
}

// PIECE 6
if(do_piece == 6) {
    output_wheel();
}

// PIECE 7
if(do_piece == 7) {
    crown();
}

//mirror([0, 0, 1]) cube(100);