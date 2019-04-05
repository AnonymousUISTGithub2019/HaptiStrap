//Title: haptistrap_enclosure
//Project: HaptiStrap
//Author: BLINDED
//Affiliation: BLINDED
//
//Description: Design file for HaptiStrap enclosure. Can generate an enclosure for both the elastic and printed tensioner designs. To adapt to tensioner type, modify lines 18-19 and 26-27. Lines 14-15 can also be used to control whether the enclosure and/or lid should appear on the generated model.

// For optimization, limit circles to 50 facets 
$fn=50;

// Whether the enclosure and lid should be included in the file (for generating STL/printing)
// Set to 1 if you want enclosure/lid
wENCLOSURE = 1;
wLID = 1;

// SET TO 1 TO SELECT TENSIONER TYPE
use_printed_tensioner = 0;
use_elastic_tensioner = 1;

//********************     DIMENSIONS     *******************
// ENCLOSURE MEASUREMENTS
// outside measurements (Excludes lid dimensions)

// ** UNCOMMENT LINE DEPENDING ON TENSIONER TYPE **
// Length
//o_l = 45; // Uncomment for printed tensioner
o_l = 30; // Uncomment for elastic tensioner

// Width
//o_w = 27; // Uncomment for printed tensioner
o_w = 25; // Uncomment for elsatic tensioner

// Thickness
o_th = 7;

// Wall Thickness
wall_th = 1;

// Bottom and top thickness
bottop_th = 1;

// Corner smooth radius
smooth_rad = 2;

// Strap width
strap_w = 20;

// Calibration Window Dimensions
cal_l = 10;
cal_w = 3;

// Parameters for elastic model
// Shaft that hold the elastic on the mobile part
shaft_r = 1.5;

// Distance between the two pegs to hold the elastic
dist_post = 2*shaft_r+0.75;

// Distance between the pegs and the front wall (larger = closer to back wall)
peg_back_dist = 5*o_l/6;

// Parameters for printed spring model
dist_post_back = 12;

// 3d printed spring priming offset
priming_offset = 3;

// *************** GENERATE ENCLOSURE ******************
enclosure(); // Insert a generic lid and enclosure with a T_spring_connector
main_buckle(); // Translate upwards to compensate for rounded bottom

