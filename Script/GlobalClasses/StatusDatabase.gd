extends Node

@onready var ArrayStatus = [Bleeding,Tired]

func _ready():
	for i in ArrayStatus:
		i.ID = ArrayStatus.find(i)
	pass

func GetStatusEff(ID:int)->StatusEff:
	return ArrayStatus[ID] if ID < ArrayStatus.size() else Err

func GetStatusEffNew(ID:int)->StatusEff:
	var Base = ArrayStatus[ID]
	var Abba = StatusEff.new(
		Base.Name,
		Base.Icon,
		Base.Duration,
		Base.Effect
		)
	Abba.ID = Base.ID
	return Abba

var Err = StatusEff.new(
	"wormy",
	"res://Assets/Textures/Environment/bush2.png",
	5,
	func (creature):
		pass
)

var Bleeding = StatusEff.new(
	"bleeding",
	"res://Assets/Textures/UIIcons/Statuses/Bleed.png",
	5,
	func (creature):
		creature.TakeDamage(50.0)
)

var Tired = StatusEff.new(
	"tired",
	"res://Assets/Textures/Environment/bush2.png",
	5,
	func (creature):
		pass
)
