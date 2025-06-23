extends Control

const NUM_COLUMNS_ITEMS = 4
const ITEMS_PER_PAGE = 8

@onready var ActionContainer = get_tree().get_first_node_in_group("ActionContainer")
@onready var ListItems = get_tree().get_first_node_in_group("ItemList")
@onready var MIArrow = get_tree().get_first_node_in_group("MoreItemsArrow")
@onready var PIArrow = get_tree().get_first_node_in_group("PrevItemsArrow")
@onready var EnemyList = get_tree().get_first_node_in_group("EnemyList")
@onready var CharProfs = get_tree().get_first_node_in_group("CharProfiles")
@onready var DPMessage = get_tree().get_first_node_in_group("DownPanelMessage")
#0-ActionMenu ; 1-ItemMenu ; 2-ProfileMenu
@onready var Cursor = get_tree().get_nodes_in_group("Cursor")

@onready var OverlayColor = get_node("Overlay/ColorRect")
@onready var EnNameDis = get_node("UI/EnemyNameDisplay")
@onready var AttTexture = get_node("AttackTexture")

@onready var ItemScene = load("res://Scenes/UIElements/item.tscn") 

#Timers
@onready var SkillUseTimer = get_node("Timers/SkillUseTimer")
@onready var TimePerSpites = get_node("Timers/TimePerSprite")
@onready var LabelAnim = get_node("Timers/LabelAnim")

#Action -> Select Item -> EnemySelect
var MenuLayer : int = 0 
var UiDir : Vector2 = Vector2.ZERO

var Turn = 0

#Elegancko
enum {ACTION_SKILL,ACTION_INFO,ACTION_ITEM,ACTION_SPECIAL}
enum {SELECT_ITEM,SELECT_PROFILE,SELECT_CHARACTER}
var MenuTypes = [
	[SELECT_ITEM,SELECT_CHARACTER],
	[SELECT_PROFILE],
	[SELECT_ITEM,SELECT_CHARACTER],
	[SELECT_ITEM]
	]

var FightParty = []
var CharacterTurn : int = -1
var YourTurn = true

#SelectAction
var SelIndexAction : int = 0 

#SelectItem
var SelIndexItem : int = 0

#SelectCharacter
var SelIndexEnemy : int = 0 
var SelIndexProf : int = 0

#ItemSeletion
var TempItemList = []

var StartMessage : String

#Passed arguments
var BattleText = ""
var BattleEnemies = []

#ActionBuffer - [ID,type,target] - type (who to attack)  0:character 1:enemy
enum IsAttacked {character,enemy} 
var ActionBuffer : Array

#DownTextbox
enum TBM {std_text,char_info}
var TextboxMode = TBM.std_text

var TextToSet = ""
var AwaitInptToEnd = 0

var HaltAction = false

func _enter_tree():
	$Overlay.visible = true

func _ready():
	#Engine.time_scale = 2.0
	for i in PartyInfo.MainParty.size():
		if PartyInfo.MainParty[i].Dead == false:
			FightParty.append(PartyInfo.MainParty.find(PartyInfo.MainParty[i]))
			if CharacterTurn == -1:
				CharacterTurn = i
	for i in PartyInfo.MainParty.size():
		ActionBuffer.append(-1)
	#don't touch this or everything breaks :)
	await get_tree().create_timer(0.05).timeout
	#
	BattleStart([0,0],BattleText)
	UpdateUi(0)
	GenProfiles()
	UpdateProfiles()

func _process(delta):
	if AwaitInptToEnd and Input.is_action_just_pressed("accept"):
		ExitBattleScene(AwaitInptToEnd)
	if OverlayColor.color.a>0.0:
		OverlayColor.color.a = lerp(OverlayColor.color.a,0.0,1.5*delta)
	TextBoxHandle(delta)
	if !HaltAction:
		UiMovement()
		UiLayerHandle()

var CharProfile = load("res://Scenes/UIElements/char_profile.tscn")

func GenProfiles():
	for i in PartyInfo.MainParty.size():
		var CharPInst = CharProfile.instantiate()
		var CChar = PartyInfo.MainParty[i]
		CharPInst.SetImage(CChar.Icon)
		CharPInst.SetName(CChar.Name)
		CharPInst.SetHealth(CChar.PhysicalHealth,CChar.MentalHealth)
		CharProfs.add_child(CharPInst)

