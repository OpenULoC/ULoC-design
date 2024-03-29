# Mechanical multiplexer design

## Design 1
![Design 1 in OpenSCAD](res/mux1.png)

[Files](mux1)

A spiral staircase design.
Both motors are mounted inside the structure,
which rotates and moves to choose an axis.
It allows the number of axes to be easily and modularly increased.

Drawbacks:
* Only supports two specific motor models.
* The heavy motors are mounted inside the structure.
* Unnecessary friction between some moving parts.
* High vertical clearance needed.
* Complex design.

## Design 2
![Design 2 in OpenSCAD](res/mux2.png)

[Files](mux2)

A much simpler design.
Motors are fixed, and mounted underside the mechanism.
NEMA17 motors of any length can be used.
Makes use of adhesive to fix bearings in place.

Drawbacks:
* Structure may be unstable.
* Requires extra pieces for support, which depend on motor length.
* Fixed number of output axes: 6.
* To select a new axis, the input shaft must also be rotated in tandem.
