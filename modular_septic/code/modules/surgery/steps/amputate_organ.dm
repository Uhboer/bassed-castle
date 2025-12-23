//Amputate organ step - for cutting off teeth, fingers, genitals
/datum/surgery_step/amputate_organ
	name = "Amputate organ"
	implements = list(
		TOOL_SCALPEL = 90,
		/obj/item/melee/energy/sword = 65,
		/obj/item/knife = 65,
		/obj/item/shard = 45,
		/obj/item = 45,
	)
	middle_click_step = TRUE
	minimum_time = 16
	maximum_time = 32
	surgery_flags = 0

/datum/surgery_step/amputate_organ/tool_check(mob/user, obj/item/tool, mob/living/carbon/target)
	. = ..()
	if((implement_type == /obj/item) && !(tool.get_sharpness() & SHARP_EDGED))
		return FALSE
	if(istype(tool, /obj/item/reagent_containers))
		return FALSE

/datum/surgery_step/amputate_organ/validate_target(mob/living/target, mob/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/C = target
	var/obj/item/bodypart/BP = C.get_bodypart(user.zone_selected)
	if(!BP)
		return FALSE

	// Check if we can amputate something in this zone
	var/can_amputate = FALSE

	switch(user.zone_selected)
		if(BODY_ZONE_PRECISE_MOUTH)
			// Check for teeth
			var/obj/item/bodypart/mouth/mouth = BP
			if(istype(mouth) && mouth.get_teeth_amount() > 0)
				can_amputate = TRUE
		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
			// Check for fingers
			if(BP && BP.get_digits_amount() > 0)
				can_amputate = TRUE
		if(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			// Check for teeth
			if(BP && BP.get_digits_amount() > 0)
				can_amputate = TRUE
		if(BODY_ZONE_PRECISE_GROIN)
			// Check for genitals
			var/list/genital_organs = C.getorganslotlist(ORGAN_SLOT_PENIS) + C.getorganslotlist(ORGAN_SLOT_VAGINA) + C.getorganslotlist(ORGAN_SLOT_TESTICLES)
			if(length(genital_organs) > 0)
				can_amputate = TRUE
		if(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE)
			// Check for eyes
			var/obj/item/organ/eyes/eye = C.getorganslot(ORGAN_SLOT_EYES)
			if(eye)
				can_amputate = TRUE

	return can_amputate

/datum/surgery_step/amputate_organ/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool)
	var/amputation_target = ""
	switch(target_zone)
		if(BODY_ZONE_PRECISE_MOUTH)
			amputation_target = "tooth"
		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
			amputation_target = "finger"
		if(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			amputation_target = "toe"
		if(BODY_ZONE_PRECISE_GROIN)
			amputation_target = "genital"
		if(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE)
			amputation_target = (target_zone == BODY_ZONE_PRECISE_L_EYE) ? "left eye" : "right eye"

	display_results(user, target, \
		span_notice("I begin to amputate [target]'s [amputation_target]..."), \
		span_notice("[user] begins to amputate [target]'s [amputation_target]."), \
		span_notice("[user] begins to amputate [target]'s [amputation_target]."))
	return SURGERY_SUCCESS

/datum/surgery_step/amputate_organ/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool)
	. = ..()
	var/mob/living/carbon/C = target

	switch(target_zone)
		if(BODY_ZONE_PRECISE_MOUTH)
			// Check what was selected for amputation
			var/obj/item/bodypart/mouth/mouth = C.get_bodypart(target_zone)
			var/obj/item/organ/tongue = C.getorganslot(ORGAN_SLOT_TONGUE)

			// Try to amputate tooth first (if available)
			if(istype(mouth) && mouth.get_teeth_amount() > 0)
				mouth.knock_out_teeth(1)
				mouth.add_pain(15) // Add pain from tooth removal
				display_results(user, target, \
					span_notice("I successfully amputate [target]'s tooth."), \
					span_notice("[user] amputates [target]'s tooth!"), \
					span_notice("[user] amputates [target]'s tooth!"))
				playsound(target, 'modular_septic/sound/gore/flesh1.ogg', 75, 0)
			// Try to amputate tongue (if available and no teeth)
			else if(tongue)
				tongue.Remove(C)
				tongue.forceMove(get_turf(C))
				// Add pain to the mouth bodypart
				var/obj/item/bodypart/mouth/mouth_part = C.get_bodypart(target_zone)
				if(mouth_part)
					mouth_part.add_pain(25) // Add pain from tongue removal
				display_results(user, target, \
					span_notice("I successfully amputate [target]'s tongue."), \
					span_notice("[user] amputates [target]'s tongue!"), \
					span_notice("[user] amputates [target]'s tongue!"))
				playsound(target, 'modular_septic/sound/gore/flesh1.ogg', 75, 0)

		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
			var/obj/item/bodypart/hand_part = C.get_bodypart(target_zone)
			if(hand_part && hand_part.get_digits_amount() > 0)
				hand_part.knock_out_digits(1)
				hand_part.add_pain(20)
				display_results(user, target,
					span_notice("I successfully amputate [target]'s finger."),
					span_notice("[user] amputates [target]'s finger!"),
					span_notice("[user] amputates [target]'s finger!"))
				playsound(target, 'modular_septic/sound/gore/flesh1.ogg', 75, 0)

		if(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			var/obj/item/bodypart/foot_part = C.get_bodypart(target_zone)
			if(foot_part && foot_part.get_digits_amount() > 0)
				foot_part.knock_out_digits(1)
				foot_part.add_pain(20)
				display_results(user, target,
					span_notice("I successfully amputate [target]'s toe."),
					span_notice("[user] amputates [target]'s toe!"),
					span_notice("[user] amputates [target]'s toe!"))
				playsound(target, 'modular_septic/sound/gore/flesh1.ogg', 75, 0)

		if(BODY_ZONE_PRECISE_GROIN)
			// Amputate genital - try to find the most appropriate one
			var/list/genital_organs = C.getorganslotlist(ORGAN_SLOT_PENIS) + C.getorganslotlist(ORGAN_SLOT_VAGINA) + C.getorganslotlist(ORGAN_SLOT_TESTICLES)
			if(length(genital_organs) > 0)
				var/obj/item/organ/genital/genital = genital_organs[1] // Take the first one
				var/genital_name = genital.name
				genital.Remove(C)
				genital.organ_flags |= ORGAN_CUT_AWAY
				genital.forceMove(get_turf(C))
				// Add pain to the groin bodypart
				var/obj/item/bodypart/groin_part = C.get_bodypart(target_zone)
				if(groin_part)
					groin_part.add_pain(50) // Add pain from genital removal
				display_results(user, target, \
					span_notice("I successfully amputate [target]'s [genital_name]."), \
					span_notice("[user] amputates [target]'s [genital_name]!"), \
					span_notice("[user] amputates [target]'s [genital_name]!"))
				playsound(target, 'modular_septic/sound/gore/flesh1.ogg', 75, 0)

		if(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE)
			// Amputate eye
			var/obj/item/organ/eyes/eye = C.getorganslot(ORGAN_SLOT_EYES)
			if(eye)
				var/eye_name = (target_zone == BODY_ZONE_PRECISE_L_EYE) ? "left eye" : "right eye"
				eye.Remove(C)
				eye.forceMove(get_turf(C))
				// Add pain to the head bodypart
				var/obj/item/bodypart/head_part = C.get_bodypart(BODY_ZONE_HEAD)
				if(head_part)
					head_part.add_pain(35) // Add pain from eye removal
				display_results(user, target, \
					span_notice("I successfully amputate [target]'s [eye_name]."), \
					span_notice("[user] amputates [target]'s [eye_name]!"), \
					span_notice("[user] amputates [target]'s [eye_name]!"))
				playsound(target, 'modular_septic/sound/gore/flesh1.ogg', 75, 0)

	return SURGERY_SUCCESS
