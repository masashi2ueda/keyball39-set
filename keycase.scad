module create_base_case1() {
    import("./src_stl/ball_right.stl");
}

module create_base_case2() {
    translate([-138, 0, 0])
    import("./src_stl/noball_left.stl");
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

// cube_size1, 2:barを支えるcubeのサイズ, cylinder_w:barの幅, cylinder_r:barの半径
module bar_core(cube_size1, cube_size2, cylinder_w, cylinder_r){
    cube_w1 = cube_size1[0];
    cube_w2 = cube_size2[0];
    cube_h = cube_size1[2];
    cube(cube_size1);
    translate([cube_w1+cylinder_w, 0, 0])
    cube(cube_size2);

    translate([0, cylinder_r/2, cube_h/2])
    rotate([0, 90, 0])
    cylinder(r=cylinder_r, h=cylinder_w+cube_w1+cube_w2, $fn=50);    
}

// bar_space_w: バーの間隔, base_cube_size: cubeの基本のサイズ, d1,2,3,4:cubeの各奥行き
module create_armrest_bar(bar_space_w, base_cube_size, d1, d2, d3, d4, cylinder_w, cylinder_r) {
    cube_size1 = [base_cube_size[0], d1, base_cube_size[2]];
    cube_size2 = [base_cube_size[0], d2, base_cube_size[2]];
    cube_size3 = [base_cube_size[0], d3, base_cube_size[2]];
    cube_size4 = [base_cube_size[0], d4, base_cube_size[2]];

    bar_core(cube_size1, cube_size2, cylinder_w, cylinder_r);
    translate([bar_space_w, 0, 0])
    bar_core(cube_size3, cube_size4, cylinder_w, cylinder_r);
}

module create_armrest_c(bar_cylinder_r, bar_cylinder_w, bar_crearance, bar_r_crearance) {
    difference() {
        bar_r = bar_cylinder_r + bar_r_crearance * 2;
        bar_h = bar_cylinder_w - bar_crearance;
        cylinder(r=bar_r, h=bar_h, $fn=50);
        
        bar_r2 = bar_cylinder_r + bar_r_crearance;
        bar_h2 = bar_cylinder_w - bar_crearance;
        cylinder(r=bar_r2, h=bar_h2, $fn=50);

        cube_w = 100;
        cube_h = 100;
        cube_d = bar_cylinder_r *2 + bar_r_crearance;
        translate([cube_w/2, 0, 0])
        cube([cube_w, cube_d, cube_h], center=true);
    }
}
module create_armrest_c_cube(cube_c_size, bar_cylinder_r, bar_cylinder_w, bar_crearance, bar_r_crearance) {
    cube(cube_c_size, center=true);
    translate([bar_cylinder_w/2, 0, cube_c_size[2]])
    rotate([0, -90, 0])
    create_armrest_c(bar_cylinder_r, bar_cylinder_w, bar_crearance, bar_r_crearance);
}

module create_armrest_plate(thickness, plate_d) {
    w1 = 100;
    w2 = 70;
    w3 = 50;
    h1 = -plate_d;
    h2 = -plate_d-10;
    h3 = -plate_d-20;
    hull() {
        translate([-w1/2, 0, 0])
        cylinder(r=5, h = thickness,$fn=50);
        translate([w1/2, 0, 0])
        cylinder(r=5, h = thickness,$fn=50);
        
        translate([-w2/2, h1, 0])
        cylinder(r=5, h = thickness,$fn=50);
        translate([w2/2, h1, 0])
        cylinder(r=5, h = thickness,$fn=50);

        translate([-w3/2, h2, 0])
        cylinder(r=5, h = thickness,$fn=50);

        translate([w3/2, h2, 0])
        cylinder(r=5, h = thickness,$fn=50);

        translate([0, h3, 0])
        cylinder(r=50, h = thickness,$fn=50);
    }
}

module create_armrest(cube_c_size, bar_cylinder_r, bar_cylinder_w, bar_crearance, bar_r_crearance, plate_thickness, bar_space_w, plate_d) {
    create_armrest_plate(plate_thickness, plate_d);
    
    t_h = plate_thickness+cube_c_size[2]/2;
    
    translate([bar_space_w/2, 0, t_h])
    create_armrest_c_cube(cube_c_size, bar_cylinder_r, bar_cylinder_w, bar_crearance, bar_r_crearance);
    
