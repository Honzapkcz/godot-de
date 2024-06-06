extends CanvasItem
class_name TextSystem

## ACS_trbl (top, right, bottom, left)
## B: blank
## S: single
## D: Double
## T: Thick
enum {
	ACS_SBSB = 0xB3,
	ACS_SBSS,
	ACS_SBSD,
	ACS_DBDS,
	ACS_BBDS,
	ACS_BBSD,
	ACS_DBDD,
	ACS_DBDB,
	ACS_BBDD,
	ACS_DBBD,
	ACS_DBBS,
	ACS_SBBD,
	ACS_BBSS,
	ACS_SSBB = 0xC0,
	ACS_SSBS,
	ACS_BSSS,
	ACS_SSSB,
	ACS_BSBS,
	ACS_SSSS,
	ACS_SDSB,
	ACS_DSDB,
	ACS_DDBB,
	ACS_BDDB,
	ACS_DDSD,
	ACS_BDDD,
	ACS_DDDB,
	ACS_BDBD,
	ACS_DDDD,
	ACS_SDBS,
	ACS_DSBS = 0xD0,
	ACS_BDSD,
	ACS_BSDS,
	ACS_DSBB,
	ACS_SDBB,
	ACS_BDSB,
	ACS_BSDB,
	ACS_DSDS,
	ACS_SDSD,
	ACS_SBBS,
	ACS_BSSB,
}

var term: TextWM
# DEBUG #
var panel_buffer: = TextBuffer.new()
var window_buffer: = TextBuffer.new()
# DEBUG #

func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	term = TextWM.new(get_canvas_item())
	term.LINES = 50
	term.COLS = 80
	term.pallete.clear()
	term.pallete.append_array(PackedColorArray([
		Color8(0x00, 0x00, 0x00), # Black
		Color8(0x00, 0x00, 0xFF), # Blue
		Color8(0x00, 0xFF, 0x00), # Green
		Color8(0x00, 0xFF, 0xFF), # Cyan
		Color8(0xFF, 0x00, 0x00), # Red
		Color8(0xFF, 0x00, 0xFF), # Magenta
		Color8(0xA8, 0xA8, 0x56), # Yellow
		Color8(0xC0, 0xC7, 0xC8), # Gray
		Color8(0x87, 0x88, 0x8F), # Dark Gray
		Color8(0x00, 0x00, 0xA8), # Light Blue
		Color8(0x00, 0x8A, 0x56), # Light Green
		Color8(0x56, 0xA8, 0xA8), # Light Cyan
		Color8(0xA8, 0x00, 0x56), # Light Red
		Color8(0xA8, 0x57, 0xA8), # Light Magenta
		Color8(0xA8, 0xA8, 0x56), # Yellow
		Color8(0xFF, 0xFF, 0xFF), # White
	]))
	# * DEBUG * #
	for i in range(5):
		var win: = TextWindow.new()
		win.rect = Rect2i(randi_range(0, 50), randi_range(0, 25), 20, 20)
		win.title = ["Hello", "World", "by Honzapkcz", "Windows Manager Test"][randi_range(0, 3)]
		win.bg_color = randi_range(0, 15)
		win.fg_color = randi_range(0, 15)
		win.parent = term
		term.windows.append(win)
	var win: = TextWindow.new()
	win.rect = Rect2i(1, 1, 30, 15)
	win.title = "Testing Window Content"
	win.parent = term
	win.content = window_buffer
	term.windows.append(win)
	var pan: = TextPanel.new()
	pan.rect = Rect2i(19, 45, 40, 4)
	pan.parent = term
	pan.content = panel_buffer
	term.windows.append(pan)
	# / DEBUG / #

func _draw():
	# * DEBUG * #
	window_buffer.addchstr(window_buffer.str2brr("Hello Window! I am content buffer and I hope I can see you soon!"), randi_range(0, 15))
	panel_buffer.addchstr(panel_buffer.str2brr("Hello Panel! I admire your view for other windows!"), randi_range(0, 15))
	# / DEBUG / #
	term._draw()

func _process(delta: float):
	term._process(delta)
	queue_redraw()

func _input(event: InputEvent):
	term._input(event)
