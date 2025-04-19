extends CharacterBody2D

var MaxSpeed = 200

var Speed = 220

@onready var Sprite = $AnimatedSprite2D

func _ready():
	motion_mode = MOTION_MODE_FLOATING

func _process(delta):
	
	var Dir = Input.get_vector("move_left","move_right","move_up","move_down")
	
	
	if Dir:
		if Sprite.animation != "default_walk":
			Sprite.play("default_walk")
		
		velocity += Dir.normalized() * Speed * delta * 13
	else:
		if Sprite.animation != "default":
			Sprite.animation = "default"
	velocity = velocity.move_toward(Vector2.ZERO,Speed * delta * 7)
	velocity = velocity.limit_length(MaxSpeed)
	
	move_and_slide()
