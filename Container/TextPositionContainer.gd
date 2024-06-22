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
		# I'm starting to get scared of cooking
		children[i].content.copyrect(content, 0, 0, children[i].rect.position.x, children[i].rect.position.y, mini(rect.size.x - children[i].rect.position.x + 1, children[i].rect.size.x), mini(rect.size.y - children[i].rect.position.y + 1, children[i].rect.size.y))
		i -= 1
