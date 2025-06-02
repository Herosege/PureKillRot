extends Node2D

var VSize = Vector2(640,480) 

func _ready():
	SignalBus.ChangeScene.connect(ChangeScene)

func _on_scene_change_area_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file","res://Scenes/main.tscn")

func ChangeScene(To):
	get_tree().call_deferred("change_scene_to_file",To)
	queue_free()
