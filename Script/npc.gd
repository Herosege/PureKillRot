extends CharacterBody2D

enum EvType {Dialogue,InitBattle,GiveItem,ChangeScene}

@export var CollShape : Shape2D
@export var AreaShape : Shape2D

@export_enum("Dialogue","InitBattle","GiveItem","ChangeScene") var AfterDial = 0
@export_group("Dialogue")
@export var Dialogues : Array[String]
@export var Agressive : bool = false

@export_group("ChangeScene")
@export var SceneTo : PackedScene

@onready var DialArea = $DialogueArea

var AreaActive = false
var InDial = false

func _ready():
	if AreaShape:
		$DialogueArea/CollisionShape2D.set_deferred("shape",AreaShape)
	if CollShape:
		$CollisionShape2D.shape = CollShape

func _process(delta):
	if (Input.is_action_just_pressed("accept") or Agressive) and AreaActive and !Globals.InDialogue and !get_tree().paused:
		if InDial:
			InDial = false
		else:
			if Dialogues:
				SignalBus.emit_signal("ShowDialogue",Dialogues,true,true)
			else:
				pass
			InDial = true

func _on_dialogue_area_body_entered(body):
	if body.is_in_group("player"):
		AreaActive = true

func _on_dialogue_area_body_exited(body):
	if body.is_in_group("player"):
		AreaActive = false
