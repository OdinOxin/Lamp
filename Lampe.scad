//Uses
use <Wire.scad>

//Options
WoodOnly=false;
Querschnitt=false;

rad=190;
HolzH=38;
RingBreite=80;
RingShift=5;

LEDShift=15;
LEDB=10;
LEDL=100;
LEDH=3;
LEDPuffer=5;

WireR=1;
NetzteilL=162.5;
NetzteilB=42.5;
NetzteilH=32.0;
ControllerL=85.0;
ControllerB=45.0;
ControllerH=23.0;

Zacken=false;
ZackenDicke=7;

//Typ="A";
Typ="B";

//Berechnungen
AussenRadius = rad+(RingBreite/2-RingShift);
InnenRadius = rad-RingBreite/2-RingShift;

{ //Auswahl n-Eck
    beta=2*acos((LEDL+LEDPuffer)/(2*(rad-LEDShift-LEDB/2)));
    if(beta>=154.3)
        Print(20);
    else if(beta>=161.1)
        Print(19);
    else if(beta>=160)
        Print(18);
    else if(beta>=158.8)
        Print(17);
    else if(beta>=157.5)
        Print(16);
    else if(beta>=156)
        Print(15);
    else if(beta>=154.3)
        Print(14);
    else if(beta>=152.3)
        Print(13);
    else if(beta>=150)
        Print(12);
    else if(beta>=147.3)
        Print(11);
    else if(beta>=144)
        Print(10);
    else if(beta>=140)
        Print(9);
    else if(beta>=135)
        Print(8);
    else if(beta>=128.6)
        Print(7);
    else if(beta>=120)
        Print(6);
    else //if(beta>=108)
        Print(5);
}
module Print(nEck) {
    Lampe(nEck);
}
module Lampe(nEck) {
    if(!Querschnitt)
        Wheel();
    else {
        color("Wheat") difference()
        {
            Wheel();
            Querschnitt();
            rotate(90) Querschnitt();
        }
    }
    if(!WoodOnly) {
        if(!Querschnitt) {
            translate([0, 0, HolzH-LEDH])
                    Light();
        }
        else {
            color("White") difference()
            {
                translate([0, 0, HolzH-LEDH])
                        Light();
                translate([0, 0.25, 0]) Querschnitt();
                rotate(90) translate([0, 0.25, 0]) Querschnitt();
            }
        }
        for(a=[45:90:360]) {
            rotate(a=a)
                translate([0, -InnenRadius, HolzH/2])
                    Haken(2.5);
        }
    }
    module Light(HeightFactor=1) {
        for(a=[0:2:18]) {
            rotate(a*(180-(((nEck*180)-360)/nEck))/2)
                //Innen
                translate([rad-LEDShift-LEDB/2, 0, -1.5*LEDH]) rotate(90) rotate(a=10, v=[1, 0, 0]) scale([1, 1, HeightFactor]) LED();
            rotate((a+1)*(180-(((nEck*180)-360)/nEck))/2)
                //Aussen
                translate([rad+LEDShift-LEDB/2, 0, -3.75*LEDH]) rotate(90) rotate(a=15, v=[1, 0, 0]) scale([1, 1, HeightFactor]) LED();
        }
    }
    module Haken(r=1) {
        color("DimGray")
        translate([0, 2*r, 0]) {
            translate([0, -r, 0])
                rotate(a=90, v=[1, 0, 0])
                    cylinder(r=r/2, h=r, $fn=100);
            rotate_extrude(a=360, $fn=100)
                translate([r, 0, 0])
                    circle(r=r/2, $fn=10);
        }
    }
    module Wheel() {
        echo("<b>Durchmesser</b>:", 2*AussenRadius);
        echo("<b>Ringbreite</b>:", RingBreite);
        color("Wheat")
        {
            difference() {
                rotate_extrude(angle=360, $fn=500)
                translate([InnenRadius, 0, 0])
                    polygon([
                        [0, 0],
                        [0, HolzH],
                        [RingBreite/2, HolzH-(RingBreite/2*tan(10))],
                        [RingBreite, HolzH-(RingBreite/2*tan(10))-(RingBreite/2*tan(15))],
                        [RingBreite, 0]
                    ]);
                
                translate([0, 0, HolzH-LEDH])
                    Light(2);
            }
            if(Zacken) {
                intersection() {
                    cylinder(r=rad+RingBreite/2+RingShift+ZackenDicke*0.6, h=maxSize, $fn=100);
                    for(angle=[0:30:330]) {
                        rotate(a=angle, v=[0,0,1]) {
                            translate([-ZackenDicke/2, rad+RingBreite/2-2*RingShift, 0]) {
                                linear_extrude(height=HolzH)
                                    polygon([[0,0],[ZackenDicke,0],[ZackenDicke*0.8685,ZackenDicke],[ZackenDicke*0.1315,ZackenDicke]]);
                            }
                        }
                    }
                }
            }
        }
    }
    module Querschnitt() {
        translate([0, AussenRadius/2, HolzH/2])
            cube([2*AussenRadius, AussenRadius, 2*HolzH], true);
    }
    Management();
}
module Management() {
    BodenDicke=8;
    Abstand = 1;
    
