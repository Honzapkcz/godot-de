extends TextWidget
## Container for absolute positioning of Widgets
class_name TextPositionContainer

var children: Array[TextWidget]
var i: int
var child_redraw: bool

func draw() -> void:
	i = children.size() - 1
	redraw = false
	while i >= 0:
		redraw = children[i].redraw or redraw
		children[i].draw()
		i -= 1
	if not redraw:
		return
	i = children.size() - 1
	while i >= 0:
		children[i].content.copy(content, children[i].rect.position.x, children[i].rect.position.y)
		i -= 1
