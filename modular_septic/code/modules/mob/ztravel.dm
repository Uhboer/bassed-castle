/// Move a mob between z levels, if it's valid to move z's on this turf
/mob/zMove(dir, feedback = FALSE, ventcrawling = FALSE)
	if(dir != UP && dir != DOWN)
		return FALSE
	if(incapacitated())
		if(feedback)
			to_chat(src, span_warning("I can't do that right now!"))
		return FALSE
	var/turf/target = get_step_multiz(src, dir)
	if(!istype(target))
		if(feedback)
			to_chat(src, span_warning("There's nowhere to go in that direction!"))
		return FALSE
	if(!canZMove(dir, target) && !ventcrawling)
		if(feedback)
			to_chat(src, span_warning("I can't move there!"))
		return FALSE
	if(!ventcrawling) //let this be handled in atmosmachinery.dm
		forceMove(target)
	else
		var/obj/machinery/atmospherics/pipe = loc
		pipe.relaymove(src, dir)
	return TRUE

/// Moves a mob upwards in z level
/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(HAS_TRAIT_FROM(src, TRAIT_MOVE_FLOATING, CLINGING_TRAIT))
		to_chat(src, span_warning("Can't move while climbing."))
		return

	// Check if we are in liquid
	if(isliving(src))
		var/mob/living/living_mob = src
		if(ishuman(living_mob))
			var/mob/living/carbon/human/human_mob = living_mob
			if(!incapacitated())
				// Try to swim up if we're in liquid
				var/turf/closed/waller = get_step_multiz(src, UP)
				if(istype(waller))
					to_chat(src, span_warning("I can't surface here."))
					return
				
				var/turf/open/floore = get_step_multiz(src, UP)
				var/turf/open/floord = get_turf(src)
				
				if(!istype(floore) || !istype(floord))
					// Standard Z-level movement if we're not in liquid
					var/turf/current_turf = get_turf(src)
					var/turf/above_turf = SSmapping.get_turf_above(current_turf)
					var/ventcrawling_mob = HAS_TRAIT(src, TRAIT_MOVE_VENTCRAWLING)

					if(above_turf && !ventcrawling_mob && (can_zFall(above_turf, 1, current_turf, DOWN) && (above_turf.can_zFall(src, 1, current_turf))))
						to_chat(src, span_warning("I can't go up."))
						return

					if(zMove(UP, TRUE, ventcrawling_mob))
						to_chat(src, span_notice("I move upwards."))
					return
				
				// Check for liquids
				if(!floore.liquids || (floore.liquids.liquid_state < LIQUID_STATE_PUDDLE))
					// No liquid above
					if(zMove(UP, TRUE, FALSE))
						to_chat(src, span_notice("I move upwards."))
					return
				
				if(!floord.liquids || (floord.liquids.liquid_state <= LIQUID_STATE_FULLTILE))
					// No liquid in current tile or not enough
					if(zMove(UP, TRUE, FALSE))
						to_chat(src, span_notice("I move upwards."))
					return
				
				// Swimming up logic
				if(human_mob.next_move > world.time)
					playsound_local(get_turf(src), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
					return
				
				var/fatigueloss = human_mob.getFatigueLoss()
				if(fatigueloss >= SPRINT_MAX_FATIGUELOSS)
					to_chat(src, span_warning("I'm too tired to swim!"))
					playsound_local(get_turf(src), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
					return
				
				var/encumbrance_penalty = 0
				var/encumbrance_cancer = 0
				switch(human_mob.encumbrance)
					if(ENCUMBRANCE_LIGHT)
						encumbrance_penalty = 2
					if(ENCUMBRANCE_MEDIUM)
						encumbrance_penalty = 5
						encumbrance_cancer = 5
					if(ENCUMBRANCE_HEAVY)
						encumbrance_penalty = 10
						encumbrance_cancer = 10
					if(ENCUMBRANCE_EXTREME)
						encumbrance_penalty = 15
						encumbrance_cancer = 15
				
				var/diceroll = diceroll(GET_MOB_SKILL_VALUE(human_mob, SKILL_SWIMMING)-encumbrance_cancer, context = DICE_CONTEXT_MENTAL)
				switch(diceroll)
					if(DICE_CRIT_SUCCESS)
						human_mob.adjustFatigueLoss(5 + encumbrance_penalty)
						to_chat(src, span_notice("I swim up perfectly."))
						forceMove(floore)
					if(DICE_SUCCESS)
						human_mob.adjustFatigueLoss(10 + encumbrance_penalty)
						to_chat(src, span_notice("I swim up successfully."))
						forceMove(floore)
					if(DICE_FAILURE)
						human_mob.adjustFatigueLoss(10 + encumbrance_penalty)
						to_chat(src, span_notice("I struggle to swim up."))
						forceMove(floore)
					if(DICE_CRIT_FAILURE)
						human_mob.adjustFatigueLoss(15 + encumbrance_penalty)
						to_chat(src, span_notice("I can't manage to swim up."))
				return
	
	// Default behavior for non-human mobs
	var/turf/current_turf = get_turf(src)
	var/turf/above_turf = SSmapping.get_turf_above(current_turf)
	var/ventcrawling_mob = HAS_TRAIT(src, TRAIT_MOVE_VENTCRAWLING)

	if(above_turf && !ventcrawling_mob && (can_zFall(above_turf, 1, current_turf, DOWN) && (above_turf.can_zFall(src, 1, current_turf))))
		to_chat(src, span_warning("I can't go up."))
		return

	if(zMove(UP, TRUE, ventcrawling_mob))
		to_chat(src, span_notice("I move upwards."))

/// Moves a mob down a z level
/mob/verb/down()
	set name = "Move Downwards"
	set category = "IC"

	if(HAS_TRAIT_FROM(src, TRAIT_MOVE_FLOATING, CLINGING_TRAIT))
		to_chat(src, span_warning("Can't move while climbing."))
		return

	// Check if we are in liquid
	if(isliving(src))
		var/mob/living/living_mob = src
		if(ishuman(living_mob))
			var/mob/living/carbon/human/human_mob = living_mob
			if(!incapacitated())
				// Try to swim down if we're in liquid
				var/turf/closed/waller = get_step_multiz(src, DOWN)
				if(istype(waller))
					to_chat(src, span_warning("I can't dive here."))
					return
				
				var/turf/open/floore = get_step_multiz(src, DOWN)
				var/turf/open/floord = get_turf(src)
				
				if(!istype(floore) || !istype(floord))
					// Standard Z-level movement if we're not in liquid
					var/ventcrawling_mob = HAS_TRAIT(src, TRAIT_MOVE_VENTCRAWLING)
					if(zMove(DOWN, TRUE, ventcrawling_mob))
						to_chat(src, span_notice("I move downwards."))
					return
				
				// Check for liquids
				if(!floore.liquids || (floore.liquids.liquid_state <= LIQUID_STATE_FULLTILE))
					// No liquid below or not enough
					if(zMove(DOWN, TRUE, FALSE))
						to_chat(src, span_notice("I move downwards."))
					return
				
				if(!floord.liquids || (floord.liquids.liquid_state < LIQUID_STATE_PUDDLE))
					// No liquid in current tile
					if(zMove(DOWN, TRUE, FALSE))
						to_chat(src, span_notice("I move downwards."))
					return
				
				// Swimming down logic
				if(human_mob.next_move > world.time)
					playsound_local(get_turf(src), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
					return
				
				var/fatigueloss = human_mob.getFatigueLoss()
				if(fatigueloss >= SPRINT_MAX_FATIGUELOSS)
					to_chat(src, span_warning("I'm too tired to swim!"))
					playsound_local(get_turf(src), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
					return
				
				var/encumbrance_penalty = 0
				switch(human_mob.encumbrance)
					if(ENCUMBRANCE_LIGHT)
						encumbrance_penalty = 2
					if(ENCUMBRANCE_MEDIUM)
						encumbrance_penalty = 5
					if(ENCUMBRANCE_HEAVY)
						encumbrance_penalty = 10
					if(ENCUMBRANCE_EXTREME)
						encumbrance_penalty = 15
				
				var/diceroll = diceroll(GET_MOB_SKILL_VALUE(human_mob, SKILL_SWIMMING), context = DICE_CONTEXT_MENTAL)
				if(diceroll >= DICE_CRIT_SUCCESS)
					human_mob.adjustFatigueLoss(3 + encumbrance_penalty)
					to_chat(src, span_notice("I dive down perfectly."))
					forceMove(floore)
				else if(diceroll >= DICE_SUCCESS)
					human_mob.adjustFatigueLoss(5 + encumbrance_penalty)
					to_chat(src, span_notice("I dive down successfully."))
					forceMove(floore)
				else // DICE_FAILURE or worse
					human_mob.adjustFatigueLoss(10 + encumbrance_penalty)
					to_chat(src, span_notice("I struggle to dive down."))
					forceMove(floore)
				return
				
	// Default behavior for non-human mobs
	var/ventcrawling_mob = HAS_TRAIT(src, TRAIT_MOVE_VENTCRAWLING)
	if(zMove(DOWN, TRUE, ventcrawling_mob))
		to_chat(src, span_notice("I move downwards."))
