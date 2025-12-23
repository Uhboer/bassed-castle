/**
 * Look Down HUD object
 * Allows looking down and flying down when the can_fly variable is set
 */

/atom/movable/screen/lookdown
	name = "look down"
	icon = 'modular_septic/icons/hud/quake/screen_quake.dmi'
	icon_state = "act_lookdown"
	screen_loc = ui_lookdown

/atom/movable/screen/lookdown/Click(location, control, params)
	. = ..()
	var/list/modifiers = params2list(params)
	if(isliving(usr))
		var/mob/living/user = usr
		
		// Handle right-click to swim down in liquids or fly down if can_fly is set
		if(modifiers["right"] || modifiers["alt"])
			// Check if we can fly
			if(user.can_fly)
				user.fly_down()
				return TRUE
				
			// Check if we're in deep water
			var/turf/T = get_turf(user)
			if(T?.liquids?.liquid_state >= LIQUID_STATE_WAIST)
				user.down() // Attempt to swim down
			return TRUE // Return TRUE to prevent look_down() from being called on right-click
		
		// Normal left-click for looking down or flying down
		if(user.can_fly)
			user.fly_down()
		else
			user.look_down()

/**
 * Fly downward to the Z-level below
 * Only works if can_fly is TRUE
 */
/mob/living/proc/fly_down()
	if(!can_fly)
		return
	
	var/turf/current = get_turf(src)
	var/turf/below = get_step_multiz(current, DOWN)
	
	if(!below)
		to_chat(src, span_warning("There's nothing below me!"))
		return
	
	// Check if the turf below is valid for flying into
	if(below.density)
		to_chat(src, span_warning("Something is blocking my way down!"))
		return
	
	// Move down
	if(zMove(DOWN, TRUE, FALSE))
		forceMove(below)
		to_chat(src, span_notice("I fly downward."))
	
	// Play a sound effect for flying
//	playsound(src, 'sound/effects/whoosh.ogg', 50, TRUE)
	
	// Add some visual effect
//	var/obj/effect/temp_visual/flying_effect = new /obj/effect/temp_visual/dir_setting/jetpack_flight(get_turf(src), dir)
//	QDEL_IN(flying_effect, 20)

/*
// Update the tooltip to indicate swimming is possible
/atom/movable/screen/lookdown/MouseEntered(location, control, params)
	. = ..()
	if(isliving(usr))
		var/mob/living/user = usr
		var/turf/T = get_turf(user)
		if(T?.liquids?.liquid_state >= LIQUID_STATE_WAIST)
			swimming = TRUE
			name = "look down/swim down"
			maptext = "<span style='color: cyan'>Right-click to swim down</span>"
		else
			swimming = FALSE
			name = "look down"
			maptext = null

/atom/movable/screen/lookdown/MouseExited(location, control, params)
	. = ..()
	maptext = null
*/

// Override zMove to prevent falling when can_fly is true