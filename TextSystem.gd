extends Node2D
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
var hello_panel: = TextWidget.new()
var hello_window: = TextWidget.new()
var debug_window: = TextWidget.new()
var position_container: = TextPositionContainer.new()
var position_label: = TextLabel.new()
# DEBUG #

func _ready():
	# Optimization Trickery #
	var dummy: TextServer = TextServerManager.find_interface("Dummy")
	if dummy:
		TextServerManager.set_primary_interface(dummy)
		for i in TextServerManager.get_interface_count():
			var text_server: TextServer = TextServerManager.get_interface(i)
			if text_server != dummy:
				TextServerManager.remove_interface(text_server)
	
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	Engine.register_singleton(&"TextSystem", self)
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
	
	var win: = TextWindow.new()
	win.rect = Rect2i(1, 1, 30, 15)
	win.child = hello_window
	win.title = "Testing Window Content"
	term.windows.append(win)
	
	win = TextWindow.new()
	win.rect = Rect2i(5, 5, 20, 20)
	win.title = "Debug Window"
	win.child = debug_window
	term.windows.append(win)
	
	win = TextWindow.new()
	win.rect = Rect2i(20, 20, 20, 10)
	win.title = "GUI Go Brrr"
	win.child = position_container
	position_label.text = "Hello, I'm Label"
	position_label.rect = Rect2i(1, 1, 10, 2)
	position_label.fg_color = 2
	position_container.children.append(position_label)
	term.windows.append(win)
	
	var pan: = TextPanel.new()
	pan.rect = Rect2i(19, 45, 40, 4)
	pan.child = hello_panel
	term.tops.append(pan)
	
	pan = TextPanel.new()
	pan.rect = Rect2i(40, 0, 39, 5)
	term.bottoms.append(pan)
	# / DEBUG / #

func _draw():
	# * DEBUG * #
	hello_window.content.clear(0x00, 0b0000, 0b0100)
	hello_window.content.addchstr(hello_window.content.str2brr("Hello Window! I am content buffer and I hope I can see you soon!"), randi_range(0, 15), 0b0100)
	hello_panel.content.addchstr(hello_panel.content.str2brr("Hello Panel! I admire your view for other windows!"), randi_range(0, 15))
	debug_window.content.addchstr(debug_window.content.str2brr(str(int(Engine.get_frames_per_second()))), 15)
	# / DEBUG / #
	term._draw()

func _process(delta: float):
	term._process(delta)
	queue_redraw()

func _input(event: InputEvent):
	term._input(event)
