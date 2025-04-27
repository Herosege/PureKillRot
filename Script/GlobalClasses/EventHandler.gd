extends Node

enum EvType {Dialogue,InitBattle,GiveItem,ChangeScene}
func _ready():
	SignalBus.EventPass.connect(EventPass)
	SignalBus.EventConclude.connect(OnEventConclude)

var CEvents = []
var EventIndex = 0

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
			pass
		EvType.GiveItem:
			pass
		EvType.ChangeScene:
			SignalBus.emit_signal("ChangeScene",CEvents[1])

func OnEventConclude():
	#EventIndex += 1
	#EventHandle()
	pass
