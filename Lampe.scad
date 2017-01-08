//Uses
use <Wire.scad>

//Options
maxSize=5;

rad=19;
high=3.8;
RingBreite=4;
RingShift=0.5;

LEDShift=1.5;
LEDB=1;
LEDL=10;
LEDH=0.3;
LEDPuffer=0.50;

WireR=0.1;
NetzteilL=16.25;
NetzteilB=4.25;
NetzteilH=3.2;
ControllerL=8.5;
ControllerB=4.5;
ControllerH=2.3;

midPoint=false;

Zacken=false;
ZackenDicke=7;

//Typ="A";
Typ="B";

//Berechnungen
AussenRadius = rad+(RingBreite-RingShift);
InnenRadius = rad-RingBreite-RingShift;

{ //Auswahl n-Eck
    beta=2*acos((LEDL+LEDPuffer)/(2*(rad-LEDShift-LEDB/2)));
    if(beta>=154.3)
        Lampe(20);
    else if(beta>=161.1)
        Lampe(19);
    else if(beta>=160)
        Lampe(18);
    else if(beta>=158.8)
        Lampe(17);
    else if(beta>=157.5)
        Lampe(16);
    else if(beta>=156)
        Lampe(15);
    else if(beta>=154.3)
        Lampe(14);
    else if(beta>=152.3)
        Lampe(13);
    else if(beta>=150)
        Lampe(12);
    else if(beta>=147.3)
        Lampe(11);
    else if(beta>=144)
        Lampe(10);
    else if(beta>=140)
        Lampe(9);
    else if(beta>=135)
        Lampe(8);
    else if(beta>=128.6)
        Lampe(7);
    else if(beta>=120)
        Lampe(6);
    else //if(beta>=108)
        Lampe(5);
}
module Lampe(nEck) {
    Wheel();
    translate([0, 0, high-LEDH])
        Light();
    if(midPoint) {
        color("black")
            cube(0.5, center=true);
    }
    module Light(HeightFactor=1) {
        for(a=[0:2:18]) {
            rotate(a*(180-(((nEck*180)-360)/nEck))/2)
                translate([rad-LEDShift-LEDB/2, 0, 0]) rotate(90) rotate(a=10, v=[1, 0, 0]) scale([1, 1, HeightFactor]) LED();
            rotate((a+1)*(180-(((nEck*180)-360)/nEck))/2)
                translate([rad+LEDShift-LEDB/2, 0, 0]) rotate(90) rotate(a=15, v=[1, 0, 0]) scale([1, 1, HeightFactor]) LED();
        }
    }
    module Wheel() {
        color("Wheat")
        {
            difference() {
                echo("<b>Durchmesser</b>:", 2*AussenRadius);
                echo("<b>Ringbreite</b>:", 2*RingBreite);
                cylinder(r=AussenRadius, h=high, $fn=500);
                translate([0, 0, -1])
                    cylinder(r=InnenRadius, h=maxSize, $fn=500);
                translate([0, 0, high-LEDH])
                    Light(2);
            }
            if(Zacken) { 
                intersection() {
                    cylinder(r=rad+RingBreite+RingShift+ZackenDicke*0.6, h=maxSize, $fn=100);
                    for(angle=[0:30:330]) {
                        rotate(a=angle, v=[0,0,1]) {
                            translate([-ZackenDicke/2, rad+RingBreite-2*RingShift, 0]) {
                                linear_extrude(height=high)
                                    polygon([[0,0],[ZackenDicke,0],[ZackenDicke*0.8685,ZackenDicke],[ZackenDicke*0.1315,ZackenDicke]]);
                            }
                        }
                    }
                }
            }
        }
    }
    Management();
}
module Management() {
    BodenDicke=0.5;
    
    module Light(HeightFactor=1) {
        translate([+InnenRadius/2, +(LEDB/2+ControllerB/2+LEDB/4), ControllerH+BodenDicke-LEDH])
            scale([1, 1, HeightFactor]) LED();
        translate([+InnenRadius/2, -(LEDB/2+ControllerB/2+LEDB/4), ControllerH+BodenDicke-LEDH])
            scale([1, 1, HeightFactor]) LED();
        translate([-InnenRadius/2, -(LEDB/2+ControllerB/2+LEDB/4), ControllerH+BodenDicke-LEDH])
            scale([1, 1, HeightFactor]) LED();
        translate([-InnenRadius/2, +(LEDB/2+ControllerB/2+LEDB/4), ControllerH+BodenDicke-LEDH])
            scale([1, 1, HeightFactor]) LED();
    }
    
