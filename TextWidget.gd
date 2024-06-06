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

var rect: Rect2i
var parent: TextBuffer
var content: TextBuffer:
	set(value):
		value.COLS = rect.size.x - 1
		value.LINES = rect.size.y - 1
		content = value

func draw() -> void:
	pass
