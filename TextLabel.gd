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

func draw() -> void:
	if not redraw:
		return
	# Someone horribly cooked here
	content.move(0 if horizontal_align == HORIZONTAL_ALIGNMENT_LEFT else int(rect.position.x / 2 - len(text) / 2) if horizontal_align == HORIZONTAL_ALIGNMENT_CENTER else rect.position.x - len(text), 0 if vertical_align == VERTICAL_ALIGNMENT_TOP else int(rect.position.y / 2 - (rect.position.x / len(text) / 2)) if vertical_align == VERTICAL_ALIGNMENT_CENTER else rect.position.y - int(rect.position.x / len(text)))
	content.attron(fg_color, bg_color)
	content.addchstr(content.str2brr(text.substr(0, visible_characters)))
	
	redraw = false
