extends Node

enum EvType {Dialogue,InitBattle,GiveItem,ChangeScene}
func _ready():
	SignalBus.EventPass.connect(EventHandle)

func EventHandle(EvArr):
	for i in EvArr.size():
		match EvArr[i][0]:
			EvType.Dialogue:
				SignalBus.emit_signal("ShowDialogue",EvArr[i][1])
			EvType.InitBattle:
				pass
			EvType.GiveItem:
				pass
			EvType.ChangeScene:
				pass
