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

var redraw: bool
var text: String:
	set(value):
		text = value
		redraw = true
var horizontal_align: int:
	set(value):
		if value < 0 or value > 2:
			push_error("horizontal_align out of range (" + str(value) + ")")
			return
		horizontal_align = value
		redraw = true
var vertical_align: int:
	set(value):
		if value < 0 or value > 2:
			push_error("vertical_align out of range (" + str(value) + ")")
			return
		vertical_align = value
		redraw = true
var visible_characters: int = -1:
	set(value):
		visible_characters = value
		redraw = true
var fg_color: int = 15:
	set(value):
		fg_color = value
		redraw = true
var bg_color: int = 0:
	set(value):
		bg_color = value
		redraw = true

func _init():
	content = TextBuffer.new()

func _notification(what: int):
	if what == NOTIFICATION_BUFFER_UPDATE and redraw:
		draw()

func draw() -> void:
	content.buffer.size()
	
	redraw = false