module enclosure(){

if (wENCLOSURE ==1){
    difference(){
        difference(){
            difference(){ // Diff between outter case shell and inner case shell
                hull(){ // Outter shell of the case
                    translate([smooth_rad, smooth_rad, smooth_rad]){
                        cylinder(r=smooth_rad, h=o_th-smooth_rad);
                        sphere(r=smooth_rad);
                    }
                    translate([o_l-smooth_rad, smooth_rad, smooth_rad]){
                        cylinder(r=smooth_rad, h=o_th-smooth_rad);
                        sphere(r=smooth_rad);
                    }
                    translate([o_l-smooth_rad, o_w-smooth_rad, smooth_rad]){
                        cylinder(r=smooth_rad, h=o_th-smooth_rad);
                        sphere(r=smooth_rad);
                    }
                    translate([smooth_rad, o_w-smooth_rad, smooth_rad]){
                      cylinder(r=smooth_rad, h=o_th-smooth_rad);
                      sphere(r=smooth_rad);  
                    } 
                }
                hull(){ // Inner shell of the case
                    translate([smooth_rad+wall_th, smooth_rad+wall_th, bottop_th])
                        cylinder(r=smooth_rad, h=o_th-bottop_th);
                                
                    translate([o_l-smooth_rad-wall_th, smooth_rad+wall_th, bottop_th])
                        cylinder(r=smooth_rad, h=o_th-bottop_th);
                                
                    translate([o_l-smooth_rad-wall_th, o_w-smooth_rad-wall_th, bottop_th])
                        cylinder(r=smooth_rad, h=o_th-bottop_th);
                                
                    translate([smooth_rad+wall_th, o_w-smooth_rad-wall_th, bottop_th])
                        cylinder(r=smooth_rad, h=o_th-bottop_th);   
                }
            }

            // Strap opening in enclosure
            translate([-1.5/wall_th,o_w/2-strap_w/2,bottop_th])
                cube([4*wall_th, strap_w, o_th]);
        }    
      
         if (use_printed_tensioner==1){
            translate([o_l-dist_post_back*2-cal_w/2-priming_offset, 0, 3*cal_w/2])
                        rotate([90,0,0])
                        hull(){
                            translate([-cal_l,0,0])
                                cylinder(r=cal_w/2, h=300, center=true);
                                cylinder(r=cal_w/2, h=300, center=true);
                        }
                
            // Make center window on "right" side of enclosure
            translate([o_l-dist_post_back*2-cal_w/2-(cal_l)/3- (cal_w*1.01)/2-priming_offset, wall_th/3, 3*cal_w/2])    
                difference(){
                hull(){
                    translate([0,0,0])
                        rotate([90,0,0]) cylinder(r=cal_w*1.01, h=wall_th/3);
                    translate([0,0,0])
                        rotate([90,0,0]) cylinder(r=cal_w*1.01, h=wall_th/3);
                }
                translate([0,0,2.5]) cube([10,5,5], center=true);
            }
            
            // Make center window on "left" side of enclosure
            translate([o_l-dist_post_back*2-cal_w/2-(cal_l)/3- (cal_w*1.01)/2-priming_offset, o_w, 3*cal_w/2])    
                difference(){
                hull(){
                    translate([0,0,0])
                        rotate([90,0,0]) cylinder(r=cal_w*1.01, h=wall_th/3);
                    translate([0,0,0])
                        rotate([90,0,0]) cylinder(r=cal_w*1.01, h=wall_th/3);
                }
                translate([0,0,2.5]) cube([10,5,5], center=true);
            }
        }
        
        if (use_printed_tensioner==0){
                translate([o_l-peg_back_dist+5, 0, 3*cal_w/2]) 
                     rotate([90,0,0])
                        hull(){
                            translate([cal_l,0,0])
                                cylinder(r=cal_w/2, h=300, center=true);
                            translate([0,0,0])
                                cylinder(r=cal_w/2, h=300, center=true);
                        }
                            
                 // Make center window on "right" side of enclosure
                translate([o_l-peg_back_dist+5+(cal_l)/3+(cal_w*1.01)/2, wall_th/3, 3*cal_w/2]) 
                    difference(){
                    hull(){
                        translate([0,0,0])
                            rotate([90,0,0]) cylinder(r=cal_w*1.01, h=wall_th/3);
                        translate([0,0,0])
                            rotate([90,0,0]) cylinder(r=cal_w*1.01, h=wall_th/3);
                    }
                    translate([0,0,2.5]) cube([10,5,5], center=true);
                }
                
                // Make center window on "left" side of enclosure
                translate([o_l-peg_back_dist+5+(cal_l)/3+(cal_w*1.01)/2, o_w, 3*cal_w/2]) 

                    difference(){
                    hull(){
                        translate([0,0,0])
                            rotate([90,0,0]) cylinder(r=cal_w*1.01, h=wall_th/3);
                        translate([0,0,0])
                            rotate([90,0,0]) cylinder(r=cal_w*1.01, h=wall_th/3);
                    }
                    translate([0,0,2.5]) cube([10,5,5], center=true);
                }
                                
        }  
    }
    
    // Post for spirale spring
    if (use_printed_tensioner==1){
        translate([o_l-dist_post_back, o_w/2, bottop_th])
            cylinder(r=1.5, h=o_th-bottop_th);
    }
    
    
    // Posts for elastics
    if (use_elastic_tensioner==1){
    shaft_r = 1.5;
    dist_post = 2*shaft_r+0.75;
        
    translate([peg_back_dist, o_w/4+dist_post, bottop_th])
        elastic_post();
         
    translate([peg_back_dist, 3*o_w/4+dist_post/1/2, bottop_th])
        elastic_post();
        
    translate([peg_back_dist, o_w/4-dist_post/1/2, bottop_th])
        elastic_post();

        
    translate([peg_back_dist, 3*o_w/4-dist_post, bottop_th])
        elastic_post();
        
    }

}

if (wLID==1){
translate([0,-o_w-4]){
    difference(){
        union(){
                hull(){ // LID base
                    translate([smooth_rad, smooth_rad, 0])
                        cylinder(r=smooth_rad, h=bottop_th);
                        
                    translate([o_l-smooth_rad, smooth_rad, 0])
                        cylinder(r=smooth_rad, h=bottop_th);
                        
                    translate([o_l-smooth_rad, o_w-smooth_rad, 0])
                        cylinder(r=smooth_rad, h=bottop_th);
                        
                    translate([smooth_rad, o_w-smooth_rad, 0])
                        cylinder(r=smooth_rad, h=bottop_th);   
                }     
                
                // Strap hole gate alignment
                translate([0,o_w/2-strap_w*0.97/2,0])
                    cube([wall_th, strap_w*0.95, o_th/2]);
            }
            
       
            // Holes in LID to distribute elastic tension between posts and on lid
            if(use_elastic_tensioner==1){        
                translate([peg_back_dist, o_w/4+dist_post, 0])
                    cylinder(r=1.8, h=o_th);  
                    
                translate([peg_back_dist, o_w/4-dist_post/1/2, 0])
                    cylinder(r=1.8, h=o_th);  
                    
                translate([peg_back_dist, 3*o_w/4+dist_post/1/2, 0])
                    cylinder(r=1.8, h=o_th);  
                    
                translate([peg_back_dist, 3*o_w/4-dist_post, 0])
                    cylinder(r=1.8, h=o_th);   
            }

        }
        

        difference(){
            hull(){ // outter shell of the lid with offset of 1.2 wall_th
                translate([smooth_rad+1.2*wall_th, smooth_rad+1.2*wall_th, bottop_th])
                    cylinder(r=smooth_rad, h=o_th-bottop_th);
                            
                translate([o_l-smooth_rad-1.2*wall_th, smooth_rad+1.2*wall_th, bottop_th])
                    cylinder(r=smooth_rad, h=o_th-bottop_th);
                            
                translate([o_l-smooth_rad-1.2*wall_th, o_w-smooth_rad-1.2*wall_th, bottop_th])
                    cylinder(r=smooth_rad, h=o_th-bottop_th);
                            
                translate([smooth_rad+1.2*wall_th, o_w-smooth_rad-1.2*wall_th, bottop_th])
                    cylinder(r=smooth_rad, h=o_th-bottop_th);   
            }
            
            hull(){ // Inner shell of the lid with offset of 2.2 wall_th
                translate([smooth_rad+2.2*wall_th, smooth_rad+2.2*wall_th, bottop_th])
                    cylinder(r=smooth_rad, h=o_th-bottop_th);
                            
                translate([o_l-smooth_rad-2.2*wall_th, smooth_rad+2.2*wall_th, bottop_th])
                    cylinder(r=smooth_rad, h=o_th-bottop_th);
                            
                translate([o_l-smooth_rad-2.2*wall_th, o_w-smooth_rad-2.2*wall_th, bottop_th])
                    cylinder(r=smooth_rad, h=o_th-bottop_th);
                            
                translate([smooth_rad+2.2*wall_th, o_w-smooth_rad-2.2*wall_th, bottop_th])
                    cylinder(r=smooth_rad, h=o_th-bottop_th);   
           }
           
            // Strap hole gate alignment
            translate([0-wall_th,o_w/2-strap_w*0.97/2,0])
                cube([wall_th*4, strap_w*0.95, 10]);
                           
           if (use_printed_tensioner==1){
                    translate([o_l-dist_post_back*2-cal_w/2-priming_offset, 0, o_th-cal_w])
                        rotate([90,0,0])
                        hull(){
                            translate([-cal_l,0,0])
                                cylinder(r=cal_w-1, h=300, center=true);
                                cylinder(r=cal_w-1, h=300, center=true);
                        }

                }
                
            // Calibration Window in lid
            if (use_printed_tensioner==0){
                translate([o_l-peg_back_dist+5, 0, o_th-cal_w]) 
                //translate([-5,0,-o_w/2+3.5])
                    rotate([90,0,0]){
                            hull(){
                                translate([cal_l,0,0])
                                    cylinder(r=cal_w-1, h=300, center=true);
                                translate([0,0,0])
                                    cylinder(r=cal_w-1, h=300, center=true);
                            }
                 }
            }
       }
    } 
}
}


