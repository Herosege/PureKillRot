extends Node

var InDialogue = false

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)

const TEXTSCROLLTIME = 0.03

var TextTime = 0.0
var TextIndex = 0
var CharTime = TEXTSCROLLTIME
var LettersAtTime = 0.0

var CurText = ""

func ScrollText(Text,delta)->String:
	var ValToRet = ""
	if CurText.is_empty():
		CurText = Text
	if !CurText.is_empty():
		
		TextTime += delta
		if TextTime > CharTime:
			LettersAtTime = floor(TextTime / CharTime)
			TextTime = 0
			if LettersAtTime >= CurText.length():
				LettersAtTime = CurText.length()
			if LettersAtTime + TextIndex >= CurText.length():
				LettersAtTime = CurText.length() - TextIndex 
			for i in range(TextIndex,TextIndex + LettersAtTime):
				ValToRet += CurText[i]
			TextIndex += LettersAtTime
			if TextIndex >= CurText.length():
				CurText = ""
	return ValToRet
