extends Node

@onready var ArrayStatus = []

func GetStatusEff(ID:int)->StatusEff:
	return ArrayStatus[ID] if ID < ArrayStatus.size() else Err

var Err = StatusEff.new(
	"wormy",
	load("res://Assets/Textures/Environment/bush2.png"),
	func ():
		pass
)

var Bleeding = StatusEff.new(
	"wormy",
	load("res://Assets/Textures/Environment/bush2.png"),
	func ():
		pass
)

var Tired = StatusEff.new(
	"wormy",
	load("res://Assets/Textures/Environment/bush2.png"),
	func ():
		pass
)
