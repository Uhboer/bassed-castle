/atom/movable/screen/lookup
	name = "look up"
	icon = 'modular_septic/icons/hud/quake/screen_quake.dmi'
	icon_state = "act_lookup"
	screen_loc = ui_lookup
//	var/swimming = FALSE

/atom/movable/screen/lookup/Click(location, control, params)
	. = ..()
	var/list/modifiers = params2list(params)
	if(isliving(usr))
		var/mob/living/user = usr
		
		// Handle right-click to swim up in liquids or fly up if can_fly is set
		if(modifiers["right"] || modifiers["alt"])
			// Check if we can fly
			if(user.can_fly)
				user.fly_up()
				return TRUE
			
			// Check if we're in deep water
			var/turf/T = get_turf(user)
			if(T?.liquids?.liquid_state >= LIQUID_STATE_WAIST)
				user.up() // Attempt to swim up
			return TRUE // Return TRUE to prevent look_up() from being called on right-click
		
		// Normal left-click for looking up or flying up
		user.look_up()

/**
 * Fly upward to the Z-level above
 * Only works if can_fly is TRUE
 */
/mob/living/proc/fly_up()
	if(!can_fly)
		return
	
	var/turf/current = get_turf(src)
	var/turf/above = get_step_multiz(current, UP)
	
	if(!above)
		to_chat(src, span_warning("There's space!"))
		return
	
	// Check if the turf above is valid for flying into
	if(above.density)
		to_chat(src, span_warning("Something is blocking my way up!"))
		return
	
	// Move up
	if(zMove(UP, TRUE, FALSE))
		forceMove(above)
		to_chat(src, span_notice("I fly upward."))
	
	// Play a sound effect for flying
//	playsound(src, 'sound/effects/whoosh.ogg', 50, TRUE)
	
	// Add some visual effect
//	var/obj/effect/temp_visual/flying_effect = new /obj/effect/temp_visual/dir_setting/jetpack_flight(get_turf(src), dir)
//	QDEL_IN(flying_effect, 20)

/*
// Update the tooltip to indicate swimming is possible
/atom/movable/screen/lookup/MouseEntered(location, control, params)
	. = ..()
	if(isliving(usr))
		var/mob/living/user = usr
		var/turf/T = get_turf(user)
		if(T?.liquids?.liquid_state >= LIQUID_STATE_WAIST)
			swimming = TRUE
			name = "look up/swim up"
			maptext = "<span style='color: cyan'>Right-click to swim up</span>"
		else
			swimming = FALSE
			name = "look up"
			maptext = null

/atom/movable/screen/lookup/MouseExited(location, control, params)
	. = ..()
	maptext = null
*/