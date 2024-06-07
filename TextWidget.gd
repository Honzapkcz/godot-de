extends RefCounted
## Base class for use by TextWM
class_name TextWidget

signal mouse_move(position: Vector2, delta: Vector2)
signal mouse_down(button: int)
signal mouse_up(button: int)
signal key_down(key: int)
signal key_up(key: int)
signal exit(code: int)

const NOTIFICATION_DYNAMIC_PROCCESS: int = 3000
const NOTIFICATION_STATIC_PROCCESS: int = 3001
const NOTIFICATION_BUFFER_UPDATE: int = 3002

var rect: Rect2i = Rect2i(0, 0, 1, 1): set = set_rect, get = get_rect
var content: TextBuffer = TextBuffer.new(): set = set_content, get = get_content

func draw() -> void:
	pass

func set_rect(value: Rect2i) -> void:
	if rect.size.x < 1:
		push_error("rect.size.x cannot be less than 1")
		rect.size.x = 1
	if rect.size.y < 1:
		push_error("rect.size.y cannot be less than 1")
		rect.size.x = 1
	if rect.position.x < 0:
		push_error("rect.position.x cannot be less than 0")
		rect.position.x = 0
	if rect.position.y < 0:
		push_error("rect.position.y cannot be less than 0")
		rect.position.y = 0
	if content:
		content.COLS = value.size.x + 1
		content.LINES = value.size.y + 1
	rect = value

func get_rect() -> Rect2i:
	return rect

func set_content(value: TextBuffer) -> void:
	value.COLS = rect.size.x + 1
	value.LINES = rect.size.y + 1
	content = value

func get_content() -> TextBuffer:
	return content
