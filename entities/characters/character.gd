extends KinematicBody2D
class_name Character

onready var animation: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_mode = animation_tree.get("paramaters/playback")
onready var sprite: Sprite = $Sprite
onready var weapon: Node2D = $Weapon
onready var dash: Dash = $Dash
onready var stamina_timer: Timer = $StaminaTimer
onready var camera: Camera2D = $Camera2D
onready var blinker: Blinker = $Blinker
onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D
onready var sprite_shader_material: ShaderMaterial = sprite.material
onready var battle_timer: Timer = $BattleTimer
onready var interaction_component: InteractionComponent = $InteractionComponent
onready var skills: Node = $Skills
onready var skill_one: Skill = $Skills.get_child(0)
onready var skill_two: Skill = $Skills.get_child(1)
onready var modifiers: Node2D = $Modifiers
onready var state_label: Label = $StateLabel

export var character_name: String
export var character_icon: Resource
export var mirrored_sprite: bool = true

var is_alive: bool = true
var inf_stamina: bool = false
var inf_health: bool = false
var attributes
export var hp: int
export var stamina: int
export var stamina_regen: float
export var acceleration: int
export var max_hp: int
export var extra_hp: int
export var max_speed: int
export var max_stamina: int
export var base_damage: int
export var stamina_regen_rate: int
export var dash_duration: float
export var dash_cooldown: float
export var dash_speed: int
export var friction: float
export var receives_knockback: bool

var active_attributes: Dictionary = {
	"hp": 0,
	"stamina": 0,
	"stamina_regen": 0.0,
	"acceleration": 0,
	"max_hp": 0,
	"max_speed": 0,
	"max_stamina": 0,
	"base_damage": 0,
	"stamina_regen_rate": 0,
	"dash_duration": 0.0,
	"friction": 0.0,
	"receives_knockback": false,
}

var velocity: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var is_in_control: bool = false
var is_focus: bool = false
var is_in_battle: bool = false setget set_is_in_battle, get_is_in_battle
var movement_key: Dictionary = {"up": false, "down": false, "left": false, "right": false}

signal battle_state_changed

## -----------------------------------------------------------------------------
##																Virtual Methods
## -----------------------------------------------------------------------------


func init(
	hp_: int,
	stamina_: int,
	stamina_regen_: float,
	acceleration_: int,
	max_hp_: int,
	extra_hp_: int,
	max_speed_: int,
	max_stamina_: int,
	base_damage_: int,
	stamina_regen_rate_: int,
	dash_duration_: float,
	dash_cooldown_: float,
	dash_speed_: int,
	friction_: float,
	receives_knockback_: bool
) -> void:
	hp = hp_
	stamina = stamina_
	stamina_regen = stamina_regen_
	acceleration = acceleration_
	max_hp = max_hp_
	extra_hp = extra_hp_
	max_speed = max_speed_
	max_stamina = max_stamina_
	base_damage = base_damage_
	stamina_regen_rate = stamina_regen_rate_
	dash_duration = dash_duration_
	dash_cooldown = dash_cooldown_
	dash_speed = dash_speed_
	friction = friction_
	receives_knockback = receives_knockback_
	attributes = CharacterAttributes.new(
		hp,
		stamina,
		stamina_regen,
		max_hp,
		extra_hp,
		max_speed,
		max_stamina,
		base_damage,
		acceleration,
		stamina_regen_rate,
		dash_duration,
		friction,
		receives_knockback
	)


func _ready() -> void:
	if attributes == null:
		attributes = CharacterAttributes.new(
			hp,
			stamina,
			stamina_regen,
			max_hp,
			extra_hp,
			max_speed,
			max_stamina,
			base_damage,
			acceleration,
			stamina_regen_rate,
			dash_duration,
			friction,
			receives_knockback
		)
	modifier_tick()
	_connect_signals()


func _process(_delta):
	modifier_tick()


## -----------------------------------------------------------------------------
##																Input Listeners
## -----------------------------------------------------------------------------


func listen_to_input_direction(event) -> void:
	if event.is_action_pressed("up"):
		movement_key["up"] = true
	if event.is_action_pressed("down"):
		movement_key["down"] = true
	if event.is_action_pressed("left"):
		movement_key["left"] = true
	if event.is_action_pressed("right"):
		movement_key["right"] = true
	if event.is_action_released("up"):
		movement_key["up"] = false
	if event.is_action_released("down"):
		movement_key["down"] = false
	if event.is_action_released("left"):
		movement_key["left"] = false
	if event.is_action_released("right"):
		movement_key["right"] = false


