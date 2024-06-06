extends TextWidget
class_name TextPanel

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

func draw():
	parent.attron(fg_color, bg_color)
	parent.move(rect.position.x, rect.position.y)
	parent.rect(0x00, rect.size.x, rect.size.y)
	parent.border(border, rect.size.x, rect.size.y)
	
	if content:
		content.copy(parent, rect.position.x + 1, rect.position.y + 1)
