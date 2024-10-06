// 描画のパラメータ
$fs = 0.1;
$fa = 0.25;

// stemのパラメータ
stem_w = 5.3;
stem_d = 4.9;
stem_h = 20;
stem_cross_length1 = stem_d;
stem_cross_length2 = stem_w-1.0;
stem_cross_w1= 1.55;
stem_cross_w2 = 1.40;
stem_cross_h = 5;

module create_stem (w, d, h, cross_length1, cross_length2, cross_w1, cross_w2, cross_h) {
    difference () {
        translate([0, 0, h / 2])
            cube([w, d, h], center = true);
        translate([0, 0, cross_h / 2])
            cube([cross_w1, cross_length1, cross_h], center = true);
        translate([0, 0, cross_h / 2])
            cube([cross_length2, cross_w2, cross_h], center = true);
    }
}
// stemの確認
//create_stem(w=stem_w, d=stem_d, h=stem_h, cross_length1=stem_cross_length1, cross_length2=stem_cross_length2, cross_w1=stem_cross_w1, cross_w2=stem_cross_w2, cross_h=stem_cross_h);

bottom_size = 18;
top_size    = 14;
top_height  = 8;
wall_t = 3;
wall_top_t = 1.5;
top_r = 3;
bottom_r = 0.5;
top_angle = 10;

function dish_r(w, d) = (w * w + 4 * d * d) / (8 * d);

module rounded_cube (size, r) {
  h = 0.0001; // cylinder の高さ (適当な値)
  minkowski () {
    cube([size[0] - r*2, size[1] - r*2, size[2] - h], center = true);
    cylinder(r = r, h = h);
  }
}

module key_base(bottom_size, top_size, top_height, top_r, bottom_r, top_angle) {
    difference() {
        hull () {
            translate([0, 0, top_height])
                rotate([- top_angle, 0, 0])
                    rounded_cube([top_size, top_size, 0.01], top_r);
            rounded_cube([bottom_size, bottom_size, 0.01], bottom_r);
        }
        dish_depth = 1;
        translate([0, 0, top_height])
          rotate([- top_angle, 0, 0])
            translate([0, 0, dish_r(top_size, dish_depth) - dish_depth])
              rotate([90, 0, 0])
                cylinder(r = dish_r(top_size, dish_depth), h = 60, /* 適当に十分な長さ */ center = true);
    }
}
// key_base(bottom_size, top_size, top_height, top_r, bottom_r, top_angle);
// key_base(bottom_size, top_size, top_height, top_r, bottom_r, top_angle);
module create_key_cap(bottom_size, top_size, top_height, top_r, bottom_r, top_angle, wall_t, wall_top_t, stem_w, stem_d, stem_h, cross_length1, cross_length2, cross_w1, cross_w2, cross_h) {
    difference () {
      key_base(bottom_size, top_size, top_height, top_r, bottom_r, top_angle);
      // 一回り小さいキーキャップ外形
      bottom_size2 = bottom_size - wall_t;
      top_size2 = top_size - wall_t;
      top_height2 = top_height - wall_top_t;
      key_base(bottom_size2, top_size2, top_height2, top_r, bottom_r, top_angle);
    }

    intersection (){
        create_stem(w=stem_w, d=stem_d, h=stem_h, cross_length1=stem_cross_length1, cross_length2=stem_cross_length2, cross_w1=stem_cross_w1, cross_w2=stem_cross_w2, cross_h=stem_cross_h);
        key_base(bottom_size, top_size, top_height, top_r, bottom_r, top_angle);

    }
}
// create_key_cap(bottom_size, top_size, top_height, top_r, bottom_r, top_angle, wall_t, wall_top_t, stem_w, stem_d, stem_h, stem_cross_length1, stem_cross_length2, stem_cross_w1, stem_cross_w2, stem_cross_h);
max_y = 3;
max_angle = 8;
max_height_add = 3;
/*
module create_key_cap_pos(x, y, under_bar) {
    now_top_angle = -2 * max_angle/max_y*y + max_angle;
    
    yy = abs(y - max_y / 2);
    add_height = yy / (max_y / 2) * max_height_add;
    now_top_height = top_height + add_height;
  
    translate([x*20, y*20, 0])
        create_key_cap(bottom_size, top_size, now_top_height, top_r, bottom_r, now_top_angle, wall_t, wall_top_t, stem_w, stem_d, stem_h, stem_cross_length1, stem_cross_length2, stem_cross_w1, stem_cross_w2, stem_cross_h);
        if (under_bar) {
            translate([0, 6.5+y*20, now_top_height - 1.4])
                rotate([0, 90, 0])
                    cylinder(r = 0.4, h = 2.5,  center = true);
        }
}
*/
module create_key_cap_pos(x, y, under_bar, now_top_angle, now_top_height, bar_cylinder_r) {  
    translate([x*20, y*20, 0])
        create_key_cap(bottom_size, top_size, now_top_height, top_r, bottom_r, now_top_angle, wall_t, wall_top_t, stem_w, stem_d, stem_h, stem_cross_length1, stem_cross_length2, stem_cross_w1, stem_cross_w2, stem_cross_h);
        if (under_bar) {
            translate([0, 6+y*20-bar_cylinder_r/2, now_top_height-0.5])
                rotate([0, 90, 0])
                    cylinder(r = bar_cylinder_r, h = 4, /* 適当に十分な長さ */ center = true);
        }
}


//create_key_cap_pos(x=0, y=0, under_bar=false);
//create_key_cap_pos(x=0, y=1, under_bar=false);
create_key_cap_pos(x=0, y=1, under_bar=true, now_top_angle=-5, now_top_height=8,bar_cylinder_r=1.5);
//create_key_cap_pos(x=0, y=1, under_bar=true);
//create_key_cap_pos(x=0, y=2, under_bar=false);
//create_key_cap_pos(x=0, y=3, under_bar=false);
