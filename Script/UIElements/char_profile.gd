extends Control

var Portrait
var PHealth 
var MHealth
var Name 

func SetImage(Img:CompressedTexture2D):
	Portrait = get_node("StatsPicture/TextureRect")
	Portrait.texture = Img

func SetName(Nam:String):
	Name = get_node("StatsPicture/VBoxContainer/Name")
	Name.text = Nam

func SetHealth(PH,MH,MPH,MMH):
	PHealth = get_node("StatsPicture/VBoxContainer/HBoxContainer/VBoxContainer/Label")
	MHealth = get_node("StatsPicture/VBoxContainer/HBoxContainer/VBoxContainer/Label2")
	PHealth.text = str(PH)+"/"+str(MPH)
	MHealth.text = str(MH)+"/"+str(MMH)

func SetSelected(type:bool):
	$CurSelected.visible = type

func SetDead(IsDead):
	$DeadOverlay.visible = IsDead

func SelectCurrent(type:bool):
	$CurSelected.visible = type

func PlayFlashAnim():
	$AnimationPlayer.play("flash")
