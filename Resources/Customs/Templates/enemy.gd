extends Resource
class_name Enemy

var Name : String
var Sprites : Array

var PhysicalHealth : float
var Skills : Array

var AI

func TakeDamage(Amnt):
	PhysicalHealth -= Amnt

func _init(a,b,c,d,e):
	Name = a
	Sprites = b
	PhysicalHealth = c
	Skills = d
	AI = e

func RSkill(turn,oppons):
	return AI.call(turn,oppons)
