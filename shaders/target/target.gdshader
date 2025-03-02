shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	vec4 tex_color = texture(TEXTURE, UV);
	float a = 0.0;
	if (tex_color.a > 0.0) {
		a = 1.0;
	}
	// COLOR = vec4(1.0 - screen_color.rgb, a);
	COLOR = vec4(1, 1, 1, tex_color.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
