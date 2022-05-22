extends WeaponHitbox

onready var sprite: Sprite = $Sprite

var rock_sprites: Array = [
	"res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard_1.png",
	"res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard_2.png",
	"res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard_3.png",
	"res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard_4.png",
	"res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard_5.png",
	"res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard_6.png",
	"res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard_7.png",
	"res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard_8.png",
]


func _ready():
	randomize()
	sprite.rotate(1.5708)
	sprite.set_texture(load(rock_sprites[randi() % 7 + 1]))