func BattleStart(Enemies : Array,Msg : String)->void:
	var EnemyScene = load("res://Scenes/UIElements/enemy.tscn")
	for i in Enemies.size():
		var EnemySceneInst = EnemyScene.instantiate()
		var EnemyFromID = EnemyDB.GetEnemyNew(Enemies[i])
		BattleEnemies.append(EnemyFromID)
		EnemySceneInst.ESprites = EnemyFromID.Sprites
		
		EnemyList.add_child(EnemySceneInst)
	StartMessage = Msg
	TextToSet = StartMessage

### MAIN UI HANDLE ------------------------------------------------------------------------------------------------------

func UiMovement()->void:
	UiDir.x = float(Input.is_action_just_pressed("move_right"))-float(Input.is_action_just_pressed("move_left"))
	UiDir.y = float(Input.is_action_just_pressed("move_down"))-float(Input.is_action_just_pressed("move_up"))
	if UiDir:
		if MenuLayer == 0:
			SelIndexAction += UiDir.y
			SelIndexAction = clamp(SelIndexAction,0,3)
			UpdateUi(MenuLayer)
		
		if MenuLayer > 0:
			match MenuTypes[SelIndexAction][MenuLayer-1]:
				SELECT_ITEM:
					ItemsMenuHandle()
				SELECT_PROFILE:
					if CharProfs.get_children():
						SelIndexProf += UiDir.x
						SelIndexProf = clamp(SelIndexProf,0,CharProfs.get_children().size()-1)
						UpdateUi(MenuLayer)
				SELECT_CHARACTER:
					if EnemyList.get_child_count() > 0:
						SelIndexEnemy += UiDir.x
						SelIndexEnemy = clamp(SelIndexEnemy,0,EnemyList.get_child_count()-1)
						UpdateUi(MenuLayer)

func UiLayerHandle()->void:
	if Input.is_action_just_pressed("accept") and CheckAction():
		
		if MenuLayer < MenuTypes[SelIndexAction].size() and Cursor.size() > MenuLayer: 
			AnimateCursor(true,MenuLayer)
		if MenuTypes[SelIndexAction].size() == MenuLayer:
			if !(SelIndexAction == SELECT_PROFILE):
				ActionBuffer[CharacterTurn] = [TempItemList[SelIndexItem],1,SelIndexEnemy]
				
				CharacterTurn += 1
				while PartyInfo.MainParty[min(CharacterTurn,PartyInfo.MainParty.size()-1)].Dead == true and !PartyInfo.MainParty.size() <= CharacterTurn:
					CharacterTurn += 1
				ResetMenu()
				if PartyInfo.MainParty.size() <= CharacterTurn:
					CommitActions()
				UpdateProfiles()
		else:
			MenuLayer += 1
		if MenuTypes[SelIndexAction][MenuLayer-1] == SELECT_ITEM:
			CharProfs.visible = false
			GenerateItemList(PartyInfo.MainParty[CharacterTurn])
			ItemsMenuHandle()
		if MenuTypes[SelIndexAction][MenuLayer-1] == SELECT_PROFILE:
			CharProfs.visible = true
	
	if Input.is_action_just_pressed("back"):
		if MenuLayer == 0 and CharacterTurn > 0:
			var GoBackAmnt = CharacterTurn - 1
			while PartyInfo.MainParty[GoBackAmnt].Dead == true and GoBackAmnt > 0:
				GoBackAmnt -= 1
			if GoBackAmnt == 0 and PartyInfo.MainParty[GoBackAmnt].Dead == true:
				return
			CharacterTurn = GoBackAmnt
			#print("Pre:   ",ActionBuffer)
			ActionBuffer.set(CharacterTurn,-1)
			#print("Post:   ",ActionBuffer)
			UpdateProfiles()
		if MenuLayer > 0 and Cursor.size() > MenuLayer-1: 
			AnimateCursor(false,MenuLayer-1)
		
		ResetMenuLayer(MenuLayer)
		
		MenuLayer -= 1
		if MenuLayer == 0 and !CharProfs.visible:
			CharProfs.visible = true
	UpdateUi(MenuLayer)
	MenuLayer = clamp(MenuLayer,0,MenuTypes[SelIndexAction].size())

