extends Area2D


export (String) var text setget write

func _ready():
	$Label.hide()

func write(what):
	$Label.text = what

func _on_InstructionLabel_body_entered(_body):
	$Label.show()


func _on_InstructionLabel_body_exited(_body):
	$Label.hide()
