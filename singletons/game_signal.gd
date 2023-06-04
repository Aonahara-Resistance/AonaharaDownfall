extends Node

signal dash_started(character)
signal dash_ended(character)

signal skill_channel_started(duration)

signal modifier_applied(character)
signal modifier_reset(character)
signal modifier_ended(character)

signal died

signal level_loaded(destination, target_node)
signal level_loaded_with_destination(destination, target_node)
signal level_entered
signal level_restarted(destination, target_node)

signal death_continue_button_pressed

signal party_member_change_requested(index)
signal party_member_changed(character)
signal party_member_died
signal party_spawned(active_character, party_members, reserve_member)

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

signal party_order_changed(old_index, new_index)
signal deploy_reserve_requested(index)
signal deploy_reserve_request_sent(index)
signal deploy_reserve_cancelled
signal reserve_deployed(party_members, reserve)
signal remove_party_member_requested(index)
signal party_member_removed(party_members, reserve)

signal cutscene_started
signal cutscene_ended(position)

signal modifier_ticked
