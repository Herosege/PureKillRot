extends Label

const AFLTime = 5.9

var t = 0.0

func _process(delta):
	t+=delta
	if t>AFLTime/1.15:
		modulate.a -= delta
		if t>AFLTime:
			queue_free()
