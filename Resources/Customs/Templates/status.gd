extends Resource
class_name StatusEff

var Name : String

var Icon : CompressedTexture2D
var Effect 

#in turns
var Duration : int
var Stacks : int

func ActivateEffect(creature):
	Effect.call(creature)

func _init(a,b,c):
	Name = a
	Icon = b
	Effect = c
