extends TextWidget
## UI Widget for drawing text
class_name TextLabel

## Horizontal Alignment
enum {
	HORIZONTAL_ALIGNMENT_LEFT,
	HORIZONTAL_ALIGNMENT_CENTER,
	HORIZONTAL_ALIGNMENT_RIGHT,
	#HORIZONTAL_ALIGNMENT_FILL,
}

## Vertical Alignment
enum  {
	VERTICAL_ALIGNMENT_TOP,
	VERTICAL_ALIGNMENT_CENTER,
	VERTICAL_ALIGNMENT_BOTTOM,
	#VERTICAL_ALIGNMENT_FILL,
}

var text: String
var horizontal_align: int
var vertical_align: int
var visible_characters: int = -1
var fg_color: int = 15
var bg_color: int = 0
