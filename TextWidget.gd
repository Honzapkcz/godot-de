extends RefCounted
## Base class for use by TextWM
class_name TextWidget

signal mouse_move(position: Vector2, delta: Vector2)
signal mouse_down(button: int)
signal mouse_up(button: int)
signal key_down(key: int)
signal key_up(key: int)
signal exit(code: int)

var rect: Rect2i
var terminal: TextBuffer
var content: TextBuffer

func draw() -> void:
	pass



