extends Node

@onready var ArrayChar = [Char_Me,Char_Amy,Char_Witold]

func GetChar(ID:int)->Character:
	return ArrayChar[ID]

func GetCharNew(ID:int)->Character:
	var Base = ArrayChar[ID]
	var Abba = Character.new(
		Base.Name,
		Base.Icon,
		Base.MaxPhysicalHealth,
		Base.MaxMentalHealth,
		Base.PhysicalStrength,
		Base.MentalStrength,
		Base.Defence,
		Base.Skills
		)
	return Abba

var IconsF = "res://Assets/Textures/Sprites_battle/Icons/"

var Err = Character.new(
	"Tissue",
	load("res://Assets/Textures/Sprites_normal/Normal/someone.png"),
	1.0,1.0,
	1.0,1.0,
	1.0,[SkillDB.Err]
)

var Char_Me = Character.new(
	"Me",
	load(IconsF + "Me.png"),
	120.0,70.0,
	10.0,10.0,
	1.0,[0,1,2]
	)

var Char_Amy = Character.new(
	"Amy",
	load(IconsF + "Amy.png"),
	123.0,111.0,
	10.0,10.0,
	1.0,[1]
)

var Char_Witold = Character.new(
	"Witold",
	load(IconsF + "Witold.png"),
	102.0,101.0,
	10.0,10.0,
	1.0,[1,2]
)
