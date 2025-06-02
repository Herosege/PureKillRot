extends Area2D

@export var Dialogues : Array[String]

@export var CollShape : Shape2D


enum ADial {Nothing,InitBattle,GiveItem,ChangeScene}
@export_enum("Nothing","InitBattle","GiveItem","ChangeScene") var AfterDial = 0 

var AreaActive = false
var InDial = false
var Agressive = false 

@export var SceneTo : String

func _ready():
	SignalBus.DialFinish.connect(OnDialFinish)
	await get_parent().ready
	$CollisionShape2D.shape = CollShape

#InDial makes sure the input detection doesn't trigger textbox event immediately after it disappears
func _process(delta):
	if (Input.is_action_just_pressed("accept") or Agressive) and AreaActive and !Globals.InDialogue and !get_tree().paused:
		if InDial:
			InDial = false
		else:
			if Dialogues:
				SignalBus.emit_signal("ShowDialogue",Dialogues,true,true)
			else:
				OnDialFinish()
			InDial = true

func _on_body_entered(body):
	if body.is_in_group("player"):
		AreaActive = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		AreaActive = false

func OnDialFinish():
	match AfterDial:
		ADial.Nothing:
			pass
		ADial.InitBattle:
			get_tree().change_scene_to_file("res://Scenes/fight_scene.tscn")
		ADial.GiveItem:
			pass
		ADial.ChangeScene:
			get_tree().call_deferred("change_scene_to_file",SceneTo)
