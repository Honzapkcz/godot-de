extends TextWidget
## Container for absolute positioning of Widgets
class_name TextPositionContainer

var children: Array[TextWidget]
var i: int

func draw() -> void:
	i = children.size() - 1
	while i >= 0:
		redraw = children[i].redraw or redraw
		children[i].draw()
		i -= 1
	if not redraw:
		return
	content.clear(0x00)
	i = children.size() - 1
	while i >= 0:
		children[i].content.copy(content, children[i].rect.position.x, children[i].rect.position.y)
		i -= 1
