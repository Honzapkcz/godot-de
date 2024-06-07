extends TextWidget
## Container for absolute positioning of Widgets
class_name TextPositionContainer

var children: Array[TextWidget]
var i: int

func draw() -> void:
	i = children.size() - 1
	while i >= 0:
		children[i].draw()
		children[i].content.copy(content, children[i].rect.position.x, children[i].rect.position.y)
