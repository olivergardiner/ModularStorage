module carcass(width, depth, height, thickness, slots) {
    t=2*thickness;

    difference () {
        cube([slots*width, depth, height]);
        translate([thickness, -thickness, thickness])
            cube([slots*width-t, depth, height-t]);
    }
}

module interlock(width, depth, height) {
	union() {
		rotate([-90, 0, 0])
			linear_extrude(depth)
				polygon(points=[[0, 0], [height, height], [width-height, height], [width, 0]]);
		translate([height, 0, -height-0.4])
			cube([width-2*height, depth, 0.5]);
	}
}

module housing(width, height, depth, thickness, interlock_thickness, easement, top=true, right=true, bottom=true, left=true, slots=1) {
	t=2*thickness;
	w=width+t;
	h=height+t;
	d=depth+thickness+easement;
	
	difference() {
		carcass(w, d, h, thickness, slots);
		if (bottom) {
			for(i=[0:slots-1]) {
				translate([i*w+w/4-easement, -1, interlock_thickness+easement])
					interlock(w/2+2*easement, d*0.9+1+2*easement, interlock_thickness+easement);
			}
		}
		if (left) {
			translate([interlock_thickness+easement, -1, 3*h/4+easement])
				rotate([0,90,0])
					interlock(h/2+2*easement, d*0.9+1+2*easement, interlock_thickness+easement);		}
	}
    if (top) {
        for(i=[0:slots-1]) {
            translate([i*w+w/4, 0, h+interlock_thickness+easement/2])
                interlock(w/2, d*0.9, interlock_thickness);
        }
    }
	if (right) {
		translate([slots*w+interlock_thickness+easement/2, 0, 3*h/4+easement])
			rotate([0,90,0])
				interlock(h/2, d*0.9, interlock_thickness);
	}
}
