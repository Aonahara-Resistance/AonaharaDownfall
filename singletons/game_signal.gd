extends Node

signal dash_started(character)
signal dash_ended(character)

signal skill_channel_started(duration)

signal modifier_applied(character)
signal modifier_reset(character)

signal died

signal level_loaded(destination, target_node)
signal level_loaded_with_destination(destination, target_node)
signal level_entered
signal level_restarted(destination, target_node)

signal death_continue_button_pressed

signal party_member_change_requested(index)
signal party_member_changed(character)
signal party_member_died
signal party_spawned(active_character)

signal skill_one_pressed
signal skill_two_pressed
signal skill_cooldown_changed(character)

signal health_changed(character)
signal stamina_changed(character)

signal reset_modifier_button_pressed
signal reset_stats_button_pressed
signal inf_health_button_pressed(state)
signal inf_stamina_button_pressed(state)
signal modifier_item_button_pressed(modifier)

signal main_menu_button_pressed

signal warp_interacted
