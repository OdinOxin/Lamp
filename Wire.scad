module Wire(from=[0, 0, 0], to=[0, 0, 0], r) {
    hull() {
        translate(from) sphere(r=r, $fn=100);
        translate(to) sphere(r=r, $fn=100);
    }
}
//module WireEdge(r) {
//    rotate(a=90, v=[0, 1, 0])
//    translate([-r, 0, 0])
//    difference() {
//        rotate_extrude($fn=60,convexity=4)
//            translate([r,0])
//                circle(r,$fn=50);
//        translate([0,-4*r,0])
//            cube(8*r, true);
//        translate([-8*r,0,0])
//            cube(16*r, true);
//    }
//}
//module Wire(r, l) {
//    rotate(a=90, v=[-1, 0, 0])
//    cylinder(r=r, h=l, $fn=50);
//}