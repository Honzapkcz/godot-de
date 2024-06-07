extends TextWidget
class_name TextPanel

var child: TextBuffer:
	set(value):
		value.COLS = rect.size.x - 2
		value.LINES = rect.size.y - 2
		child = value
var border: = TextBuffer.BorderChars.new()
var fg_color: int = 15
var bg_color: int = 0

func _init():
	border.ls = TextSystem.ACS_SBSB
	border.rs = TextSystem.ACS_DBDB
	border.ts = TextSystem.ACS_BSBS
	border.bs = TextSystem.ACS_BDBD
	border.tl = TextSystem.ACS_BSSB
	border.tr = TextSystem.ACS_BBDS
	border.bl = TextSystem.ACS_SDBB
	border.br = TextSystem.ACS_DBBD
	
	content = TextBuffer.new()

func draw():
	content.attron(fg_color, bg_color)
	content.move(0, 0)
	content.rect(0x00, rect.size.x, rect.size.y)
	content.border(border, rect.size.x, rect.size.y)
	
	if child:
		child.copy(content, 1, 1)
