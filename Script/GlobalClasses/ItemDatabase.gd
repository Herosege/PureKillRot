extends Node

@onready var Items = []
func GetItem(ID:int)->Item:
	return Items[ID] if ID < Items.size() else Err

var Err = Item.new(
	"Tissue",
	"This is an error! sorry!",
	load("res://Assets/Sprites/npcs/someone.png"),
	func Eff():
		pass
)
