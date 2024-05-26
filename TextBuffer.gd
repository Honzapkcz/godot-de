extends RefCounted
## Buffer of colored text
## +------+--------------+
## | Byte | Description  |
## +------+--------------+
## | 0-7  | Char index   |
## | 8-11 | FG Color idx |
## | 12-15| BG Color idx |
## +------+--------------+
class_name TextBuffer

@export var LINES: int:
	set(value):
		if value < 1:
			push_error("Cannot have zero height buffer")
			return
		LINES = value
		buffer.resize(COLS * LINES * 2)
@export var COLS: int:
	set(value):
		if value < 1:
			push_error("Cannot have zero width buffer")
			return
		COLS = value
		buffer.resize(COLS * LINES * 2)

class BorderChars:
	var ls: int
	var rs: int
	var ts: int
	var bs: int
	var tl: int
	var tr: int
	var bl: int
	var br: int

var buffer: = PackedByteArray()
var _ix: int
var _iy: int
var cur: Vector2i
var fgc: int
var bgc: int

func addch(ch: int, fg: int = -1, bg: int = -1) -> void:
	fg = fg if fg >= 0 and fg < 16 else fgc
	bg = bg if bg >= 0 and bg < 16 else bgc
	buffer[(cur.y * COLS + cur.x) * 2] = ch
	buffer[(cur.y * COLS + cur.x) * 2 + 1] = fg | bg << 4

func move(x: int, y: int) -> void:
	cur.x = clampi(x, 0, COLS - 1)
	cur.y = clampi(y, 0, LINES - 1)

func attron(fg: int, bg: int) -> void:
	fgc = clampi(fg, 0, 15)
	bgc = clampi(bg, 0, 15)

func addchstr(str: PackedByteArray, fg: int = -1, bg: int = -1) -> void:
	fg = fg if fg >= 0 and fg < 16 else fgc
	bg = bg if bg >= 0 and bg < 16 else bgc
	for i in len(str):
		buffer[(cur.y * COLS + cur.x + i) * 2] = str[i]
		buffer[(cur.y * COLS + cur.x + i) * 2 + 1] = fg | bg << 4

func hline(ch: int, n: int, fg: int = -1, bg: int = -1) -> void:
	fg = fg if fg >= 0 and fg < 16 else fgc
	bg = bg if bg >= 0 and bg < 16 else bgc
	n = clampi(n, cur.x, COLS)
	while n > 0:
		buffer[(cur.y * COLS + cur.x + n) * 2] = ch
		buffer[(cur.y * COLS + cur.x + n) * 2 + 1] = fg | bg << 4
		n -= 1

func vline(ch: int, n: int, fg: int = -1, bg: int = -1) -> void:
	fg = fg if fg >= 0 and fg < 16 else fgc
	bg = bg if bg >= 0 and bg < 16 else bgc
	n = clampi(n, cur.x, LINES) - 1
	while n >= 0:
		buffer[((cur.y + n) * COLS + cur.x) * 2] = ch
		buffer[((cur.y + n) * COLS + cur.x) * 2 + 1] = fg | bg << 4
		n -= 1