    if(Typ=="A") {
        Abhang=10;
        Radius=16.25/2+3.2;
        translate([0, 0, Abhang]) {
            color("Wheat")
            difference() {
                cylinder(r=Radius, h=3.2+1, $fn=100);
                translate([0, 0, 1])
                    cylinder(r=Radius-1, h=3.2+maxSize, $fn=100);
            }
            translate([-16.25/2, -4.25/2, 1])
                Netzteil();
            translate([-8.5/2, 4.25/2, 1])
                Controller();
        }
        for(i=[0:90:360]) {
            color("DimGray")
            rotate(a=i, v=[0, 0, 1])
            translate([InnenRadius, 0, 0.5])
                rotate(a=atan((InnenRadius-Radius)/Abhang), v=[0, -1, 0])
                    cylinder(r=0.15, h=sqrt((InnenRadius-Radius)*(InnenRadius-Radius)+Abhang*Abhang), $fn=10);
        }
    }
    else {
        translate([0, 0, high-(ControllerH+BodenDicke)]) {
            color("Wheat")
                difference() {
                    translate([-InnenRadius, -(ControllerB+NetzteilH)/2, 0])
                        cube([2*InnenRadius, ControllerB+NetzteilH, ControllerH+BodenDicke]);
                    translate([-InnenRadius-0.1, -(ControllerB+0.2)/2, BodenDicke])
                        cube([2*InnenRadius+0.2, ControllerB+0.2, ControllerH+BodenDicke]);
                    Light(1.5);
                }
            Light();
            translate([-NetzteilL/6, -NetzteilB/2, high-NetzteilH]) {
                Netzteil();
                translate([0, 3, 0.5]) rotate(90) color("Red") Wire([0, 0, 0], [0, 2.5, 0], WireR);
                translate([0, 2.5, 0.5]) rotate(90) color("Black") Wire([0, 0, 0], [0, 2.5, 0], WireR);
            }
            translate([-ControllerL-5, -ControllerB/2, BodenDicke]) {
                { //Wires
//            rotate(90) {
//                constInnenA=6.37035;
//                constInnenB=2.54353;
//                constAussen=6.67429;
//                translate([2*ControllerB/8, 0, 0]) color("White") {
//                    Wire([0, 0, ControllerH/2], [0, WireR, ControllerH/2], WireR);
//                    Wire([0, WireR, ControllerH/2], [0, WireR, WireR], WireR);
//                    Wire([0, WireR, WireR], [2*ControllerB/8, WireR, WireR], WireR);
//                    Wire([2*ControllerB/8, WireR, WireR], [2*ControllerB/8, constAussen+2*WireR, WireR], WireR);
//                    
//                    Wire([2*ControllerB/8, 14*WireR, WireR], [constInnenA, 14*WireR, WireR], WireR);
//                    Wire([constInnenA, 14*WireR, WireR], [constInnenA, constInnenB+2*WireR, WireR], WireR);
//                }
//                translate([3*ControllerB/8, 0, 0]) color("Blue") {
//                    Wire([0, 0, ControllerH/2], [0, WireR, ControllerH/2], WireR);
//                    Wire([0, WireR, ControllerH/2], [0, WireR, 3*WireR], WireR);
//                    Wire([0, WireR, 3*WireR], [ControllerB/8, WireR, 3*WireR], WireR);
//                    Wire([ControllerB/8, WireR, 3*WireR], [ControllerB/8, constAussen+4*WireR, 3*WireR], WireR);
//                    Wire([ControllerB/8, constAussen+4*WireR, 3*WireR], [ControllerB/8, constAussen+4*WireR, WireR], WireR);
//                    
//                    Wire([1*ControllerB/8, 14*WireR, 3*WireR], [constInnenA-1*ControllerB/8, 14*WireR, 3*WireR], WireR);
//                    Wire([constInnenA-1*ControllerB/8, 14*WireR, 3*WireR], [constInnenA-1*ControllerB/8, constInnenB+4*WireR, 3*WireR], WireR);
//                    Wire([constInnenA-1*ControllerB/8, constInnenB+4*WireR, 3*WireR], [constInnenA-1*ControllerB/8, constInnenB+4*WireR, WireR], WireR);
//                }
//                translate([4*ControllerB/8, 0, 0]) color("Green") {
//                    Wire([0, 0, ControllerH/2], [0, WireR, ControllerH/2], WireR);
//                    Wire([0, WireR, ControllerH/2], [0, WireR, 5*WireR], WireR);
//                    Wire([0, WireR, 5*WireR], [0, constAussen+6*WireR, 5*WireR], WireR);
//                    Wire([0, constAussen+6*WireR, 5*WireR], [0, constAussen+6*WireR, WireR], WireR);
//                    
//                    Wire([0*ControllerB/8, 14*WireR, 5*WireR], [constInnenA-2*ControllerB/8, 14*WireR, 5*WireR], WireR);
//                    Wire([constInnenA-2*ControllerB/8, 14*WireR, 5*WireR], [constInnenA-2*ControllerB/8, constInnenB+6*WireR, 5*WireR], WireR);
//                    Wire([constInnenA-2*ControllerB/8, constInnenB+6*WireR, 5*WireR], [constInnenA-2*ControllerB/8, constInnenB+6*WireR, WireR], WireR);
//                }
//                translate([5*ControllerB/8, 0, 0]) color("Red") {
//                    Wire([0, 0, ControllerH/2], [0, WireR, ControllerH/2], WireR);
//                    Wire([0, WireR, ControllerH/2], [0, WireR, 7*WireR], WireR);
//                    Wire([0, WireR, 7*WireR], [0, 3*WireR, 7*WireR], WireR);
//                    Wire([0, 3*WireR, 7*WireR], [-ControllerB/8+2*WireR, 3*WireR, 7*WireR], WireR);
//                    Wire([-ControllerB/8+2*WireR, 3*WireR, 7*WireR], [-ControllerB/8, 3*WireR, 7*WireR], WireR);
//                    Wire([-ControllerB/8, 3*WireR, 7*WireR], [-ControllerB/8, constAussen+8*WireR, 7*WireR], WireR);
//                    Wire([-ControllerB/8, constAussen+8*WireR, 7*WireR], [-ControllerB/8, constAussen+8*WireR, WireR], WireR);
//                    
//                    Wire([-1*ControllerB/8, 14*WireR, 7*WireR], [constInnenA-3*ControllerB/8, 14*WireR, 7*WireR], WireR);
//                    Wire([constInnenA-3*ControllerB/8, 14*WireR, 7*WireR], [constInnenA-3*ControllerB/8, constInnenB+8*WireR, 7*WireR], WireR);
//                    Wire([constInnenA-3*ControllerB/8, constInnenB+8*WireR, 7*WireR], [constInnenA-3*ControllerB/8, constInnenB+8*WireR, WireR], WireR);
//                }
//                translate([6*ControllerB/8, 0, 0]) color("DimGray") {
//                    Wire([0, 0, ControllerH/2], [0, 3*WireR, ControllerH/2], WireR);
//                    Wire([0, 3*WireR, ControllerH/2], [0, 3*WireR, 9*WireR], WireR);
//                    Wire([0, 3*WireR, 9*WireR], [-2*ControllerB/8, 3*WireR, 9*WireR], WireR);
//                    Wire([-2*ControllerB/8, 3*WireR, 9*WireR], [-2*ControllerB/8, constAussen+10*WireR, 9*WireR], WireR);
//                    Wire([-2*ControllerB/8, constAussen+10*WireR, 9*WireR], [-2*ControllerB/8, constAussen+10*WireR, WireR], WireR);
//                    
//                    Wire([-2*ControllerB/8, 14*WireR, 9*WireR], [constInnenA-4*ControllerB/8, 14*WireR, 9*WireR], WireR);
//                    Wire([constInnenA-4*ControllerB/8, 14*WireR, 9*WireR], [constInnenA-4*ControllerB/8, constInnenB+10*WireR, 9*WireR], WireR);
//                    Wire([constInnenA-4*ControllerB/8, constInnenB+10*WireR, 9*WireR], [constInnenA-4*ControllerB/8, constInnenB+10*WireR, WireR], WireR);
//                }
//            }
                }
                Controller();
            }
        }
    }
}

module Netzteil() {
    color("Gainsboro")
        cube([NetzteilL, NetzteilB, NetzteilH]); //Netzteil 400g
}
module Controller() {
    color("WhiteSmoke")
        cube([ControllerL, ControllerB, ControllerH]);
}
module LED() {
    translate([0, 0, LEDH/2])
        color("LightYellow")
            cube([LEDL, LEDB, LEDH], center=true);
}