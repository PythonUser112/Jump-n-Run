extends Node

signal score_changed
signal keys_changed
signal coins_changed
signal level_finished
signal level_failed

var level
var score
var coins
var pickup_scene = preload("res://Collectibles.tscn")
var pickups = [[], [["key_red", -20, 25], ["star", -12, 6], 
			["gem_red", -101, 25], ["key_blue", -50, 18],
			["star", -61, 31], ["coin_gold", -92, 25]], 
			[["key_green", 7, 7], ["key_blue", 3, 12], 
			["gem_yellow", 2, 26], ["star", 28, 5], ["star", 28, 4], 
			["star", 28, 3], ["star", 28, 8], ["key_yellow", 29, 5],
			["key_red", 29, 9]], 
			[["key_red", 4, -2], ["gem_green", 34, 7]]]
var lock_scene = preload("res://Lock.tscn")
var locks = [[], [["red", -11, 6], ["red", -11, 5], ["red", -11, 4], 
			["red", -11, 3], ["blue", -49, 29], ["blue", -48, 29]], 
			[["red", 18, 19],["yellow", 18, 22], ["blue", 27, 9],
			["blue", 27, 8], ["blue", 27, 7], ["red", 27, 5], ["green", 27, 4],
			["red", 27, 3], ["green", 27, 2]], [["red", 33, 6], ["red", 34, 6]]]
var keys = {"key_red":false, "key_yellow":false, 
			"key_green":false, "key_blue":false, "key_":true}
var cpt = {"coin_gold":3, "coin_silver":2, "coin_bronze":1}
var spt = {"coin_gold":400, "coin_silver":200, "coin_bronze":100}
var player_start_pos = [Vector2(100, 100), Vector2(360, 100), Vector2(360, 100),
						Vector2(360, 100)]

func init(_level):
	level = _level
	keys = {"key_red":false, "key_yellow":false, 
			"key_green":false, "key_blue":false,
			"key_":true}
	emit_signal("score_changed", score)
	emit_signal("coins_changed", coins)
	emit_signal("keys_changed", keys)
	if has_node("Enemies"):
		for enemy in get_node("Enemies").get_children():
# warning-ignore:return_value_discarded
			enemy.connect("collided", $Player, "enemy_collision")
			enemy.connect("killed", self, "enemy_killed")
			$Player.connect("moved", enemy, "set_marker_pos")
	$Player.start(player_start_pos[level-1])
	spawn_pickups()
	spawn_locks()

func spawn_pickups():
	var level_pickups = pickups[level]
	for pickup in level_pickups:
		var type = pickup[0]
		var pos_x = pickup[1] * $TileMap.cell_size.x + $TileMap.cell_size.x/2
		var pos_y = pickup[2] * $TileMap.cell_size.y + $TileMap.cell_size.y/2
		var c = pickup_scene.instance()
		c.init(type, Vector2(pos_x, pos_y))
		add_child(c)
		c.connect("pickup", self, "_on_Collectible_pickup")

func spawn_locks():
	var level_locks = locks[level]
	for lock in level_locks:
		var color = lock[0]
		var pos_x = lock[1] * $TileMap.cell_size.x + $TileMap.cell_size.x/2
		var pos_y = lock[2] * $TileMap.cell_size.y + $TileMap.cell_size.y/2
		var c = lock_scene.instance()
		c.init(color, Vector2(pos_x, pos_y))
# warning-ignore:return_value_discarded
		connect("keys_changed", c, "_on_Main_keys_changed")
		$TileMap.add_child(c)

func _on_Collectible_pickup(type):
	if type in ["key_red", "key_yellow", "key_green", "key_blue"]:
		keys[type] = true
		emit_signal("keys_changed", keys)
	elif type == "star":
		score += 1000
		emit_signal("score_changed", score)
	elif type in ["coin_silver", "coin_bronze", "coin_gold"]:
		score += spt[type]
		coins += cpt[type]
		emit_signal("score_changed", score)
		emit_signal("coins_changed", coins)
	elif type in ["gem_red", "gem_blue", "gem_yellow", "gem_green"]:
		score += 5000
		emit_signal("level_finished")
	
func _on_Player_dead():
	emit_signal("level_failed")

func enemy_killed():
	score += 50
	emit_signal("score_changed", score)
