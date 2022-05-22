extends Node2D

var nom = preload("res://entities/characters/nom_nom/nom_nom.tscn").instance()
onready var sprite: Sprite = $Sprite


func _ready():
	var dialog = Dialogic.start("train")
	dialog.connect("dialogic_signal", self, "dialog_listener")
	add_child(dialog)


func dialog_listener(_arg):
	sprite.set_visible(false)
	Party.add_party_member(nom)
	Party.spawn_party($YSort)
	Party.current_character().global_position = $Spawn.global_position
