shader_type canvas_item;


uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float line_width : hint_range(0.0, 10.0, 0.1) = 1.0;

const vec2 OFFSET[8] = {
	vec2(1.0, 0.0),
	vec2(1.0, 1.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(-1.0, -1.0),
	vec2(0.0, -1.0),
	vec2(1.0, -1.0)
};
}


void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_width;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
