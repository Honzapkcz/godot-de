extends TextBuffer
class_name TextWM

var j: int
@export var width: int = 8
@export var height: int = 8
var font: RID
var canvas: RID
var canvas_item: RID
var focus_window: TextWidget
var windows: Array[TextWidget]
var pallete: = PackedColorArray([Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK,
	Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK,
	Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK])

func pos2char(pos: Vector2) -> Vector2i:
	return Vector2i(pos) * Vector2i(width, height)

func get_textwidget(pos: Vector2i) -> TextWidget:
	pos = Vector2i(pos / 8)
	for i in windows:
		if pos.x >= i.rect.position.x and pos.y >= i.rect.position.y and \
		pos.x <= i.rect.end.x and pos.y <= i.rect.end.y:
			return i
	#return windows[0] # HACK
	return null

func _init() -> void:
	font = load("res://itf.png")
	canvas_item = RenderingServer.canvas_item_create()
	call_deferred("post_init")

func post_init() -> void:
	RenderingServer.canvas_item_set_parent(canvas_item, canvas)
	RenderingServer.canvas_item_set_draw_behind_parent(canvas_item, true)

# TODO: need to fix this somehow
func _draw() -> void:
	j = 0
	RenderingServer.canvas_item_clear(canvas_item)
	while j < LINES:
		i = 0
		while i < COLS:
			#draw_rect(Rect2(ix * width, iy * height, width, height), pallete[(buffer[(iy * COLS + ix) * 2 + 1] & 0b11110000) >> 4])
			RenderingServer.canvas_item_add_rect(canvas_item, Rect2(i * width, j * height, width, height), pallete[(buffer[(j * COLS + i) * 2 + 1] & 0b11110000) >> 4])
			if buffer[(j * COLS + i) * 2]:
				#draw_char(font, Vector2(ix * width, iy * height + height / 2), char(buffer[(iy * COLS + ix) * 2]), size, pallete[buffer[(iy * COLS + ix) * 2 + 1] & 0b00001111])
				#RenderingServer.canvas_item_add_circle(canvas_item, Vector2(_ix * width + 4, j * height + 4), buffer[(j * COLS + _ix) * 2] / 32, pallete[buffer[(j * COLS + _ix) * 2 + 1] & 0b00001111])
				RenderingServer.canvas_item_add_texture_rect_region(canvas_item, Rect2(i * width, j * height, width, height), font, Rect2(buffer[(j * COLS + i) * 2] % 16 * width,
					int(buffer[(j * COLS + i) * 2] / 16) * height, width, height), pallete[buffer[(j * COLS + i) * 2 + 1] & 0b00001111])
			i += 1
		j += 1

func _process(delta):
	move(0, 0)
	rect(0x00, COLS - 1, LINES - 1, 0, 0)
	windows.reverse()
	for i in windows:
		i.draw()
	windows.reverse()
	#refresh()

func _input(event: InputEvent):
	if event is InputEventKey and focus_window:
		if (event as InputEventKey).pressed and not (event as InputEventKey).echo:
			focus_window.key_down.emit((event as InputEventKey).keycode)
		else:
			focus_window.key_up.emit((event as InputEventKey).keycode)
		return
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			focus_window = get_textwidget((DisplayServer.mouse_get_position() - DisplayServer.window_get_position()) / 2)
			if not focus_window:
				return
			windows.push_front(windows.pop_at(windows.find(focus_window)))
			focus_window.mouse_down.emit((event as InputEventMouseButton).button_index)
		elif focus_window:
			focus_window.mouse_up.emit((event as InputEventMouseButton).button_index)
	elif event is InputEventMouseMotion and focus_window:
		focus_window.mouse_move.emit(pos2char((event as InputEventMouseMotion).position), (event as InputEventMouseMotion).relative)
		
