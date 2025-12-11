extends Node

@onready var ArrayStatus = []

func GetStatusEff(ID:int)->StatusEff:
	return ArrayStatus[ID] if ID < ArrayStatus.size() else Err

var Err = StatusEff.new(
	"wormy",
	load("res://Assets/Textures/Environment/bush2.png"),
	func (creature):
		pass
)

var Bleeding = StatusEff.new(
	"bleeding",
	load("res://Assets/Textures/Environment/bush2.png"),
	func (creature):
		pass
)

var Tired = StatusEff.new(
	"tired",
	load("res://Assets/Textures/Environment/bush2.png"),
	func (creature):
		pass
)
