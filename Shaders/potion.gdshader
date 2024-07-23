shader_type canvas_item;

//void vertex() {
	//// Called for every vertex the material is visible on.
//}

uniform vec4 WHITE : source_color;

uniform vec4 NEW_COLOR : source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 curr_color = texture(TEXTURE,UV);
	
	if (curr_color == WHITE) {
		COLOR = NEW_COLOR;
	}
		
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
