/obj/structure/tank_part/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir, armour_penetration = 0)
	. = ..()
	if(!.)
		return
	
	health -= damage_amount
	if(health <= 0)
		qdel(src)
		return
	
	update_icon()

/obj/structure/tank_part/update_icon()
	. = ..()
	var/health_percent = (health / max_health) * 100
	switch(health_percent)
		if(75 to 100)
			icon_state = initial(icon_state)
		if(50 to 74)
			icon_state = "[initial(icon_state)]_damaged"
		if(25 to 49)
			icon_state = "[initial(icon_state)]_heavily_damaged"
		if(0 to 24)
			icon_state = "[initial(icon_state)]_critical"

/obj/structure/tank_core/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir, armour_penetration = 0)
	. = ..()
	if(!.)
		return
	
	if(health <= 0)
		// When core is destroyed, the entire tank is destroyed
		for(var/obj/structure/tank_part/P in parts)
			qdel(P)
		if(driver)
			driver.forceMove(get_turf(src))
			driver = null
		qdel(src)
		return

/obj/structure/tank_track/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir, armour_penetration = 0)
	. = ..()
	if(!.)
		return
	
	if(health <= 0)
		// When track is destroyed, check tank integrity
		if(core && istype(core, /obj/structure/tank_core))
			var/obj/structure/tank_core/tank_core = core
			tank_core.check_integrity() 