func listen_to_attacks(event) -> void:
	if event.is_action_pressed("light_attack"):
		equiped_weapon().light_attack()
	if event.is_action_released("light_attack"):
		equiped_weapon().light_attack_release()
	if event.is_action_pressed("heavy_attack"):
		equiped_weapon().heavy_attack()
	if event.is_action_released("heavy_attack"):
		equiped_weapon().heavy_attack_release()


func listen_to_focus_mode(event) -> void:
	if event.is_action_pressed("focus"):
		is_focus = true
	if event.is_action_released("focus"):
		is_focus = false


func listen_to_skills(event) -> void:
	if event.is_action_pressed("first_skill"):
		skill_one.activate_skill()
	if event.is_action_pressed("second_skill"):
		skill_two.activate_skill()


func listen_to_party_change(event) -> void:
	if event.is_action_pressed("party1") && Party.party_members.size() >= 1 && is_in_control:
		Party.change_party_member(0)
	if event.is_action_pressed("party2") && Party.party_members.size() >= 2 && is_in_control:
		Party.change_party_member(1)
	if event.is_action_pressed("party3") && Party.party_members.size() >= 3 && is_in_control:
		Party.change_party_member(2)
	if event.is_action_pressed("party4") && Party.party_members.size() >= 4 && is_in_control:
		Party.change_party_member(3)


func listen_to_dash(event) -> void:
	if event.is_action_pressed("dash") && is_in_control:
		dash.start_dash(self)
		set_stamina_regen_timer(get_attribute("stamina"))
		stamina_timer.start()


## -----------------------------------------------------------------------------
##																Movement Stuff
## -----------------------------------------------------------------------------


func move(delta: float) -> void:
	var input_direction: Vector2 = get_input_direction()
	velocity = move_and_slide(velocity)
	velocity += (get_attribute("acceleration") * input_direction * delta * 60)
	velocity = lerp(velocity, Vector2.ZERO, get_attribute("friction"))
	velocity = velocity.clamped(get_attribute("max_speed"))


func _on_Dash_started() -> void:
	_whiten_sprite(dash_duration)
	_enable_iframes(dash_duration)


## -----------------------------------------------------------------------------
##																Combat Stuff
## -----------------------------------------------------------------------------


func equiped_weapon():
	if !weapon.get_children().empty():
		return weapon.get_child(0)
	else:
		# TDOO: Handle if weapon is not equiped
		return null


func get_is_in_battle() -> bool:
	return is_in_battle


func set_is_in_battle(new_state) -> void:
	if new_state == true:
		battle_timer.start()
	is_in_battle = new_state
	emit_signal("battle_state_changed")


func listen_knockback(delta) -> void:
	if get_attribute("receives_knockback"):
		knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
		knockback = move_and_slide(knockback)


func apply_knockback(direction, strength) -> void:
	knockback = (direction.direction_to(self.global_position) * strength)


func _on_Hurtbox_area_entered(hitbox) -> void:
	if hitbox is WeaponHitbox:
		set_is_in_battle(false)
		blinker.start_blinking(sprite)
		_whiten_sprite(0.3)
		_take_damage(hitbox.damage)
		apply_knockback(hitbox.global_position, hitbox.knockback_strength)
		_enable_iframes(1.0)


func regenerate_stamina() -> void:
	while get_attribute("stamina") < get_attribute("max_stamina") && stamina_timer.is_stopped():
		set_attribute("stamina", get_attribute("stamina") + 1)
		yield(get_tree().create_timer(get_attribute("stamina_regen_rate")), "timeout")


func get_stamina_timer() -> float:
	return stamina_timer.time_left


func _on_StaminaTimer_timeout() -> void:
	regenerate_stamina()


func set_stamina_regen_timer(current_stamina) -> void:
	if current_stamina == 0:
		stamina_timer.wait_time = get_attribute("stamina_regen") * 2
	else:
		stamina_timer.wait_time = get_attribute("stamina_regen")


func _take_damage(damage: int) -> void:
	if inf_health:
		set_attribute("hp", get_attribute("hp") - damage * 0)
	else:
		set_attribute("hp", get_attribute("hp") - damage)
	if get_attribute("hp") < 0:
		set_attribute("hp", 0)
	_die_check(get_attribute("hp"))


func _enable_iframes(duration: float) -> void:
	hurtbox.set_deferred("disabled", true)
	yield(get_tree().create_timer(duration), "timeout")
	hurtbox.disabled = false


func _die_check(current_hp: int) -> void:
	if current_hp <= 0:
		die()


func die() -> void:
	is_alive = false
	Party.tactical_character_hiding(Party.current_character())
	Party.switch_to_available_member()


