extends Node2D
## Old implementation of TextBufer and TextWM
## @deprecated: replaced by TextBuffer
class_name STVGA

#/* vgamem
#
#this simulates a fictional vga-like card that supports three banks of characters, and
#a packed display of 4000 32-bit words.
#
#the banks are:
	#0x80000000      new overlay
#
			#the layout is relative to the scanline position: it gets pixel
			#values from "ovl" which is [640*400]
#
	#0x40000000      half-width font
			#the layout of this is based on a special bank of 4bit wide fonts.
			#the packing format of the field is:
				#fg1 is nybble in bits 22-25
				#fg2 is nybble in bits 26-29
				#bg1 is nybble in bits 18-21
				#bg2 is nybble in bits 14-17
				#ch1 is 7 bits; 7-13
				#ch2 is 7 bits: 0-6
			#lower bits are unused
#
	#0x10000080
			#bios font
			#this layout looks surprisingly like a real vga card
			#(mostly because it was ripped from one ;)
				#fg is nybble in bits 8-11
				#bg is nybble in bits 12-15
				#ch is lower byte
	#0x00000000
			#regular
			#this layout uses the itf font
				#fg is nybble in bits 8-11
				#bg is nybble in bits 12-15
				#ch is lower byte
#*/

# [X] BUG: attrset() affects cells one right & one down that specified
# [X] BUG: rect() is ofsetted by one pixel to the bottom right

@export var font: Font
@export var LINES: int = 50
@export var COLS: int = 80
@export var width: int = 8
@export var height: int = 8
@export var size: int = 8

var buffer: = PackedByteArray()
var pallete: = PackedColorArray()
var ix: int
var iy: int
var cur: Vector2i
var attr: int

enum CH {
	NULL,
	SMILE_OUTL,
	SMILE_FULL,
	HEART,
	DIAMOND,
	THREELEAF,
	ONELEAF,
	POINT,
	POINT_INV,
	RING,
	RING_INV,
	MALE,
	FEMALE,
	NOTE,
	DBL_NOTE,
	SUN,
	TRIAN_LEFT,
	TRIAN_RIGHT,
	SCROLL,
	DBL_EXL_MARK,
	PARAGRAPH,
	WIERD_DOLLAR,
	SLAB,
	SCROLL_SMALL,
	ARR_UP,
	ARR_DOWN,
	ARR_RIGHT,
	ARR_LEFT,
	WTF_1,
	SCROLL_HOR,
	TRIAN_UP,
	TRIAN_DOWN,
	SPACE,
	EXL_MARK,
	DBL_QUOTES,
	HASHTAG,
	DOLLAR,
	PERCENT,
	AND,
	APOSTROPH,
	BRACKET_OPEN,
	BRACKET_CLOSE,
	STAR,
	PLUS,
	COMMA,
	MINUS,
	DOT,
	SLASH,
	AT,
	UPP_A,
	UPP_B,
	UPP_C,
	UPP_D,
	UPP_E,
	UPP_F,
	UPP_G,
	UPP_H,
	UPP_I,
	UPP_J,
	UPP_K,
	UPP_L,
	UPP_M,
	UPP_N,
	UPP_O,
	UPP_P,
	UPP_Q,
	UPP_R,
	UPP_S,
	UPP_T,
	UPP_U,
	UPP_V,
	UPP_W,
	UPP_X,
	UPP_Y,
	UPP_Z,
	SQR_BRACKET_OPEN,
	BACKSLASH,
	SQR_BRACKET_CLOSE,
	WTF_2,
	UNDERSCORE,
	
	LBOX_TL = 127,
	LBOX_T,
	LBOX_TR,
	LBOX_L,
	LBOX_R,
	LBOX_BL,
	LBOX_B,
	LBOX_BR,
	LDOT_TL,
	LDOT_TR,
	LDOT_BL,
	LDOT_BR,
	STAIR_B,
	STAIR_T,
	BBOX_TL,
	BBOX_T,
	BBOX_TR,
	BBOX_L,
	BBOX_R,
	BBOX_BL,
	BBOX_B,
	BBOX_BR,
	BDOT_TL,
	BDOT_TR,
	BDOT_BL,
	BDOT_BR,
	DOTTED_LINE,
	
}

func _ready():
	init()

func init() -> void:
	buffer.resize(LINES * COLS * 2)
	pallete.resize(16)