func border(chs: BorderChars, h: int, v: int, fg: int = -1, bg: int = -1) -> void:
	fg = fg if fg >= 0 and fg < 16 else fgc
	bg = bg if bg >= 0 and bg < 16 else bgc
	_ix = h
	while _ix > 0:
		buffer[(cur.y * COLS + cur.x + _ix) * 2] = chs.ts
		buffer[(cur.y * COLS + cur.x + _ix) * 2 + 1] = fg | bg << 4
		_ix -= 1
	
	_ix = h
	while _ix > 0:
		buffer[((cur.y + v) * COLS + cur.x + _ix) * 2] = chs.bs
		buffer[((cur.y + v) * COLS + cur.x + _ix) * 2 + 1] = fg | bg << 4
		_ix -= 1
	
	_iy = v
	while _iy > 0:
		buffer[((cur.y + _iy) * COLS + cur.x) * 2] = chs.ls
		buffer[((cur.y + _iy) * COLS + cur.x) * 2 + 1] = fg | bg << 4
		_iy -= 1
	
	_iy = v
	while _iy > 0:
		buffer[((cur.y + _iy) * COLS + cur.x + h) * 2] = chs.rs
		buffer[((cur.y + _iy) * COLS + cur.x + h) * 2 + 1] = fg | bg << 4
		_iy -= 1
	
	buffer[(cur.y * COLS + cur.x) * 2] = chs.tl
	buffer[(cur.y * COLS + cur.x) * 2 + 1] = fg | bg << 4
	
	buffer[(cur.y * COLS + cur.x + h) * 2] = chs.tr
	buffer[(cur.y * COLS + cur.x + h) * 2 + 1] = fg | bg << 4
	
	buffer[((cur.y + v) * COLS + cur.x) * 2] = chs.bl
	buffer[((cur.y + v) * COLS + cur.x) * 2 + 1] = fg | bg << 4
	
	buffer[((cur.y + v) * COLS + cur.x + h) * 2] = chs.br
	buffer[((cur.y + v) * COLS + cur.x + h) * 2 + 1] = fg | bg << 4

func rect(ch: int, h: int, v: int, fg: int = -1, bg: int = -1) -> void:
	fg = fg if fg >= 0 and fg < 16 else fgc
	bg = bg if bg >= 0 and bg < 16 else bgc
	while v >= 0:
		_ix = h
		while _ix >= 0:
			buffer.set(((cur.y + v) * COLS + cur.x + _ix) * 2, ch)
			buffer.set(((cur.y + v) * COLS + cur.x + _ix) * 2 + 1, fg | bg << 4)
			_ix -= 1
		v -= 1

func clear(ch: int = 0x00, fg: int = -1, bg: int = -1) -> void:
	fg = fg if fg >= 0 and fg < 16 else fgc
	bg = bg if bg >= 0 and bg < 16 else bgc
	buffer.fill(fg | bg << 4)
	_ix = buffer.size() - 2
	while _ix > 0:
		buffer.set(_ix, ch)
		_ix -= 2
	buffer.set(0, ch)

func attrset(h: int, v: int, fg: int = -1, bg: int = -1) -> void:
	fg = fg if fg >= 0 and fg < 16 else fgc
	bg = bg if bg >= 0 and bg < 16 else bgc
	while v > 0:
		_ix = h
		v -= 1
		while _ix > 0:
			_ix -= 1
			buffer[((cur.y + v) * COLS + cur.x + _ix) * 2 + 1] = fg | bg << 4


func ch2int(ch: String) -> int:
	return ch.to_wchar_buffer()[0]

func str2brr(str: String) -> PackedByteArray:
	return str.to_ascii_buffer()

func mvaddch(x: int, y: int, ch: int, fg: int = -1, bg: int = -1) -> void:
	move(x, y)
	addch(ch, fg, bg)

func mvaddchstr(x: int, y: int, str: PackedByteArray, fg: int = -1, bg: int = -1) -> void:
	move(x, y)
	addchstr(str, fg, bg)

func mvhline(x: int, y: int, ch: int, n: int, fg: int = -1, bg: int = -1) -> void:
	move(x, y)
	hline(ch, n, fg, bg)

func mvvline(x: int, y: int, ch: int, n: int, fg: int = -1, bg: int = -1) -> void:
	move(x, y)
	vline(ch, n, fg, bg)

func mvrect(x: int, y: int, ch: int, h: int, v: int, fg: int = -1, bg: int = -1) -> void:
	move(x, y)
	rect(ch, h, v, fg, bg)

func mvborder(x: int, y: int, chs: BorderChars, h: int, v: int, fg: int = -1, bg: int = -1)-> void:
	move(x, y)
	border(chs, h, v, fg, bg)