func UpdateUi(Layer:int)->void:
	if Layer == 0:
		Cursor[0].SetCursorFromIndex(SelIndexAction)
	if Layer > 0:
		match MenuTypes[SelIndexAction][Layer-1]:
			SELECT_ITEM:
				Cursor[1].SetCursorFromIndex(SelIndexItem%8)
			SELECT_PROFILE:
				Cursor[2].SetCursorFromIndex(SelIndexProf)
			SELECT_CHARACTER:
				var AnimSprite
				EnNameDis.visible = true
				var SetName =  str(BattleEnemies[SelIndexEnemy].Name) + " " + str(SelIndexEnemy+1) if BattleEnemies.size() > 1 else str(BattleEnemies[SelIndexEnemy].Name)
				EnNameDis.get_node("TextMargin/Label").text = SetName
				for i in EnemyList.get_children().size():
					AnimSprite = EnemyList.get_child(i).get_child(0)
					AnimSprite.material.set_shader_parameter("FlashOn",false)
				AnimSprite = EnemyList.get_child(SelIndexEnemy).get_child(0)
				AnimSprite.material.set_shader_parameter("FlashOn",true)

func UpdateProfiles():
	for i in CharProfs.get_children().size():
		var CCharP = CharProfs.get_child(i)
		CCharP.SelectCurrent(i==CharacterTurn)
		CCharP.SetHealth(PartyInfo.MainParty[i].PhysicalHealth,PartyInfo.MainParty[i].MentalHealth)
		if PartyInfo.MainParty[i].Dead == true:
			CCharP.SetDead(true)

func ResetMenu():
	MenuLayer = 0
	
	ResetMenuLayer(-1)
	for i in Cursor.size():
		Cursor[i].AnimateCursor(false)
	
	SelIndexItem = 0
	SelIndexAction = 0

### ITEMS HANDLE ------------------------------------------------------------------------------------------------------

func UpdateItems()->void:
	ClearItems()
	for i in min(TempItemList.size(),ITEMS_PER_PAGE):
		if i+floor(SelIndexItem/ITEMS_PER_PAGE)*ITEMS_PER_PAGE > TempItemList.size()-1:
			break
		var IInst = ItemScene.instantiate()
		IInst.get_node("Label").text = str(SkillDB.ArraySkills[TempItemList[i+floor(SelIndexItem/ITEMS_PER_PAGE)*ITEMS_PER_PAGE]].Name)
		ListItems.add_child(IInst)
	#Arrow indicators
	if !(ceil(SelIndexItem/ITEMS_PER_PAGE)*ITEMS_PER_PAGE >= TempItemList.size()-8):
		MIArrow.visible = true
	else:
		MIArrow.visible = false
	
	if SelIndexItem >= 8:
		PIArrow.visible = true
	else:
		PIArrow.visible = false

func ClearItems():
	for i in ListItems.get_children():
		i.queue_free()

#0 Skills - 1 PlayerInfo - 2 Items - 3 Escape
func ItemsMenuHandle()->void:
	if ListItems.get_children().size() > 0:
		SelIndexItem += UiDir.x
		SelIndexItem += NUM_COLUMNS_ITEMS * UiDir.y
		SelIndexItem = clamp(SelIndexItem,0,TempItemList.size()-1)
	UpdateItems()
	await get_tree().process_frame
	UpdateUi(MenuLayer)
	await get_tree().process_frame
	if Cursor[1].visible == false:
		Cursor[1].visible = true

func GenerateItemList(Char:Character):
	TempItemList.resize(0)
	match SelIndexAction:
		ACTION_SKILL:
			for i in Char.Skills.size():
				TempItemList.append(Char.Skills[i])
		ACTION_ITEM:
			pass
		ACTION_SPECIAL:
			pass


func CheckAction()->bool:
	match SelIndexAction:
		ACTION_SKILL:
			return true if PartyInfo.MainParty[CharacterTurn].Skills else false
		ACTION_INFO:
			return true if PartyInfo.MainParty[CharacterTurn] else false
		ACTION_ITEM:
			return true if PartyInfo.Items else false
		ACTION_SPECIAL:
			return true if PartyInfo.MainParty[CharacterTurn].Special else false
	return false

