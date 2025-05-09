shader_type canvas_item;

uniform sampler2D texture_albedo;
uniform float rounded_radius : hint_range(0.0,256.0) = 0.0;
uniform float view_width : hint_range(0.0,1024.0) = 200.0;
uniform float view_height : hint_range(0.0,1024.0) = 200.0;
uniform float border_width : hint_range(0.0,50.0) = 1.0;
uniform vec4 border_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    // 取得 UV 座標與內建頂點顏色
    vec2 uv = UV;
    vec4 tex_color = texture(texture_albedo, uv) * COLOR;

    // 使用傳入的 view_width 與 view_height 當作畫布尺寸
    float width = view_width;
    float height = view_height;

    // 將 UV 轉換到像素座標空間
    float x = uv.x * width;
    float y = uv.y * height;
    float r = rounded_radius;
    float arc_size = 0.0;

    vec4 out_color = tex_color;

    // 左下角
    if(x < r && y < r) {
        arc_size = pow(x - r, 2.0) + pow(y - r, 2.0);
        if(arc_size > r * r) {
            out_color.a = 0.0;
        } else if(border_width > 0.0 && arc_size > pow(r - border_width, 2.0)) {
            out_color = border_color;
        }
    }
    // 左上角
    if(x < r && y > (height - r)) {
        arc_size = pow(x - r, 2.0) + pow(y - (height - r), 2.0);
        if(arc_size > r * r) {
            out_color.a = 0.0;
        } else if(border_width > 0.0 && arc_size > pow(r - border_width, 2.0)) {
            out_color = border_color;
        }
    }
    // 右下角
    if(x > (width - r) && y < r) {
        arc_size = pow(x - (width - r), 2.0) + pow(y - r, 2.0);
        if(arc_size > r * r) {
            out_color.a = 0.0;
        } else if(border_width > 0.0 && arc_size > pow(r - border_width, 2.0)) {
            out_color = border_color;
        }
    }
    // 右上角
    if(x > (width - r) && y > (height - r)) {
        arc_size = pow(x - (width - r), 2.0) + pow(y - (height - r), 2.0);
        if(arc_size > r * r) {
            out_color.a = 0.0;
        } else if(border_width > 0.0 && arc_size > pow(r - border_width, 2.0)) {
            out_color = border_color;
        }
    }

    // 處理四邊的邊框區域
    if(border_width > 0.0) {
        // 下邊直線區域
        if(x > r && x < (width - r) && y < border_width) {
            out_color = border_color;
        }
        // 上邊直線區域
        if(x > r && x < (width - r) && (height - y) < border_width) {
            out_color = border_color;
        }
        // 左邊直線區域
        if(y > r && y < (height - r) && x < border_width) {
            out_color = border_color;
        }
        // 右邊直線區域
        if(y > r && y < (height - r) && x > (width - border_width)) {
            out_color = border_color;
        }
    }

    COLOR = out_color;
}
