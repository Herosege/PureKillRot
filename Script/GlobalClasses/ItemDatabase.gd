extends Node

@onready var Items = []
func GetItem(ID:int)->Item:
	return Items[ID] if ID < Items.size() else Err

var Err = Item.new(
	"HAHAHAAHAHAHAHAHAAHA",
	"The laws of this reality have been broken",
	load("res://Assets/Textures/Environment/bush2.png"),
	func Eff():
		pass
)
