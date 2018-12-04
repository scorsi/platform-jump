extends Node


onready var highscore = $Highscore



func _ready():
	highscore.bbcode_text = "[center]" + str(PlayerData.load_highscore()) + "[/center]"


func _on_Button_pressed():
	LevelManager.change_scene("Game")
