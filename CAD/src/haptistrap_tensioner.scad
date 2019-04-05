//Title: haptistrap_tensioner
//Project: HaptiStrap
//Author: BLINDED
//Affiliation: BLINDED
//
//Description: Design file for HaptiStrap tensioner. Can generate the tensioner for both the elastic and printed tensioner designs. To change tensioner type, modify lines 14-15.

//Credit: This work makes use of the "Achimedean Spiral Module" (CC BY 3.0: https://creativecommons.org/licenses/by/3.0/) by user "Manticorp", available on thingiverse: https://www.thingiverse.com/thing:1267784
 
// Generates the part that links between the enclosure and strap
use <archimedean_spiral.scad>

// SET TO 1 TO SELECT TENSIONER TYPE
use_printed_tensioner= 0;
use_elastic_tensioner = 1;

//**************   Strap and Buckle Dimensions  ****************
// Strap width
strap_w = 20;
// Strap length
strap_l = 4;
// Buckle height
strap_h= 5;
// Thickness of the strap
strap_th = 2;
// Extra plastic on each side of the strap
Extra_w = 1; 

// Information necessary to position the elastic slots
shaft_r = 1.5;
dist_post = 2*shaft_r+0.75;
wall_th = 1;
o_w = 25;

center_offset = o_w/5;

// *************** GENERATE TENSIONER ******************
insert_tensioner();


module insert_tensioner(){
    union(){
        insert_link();
        insert_attachment();
        insert_calibration_pins();    
    }
}


// Vertical Pin for Calibration
module insert_calibration_pins(){
    translate([0,o_w/2-4*wall_th,0]) cylinder(r=1, h=4, $fn=50);
    translate([0,-o_w/2+4*wall_th,0]) cylinder(r=1, h=4, $fn=50);
    hull(){
    translate([0,o_w/2-4*wall_th,0]) cylinder(r=1, h=1, $fn=50);
    translate([0,-o_w/2+4*wall_th,0]) cylinder(r=1, h=1, $fn=50);
    }
    
}

module insert_link(){
    if (use_printed_tensioner==1) spirale_spring();
    if (use_elastic_tensioner==1) elastic_attachment();        
}

module spirale_spring(){
    translate([10+1,0,0]){
            difference(){
                union(){
                    rotate([0,0,180])
                        linear_extrude(5)
                            archimedean_spiral(4,1.2,10);
                    
                    cylinder(r=3,h=5, $fn=50);
                }
                    cylinder(r=2,h=5, $fn=50);
                    
            }
        }
}

// Add Buckle Attachment
module buckle(){
    translate([-strap_l, -strap_w/2-Extra_w/2,0]){
        difference(){
            translate([0, -Extra_w,0])
                cube([strap_l+1, strap_w+2*Extra_w, strap_h]);

            union(){
                hull(){
                    translate([0,0,strap_h-strap_th])
                        cube([strap_th, strap_w, strap_th]);
                    translate([strap_l-strap_th,0,strap_h-strap_th])
                        cube([strap_th, strap_w, strap_th]);
                }
                hull(){
                    translate([strap_l-strap_th,0,strap_h-strap_th])
                        cube([strap_th, strap_w, strap_th]);    
                    translate([strap_l-strap_th, 0, 0])
                        cube([strap_th, strap_w, strap_th]);
                }

                hull(){   
                    translate([strap_l-strap_th, 0, 0])
                        cube([strap_th, strap_w, strap_th]);
                    cube([strap_th, strap_w, strap_th]);
                }
            }
        }
    }
}



module elastic_attachment(){
    // mm of offset between center of elastic posts and geometric center of the base
    translate([0,-center_offset,0]) elastic_post();
    translate([0,center_offset,0]) elastic_post();
}

module elastic_post(){
    difference(){
        hull(){
            // prism placed inside the base
            translate([0,0,0.5]) cube([1, 3.25, 1], center=true);
            // Cylinder places at the back where elastics are inserted
            translate([3.5,0,0]) cylinder(r=2, h=4.5, $fn=50);
        }
        hull(){
            // Hole for elastics
            translate([3,0,1.5/2+1]) cube([1,50,1.5], center=true);
            translate([1,0,4+1.5/2]) cube([1,50,1.5], center=true);
        }
    }
}

module insert_attachment(){
    // number of staples to place
    n_row = 2;
    // Staple hole size
    staple_r = 0.5;
    // Staple width
    staple_w = 11.8;
    // Spacing between staples
    staple_spc = 1.5;
    
    
    difference(){
        // Position and constructs the base through which the staple/sewing holes are inserted
        translate([-(staple_r+staple_spc+0.5), 0, 0.25])
            resize([n_row*(6*staple_r+staple_spc),staple_w*1.5, 1], auto=true)
                minkowski(){
                    cylinder(r=0.4,h=1, $fn=50);
                    cube([1,1,1], center=true);
                }
       
        translate([-2.5,0,0])
            for (i = [1:n_row]) {
                translate([-2.5*(i-1), 0, 0])
                    staple_hole();
            }
            
        // Places 4-button-type goles at the center for sewing
        translate([-3,0,0])
            rotate([0,0,45])   
                for (i=[1:4]){
                    rotate([0,0,90*i])
                        translate([2,0,0])
                            cylinder(r=0.6,h=100, $fn=50, center=true);
                }
    }
}

module staple_hole(){
// Dimensions based on North American typical office staples
// Staple hole size (a bit larger than reality to make it easier during installation
staple_r = 0.7;
// Staple width
staple_w = 11.8;
// Spacing between staples
staple_spc = 2;

// Places two extra long cylinders to be substracted from the base where the strap is sewn/stapled
translate([0, -staple_w/2, 0]) cylinder(r=staple_r, h=100, center=true, $fn=50);
translate([0, staple_w/2, 0]) cylinder(r=staple_r, h=100, center=true, $fn=50);
}