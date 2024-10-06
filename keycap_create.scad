include <keycap.scad>

//////////////////
// 以下は基本のパラメータ(変更不要)
//////////////////

// 描画のパラメータ
$fs = 0.1;
$fa = 0.25;

// stemのパラメータ
stem_w = 5.3;
stem_d = 4.9;
stem_h = 20;
stem_cross_length1 = stem_d;
stem_cross_length2 = stem_w - 1.0;
stem_cross_w1= 1.55;
stem_cross_w2 = 1.40;
stem_cross_h = 5;

// キーキャップのパラメータ
bottom_size = 18;
top_size    = 14;
top_height  = 8;
wall_t = 3;
wall_top_t = 1.5;
top_r = 3;
bottom_r = 0.5;
top_angle = 10;

// [0,1,2,3]で4行分
max_y = 3;

//////////////////
// 以下のパラメータを調整
//////////////////
// 0行目と3行目を何度傾けるか
max_angle = 10;
// 1.5行目を0として、0行目、3行目を何mm高くするか
max_height_add = 3;

//////////////////
// 表示
//////////////////
// 0行目を表示
//create_key_cap_pos(x=0, y=0, under_bar=false, now_top_angle=0, now_top_height=9);
// 1行目を表示
//create_key_cap_pos(x=0, y=1, under_bar=false, now_top_angle=-5, now_top_height=9);
// 1行目を表示(ホームポジションの突起有り)
create_key_cap_pos(x=0, y=1, under_bar=true, now_top_angle=-5, now_top_height=8, bar_cylinder_r=1.5);
// 2行目を表示
//create_key_cap_pos(x=0, y=2, under_bar=false, now_top_angle=-10, now_top_height=8);
// 3行目を表示
//create_key_cap_pos(x=0, y=3, under_bar=false, now_top_angle=-15, now_top_height=8);
