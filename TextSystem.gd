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

func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	get_viewport().transparent_bg = true
	term = TextWM.new()
	term.canvas = get_canvas_item()
	term.LINES = 50
	term.COLS = 80
	move_child($Cursor, -1)
	term.pallete.clear()
	term.pallete.append_array(PackedColorArray([
		Color.BLACK,
		Color.BLUE,
		Color.GREEN,
		Color.CYAN,
		Color.RED,
		Color.MAGENTA,
		Color.BROWN,
		Color.GRAY,
		Color.DARK_GRAY,
		Color.LIGHT_BLUE,
		Color.LIGHT_GREEN,
		Color.LIGHT_CYAN,
		Color.LIGHT_CORAL,
		Color.HOT_PINK,
		Color.YELLOW,
		Color.WHITE,
	]))
	# DEBUG #
	for i in range(5):
		var win: = TextWindow.new()
		win.rect = Rect2i(randi_range(0, 50), randi_range(0, 25), 20, 20)
		win.title = ["Hello", "World", "by Honzapkcz", "Windows Manager Test"][randi_range(0, 3)]
		win.bg_color = randi_range(0, 15)
		win.fg_color = randi_range(0, 15)
		win.terminal = term
		term.windows.append(win)
	# DEBUG #

func _draw():
	term._draw()

func _process(delta):
	$Cursor.position = (DisplayServer.mouse_get_position() - DisplayServer.window_get_position()) / 2
	term._process(delta)
	queue_redraw()

func _input(event: InputEvent):
	term._input(event)
