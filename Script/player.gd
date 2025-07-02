extends CharacterBody2D

const BASE_MAX_SPEED = 240
var MaxSpeed = 240

var Speed = 220

@onready var Sprite = $AnimatedSprite2D
@onready var Cam = $Camera2D

var Dir

func _ready():
	motion_mode = MOTION_MODE_FLOATING
	if Dir:
		Sprite.play("default_walk")



func _process(delta):
	
	Dir = Input.get_vector("move_left","move_right","move_up","move_down")
	
	
	if Dir:
		if Dir.y > 0 and Sprite.animation != "walk_down":
			Sprite.play("walk_down")
		if Dir.y < 0 and Sprite.animation != "walk_up":
			Sprite.play("walk_up")
		if Dir.x > 0 and Sprite.animation != "walk_right":
			Sprite.play("walk_right")
		if Dir.x < 0 and Sprite.animation != "walk_left":
			Sprite.play("walk_left")
		velocity += Dir.normalized() * Speed * delta * 15
	else:
		if Sprite.animation == "walk_down":
			Sprite.play("def_d")
		if Sprite.animation == "walk_up":
			Sprite.play("def_u")
		if Sprite.animation == "walk_right":
			Sprite.play("def_r")
		if Sprite.animation == "walk_left":
			Sprite.play("def_l")
	if Input.is_action_pressed("Sprint"):
		MaxSpeed = 320
	else:
		MaxSpeed = BASE_MAX_SPEED 
	velocity = velocity.move_toward(Vector2.ZERO,Speed * delta * 10)
	velocity = velocity.limit_length(MaxSpeed)
	
	move_and_slide()



func SetCamLimit():
	pass
