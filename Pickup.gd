extends Area2D

signal pickup

var type = ""
var textures = {"key_red":"res://graphics/GRP/items/keys/keyRed.png",
				"key_yellow":"res://graphics/GRP/items/keys/keyYellow.png",
				"key_green":"res://graphics/GRP/items/keys/keyGreen.png",
				"key_blue":"res://graphics/GRP/items/keys/keyBlue.png",
				"coin_gold":"res://graphics/GRP/items/coins/coinGold.png",
				"coin_silver":"res://graphics/GRP/items/coins/coinSilver.png",
				"coin_bronze":"res://graphics/GRP/items/coins/coinBronze.png",
				"gem_blue":"res://graphics/GRP/items/gems/gemBlue.png",
				"gem_green":"res://graphics/GRP/items/gems/gemGreen.png",
				"gem_red":"res://graphics/GRP/items/gems/gemRed.png",
				"gem_yellow":"res://graphics/GRP/items/gems/gemYellow.png",
				"star":"res://graphics/GRP/items/star/star.png"}

func init(_type, pos):
	type = _type
	$Sprite.texture = load(textures[type])
	position = pos

func _on_Collectible_body_entered(__):
	emit_signal("pickup", type)
	queue_free()