    translate([-bar_space_w/2, 0, t_h])
    create_armrest_c_cube(cube_c_size, bar_cylinder_r, bar_cylinder_w, bar_crearance, bar_r_crearance);
}


// ギアのパラメータ
gear_h = 3;
gear_num = 18;
gear_r = 5;
gear_rd = 13;
gear_box_size = [12, 12, 3.5];
gear_box_crealance = 0.2;
gear_box_crealance_rd = 6.0;

// アームレストのパラメータ
armrest_base_cube_size = [2,5,4];
armrest_bar_cylinder_w = 10;
armrest_bar_cylinder_r = 2;
armrest_bar_space_w = 90;
armrest_bar_crearance = 0.5;
armrest_bar_r_crearance = 2;
armrest_cube_c_size = [10, 10, 5];
armrest_plate_thickness = 2;
armrest_plate_d = 50;

/*
//　右のケースを作る
difference() {
    create_base_case1();
    translate([15, 90, 10])
    cube([15, 20, 5]);
}

translate([1, 98, 5])
rotate([0, -90, 0])
create_gear_base(gear_box_size, gear_num, gear_h, gear_r, gear_rd, gear_box_crealance, gear_box_crealance_rd);

translate([4.5, 10, 5])
rotate([20, -90, 0])
create_gear_base(gear_box_size, gear_num, gear_h, gear_r, gear_rd, gear_box_crealance, gear_box_crealance_rd);

translate([30, -5, 5]){
    create_armrest_bar(armrest_bar_space_w, armrest_base_cube_size, 16, 18, 17, 30, armrest_bar_cylinder_w, armrest_bar_cylinder_r);
}
*/


// 左のケースを作る
difference() {
    create_base_case2();
    translate([-31, 90, 10])
    cube([15, 20, 5]);
}
translate([-1, 98, 5])
rotate([0, 90, 0])
create_gear_base(gear_box_size, gear_num, gear_h, gear_r, gear_rd, gear_box_crealance, gear_box_crealance_rd);

translate([-4.5, 10, 5])
rotate([20, 90, 0])
create_gear_base(gear_box_size, gear_num, gear_h, gear_r, gear_rd, gear_box_crealance, gear_box_crealance_rd);

translate([-30, -5, 5]){
    rotate([0, 180, 0])
    create_armrest_bar(armrest_bar_space_w, armrest_base_cube_size, 16, 18, 17, 30, armrest_bar_cylinder_w, armrest_bar_cylinder_r);
}


/*
// armrestを作る
create_armrest(armrest_cube_c_size, armrest_bar_cylinder_r, armrest_bar_cylinder_w, armrest_bar_crearance, armrest_bar_r_crearance, armrest_plate_thickness, armrest_bar_space_w, armrest_plate_d);
*/

/*
// 足を作る
foot_size = [gear_r*2, 45, 10];
cube(foot_size);
translate([gear_r, gear_r, foot_size[2]])
create_gear(gear_num=gear_num, h=gear_h, r=gear_r, rd=gear_rd);
*/


/*
// ギアをテストプリントする
translate([20, 0, 0])
create_gear_base(gear_box_size, gear_num, gear_h, gear_r, gear_rd, gear_box_crealance, gear_box_crealance_rd);

foot_size = [gear_r*2, 15, 3];
cube(foot_size);
translate([gear_r, gear_r, foot_size[2]])
create_gear(gear_num=gear_num, h=gear_h, r=gear_r, rd=gear_rd);
*/


/*
// armrestをテストプリントする
translate([-20, 30, 0]) {
    create_armrest_bar(armrest_bar_space_w, armrest_base_cube_size, 20, 20, 20, 20, armrest_bar_cylinder_w, armrest_bar_cylinder_r);
    translate([0, 10, 0])
    cube([120, 5, 5]);
} 

difference(){
    translate([armrest_bar_space_w/2+7, 0, 0]) {
        create_armrest(armrest_cube_c_size, armrest_bar_cylinder_r, armrest_bar_cylinder_w, armrest_bar_crearance, armrest_bar_r_crearance, armrest_plate_thickness, armrest_bar_space_w);
    }
    translate([-10, -190, -10])
    cube([200, 180, 14]);
}
*/