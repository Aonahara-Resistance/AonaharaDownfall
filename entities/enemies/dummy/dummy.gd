extends Enemy


func _on_Hurtbox_area_entered(hitbox) -> void:
	if hitbox is WeaponHitbox:
		animation.play("hurt")
		var final_damage = _randomize_damage(hitbox.total_damage())
		apply_knockback(hitbox.global_position, hitbox.knockback_strength)
		Shake.shake(1.0, 0.2, 1)
		spawn_hit_effect()
		spawn_damage_indicator(final_damage)
