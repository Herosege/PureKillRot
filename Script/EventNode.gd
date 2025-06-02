extends Node2D

enum EvType {Dialogue,InitBattle,GiveItem,ChangeScene}

@export_multiline var EventLine : String

@export var CollShape : Shape2D
@export var AreaShape : Shape2D

@export var Agressive : bool = false

@export_enum("Dialogue","InitBattle","GiveItem","ChangeScene") var EventType = 0

@export_group("Dialogue")
@export var Dialogues : Array[PackedStringArray]

@export_group("ChangeScene")
@export var SceneTo : String

@export_group("InitBattle")
@export_multiline var BattleText : String
@export var EnemiesID : Array[int]
@export var KysAfterBattle : bool = false

@onready var EventArea = $EvArea

var AreaActive = false
var InDial = false

var BattleBurned = false

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
					if Dialogues.size()>0:
						SignalBus.emit_signal("EventPass",[EventType,Dialogues[0],true,true])
				EvType.InitBattle:
					if !BattleBurned:
						SignalBus.emit_signal("EventPass",[EventType,BattleText])
						BattleBurned = true
						if KysAfterBattle:
							get_parent().queue_free()
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
