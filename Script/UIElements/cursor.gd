extends Control

@export var ParentPath : NodePath

@onready var MenuParent = get_node(ParentPath)

var CursorIndex : int = 0

func GetMenuItem(index:int)->Control:
	if MenuParent == null:
		return null
	
	if index >= MenuParent.get_child_count() or index < 0:
		return null
	
	return MenuParent.get_child(index) as Control

func SetCursorFromIndex(index:int)->void:
	var MenuItem = GetMenuItem(index)
	
	if MenuItem == null:
		return 
	
	var Pos = MenuItem.global_position
	var Size = MenuItem.size
	
	global_position = Pos
	size = Size
	pivot_offset = Size/2
	$CursorSel.pivot_offset = pivot_offset
	
	CursorIndex = index

#Animations 
var AnimTween
var EaseType : Tween.EaseType = Tween.EASE_OUT

func AnimateCursor(Sel : bool):
	if AnimTween:
		AnimTween.kill()
	AnimTween = create_tween().set_parallel(true)
	
	if !Sel:
		AnimTween.tween_property($CursorSel,"scale",Vector2(1.0,1.0),0.15).set_trans(Tween.TRANS_CUBIC)
		AnimTween.tween_property($Panel,"modulate",Color.from_hsv(0.0,0.0,1.0,0.0),0.08).set_trans(Tween.TRANS_SINE)
		AnimTween.set_ease(EaseType)
	else:
		AnimTween.tween_property($CursorSel,"scale",Vector2(0.6,1.0),0.15).set_trans(Tween.TRANS_CUBIC)
		AnimTween.tween_property($Panel,"modulate",Color.from_hsv(0.0,0.0,1.0,1.0),0.08).set_trans(Tween.TRANS_SINE)
		AnimTween.set_ease(EaseType)
