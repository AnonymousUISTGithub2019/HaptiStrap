//Title: haptistrap_elastic_primer
//Project: HaptiStrap
//Author: BLINDED
//Affiliation: BLINDED
//
//Description: Design file for the elastic primer. Change line 13 to the number of elastics that should be pre-stretched.


// Number of faces on cylinders, sphere, etc.
$fn=50;

use_printed_tensioner = 1;
use_elastic_tensioner = 0;

// Number of elastics to prime
n_elastics = 8;

if (use_elastic_tensioner == 1){
    // Base plate
    translate([n_elastics*5/2,0,1]) cube([n_elastics*5, 10, 1], center=true);

    // Place posts on base plate
    for (n=[1:n_elastics]){
        translate([(n-1)*5+2.5,0,0]){
            translate([0,-5+1.5,1]) cylinder(r=1.5, h=3);
            translate([0,5-1.5,1]) cylinder(r=1.5, h=3);
        }
    }
}

if (use_printed_tensioner == 1){
    // base plate
    hull(){
        cylinder(r=3, h=2);
        translate([20,0,0]) cylinder(r=3, h=2);
        translate([20,-10,0]) cylinder(r=3, h=2);
    }
    
    // posts
    cylinder(r=1.5, h=7);
    translate([20,0,0]) cylinder(r=1.5, h=7);
    translate([20,-10,0]) cylinder(r=1.5, h=7);

}


