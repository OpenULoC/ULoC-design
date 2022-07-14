# ULoC: design
Brainstorming and high-level design towards the ULoC.

## The ULoC
The **Universal Lab-on-a-Chip** (**ULoC**) is a hypotetical device capable of carrying out
a wide variety of laboratory tasks in an automatic, programmable manner.

In this regard, it seeks to provide the same advantages that a regular
[LoC](https://en.wikipedia.org/wiki/Lab-on-a-chip) offers, namely high throughput and low cost.
Additionally, the **OpenULoC** project is intended to create an Open Source incarnation
of this machine, opening up the doors to affordable research.

## Goals
Scientific research is neither cheap nor fast;
much of the funds are spent in expensive products and specialized equipment.
Cutting times or increasing quality is difficult,
as it often entails obtaining even less affordable equipment.

Same goes for medical practice.
There is an increasing market for biological and genetic therapies,
both of which are prohibitively expensive at the moment.
Reducing the barrier of entry to the manufacture of these products
could prove key to reducing health costs,
especially in developing countries.

## Scope
The ULoC will be initially limited to Molecular Biology experiments, tests and processes.
This is due to the fact that this field is effectively "low-hanging fruit" for
the goals exposed above, with many Cell Biology procedures depending on biomolecule products
and Organic Chemistry being very non-trivial to implement as solid-state circuitry.

This could include any of the following.

* Standard enzyme-catalyzed reactions.
* Nucleic acid amplification.
* Some antibody-mediated tests.
* Basic substance identification.
* _In vitro_ gene expression.
* _In vitro_ gene editing.
* Polynucleotide synthesis.

## Tools

> The trajectory of 3D printing will most certainly raise real grievances,
> from solid state meth labs, to ceramic knives.
> 
> - Cory Doctorow

This is a non-comprehensive list of tools that have been, or could be, helpful to this project.
They have been chosen over alternatives so as to avoid vendor lock or increasing costs.

* Standard FFF 3D printers
* [Cura by Ultimaker](https://github.com/Ultimaker/Cura)
* [OpenSCAD](https://github.com/openscad/openscad)
* [KiCAD](https://gitlab.com/kicad)
* [fluidics by aerkiaga](https://github.com/aerkiaga/fluidics)
* [OpenFOAM](https://github.com/OpenFOAM)
* [Rust](https://www.rust-lang.org/)

## Design
See [design.md](design.md).
