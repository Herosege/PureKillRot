extends Node

@onready var ArrayChar = [Char_Me,Char_Amy,Char_Witold]

func GetChar(ID:int)->Character:
	return ArrayChar[ID]

var Err = Character.new(
	"Tissue",
	load("res://Assets/Sprites/npcs/someone.png"),
	1.0,1.0,
	1.0,1.0,
	1.0,[SkillDB.Err]
)

var Char_Me = Character.new(
	"Me",
	load("res://Assets/Icons/Me.png"),
	100.0,100.0,
	10.0,10.0,
	1.0,[0,1,2]
	)

var Char_Amy = Character.new(
	"Amy",
	load("res://Assets/Icons/Amy.png"),
	100.0,100.0,
	10.0,10.0,
	1.0,[1]
)

var Char_Witold = Character.new(
	"Witold",
	load("res://Assets/Icons/Witold.png"),
	100.0,100.0,
	10.0,10.0,
	1.0,[1,2]
)
