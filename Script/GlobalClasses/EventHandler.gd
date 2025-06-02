extends Node

enum EvType {Dialogue,InitBattle,GiveItem,ChangeScene}
func _ready():
	SignalBus.EventPass.connect(EventPass)
	SignalBus.EventConclude.connect(OnEventConclude)
	SignalBus.EndBattle.connect(OnEndBattle)

var CEvents = []
var EventIndex = 0

var CSceneStore

func EventPass(EvArr):
	EventIndex = 0
	CEvents = EvArr
	EventHandle()

func EventHandle():
	if EventIndex >= CEvents.size():
		return
	#match CEvents[EventIndex][0]:
		#EvType.Dialogue:
			#SignalBus.emit_signal("ShowDialogue",CEvents[EventIndex][1])
	match CEvents[0]:
		EvType.Dialogue:
			SignalBus.emit_signal("ShowDialogue",CEvents[1],CEvents[2],CEvents[3])
		EvType.InitBattle:
			InitiateBattle(CEvents[1])
		EvType.GiveItem:
			pass
		EvType.ChangeScene:
			SignalBus.emit_signal("ChangeScene",CEvents[1])

func OnEventConclude():
	#EventIndex += 1
	#EventHandle()
	pass


var BattleS = preload("res://Scenes/fight_scene.tscn")

func InitiateBattle(Text):
	var BattleScene = BattleS.instantiate()
	BattleScene.BattleText = Text
	
	get_tree().root.add_child(BattleScene)
	get_tree().paused = true
	CSceneStore = get_tree().root.get_node("/root/Main")
	get_tree().root.remove_child(get_node("/root/Main"))
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false

func OnEndBattle():
	if CSceneStore:
		get_tree().root.add_child(CSceneStore)
