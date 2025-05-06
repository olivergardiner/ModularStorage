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
			for (i=[0:slots-1]) {
				translate([i*w+w/4-2*easement, -1, interlock_thickness+easement])
					interlock(w/2+4*easement, d*0.8+1+2*easement, interlock_thickness+easement);
			}
		}
		if (left) {
			translate([interlock_thickness+easement, -1, 3*h/4+2*easement])
				rotate([0,90,0])
					interlock(h/2+4*easement, d*0.8+1+2*easement, interlock_thickness+easement);
		}
	}
    if (top) {
        for (i=[0:slots-1]) {
            translate([i*w+w/4, 0, h+interlock_thickness+easement])
                interlock(w/2, d*0.8-2*easement, interlock_thickness);
        }
    }
	if (right) {
		translate([slots*w+interlock_thickness+easement, 0, 3*h/4])
			rotate([0,90,0])
				interlock(h/2, d*0.8-2*easement, interlock_thickness);
	}
}

module handle(radius, thickness, width, height) {
	ht = thickness/2;
	p = ht*4.5;

	translate([0,-ht,0])
		difference() {
			cylinder(thickness, r=radius);
			
			translate([-radius-1, 0, -1])
				cube([2*radius+2, 2*radius+2, thickness+2]); 
		}

	translate([-width/2+ht, -ht, 0])
		cube([width-thickness, ht, thickness]);

	translate([width/2-p-ht, -thickness, 0])
		cube([p, ht, height/2+ht]);

	translate([width/2-ht-thickness, -ht, 0])
		cube([thickness, ht, height/2+ht]);

	translate([-width/2+ht, -thickness, 0])
		cube([p, ht, height/2+ht]);

	translate([-width/2+ht, -ht, 0])
		cube([thickness, ht, height/2+ht]);
}

module fixedDivider(width, height, thickness, style) {
	translate([0, -thickness/2, 0])
		cube([width, thickness, height-thickness]);
}

module variableDivider(width, height, thickness, style) {
	translate([0, -3*thickness/2, 0])
		cube([2*thickness, thickness, height-thickness]);

	translate([0, thickness/2, 0])
		cube([2*thickness, thickness, height-thickness]);

	translate([width-2*thickness, -3*thickness/2, 0])
		cube([2*thickness, thickness, height-thickness]);

	translate([width-2*thickness, thickness/2, 0])
		cube([2*thickness, thickness, height-thickness]);
}

module drawer(width, height, depth, thickness, radius, slots=1, compartments=2, style=0) {
    t=2*thickness;
	w=slots*width;

    difference () {
        cube([w, depth, height]);
        translate([thickness, thickness, thickness])
            cube([w-t, depth-t, height]);
    }
	
	translate([w/2, 0, height/2-thickness/2])
		handle(radius=radius, thickness=thickness, width=width, height=height);
		
	for (i=[1:compartments-1]) {
		translate([0, i*(depth-t)/compartments+thickness, 0]) {
			if (style==0) {
				fixedDivider(width=width, height=height, thickness=thickness);
			}
			else if (style==1) {
				variableDivider(width=width, height=height, thickness=thickness);
			}
		}
	}
}

//drawer(width=54, height=52.25, depth=117, thickness=2, radius=13, compartments=4, style=1);

//handle(radius=13, thickness=2, width=54, height=52.25); 

//variableDivider(width=54, height=52.25, thickness=2, style=0);