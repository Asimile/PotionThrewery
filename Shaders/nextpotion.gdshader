shader_type canvas_item;

uniform vec4 OLD_COLOR : source_color;

uniform vec4 NEW_COLOR : source_color;

void fragment() {
	vec4 curr_color = texture(TEXTURE,UV);
	
	if (curr_color == OLD_COLOR) {
		COLOR = NEW_COLOR;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
