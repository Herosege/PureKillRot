extends Label

var Lifetime = 1

var t = 0.0

@export var Curva : Curve
@onready var Grad = get_node("TextureRect")

func _ready():
	pass


func _process(delta):
	t+=delta
	
	if t>Lifetime/1.7:
		if Curva.sample(t) > 0:
			global_position.y += pow(Curva.sample(t)*4,3.3)/220
	if t>Lifetime*0.5:
		modulate.a -= delta*1.2
		if t>Lifetime:
			queue_free()
