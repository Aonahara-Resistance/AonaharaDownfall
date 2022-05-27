extends CanvasLayer

onready var modifier_container: GridContainer = $Dialog/MarginContainer/ModifierContainer
onready var dialog: PopupDialog = $Dialog
export var modifier_item_path: PackedScene


func _ready():
	for item in get_dir_contents()[0]:
		if ".tscn" in item && !"effect" in item:
			var a = modifier_item_path.instance()
			var modifier_item: Modifier = load(item).instance()
			a.texture_normal = modifier_item.buff_icon
			a.modifier = item
			a.get_node("Label").text = modifier_item.buff_name
			if modifier_item.type == Modifier.Types.Buff:
				a.get_node("Label").modulate = Color(0, 1, 0)
			modifier_container.add_child(a)


func get_dir_contents() -> Array:
	var files = []
	var directories = []
	var dir = Directory.new()

	if dir.open("res://status/modifiers") == OK:
		dir.list_dir_begin(true, false)
		_add_dir_contents(dir, files, directories)
	else:
		push_error("An error occurred when trying to access the path.")

	return [files, directories]


func _add_dir_contents(dir: Directory, files: Array, directories: Array):
	var file_name = dir.get_next()

	while file_name != "":
		var path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir():
			var subDir = Directory.new()
			subDir.open(path)
			subDir.list_dir_begin(true, false)
			directories.append(path)
			_add_dir_contents(subDir, files, directories)
		else:
			files.append(path)

		file_name = dir.get_next()

	dir.list_dir_end()
