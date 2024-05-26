extends TextWidget
class_name TextWindow

enum {
	MOTION_EVENT_NONE,
	MOTION_EVENT_MOVE,
	MOTION_EVENT_SIZE,
}
var title: String
var button_offset: int = 2
var title_offset: int = 2
var fg_color: int = 15
var bg_color: int = 0
var border: = TextBuffer.BorderChars.new()
var motion_state: int
var motion_origin: Vector2
var motion_delta: Vector2

func _init():
	border.ls = TextSystem.ACS_SBSB
	border.rs = TextSystem.ACS_DBDB
	border.ts = TextSystem.ACS_BSBS
	border.bs = TextSystem.ACS_BDBD
	border.tl = TextSystem.ACS_BSSB
	border.tr = TextSystem.ACS_BBDS
	border.bl = TextSystem.ACS_SDBB
	border.br = TextSystem.ACS_DBBD
	mouse_up.connect(on_mouse_up)
	mouse_down.connect(on_mouse_down)
	mouse_move.connect(on_mouse_move)


func draw():
	terminal.attron(fg_color, bg_color)
	terminal.move(rect.position.x, rect.position.y)
	terminal.rect(0x00, rect.size.x, rect.size.y)
	terminal.border(border, rect.size.x, rect.size.y)
	terminal.move(rect.position.x + title_offset, rect.position.y)
	terminal.addchstr(terminal.str2brr("[ " + title + " ]"))
	#terminal.move(rect.position.x + rect.size.x - button_offset, rect.position.y)
	#terminal.addch(0x94, fg_color, bg_color)
	#terminal.move(rect.position.x + rect.size.x - button_offset + 1, rect.position.y)
	#terminal.addch(terminal.ch2int('O'), fg_color, bg_color)
	#terminal.move(rect.position.x + rect.size.x - button_offset + 2, rect.position.y)
	#terminal.addch(terminal.ch2int('X'), bg_color, fg_color)

func move(pos: Vector2i):
	if pos.x < 0:
		pos.x = 0
	if pos.y < 0:
		pos.y = 0
	if rect.size.x + pos.x >= terminal.COLS:
		pos.x = terminal.COLS - rect.size.x - 1
	if rect.size.y + pos.y >= terminal.LINES:
		pos.y = terminal.LINES - rect.size.y - 1
	rect.position = pos
	

func resize(size: Vector2i):
	if size.x <= 1:
		size.x = 2
	if size.y <= 1:
		size.y = 2
	if terminal.COLS - rect.position.x <= size.x:
		size.x = terminal.COLS - rect.position.x - 1
	if terminal.LINES - rect.position.y <= size.y:
		size.y = terminal.LINES - rect.position.y - 1
	rect.size = size
	if content:
		content.COLS = size.x - 1
		content.LINES = size.y - 1

func on_mouse_up(button: int):
	motion_state = MOTION_EVENT_NONE

func on_mouse_down(button: int):
	if button == MOUSE_BUTTON_LEFT:
		motion_state = MOTION_EVENT_MOVE
		motion_origin = rect.position * 8
	elif button == MOUSE_BUTTON_RIGHT:
		motion_state = MOTION_EVENT_SIZE
		motion_origin = rect.size * 8
	motion_delta = Vector2.ZERO

func on_mouse_move(position: Vector2, delta: Vector2):
	motion_delta += delta
	if motion_state == MOTION_EVENT_MOVE:
		move(Vector2i(motion_origin + motion_delta) / 8)
	elif motion_state == MOTION_EVENT_SIZE:
		resize(Vector2i(motion_origin + motion_delta) / 8)

#func _input(event: InputEvent):
	#if event is InputEventMouseButton:
		#if not event.alt_pressed:
			#return
		#get_tree().root.set_input_as_handled()
		#if not event.pressed:
			#motion_state = MOTION_EVENT_NONE
			#return
		#focus_window = get_textwindow(get_global_mouse_position())
		#if not focus_window:
			#return
		#motion_delta = Vector2.ZERO
		#if event.button_index == MOUSE_BUTTON_MIDDLE:
			#motion_state = MOTION_EVENT_SWITCH
			#windows.push_front(windows.pop_back())
			#return
		#windows.push_front(windows.pop_at(windows.find(focus_window)))
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#motion_state = MOTION_EVENT_MOVE
			#motion_origin = focus_window.rect.position * Vector2i(width, height)
		#elif event.button_index == MOUSE_BUTTON_RIGHT:
			#motion_state = MOTION_EVENT_SIZE
			#motion_origin = focus_window.rect.size * Vector2i(width, height)
	#elif event is InputEventMouseMotion:
		#motion_delta += event.relative
		#if not focus_window:
			#return
		#if motion_state == MOTION_EVENT_MOVE:
			#focus_window.move(pos2char(motion_origin + motion_delta))
		#elif motion_state == MOTION_EVENT_SIZE:
			#focus_window.resize(pos2char(motion_origin + motion_delta))