module elastic_post(){
            difference(){
            cylinder(r=1.5, h=o_th);      
            translate([0,0,shaft_r])
                difference(){
                    cylinder(r=1.5, h=3.5);
                    cylinder(r=0.8, h=3.5);}}
}

module main_buckle(){
strap_space = 2;
translate([0,(o_w-strap_w)/2-smooth_rad/2,2]) {
    if (use_elastic_tensioner==1){
    translate([o_l,0,smooth_rad])
        rotate([-90,0,0]){
            strap_bar();
            strap_holder_ends();
        }
    }
    
    if (use_printed_tensioner==1){
    translate([o_l,0,smooth_rad])
        rotate([-90,0,0]){
            strap_bar();
            strap_holder_ends();
        }
    }
}

module strap_bar(){
    translate([1+strap_space,0,1])
    hull(){
        cylinder(r=1, h=strap_w, $fn=50);
        translate([1,0,0])
            cylinder(r=1, h=strap_w, $fn=50);
    }
}
module strap_holder_ends(){
    hull(){
        translate([2+strap_space,0,0])
            cylinder(r=1, h=1, $fn=50);
        translate([0, -1, 0])
            cube([2,2,1]);
    }
    
    translate([0,0,strap_w+1])
    hull(){
        translate([2+strap_space,0,0])
            cylinder(r=1, h=1, $fn=50);
        translate([0, -1, 0])
            cube([2,2,1]);
    }
    
    
}
}