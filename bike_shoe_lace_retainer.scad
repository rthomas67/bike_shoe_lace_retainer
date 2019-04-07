// shoelace retainer
// for bike shoes, to keep laces out of the chain.

clipThickness=2;
upperClipWidth=25;
lowerClipWidthFactor=1.2;
lowerClipWidth=upperClipWidth*lowerClipWidthFactor;
upperClipCloseAngle=-9;

clipCoreInnerDia=7;

clipLength=85;

// size of the hole through which the laces pass
laceCutHoleDia=5;

laceCutHoleSpacing=21;

// the angle, relative to the end, of the lace hole alignment
laceCutHoleSpiralAngle=20;

laceCutHolePathDia=clipCoreInnerDia*1.7;
laceCutHoleShift=clipCoreInnerDia/5;
laceCutHolePathSquashFactorX=1.5+0;
laceCutHolePathSquashFactorY=0.7+0;

clipOuterDia=clipCoreInnerDia+clipThickness*2;
numberOfLaceCutHoles = round(clipLength/laceCutHoleSpacing);
firstLaceCutHoleOffset=
    (clipLength-(laceCutHoleSpacing*
        (numberOfLaceCutHoles-1)))/2;

overlap=0.01;
$fn=50;

difference() {
    linear_extrude(height = clipLength, center = false, convexity = 10, twist = 0)
        clipShape();
    for (holeNum = [0 : 1 : numberOfLaceCutHoles-1]) {
            translate([0,-laceCutHoleShift,
                    firstLaceCutHoleOffset+laceCutHoleSpacing*holeNum])
                scale([laceCutHolePathSquashFactorX,
                        laceCutHolePathSquashFactorY,1])
        rotate([0,laceCutHoleSpiralAngle,0])
                    torus(laceCutHoleDia, laceCutHolePathDia);
    }
}

module clipShape() {
    // upper clip face
    translate([0,clipCoreInnerDia+clipThickness])
    rotate([0,0,upperClipCloseAngle])
    hull() {
        circle(d=clipThickness);
        translate([upperClipWidth,0])
        circle(d=clipThickness);
    }
    // lower clip face
    hull() {
        circle(d=clipThickness);
        translate([lowerClipWidth,0])
        circle(d=clipThickness);
    }

    translate([0,clipCoreInnerDia/2+clipThickness/2]) {
        difference() {
            circle(d=clipOuterDia);
            translate([0, -clipOuterDia/2-overlap])
                square([clipOuterDia, clipOuterDia+overlap*2]);
            circle(d=clipCoreInnerDia);
        }
    }    
}

module torus(torusThickness, torusDia) {
    rotate_extrude(angle = 360, convexity = 2)
        translate([torusDia/2,0])
            circle(d=torusThickness);
}