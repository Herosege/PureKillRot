extends Node2D

var VSize = Vector2(640,480) 

@export var NoiseTexture : NoiseTexture2D

const amt = 200

var TreeScene = load("res://Scenes/Environment/tree.tscn")

@onready var PNode = get_tree().get_first_node_in_group("player")

func _process(delta):
	pass

func _ready():
	SignalBus.ChangeScene.connect(ChangeScene)
	if PNode:
		var Cam = PNode.get_node("Camera2D")
		var flor = $Floor/floor1
		Cam.limit_left = -8500.0/2.0+flor.position.x
		Cam.limit_right = 8500.0/2.0+flor.position.x
		Cam.limit_top = -4500.0/2.0+flor.position.y
		Cam.limit_bottom = 4500.0/2.0+flor.position.y
	#await NoiseTexture.changed
	#for x in range(-sqrt(amt)/2,sqrt(amt)/2):
		#for y in range(-sqrt(amt)/2,sqrt(amt)/2):
			#var Noiseimg = NoiseTexture.get_image()
			#var NoiseVal = Noiseimg.get_pixel(x+sqrt(amt)/2,y+sqrt(amt)/2).r
			#
			#if NoiseVal >= 0.5:
				#var TDup = TreeScene.instantiate()
				#TDup.visible = true
				#var RandCoords = Vector2(Noiseimg.get_pixel(abs(x)+sqrt(amt)/4,abs(y)+sqrt(amt)/4).r-0.4,Noiseimg.get_pixel(abs(x)+sqrt(amt)/7,abs(y)+sqrt(amt)/7).r-0.4)*4
				#TDup.global_position = (Vector2(x,y) + (RandCoords*4.0))*Vector2(540,220)+Vector2(0,600)
				#
				#$YSort/Trees.add_child(TDup)
				#TDup.set_owner(self)


func ChangeScene(To):
	get_tree().call_deferred("change_scene_to_file",To)
	queue_free()
