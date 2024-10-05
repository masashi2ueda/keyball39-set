module create_base_case() {
    import("./bambucase2.stl");
    translate([-138, 0, 0])
    import("./bambucase3.stl");
}


// gear_num:ギアの個数, h:ギアの高さ, r=ギアの半径, rd:一つのギアの縦横比
module create_gear(gear_num=36, h = 1, r = 5, rd = 5) {
    dd = 360/gear_num;
    for(deg = [0:dd:360]) {
    rotate([0, 0, deg])
        scale([1,1/rd,1])
        cylinder(h = h, r = r,$fn=50,center=false);
    }
}

// gear_box_size:ギアの受けの箱のサイズ[w, d, h],gear_crealance箱の gear_num:ギアの個数, h:ギアの高さ, r=ギアの半径, rd:一つのギアの縦横比, gear_box_crealance:ギアの受け箱のクリアランスのサイズ, gear_box_crealance_rd:ギアの縦横のクリアランスのサイズ
module create_gear_base(gear_box_size, gear_num, gear_h, gear_r, gear_rd, gear_box_crealance, gear_box_crealance_rd) {
    gear_box_h = gear_box_size[2];
    difference() {
        translate([0, 0, gear_box_h/2]) {
            cube(gear_box_size, center=true);
        }
        translate([0, 0, gear_box_h - gear_h]) {
            create_gear(h=gear_h+gear_box_crealance, gear_num=gear_num, r=gear_r+gear_box_crealance, rd=gear_rd-gear_box_crealance-gear_box_crealance_rd);
        }
    }
}

module create_armrest_plate() {
    w1 = 100;
    w2 = 70;
    w3 = 50;
    h1 = -100;
    h2 = -110;
    h3 = -120;
    hull() {
        translate([-w1/2, 0, 0])
        cylinder(r=5, h = 5,$fn=50);
        translate([w1/2, 0, 0])
        cylinder(r=5, h = 5,$fn=50);
        
        translate([-w2/2, h1, 0])
        cylinder(r=5, h = 5,$fn=50);
        translate([w2/2, h1, 0])
        cylinder(r=5, h = 5,$fn=50);

        translate([-w3/2, h2, 0])
        cylinder(r=5, h = 5,$fn=50);

        translate([w3/2, h2, 0])
        cylinder(r=5, h = 5,$fn=50);

        translate([0, h3, 0])
        cylinder(r=50, h = 5,$fn=50);
    }
}

// d1,2,3: 3本の柱の長さ, bar_h: バーの長さ, bar_r:バーの半径, cube_w:柱の幅, cube_h:柱の高さ
module create_armrest_bar(d1, d2, d3, bar_h, bar_r, cube_w, cube_h) {
    cube([cube_w, d1, cube_h]);
    translate([cw/2-cube_w, 0, 0])
    cube([cube_w, d2, cube_h]);
    translate([cw-cube_w, 0, 0])
    cube([cube_w, d3, cube_h]);
    translate([0, cube_w/2, cube_h/2])
    rotate([0, 90, 0])
    cylinder(r=bar_r, h=bar_h, $fn=50);
}

//create_gear(gear_num=36, h=1, r=5, rd=20);

// caseのベースを作る
create_base_case();

gear_h = 3;
gear_num = 20;
gear_r = 4;
gear_rd = 13;
gear_box_size = [10, 10, 3.5];
gear_box_crealance = 0.5;
gear_box_crealance_rd = 5.0;

/*
//gear test
translate([20, 0, 0])
create_gear_base(gear_box_size, gear_num, gear_h, gear_r, gear_rd, gear_box_crealance, gear_box_crealance_rd);

foot_size = [gear_r*2, 50, 3];
cube(foot_size);
translate([gear_r, gear_r, foot_size[2]])
create_gear(gear_num=gear_num, h=gear_h, r=gear_r, rd=gear_rd);
*/



// arm_rest_bar
cw = 95;
cr = 2;
ccr = 4;
arm_rest_bar_w = 95;
arm_rest_bar_r = 2;
arm_rest_bar_cube_w = 4;
arm_rest_bar_cube_h = 6;
dw = 40;
dy = -5;
dh = 5;
translate([dw, dy, dh])
create_armrest_bar(18, 14, 20, arm_rest_bar_w, arm_rest_bar_r, arm_rest_bar_cube_w, arm_rest_bar_cube_h);
translate([-cw-dw, dy, dh])
create_armrest_bar(10, 22, 17, arm_rest_bar_w, arm_rest_bar_r, arm_rest_bar_cube_w, arm_rest_bar_cube_h);





cu_w1 = 2;
cu_h1 = 2;
cu_w2 = cu_w1;
cu_h2 = cu_h1;
cy_w = 10;
cy_r = 2;

module bar_core(cu_d1, cu_d2){
    cube([cu_w1, cu_d1, cu_h1]);
    translate([cu_w1+cy_w, 0, 0])
    cube([cu_w2, cu_d2, cu_h2]);

    translate([0, cy_r/2, cy_r/2])
    rotate([0, 90, 0])
    cylinder(r=cy_r, h=cy_w+cu_w1+cu_w2, $fn=50);    
}

bar_cu_d1 = 30;
bar_cu_d2 = 30;
bar_cu_d3 = 30;
bar_cu_d4 = 30;
bar_w = 90;
module bar(bar_w, bar_cu_d1, bar_cu_d2, bar_cu_d3, bar_cu_d4) {
    bar_core(bar_cu_d1, bar_cu_d2);
    translate([bar_w, 0, 0])
    bar_core(bar_cu_d3, bar_cu_d4);
}

translate([30, -10, 5]){
    //bar(90, 30, 30, 30, 30);
    bar_core(bar_cu_d3, bar_cu_d4);

}


hame_add_r = cy_r + 2;
hame_crl = 0.5;
//cylinder(r=hame_add_r, h = cy_w - hame_ctr, $fn=50);

difference() {
    cylinder(r=hame_add_r, h=cy_w-hame_crl, $fn=50);
    cylinder(r=cy_r+hame_crl, h=cy_w, $fn=50);
    translate([3, 0, 0])
    cube([cy_r+5, cy_r*2+hame_crl, 30], center=true);
}

translate([-13, 0, 0])
cube([10, cy_r+hame_crl, 10]);

/*
translate([30, 10, 0])
cube([20, 10, 10]);
*/