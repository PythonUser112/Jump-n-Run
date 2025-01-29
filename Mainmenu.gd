extends Control

export (PackedScene) var fontbutton

var loadable_levels = 3
var score = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var max_level = 1
var coins = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var save_file = "user://progress.txt"
var f
var levelscene

func setup_buttons():
	for button in $Container/Levels.get_children():
		button.queue_free()
	for level in range(max_level):
		var bt = fontbutton.instance()
		bt.set_level(level+1)
		bt.connect("level", self, "load_level")
		$Container/Levels.add_child(bt)

func _ready():
	f = File.new()
	if f.file_exists(save_file):
		f.open(save_file, File.READ)
		var text = f.get_as_text()
		f.close()
		var lines = text.split("\n")
		max_level = min(int(lines[0]), loadable_levels)
		var i = -2
		for line in lines:
			i=i+1
			if not line:
				continue
			if i==-1:
				continue
			var sc = line.split(";")
			score[i] = int(sc[0])
			coins[i] = int(sc[1])
	setup_buttons()

func get_score(level):
	if level == 1:
		return 0
	return score[level-2]

func get_coins(level):
	if level == 1:
		return 0
	return coins[level-2]

func load_level(level):
	$Container.hide()
	levelscene = load("res://Level/Level "+str(level)+".tscn").instance()
	levelscene.score = get_score(level)
	levelscene.coins = get_coins(level)
	levelscene.connect("level_finished", self, "_on_Level_finished")
	levelscene.connect("level_failed", self, "retry", [level])
	add_child(levelscene)
	levelscene.init(level)

func _on_Level_finished():
	score[levelscene.level-1] = levelscene.score
	coins[levelscene.level-1] = levelscene.coins
	levelscene.queue_free()
	max_level = min(max_level+1, loadable_levels)
	f.open(save_file, File.WRITE)
	var text = str(max_level) + "\n"
	for i in range(max_level-1):
		text += str(score[i]) + ";" + str(coins[i])+"\n"
	f.store_string(text)
	f.close()
	setup_buttons()
	$Container.show()

func retry(level):
	levelscene.queue_free()
	load_level(level)