func reset_stats() -> void:
	set_attribute("hp", attributes.stateless_attributes.max_hp)
	set_attribute("stamina", attributes.stateless_attributes.max_stamina)


func _on_BattleTimer_timeout():
	set_is_in_battle(false)


## -----------------------------------------------------------------------------
##															Modifier Stuff
## -----------------------------------------------------------------------------


func get_attribute(attribute: String):
	if active_attributes.has(attribute):
		modifier_tick()
		return active_attributes[attribute]
	else:
		print("Attribute does not exist")
		print(attribute)
		return 0


func set_attribute(attribute: String, new_value):
	if attributes.stateful_attributes.has(attribute):
		attributes.stateful_attributes[attribute] = new_value
	else:
		attributes.stateless_attributes[attribute] = new_value
	modifier_tick()


func apply_modifier(new_modifier: Modifier) -> void:
	var modifier_list: Array = get_modifiers()
	for modifier in modifier_list:
		if modifier.buff_name == new_modifier.buff_name:
			modifier.reset_duration()
			return
	modifiers.add_child(new_modifier)
	modifier_tick()
	new_modifier.modify_stateful(self)
	Hud.update_modifier_indicator()


func reset_modifier() -> void:
	var modifier_list: Array = get_modifiers()
	for modifier in modifier_list:
		modifier.get_parent().remove_child(modifier)
	Hud.update_modifier_indicator()


func get_modifiers() -> Array:
	return modifiers.get_children()


func modifier_tick() -> void:
	var res: Dictionary = attributes.stateless_attributes.duplicate()
	var modifier_list: Array = get_modifiers()
	for modifier in modifier_list:
		res = modifier.modify_stateless(res)
	active_attributes = {
		"hp": attributes.stateful_attributes.hp + res.extra_hp,
		"stamina": attributes.stateful_attributes.stamina,
		"stamina_regen": res.stamina_regen,
		"acceleration": res.acceleration,
		"max_hp": res.max_hp,
		"max_speed": res.max_speed,
		"max_stamina": res.max_stamina,
		"base_damage": res.base_damage,
		"stamina_regen_rate": res.stamina_regen_rate,
		"dash_duration": res.dash_duration,
		"friction": res.friction,
		"receives_knockback": res.receives_knockback,
	}


## -----------------------------------------------------------------------------
##																	Miscs
## -----------------------------------------------------------------------------


func get_mouse_direction() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()


func get_input_direction() -> Vector2:
	var input_direction: Vector2 = Vector2.ZERO
	input_direction.x = (int(movement_key["right"]) - int(movement_key["left"]))
	input_direction.y = (int(movement_key["down"]) - int(movement_key["up"]))
	input_direction = input_direction.normalized()
	if is_in_control:
		return input_direction
	else:
		return Vector2.ZERO


func sprite_control() -> void:
	var mouse_direction: Vector2 = get_mouse_direction()
	_flip_interaction_detection(mouse_direction)
	_control_weapon_direction(mouse_direction)
	_flip_character_sprite(mouse_direction)


func _flip_interaction_detection(mouse_direction):
	if mouse_direction.x < 0 and sign(interaction_component.scale.x) != sign(mouse_direction.x):
		interaction_component.scale.x *= -1
	elif mouse_direction.x > 0 and sign(interaction_component.scale.x) != sign(mouse_direction.x):
		interaction_component.scale.x *= -1


func _flip_character_sprite(mouse_direction):
	if mirrored_sprite:
		if mouse_direction.x < 0 and sign(sprite.scale.x) != sign(mouse_direction.x):
			sprite.scale.x *= -1
		elif mouse_direction.x > 0 and sign(sprite.scale.x) != sign(mouse_direction.x):
			sprite.scale.x *= -1


func _control_weapon_direction(mouse_direction):
	weapon.rotation = mouse_direction.angle()
	if mouse_direction.x < 0 and sign(weapon.scale.y) != sign(mouse_direction.x):
		weapon.scale.y *= -1
	elif mouse_direction.x > 0 and sign(weapon.scale.y) != sign(mouse_direction.x):
		weapon.scale.y *= -1
	if mouse_direction.y < 0 and sign(weapon.z_index) != sign(mouse_direction.y):
		weapon.z_index *= -1
	elif mouse_direction.y > 0 and sign(weapon.z_index) != sign(mouse_direction.y):
		weapon.z_index *= -1


func _whiten_sprite(duration: float):
	sprite_shader_material.set_shader_param("whiten", true)
	yield(get_tree().create_timer(duration), "timeout")
	sprite_shader_material.set_shader_param("whiten", false)


# warning-ignore-all:return_value_discarded
func _connect_signals():
	dash.connect("dash_started", self, "_on_Dash_started")
