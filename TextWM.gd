extends TextBuffer
class_name TextWM

var j: int
@export var width: int = 8
@export var height: int = 8
var font: RID
var cursor: RID
var canvas: RID
var canvas_item: RID
var mouse_position: Vector2
var focus_window: TextWidget
var windows: Array[TextWidget]
var tops: Array[TextWidget]
var bottoms: Array[TextWidget]
var pallete: = PackedColorArray([Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK,
	Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK,
	Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK])

func pos2char(pos: Vector2) -> Vector2i:
	return Vector2i(pos) * Vector2i(width, height)

func get_textwidget(pos: Vector2i) -> TextWidget:
	pos = Vector2i(pos / 8)
	
	for i in tops:
		if pos.x >= i.rect.position.x and pos.y >= i.rect.position.y and \
		pos.x <= i.rect.end.x and pos.y <= i.rect.end.y:
			return i
	
	for i in windows:
		if pos.x >= i.rect.position.x and pos.y >= i.rect.position.y and \
		pos.x <= i.rect.end.x and pos.y <= i.rect.end.y:
			return i
	
	for i in bottoms:
		if pos.x >= i.rect.position.x and pos.y >= i.rect.position.y and \
		pos.x <= i.rect.end.x and pos.y <= i.rect.end.y:
			return i
	return null

func _init(canvas_parent: RID) -> void:
	font = load("res://itf.png")
	cursor = load("res://cursor.png")
	canvas = canvas_parent
	canvas_item = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(canvas_item, canvas)

func _draw() -> void:
	j = 0
	RenderingServer.canvas_item_clear(canvas_item)
	while j < LINES:
		i = 0
		while i < COLS:
			RenderingServer.canvas_item_add_rect(canvas_item, Rect2(i * width, j * height, width, height), pallete[(buffer[(j * COLS + i) * 2 + 1] & 0b11110000) >> 4])
			if buffer[(j * COLS + i) * 2]:
				RenderingServer.canvas_item_add_texture_rect_region(canvas_item, Rect2(i * width, j * height, width, height), font, Rect2(buffer[(j * COLS + i) * 2] % 16 * width,
					int(buffer[(j * COLS + i) * 2] / 16) * height, width, height), pallete[buffer[(j * COLS + i) * 2 + 1] & 0b00001111])
			i += 1
		j += 1
	RenderingServer.canvas_item_add_texture_rect(canvas_item, Rect2(Vector2(Vector2i(mouse_position)), Vector2(8, 14)), cursor)

func _process(delta):
	move(0, 0)
	rect(0x00, COLS - 1, LINES - 1, 0, 0)
	
	j = len(bottoms) - 1
	while j >= 0:
		bottoms[j].draw()
		bottoms[j].content.copy(self, bottoms[j].rect.position.x, bottoms[j].rect.position.y)
		j -= 1
	
	j = len(windows) - 1
	while j >= 0:
		windows[j].draw()
		windows[j].content.copy(self, windows[j].rect.position.x, windows[j].rect.position.y)
		j -= 1
	
	j = len(tops) - 1
	while j >= 0:
		tops[j].draw()
		tops[j].content.copy(self, tops[j].rect.position.x, tops[j].rect.position.y)
		j -= 1

func _input(event: InputEvent):
	if event is InputEventKey and focus_window:
		if (event as InputEventKey).pressed and not (event as InputEventKey).echo:
			focus_window.key_down.emit((event as InputEventKey).keycode)
		else:
			focus_window.key_up.emit((event as InputEventKey).keycode)
		return
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			focus_window = get_textwidget(mouse_position)
			if not focus_window:
				return
			if focus_window in windows:
				windows.push_front(windows.pop_at(windows.find(focus_window)))
			focus_window.mouse_down.emit((event as InputEventMouseButton).button_index)
		elif focus_window:
			focus_window.mouse_up.emit((event as InputEventMouseButton).button_index)
	elif event is InputEventMouseMotion:
		mouse_position = (event as InputEventMouseMotion).position
		if focus_window:
			focus_window.mouse_move.emit(pos2char((event as InputEventMouseMotion).position), (event as InputEventMouseMotion).relative)
		
