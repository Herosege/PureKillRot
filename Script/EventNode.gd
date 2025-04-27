extends Node2D

enum EvType {Dialogue,InitBattle,GiveItem,ChangeScene}

@export var CollShape : Shape2D
@export var AreaShape : Shape2D

@export var Agressive : bool = false

@export_enum("Dialogue","InitBattle","GiveItem","ChangeScene") var EventType = 0

@export_group("Dialogue")
@export var Dialogues : Array[String]

@export_group("ChangeScene")
@export var SceneTo : String

@onready var EventArea = $EvArea

var AreaActive = false
var InDial = false

var AgressionCanActivar = true

func _ready():
	if AreaShape:
		$EvArea/CollisionShape2D.set_deferred("shape",AreaShape)
	if CollShape:
		$StaticBody2D/CollisionShape2D.shape = CollShape

func _process(delta):
	if (Input.is_action_just_pressed("accept") or (Agressive and AgressionCanActivar)) and AreaActive and !Globals.InDialogue and !get_tree().paused:
		if InDial:
			InDial = false
		else:
			match EventType:
				EvType.Dialogue:
					SignalBus.emit_signal("EventPass",[EventType,Dialogues,true,true])
				EvType.InitBattle:
					pass
				EvType.GiveItem:
					pass
				EvType.ChangeScene:
					SignalBus.emit_signal("EventPass",[EventType,SceneTo])
			AgressionCanActivar = false
			InDial = true

func _on_ev_area_body_entered(body):
	if body.is_in_group("player"):
		AreaActive = true

func _on_ev_area_body_exited(body):
	if body.is_in_group("player"):
		AreaActive = false
		AgressionCanActivar = true
