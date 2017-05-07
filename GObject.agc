TYPE GObject
	SmallX AS INTEGER
	SmallY AS INTEGER
	BigX AS INTEGER
	BigY AS INTEGER
	SpriteIndex AS INTEGER
ENDTYPE

FUNCTION GObject_Init(obj AS GObject, x, y, si)
	obj.BigX = x
	obj.BigY = y
	obj.SpriteIndex = si
ENDFUNCTION obj
