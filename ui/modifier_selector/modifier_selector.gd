extends PopupDialog
onready var modifier_container: GridContainer = $MarginContainer/ModifierContainer


func _ready():
	var dir = Directory.new()
	if dir.open("res://SAVES_folder") == OK:
		dir.list_dir_begin()
	var files = dir.get_next()
	while files != "":
		if not dir.current_is_dir():
			print(files, " B4 LOADING")
		files = dir.get_next()