#-1 to Reset all layers
func ResetMenuLayer(Layer):
	if Layer > 0:
		match MenuTypes[SelIndexAction][Layer-1]:
			SELECT_ITEM:
				ClearItems()
				ResetCursor(1)
				Cursor[1].visible = false
				MIArrow.visible = false
				PIArrow.visible = false
				SelIndexItem = 0
			SELECT_PROFILE:
				ResetCursor(2)
			SELECT_CHARACTER:
				var AnimSprite
				EnNameDis.visible = false
				for i in EnemyList.get_children().size():
					AnimSprite = EnemyList.get_child(i).get_child(0)
					AnimSprite.material.set_shader_parameter("FlashOn",false)
	if Layer == -1:
		#
		ClearItems()
		CharProfs.visible = true
		ResetCursor(1)
		Cursor[1].visible = false
		MIArrow.visible = false
		PIArrow.visible = false
		SelIndexItem = 0
		#
		ResetCursor(2)
		#
		var AnimSprite
		EnNameDis.visible = false
		for i in EnemyList.get_children().size():
			AnimSprite = EnemyList.get_child(i).get_child(0)
			AnimSprite.material.set_shader_parameter("FlashOn",false)

### CURSOR ------------------------------------------------------------------------------------------------------

func AnimateCursor(SetAnim:bool,Layer:int):
	if Layer == 0:
		Cursor[0].AnimateCursor(SetAnim)
	if Layer > 0:
		match SelIndexAction:
			ACTION_SKILL:
				Cursor[1].AnimateCursor(SetAnim)
			ACTION_INFO:
				Cursor[2].AnimateCursor(SetAnim)
			ACTION_ITEM:
				Cursor[1].AnimateCursor(SetAnim)
			ACTION_SPECIAL:
				Cursor[1].AnimateCursor(SetAnim)

func ResetCursor(Layer):
	Cursor[Layer].global_position = Vector2.ZERO
	Cursor[Layer].size = Vector2.ZERO
	Cursor[Layer].pivot_offset = Vector2.ZERO

### ACTIONS ------------------------------------------------------------------------------------------------------

func CommitActions():
	HaltAction = true
	GenEnemyActions()
	
	for i in ActionBuffer.size():
		if i >= ActionBuffer.size():
			break
		if AwaitInptToEnd:
			break
		if ActionBuffer[i] is not int:
			var SkillT = ActionBuffer[i]
			var CharaType = SkillT[1] 
			var TargetArray = BattleEnemies if CharaType == 1 else PartyInfo.MainParty
			var TargetType = SkillT[2] if SkillT[2] <= TargetArray.size()-1 else 0 
			var STimes = SkillDB.GetSkill(SkillT[0]).AnimDuration
			var Sprts = SkillDB.GetSkill(SkillT[0]).AnimSprites
			var EnemyType = TargetArray[TargetType]
			var EnemNode
			
			if ActionBuffer[i][1] == 1:
				EnemNode = EnemyList.get_child(TargetType)
			else:
				EnemNode = CharProfs.get_child(TargetType).get_node("StatsPicture/TextureRect")
			
			SkillUseTimer.start(STimes*1.6)
			
			AttackTextureAnim(Sprts,STimes,EnemNode.global_position+EnemNode.size/2)
			
			await SkillUseTimer.timeout
			SkillUse(SkillT,TargetArray,TargetType,EnemyType)
			DamagedFlashAnim(EnemNode)
			
			SkillUseTimer.start(0.6)
			await SkillUseTimer.timeout
			
			CheckDeadUpdate(TargetArray,TargetType,EnemyType,CharaType)
			if CheckEndFight():
				return
			SkillUseTimer.start(0.05)
			await SkillUseTimer.timeout
	ResetMenu()
	if FightParty:
		CharacterTurn = FightParty[0]
	UpdateProfiles()
	ActionBuffer.resize(PartyInfo.MainParty.size())
	for i in ActionBuffer.size():
		ActionBuffer[i] = -1
	HaltAction = false if !AwaitInptToEnd else true

func GenEnemyActions():
	FightParty.resize(0)
	for i in PartyInfo.MainParty.size():
		if PartyInfo.MainParty[i].Dead == false:
			FightParty.append(PartyInfo.MainParty.find(PartyInfo.MainParty[i]))
	for i in BattleEnemies.size():
		var TempBuf = BattleEnemies[i].RSkill(Turn,FightParty.size())
		TempBuf[2] = FightParty[TempBuf[2]]
		ActionBuffer.append(TempBuf)

