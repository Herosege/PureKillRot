extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

var ActiveEn = false
var Attacken = false
var Speed = 350.0

var ScanLines = 200
var x_cast = 0

func _ready():
	for i in ScanLines+1:
		var Raycast = RayCast2D.new()
		Raycast.position.y -= 40
		Raycast.target_position = Vector2.RIGHT * 350
		Raycast.rotation = (x_cast*TAU)/ScanLines
		Raycast.enabled = true
		$Raycasts.add_child(Raycast)
		x_cast += 1

func _process(delta):
	Aggro(delta)
	var Amnt_not_coll = 0
	for i in $Raycasts.get_children():
		if i.is_colliding():
			if i.get_collider().is_in_group("player"):
				ActiveEn = true
			else:
				ActiveEn = false
				Attacken = false
		else:
			Amnt_not_coll += 1
		if Amnt_not_coll >= $Raycasts.get_children().size():
			ActiveEn = false
			Attacken = false

func Aggro(delta):
	if ActiveEn:
		if !PNode:
			return
		if PNode.position.distance_to(global_position) < 350 and !Attacken:
			Attacken = true
		if Attacken:
			global_position = global_position.move_toward(Vector2(PNode.global_position.x,PNode.global_position.y+40.0),Speed*delta)
			if (PNode.global_position.x-global_position.x)<0:
				$AnimatedSprite2D.scale.x = -1
			else:
				$AnimatedSprite2D.scale.x = 1