    module Light(HeightFactor=1) {
        LEDStegB = NetzteilH/2-Abstand;
        translate([+InnenRadius/2, +(ControllerB+NetzteilH-LEDStegB)/2, ControllerH+BodenDicke-LEDH])
            scale([1, 1, HeightFactor]) LED();
        translate([+InnenRadius/2, -(ControllerB+NetzteilH-LEDStegB)/2, ControllerH+BodenDicke-LEDH])
            scale([1, 1, HeightFactor]) LED();
        translate([-InnenRadius/2, -(ControllerB+NetzteilH-LEDStegB)/2, ControllerH+BodenDicke-LEDH])
            scale([1, 1, HeightFactor]) LED();
        translate([-InnenRadius/2, +(ControllerB+NetzteilH-LEDStegB)/2, ControllerH+BodenDicke-LEDH])
            scale([1, 1, HeightFactor]) LED();
    }
    
    if(Typ=="A") {
        Abhang=100;
        Radius=NetzteilL/2+NetzteilH;
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
            translate([InnenRadius, 0, 5])
                rotate(a=atan((InnenRadius-Radius)/Abhang), v=[0, -1, 0])
                    cylinder(r=0.15, h=sqrt((InnenRadius-Radius)*(InnenRadius-Radius)+Abhang*Abhang), $fn=10);
        }
    }
    else {
        translate([0, 0, HolzH-(ControllerH+BodenDicke)]) {
            color("Wheat") difference() {
                translate([-InnenRadius, -(ControllerB+NetzteilH)/2, 0])
                    cube([2*InnenRadius, ControllerB+NetzteilH, ControllerH+BodenDicke]);
                translate([-InnenRadius, -(ControllerB+2*Abstand)/2, BodenDicke])
                    cube([2*InnenRadius, ControllerB+2*Abstand, ControllerH+BodenDicke]);
                difference() {
                    cylinder(r=AussenRadius-InnenRadius/2, h=HolzH);
                    cylinder(r=InnenRadius, h=HolzH, $fn=500);
                }
                Light(1.5);
            }
            if(!WoodOnly) {
                    Light();
                translate([-NetzteilL/6, -NetzteilB/2, HolzH-NetzteilH]) {
                    Netzteil();
                    translate([0, 3, 0.5]) rotate(90) color("Red") Wire([0, 0, 0], [0, 2.5, 0], WireR);
                    translate([0, 2.5, 0.5]) rotate(90) color("Black") Wire([0, 0, 0], [0, 2.5, 0], WireR);
                }
                translate([-1.5*ControllerL, -ControllerB/2, BodenDicke]) {
                    Controller();
                }
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