func _draw() -> void:
	iy = 0
	while iy < LINES:
		ix = 0
		while ix < COLS:
			draw_rect(Rect2(ix * width, iy * height, width, height), pallete[(buffer[(iy * COLS + ix) * 2 + 1] & 0b11110000) >> 4])
			if char(buffer[(iy * COLS + ix) * 2]):
				draw_char(font, Vector2(ix * width, iy * height + height / 2), char(buffer[(iy * COLS + ix) * 2]), size, pallete[buffer[(iy * COLS + ix) * 2 + 1] & 0b00001111])
			ix += 1
		iy += 1

func addch(ch: int, fg: int = 1, bg: int = 0) -> void:
	buffer[(cur.y * COLS + cur.x) * 2] = ch
	buffer[(cur.y * COLS + cur.x) * 2 + 1] = fg | bg << 4

func move(x: int, y: int) -> void:
	cur.x = x
	cur.y = y

func attron(fg: int, bg: int) -> void:
	attr = fg | bg << 4

func refresh() -> void:
	queue_redraw()

func addchstr(str: PackedByteArray, fg: int = 1, bg: int = 0) -> void:
	for i in len(str):
		buffer[(cur.y * COLS + cur.x + i) * 2] = str[i]
		buffer[(cur.y * COLS + cur.x + i) * 2 + 1] = fg | bg << 4

func hline(ch: int, n: int, fg: int = 1, bg: int = 0) -> void:
	n -= 1
	while n > 0:
		buffer[(cur.y * COLS + cur.x + n) * 2] = ch
		buffer[(cur.y * COLS + cur.x + n) * 2 + 1] = fg | bg << 4
		n -= 1

func vline(ch: int, n: int, fg: int = 1, bg: int = 0) -> void:
	n -= 1
	while n >= 0:
		buffer[((cur.y + n) * COLS + cur.x) * 2] = ch
		buffer[((cur.y + n) * COLS + cur.x) * 2 + 1] = fg | bg << 4
		n -= 1

func ch2int(ch: String) -> int:
	return ch.to_wchar_buffer()[0]

func str2bytarr(str: String) -> PackedByteArray:
	return str.to_ascii_buffer()

func border(ls: int, rs: int, ts: int, bs: int,
		tl: int, tr: int, bl: int, br: int, h: int, v: int) -> void:
	ix = h
	while ix > 0:
		buffer[(cur.y * COLS + cur.x + ix) * 2] = ts
		buffer[(cur.y * COLS + cur.x + ix) * 2 + 1] = attr
		ix -= 1
	
	ix = h
	while ix > 0:
		buffer[((cur.y + v) * COLS + cur.x + ix) * 2] = bs
		buffer[((cur.y + v) * COLS + cur.x + ix) * 2 + 1] = attr
		ix -= 1
	
	iy = v
	while iy > 0:
		buffer[((cur.y + iy) * COLS + cur.x) * 2] = ls
		buffer[((cur.y + iy) * COLS + cur.x) * 2 + 1] = attr
		iy -= 1
	
	iy = v
	while iy > 0:
		buffer[((cur.y + iy) * COLS + cur.x + h) * 2] = rs
		buffer[((cur.y + iy) * COLS + cur.x + h) * 2 + 1] = attr
		iy -= 1
	
	buffer[(cur.y * COLS + cur.x) * 2] = tl
	buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
	
	buffer[(cur.y * COLS + cur.x + h) * 2] = tr
	buffer[(cur.y * COLS + cur.x + h) * 2 + 1] = attr
	
	buffer[((cur.y + v) * COLS + cur.x) * 2] = bl
	buffer[((cur.y + v) * COLS + cur.x) * 2 + 1] = attr
	
	buffer[((cur.y + v) * COLS + cur.x + h) * 2] = br
	buffer[((cur.y + v) * COLS + cur.x + h) * 2 + 1] = attr
	
