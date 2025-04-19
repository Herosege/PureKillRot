extends Control

var MenuActive = false

func _ready():
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("back") and !Globals.InDialogue:
		MenuActive = !MenuActive
		visible = MenuActive
		get_tree().paused = MenuActive
