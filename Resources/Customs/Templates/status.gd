extends Resource
class_name StatusEff

var Name : String

var Icon : CompressedTexture2D
var Effect 

#in turns
var Duration : int
var Stacks 

func ActivateEffect():
	Effect.call()
