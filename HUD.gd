extends MarginContainer

onready var life_counter = [$"UI/Stats Counter/L1",
							$"UI/Stats Counter/L2",
							$"UI/Stats Counter/L3",
							$"UI/Stats Counter/L4",
							$"UI/Stats Counter/L5"]

onready var key_counter = [$"UI/Stats Counter/KR",
						   $"UI/Stats Counter/KY",
						   $"UI/Stats Counter/KG",
						   $"UI/Stats Counter/KB"]

var keys_full_textures = ["res://graphics/GRP/hud/items/hud_keyRed.png",
						"res://graphics/GRP/hud/items/hud_keyYellow.png",
						"res://graphics/GRP/hud/items/hud_keyGreen.png",
						"res://graphics/GRP/hud/items/hud_keyBlue.png"]

var score = 0
var coins = 0


func _on_Player_life_changed(lives):
	for heart in range(life_counter.size()):
		life_counter[heart].visible = lives > heart

func _on_Main_score_changed(value):
	score = value
	$UI/ScoreLable.text = "Score "+str(score)+\
									 "\nCoins "+str(coins)

# warning-ignore:unused_argument
func key_visibility(num):
	return load(keys_full_textures[num]) as Texture

func _on_Main_keys_changed(keys):
	for key in range(key_counter.size()):
		if keys["key_"+["red", "yellow", "green", "blue"][key]]:
			key_counter[key].texture = key_visibility(key)

func _on_Main_coins_changed(value):
	coins = value
	$UI/ScoreLable.text = "Score "+str(score)+\
									 "\nCoins "+str(coins)
