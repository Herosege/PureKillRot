extends Resource
class_name StatusEff

var ID : int = -1
var Name : String

var Icon : String
var Effect 

#in turns
var Duration : int
var Stacks : int = 1

func ActivateEffect(creature):
	Effect.call(creature)

func _init(a,b,c,d):
	Name = a
	Icon = b
	Duration = c
	Effect = d