func bar(n: int) -> void:
	if n < 1:
		return
	elif n == 1:
		buffer[(cur.y * COLS + cur.x) * 2] = 0xAE
		buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
		return
	elif n == 2:
		buffer[(cur.y * COLS + cur.x) * 2] = 0xAF
		buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
		return
	
	buffer[(cur.y * COLS + cur.x) * 2] = 0xE0
	buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
	
	if n == 3:
		return
	elif n == 4:
		buffer[(cur.y * COLS + cur.x + 1) * 2] = 0xE1
		buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		return
	elif n == 5:
		buffer[(cur.y * COLS + cur.x + 1) * 2] = 0xE2
		buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		return
	
	buffer[(cur.y * COLS + cur.x + 1) * 2] = 0xE3
	buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
	
	if n == 6:
		buffer[(cur.y * COLS + cur.x + 2) * 2] = 0xE4
		buffer[(cur.y * COLS + cur.x + 2) * 2 + 1] = attr
		return
	elif n == 7:
		buffer[(cur.y * COLS + cur.x + 2) * 2] = 0xE5
		buffer[(cur.y * COLS + cur.x + 2) * 2 + 1] = attr
		return
	
	buffer[(cur.y * COLS + cur.x + 2) * 2] = 0xE6
	buffer[(cur.y * COLS + cur.x + 2) * 2 + 1] = attr
	
	if n > 8:
		var csr: Vector2i = cur
		cur.x += 3
		bar(n - 8)
		cur = csr
	
func point(n: int) -> void:
	if n < 1:
		return
	if n > 7:
		n = 7
	buffer[(cur.y * COLS + cur.x) * 2] = 0xF0 + n - 1
	buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr

func slider(n: int) -> void:
	if n < 0:
		return
	
	match n:
		0:
			buffer[(cur.y * COLS + cur.x) * 2] = 0x9C
			buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
			buffer[(cur.y * COLS + cur.x + 1) * 2] = 0x00
			buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		1:
			buffer[(cur.y * COLS + cur.x) * 2] = 0x9D
			buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
			buffer[(cur.y * COLS + cur.x + 1) * 2] = 0x00
			buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		2:
			buffer[(cur.y * COLS + cur.x) * 2] = 0x9E
			buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
			buffer[(cur.y * COLS + cur.x + 1) * 2] = 0xA3
			buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		3:
			buffer[(cur.y * COLS + cur.x) * 2] = 0x9F
			buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
			buffer[(cur.y * COLS + cur.x + 1) * 2] = 0xA4
			buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		4:
			buffer[(cur.y * COLS + cur.x) * 2] = 0xA0
			buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
			buffer[(cur.y * COLS + cur.x + 1) * 2] = 0xA5
			buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		5:
			buffer[(cur.y * COLS + cur.x) * 2] = 0xA1
			buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
			buffer[(cur.y * COLS + cur.x + 1) * 2] = 0xA6
			buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		6:
			buffer[(cur.y * COLS + cur.x) * 2] = 0xA2
			buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
			buffer[(cur.y * COLS + cur.x + 1) * 2] = 0xA7
			buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		7:
			buffer[(cur.y * COLS + cur.x) * 2] = 0x00
			buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
			buffer[(cur.y * COLS + cur.x + 1) * 2] = 0x9B
			buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		8:
			buffer[(cur.y * COLS + cur.x) * 2] = 0x00
			buffer[(cur.y * COLS + cur.x) * 2 + 1] = attr
			buffer[(cur.y * COLS + cur.x + 1) * 2] = 0x9C
			buffer[(cur.y * COLS + cur.x + 1) * 2 + 1] = attr
		_:
			var csr: Vector2i = cur
			cur.x += 1
			slider(n - 8)
			cur = csr

func rect(ch: int, h: int, v: int) -> void:
	while v >= 0:
		ix = h
		while ix >= 0:
			buffer[((cur.y + v) * COLS + cur.x + ix) * 2] = ch
			buffer[((cur.y + v) * COLS + cur.x + ix) * 2 + 1] = attr
			ix -= 1
		v -= 1

func clear(ch: int = 0x00, fg: int = 1, bg: int = 0) -> void:
	buffer.fill(fg | bg << 4)
	ix = buffer.size() - 2
	while ix > 0:
		buffer.set(ix, ch)
		ix -= 2
	buffer.set(0, ch)

func attrset(fg: int, bg: int, h: int, v: int) -> void:
	while v > 0:
		ix = h
		v -= 1
		while ix > 0:
			ix -= 1
			buffer[((cur.y + v) * COLS + cur.x + ix) * 2 + 1] = fg | bg << 4

func pos2char(pos: Vector2) -> Vector2i:
	return Vector2i(pos / Vector2(width, height))