func SkillUse(SkillT,TargetArray,TargetType,EnemyType):
	var Effect = SkillDB.GetSkill(SkillT[0]).Effect
	var Vals = SkillDB.GetSkill(SkillT[0]).Values
	
	match Effect:
		Enums.TSkill.Damage:
			CheckEndFight()
			if SkillT[1] == IsAttacked.character:
				if EnemyType.Dead == true:
					TargetType = FightParty[randi()%FightParty.size()]
					EnemyType = TargetArray[TargetType]
			EnemyType.TakeDamage(Vals[0])
			var HasDupes = false
			var TempDup = []
			for i in TargetArray:
				if !TempDup.has(i.Name):
					TempDup.append(i.Name)
				else:
					HasDupes = true
					break
			var EnemName = str(EnemyType.Name) if !HasDupes else str(EnemyType.Name) + " " + str(TargetType+1)
			SignalBus.emit_signal("AnnounceAction", EnemName + " took " + str(Vals[0]) + " Damage!")
			UpdateProfiles()
			DamageNumberAnim(Vals[0])

func CheckEndFight()->bool:
	if BattleEnemies.size() == 0:
		BattleEnd(1)
		return true
	if FightParty.size() == 0:
		BattleEnd(0)
		return true
	return false

func CheckDeadUpdate(TargetArray,TargetType,EnemyType,CharaType):
	var HasDupes = false
	var TempDup = []
	for i in TargetArray:
		if !TempDup.has(i.Name):
			TempDup.append(i.Name)
		else:
			HasDupes = true
			break
		
	var EnemName = str(EnemyType.Name) if !HasDupes else str(EnemyType.Name) + " " + str(TargetType+1)
	if EnemyType.PhysicalHealth <= 0:
		
		SignalBus.emit_signal("AnnounceAction",EnemName + " died")
		CharacterDie(TargetType,CharaType)
		UpdateProfiles()

### SKILL ANIMS ------------------------------------------------------------------------------------

func AttackTextureAnim(Sprites,SpriteTime,EnemNodePos):
	var CalcTPS = (SpriteTime)/Sprites.size()
	AttTexture.global_position = EnemNodePos
	for i in Sprites:
		AttTexture.texture = i
		TimePerSpites.start(CalcTPS)
		await TimePerSpites.timeout
	
	AttTexture.texture = null

func DamagedFlashAnim(EnemNode):
	for i in 8:
		EnemNode.modulate.a = float(!bool(EnemNode.modulate.a))
		TimePerSpites.start(0.06)
		await TimePerSpites.timeout

func DamageNumberAnim(DamageNum):
	var LabelsPos = AttTexture.global_position + Vector2(0,20.0)
	SignalBus.emit_signal("AnnounceDamage",-DamageNum,LabelsPos)

### END STUFF ------------------------------------------------------------------------------------------------------
#0-character 1-enemy
func CharacterDie(Index,Type):
	match Type:
		IsAttacked.character:
			FightParty.remove_at(FightParty.find(Index))
			PartyInfo.MainParty[Index].Dead = true
			CharProfs.get_child(Index).SetDead(true)
		IsAttacked.enemy:
			if ActionBuffer.size() >= PartyInfo.MainParty.size() + BattleEnemies.size():
				ActionBuffer.remove_at(PartyInfo.MainParty.size()+Index)
			BattleEnemies.remove_at(Index)
			EnemyList.get_child(Index).queue_free()
			SelIndexEnemy = 0
	CheckEndFight()

#0-lose   1-win
func BattleEnd(type):
	if type == 0:
		HaltAction = true
		TextToSet = "You lost"
		AwaitInptToEnd = 1
	else:
		HaltAction = true
		TextToSet = "You won!"
		AwaitInptToEnd = 2

func ExitBattleScene(type):
	SignalBus.emit_signal("EndBattle",type)
	queue_free()

### TEXTBOX ------------------------------------------------------------------------------------------------------

var NewTextSwitch = true
var PrevTTS = ""

func TextBoxHandle(delta):
	if !TextToSet.is_empty() and TextboxMode == TBM.std_text:
		if !PrevTTS.is_empty() and TextToSet != PrevTTS:
			NewTextSwitch = true
		PrevTTS = TextToSet
		if NewTextSwitch:
			DPMessage.text = ""
			NewTextSwitch = false
			Globals.TextTime = 0.0
			Globals.TextIndex = 0
			Globals.CharTime = Globals.TEXTSCROLLTIME
			Globals.LettersAtTime = 0.0
		var Char = Globals.ScrollText(TextToSet,delta)
		#print(Char,"abba")
		DPMessage.text += Char
		if Globals.CurText.is_empty():
			TextToSet = ""
			NewTextSwitch = true
