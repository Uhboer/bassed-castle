/mob/living/carbon/human/examine(mob/user)
	//hehe
	if(user.zone_selected in list(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE))
		user.handle_eye_contact(src)
//	var/mob/living/carbon/human/human_user = user
//	var/get_aroused = FALSE
//	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
//		get_aroused = TRUE

//	var/t_he = p_they()
//	if(user == src)
//		t_he = "i"

	var/sanitized_chat_color = sanitize_hexcolor(chat_color)
	var/fancy_name = name
	if(chat_color)
		fancy_name = "<span style='color: [sanitized_chat_color];text-shadow: 0 0 3px [sanitized_chat_color];'>[name]</span>"
	var/obscure_name = FALSE
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	var/obscure_species = (skipface || obscure_name || (name == "Unknown"))
	var/obscured = check_obscured_slots()
	var/distance = get_dist(user, src)
	if(isliving(user))
		var/mob/living/living_user = user
		if(HAS_TRAIT(living_user, TRAIT_PROSOPAGNOSIA))
			obscure_name = TRUE
			obscure_species = TRUE

	. = list()
	if(obscure_species)
		. += "<span class='info'>Oh, this is <EM>[obscure_name ? "Unknown" : fancy_name]</EM>, <EM>Human</EM>!</span>"
		if(HAS_TRAIT(src, TRAIT_FRAGGOT))
			if(!(obscured & ITEM_SLOT_NECK))
				if(!wear_neck)
					var/necky = get_bodypart_nostump(BODY_ZONE_PRECISE_NECK)
					if(!LAZYLEN(clothingonpart(necky)))
						. += span_flashingdanger("[emoji_parse(":fatal:")] [uppertext(src.name)] IS A FATAL! IT'S SHOULD BE KILLED!")
	else
		. += "<span class='info'>Oh, this is <EM>[obscure_name ? "Unknown" : fancy_name]</EM>, <EM>[dna.species.name]</EM>! It's race is <span style='color:purple'><EM>[racestory]</EM></span>!</span>"
		if(!teeth_hidden)
			. += "<span style='color:red'>There is a suspicious grimace!</span>"
		if(HAS_TRAIT(src, TRAIT_FRAGGOT))
			if(!(obscured & ITEM_SLOT_NECK))
				if(!wear_neck)
					var/necky = get_bodypart_nostump(BODY_ZONE_PRECISE_NECK)
					if(!LAZYLEN(clothingonpart(necky)))
						. += span_flashingdanger("[emoji_parse(":fatal:")] [uppertext(src.name)] IS A FATAL! IT'S SHOULD BE KILLED!")
	. += "<br><hr class='infohr'>"

	//TODO: Add a social recordkeeping mechanic and datum to keep tracker of who the viewer knows
	//This will do it for now, i guess
//	var/visible_job = get_assignment(if_no_id = "", if_no_job = "", hand_first = FALSE)
	var/job_message = "<span class='info'>"
	if(truerole)
		if(!skipface)
			if(!special_zvanie)
				job_message += "I'm sure, it is <b>[truerole]</b>."
			else
				job_message += "I'm sure, it is <b>[truerole]</b>. And wow, it is <span class='yellowteamradio'><b>[special_zvanie]</b></span>"
			if(pod_faction)
				var/faction_color = "green"
				if(!user.pod_faction || user.pod_faction != pod_faction)
					faction_color = "red"
				job_message += " It is a member of a <b><span style='color:[faction_color];'>[pod_faction]</span></b> faction."
		else
			job_message += "I don't know it's role or faction."
	if(!skipface)
		. += "<span class='artery'>By age, it looks [looks_age] years old.</span>"
		if(HAS_TRAIT(src, TRAIT_CHILDO))
			. += "<span class='artery'>This is a baby!</span>"
		if((HAS_TRAIT(src, TRAIT_DMT)) && (!HAS_TRAIT(src, TRAIT_HIDDEN_DMT)))
			. += "<span class='meaty_meat'>THIS IS DMT! THIS MUST BE KILLED!</span>"
	. += job_message
/*
	var/visible_gender = t_he
	switch(visible_gender)
		if("he", "she", "am")
			visible_gender = "This is [get_aged_gender(TRUE, TRUE)]."
		if("i")
			visible_gender = "This is [get_aged_gender(TRUE, TRUE)]."
		else
			if(user != src)
				visible_gender = "I don't know his gender."
			else
				visible_gender = "I don't know my gender."
	. += visible_gender
*/
	// Display body type based on gender
	var/body_type_text = ""
	if(body_type == MALE)
		body_type_text = "It's body appears <b>masculine</b>."
	else if(body_type == FEMALE)
		body_type_text = "It's body appears <b>feminine</b>."
	else
		body_type_text = "It's body type is <b>weird</b>."
	. += body_type_text

	//lips
	var/obj/item/bodypart/mouth = get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(mouth)
		var/list/covered_lips = list()
		for(var/component_type in GLOB.creamed_types)
			var/datum/component/creamed/creampie = GetComponent(component_type)
			if(creampie?.cover_lips)
				covered_lips += creampie.cover_lips
		if(HAS_TRAIT(src, TRAIT_SSD_INDICATOR))
			covered_lips |= "<span style='color: #[COLOR_BLUE_WATER];'>drool</span>"
		if(LAZYLEN(covered_lips))
			. += "Oh, it's lips are covered with [english_list(covered_lips)]!"
		if(belief == "Hadot")
			. += "У него усы ебанутые."

	//head
	if(head && !(obscured & ITEM_SLOT_HEAD) && !(head.item_flags & EXAMINE_SKIP) && !(head.item_flags & ABSTRACT))
		if (head.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[head.get_examine_string(user)]</b></span> on it's head."
		else
			. += "It has <b>[head.get_examine_string(user)]</b> on it's head."
	//uniform
	if(w_uniform && !(obscured & ITEM_SLOT_ICLOTHING) && !(w_uniform.item_flags & EXAMINE_SKIP) && !(w_uniform.item_flags & ABSTRACT))
		//accessory
		var/accessory_msg
		if(istype(w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.attached_accessory && !(U.attached_accessory.item_flags & EXAMINE_SKIP) && !(U.attached_accessory.item_flags & ABSTRACT))
				accessory_msg += " with <b>[U.attached_accessory.get_examine_string(user, FALSE)]</b>"

		if (w_uniform.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[w_uniform.get_examine_string(user)]</b></span>[accessory_msg]."
		else
			. += "It has <b>[w_uniform.get_examine_string(user)]</b>[accessory_msg]."

	//suit/armor
	if(wear_suit && !(obscured & ITEM_SLOT_OCLOTHING) && !(wear_suit.item_flags & EXAMINE_SKIP) && !(wear_suit.item_flags & ABSTRACT))
		if (wear_suit.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[wear_suit.get_examine_string(user)]</b></span>."
		else
			. += "It has <b>[wear_suit.get_examine_string(user)]</b>."

	//pants
	if(pants && !(obscured & ITEM_SLOT_PANTS) && !(pants.item_flags & EXAMINE_SKIP) && !(pants.item_flags & ABSTRACT))
		if (pants.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[pants.get_examine_string(user)]</b></span> on it's legs."
		else
			. += "It has <b>[pants.get_examine_string(user)]</b> on it's legs."

	//oversuit
	if(oversuit && !(obscured & ITEM_SLOT_OVERSUIT) && !(oversuit.item_flags & EXAMINE_SKIP) && !(oversuit.item_flags & ABSTRACT))
		if (oversuit.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[oversuit.get_examine_string(user)]</b></span>."
		else
			. += "It has <b>[oversuit.get_examine_string(user)]</b>."

	//back
	if(back && !(obscured & ITEM_SLOT_BACKPACK) && !(back.item_flags & EXAMINE_SKIP) && !(back.item_flags & ABSTRACT))
		if (back.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[back.get_examine_string(user)]</b></span> on it's spine."
		else
			. += "It has <b>[back.get_examine_string(user)]</b> on it's spine."

	//back 2 storage boogaloo
	if(s_store && !(obscured & ITEM_SLOT_SUITSTORE) && !(s_store.item_flags & EXAMINE_SKIP) && !(s_store.item_flags & ABSTRACT))
		if (s_store.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[s_store.get_examine_string(user)]</b></span> on it's spine."
		else
			. += "It has <b>[s_store.get_examine_string(user)]</b> on it's spine."

	//wrists
	if(wrists && !(obscured & ITEM_SLOT_WRISTS) && !(wrists.item_flags & EXAMINE_SKIP) && !(wrists.item_flags & ABSTRACT))
		if (wrists.rara > 50)
			. += "It has <span style='color:purple'>♦ [wrists.get_examine_string(user)]</span> on it's wrists."
		else
			. += "It has [wrists.get_examine_string(user)] on it's wrists."
	//hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT) && !(I.item_flags & EXAMINE_SKIP))
			. += "It holds <b>[I.get_examine_string(user)]</b> in it's [get_held_index_name(get_held_index_of_item(I))]."

	//gloves
	if(!(obscured & ITEM_SLOT_GLOVES))
		if(gloves && !(gloves.item_flags & EXAMINE_SKIP) && !(gloves.item_flags & ABSTRACT))
			if (gloves.rara > 50)
				. += "It has <span style='color:purple'>♦ <b>[gloves.get_examine_string(user)]</b></span> on its hands."
			else
				. += "It has <b>[gloves.get_examine_string(user)]</b> on its hands."
		else if(!(obscured & ITEM_SLOT_GLOVES) && num_hands)
			if(blood_in_hands)
				. += "<span class='warning'>It has <span class='bloody'><b>bloody</b></span> [num_hands > 1 ? "hands" : "hand"]!</span>"
			if(shit_in_hands)
				. += "<span class='warning'>It has <span class='shitty'><b>shitty</b></span> [num_hands > 1 ? "hands" : "hand"]!</span>"
			if(cum_in_hands)
				. += "<span class='warning'>It has <span class='cummy'><b>cummy</b></span> [num_hands > 1 ? "hands" : "hand"]!</span>"
			if(femcum_in_hands)
				. += "<span class='warning'>It has <span class='femcummy'><b>femcummy</b></span> [num_hands > 1 ? "hands" : "hand"]!</span>"

	//belt
	if(belt && !(obscured & ITEM_SLOT_BELT) && !(belt.item_flags & EXAMINE_SKIP))
		if (belt.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[belt.get_examine_string(user)]</b></span> on it's belt."
		else
			. += "It has <b>[belt.get_examine_string(user)]</b> on it's belt."

	//shoes
	if(shoes && !(obscured & ITEM_SLOT_FEET)  && !(shoes.item_flags & EXAMINE_SKIP))
		if (shoes.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[shoes.get_examine_string(user)]</b></span> on it's feet."
		else
			. += "It has <b>[shoes.get_examine_string(user)]</b> on it's feet."

	//mask
	if(wear_mask && !(obscured & ITEM_SLOT_MASK) && !(wear_mask.item_flags & EXAMINE_SKIP))
		if (wear_mask.rara > 50)
			. += "It has <span style='color:purple'>♦ [wear_mask.get_examine_string(user)]</span> on it's face."
		else
			. += "It has [wear_mask.get_examine_string(user)] on it's face."

	if(wear_neck && !(obscured & ITEM_SLOT_NECK) && !(wear_neck.item_flags & EXAMINE_SKIP))
		if (wear_neck.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[wear_neck.get_examine_string(user)]</b></span> on it's neck."
		else
			. += "It has <b>[wear_neck.get_examine_string(user)]</b> on it's neck."

	//eyes
	if(!(obscured & ITEM_SLOT_EYES))
		if(glasses && !(glasses.item_flags & EXAMINE_SKIP))
			if (glasses.rara > 50)
				. += "It has <span style='color:purple'>♦ <b>[glasses.get_examine_string(user)]</b></span> on it's eyes."
			else
				. += "It has <b>[glasses.get_examine_string(user)]</b> on it's eyes."
		if(HAS_TRAIT(src, TRAIT_UNNATURAL_RED_GLOWY_EYES))
			. += "<span class='warning'><B>It has crazy eyes!</B></span>"
		if(HAS_TRAIT(src, TRAIT_FLUORIDE_STARE))
			. += "<span class='animated'>It has a spatial view...</B></span>"
		if(HAS_TRAIT(src, TRAIT_BLOODARN))
			. += "<span class='warning'>Giant eyes.</B></span>"
		if(HAS_TRAIT(src, TRAIT_HORROR_STARE))
			. += "<span class='animated'>У него глубокий, страшный взгляд.</B></span>"
		if(belief == "Gutted")
			. += "<span class='warning'>У него змеиный зрачок.</B></span>"

	//left ear
	if(ears && !(obscured & ITEM_SLOT_LEAR) && !(ears.item_flags & EXAMINE_SKIP))
		if (ears.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[ears.get_examine_string(user)]</b></span> on it's left ear."
		else
			. += "It has <b>[ears.get_examine_string(user)]</b> on it's left ear."

	//right ear
	if(ears_extra && !(obscured & ITEM_SLOT_REAR) && !(ears_extra.item_flags & EXAMINE_SKIP))
		if (ears_extra.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[ears_extra.get_examine_string(user)]</b></span> on it's right ear."
		else
			. += "It has <b>[ears_extra.get_examine_string(user)]</b> on it's right ear."

	//ID
	if(wear_id && !(wear_id.item_flags & EXAMINE_SKIP))
		if (wear_id.rara > 50)
			. += "It has <span style='color:purple'>♦ <b>[wear_id.get_examine_string(user)]</b></span>."
		else
			. += "It has <b>[wear_id.get_examine_string(user)]</b>."

	//Status effects
	var/list/status_examines = status_effect_examines()
	if (length(status_examines))
		. += status_examines

	//Jitters
	switch(jitteriness)
		if(300 to INFINITY)
			. += "<span class='warning'><B>It's having convulsions!</B></span>"
		if(100 to 300)
			. += "<span class='warning'>It's shaking.</span>"

	if(pulling)
		switch(grab_state)
			if(GRAB_PASSIVE)
				. += "<span class='notice'>It's is pulling [pulling].</span>"
			if(GRAB_AGGRESSIVE)
				. += "<span class='warning'>It's grabbed [pulling].</span>"
			if(GRAB_NECK)
				. += "<span class='danger'>It's grabbed [pulling] by neck!</span>"
			if(GRAB_KILL)
				. += "<span class='danger'><b>It's strangling [pulling]!</b></span>"

	var/list/msg = list()
	//stores stumps
	var/list/stumps = list()
	//stores missing limbs
	var/list/missing = get_missing_limbs()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.is_stump())
			msg += "<span class='dead'><b>It's [parse_zone(bodypart.body_zone)] is just a stump!</b></span>"
			//stumps count as missing
			missing += bodypart.body_zone
			stumps += bodypart.body_zone
		if(bodypart.max_teeth)
			var/teeth = bodypart.get_teeth_amount()
			if(!clothingonpart(bodypart) || !is_mouth_covered())
				if(teeth < bodypart.max_teeth)
					var/missing_teeth = bodypart.max_teeth - teeth
					var/number_teeth
					if(missing_teeth < 2)
						number_teeth = "tooth"
					else
						number_teeth = "teeth"
					msg += "<span class='danger'>It's [bodypart.name] don't have [missing_teeth] [number_teeth]!</span>"
		var/max_fingers = bodypart.get_max_digits()
		if(max_fingers)
			var/fingers = bodypart.get_digits_amount()
			var/static/list/toe_zones = list(BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
			if(!LAZYLEN(clothingonpart(bodypart)))
				if(fingers < max_fingers)
					var/missing_fingers = max_fingers - fingers
					var/number_fingers
					if(missing_fingers < 2)
						number_fingers = "finger"
					else
						number_fingers = "fingers"
					msg += "<span class='danger'>It's [bodypart.name] don't have [missing_fingers] [number_fingers]!</span>"
	for(var/zone in missing)
		//redundancy checks
		if((GLOB.bodyzone_to_parent[zone] && ((GLOB.bodyzone_to_parent[zone] in missing) || (GLOB.bodyzone_to_parent[zone] in stumps))))
			continue
		msg += "<span class='dead'><b>It's [parse_zone(zone)] is lost!</b></span>"
	var/damage_value = 0
	if(!((user == src) && (src.hal_screwyhud == SCREWYHUD_HEALTHY))) //fake healthy
		var/hyperbole = ((user == src) && (hal_screwyhud == SCREWYHUD_CRIT) ? 50 : 0)
		var/wound_injured = 0
		for(var/thing in all_wounds)
			var/datum/wound/wound = thing
			wound_injured += (wound.severity - WOUND_SEVERITY_TRIVIAL) * 20
		damage_value = getBruteLoss() + getFireLoss() + getCloneLoss() + hyperbole + wound_injured
		switch(damage_value)
			if(5 to 25)
				msg += "It's a little damaged."
			if(25 to 50)
				msg += "It's <B>pretty</B> damaged!"
//				get_aroused = FALSE
			if(50 to INFINITY)
				msg += "<B>It's heavily damaged!</B>"
//				get_aroused = FALSE
/*
	var/datum/component/irradiated/irradiated = GetComponent(/datum/component/irradiated)
	if(!skipface && (irradiated?.radiation_sickness >= RADIATION_SICKNESS_STAGE_1) && get_bodypart_nostump(BODY_ZONE_PRECISE_FACE))
		msg += "[t_His] nose is bleeding."
	if(fire_stacks > 0)
		msg += "[t_He] [t_is] covered in something flammable."
	if(fire_stacks < 0)
		msg += "[t_He] look[p_s()] a little soaked."
*/
	if(nutrition <= NUTRITION_LEVEL_STARVING)
		msg += "It's starving."
	else if(nutrition >= NUTRITION_LEVEL_FAT)
		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
			msg += "It's fat."
/*
	switch(disgust)
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			msg += "[t_He] look[p_s()] a bit grossed out."
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			msg += "[t_He] look[p_s()] really grossed out."
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			msg += "[t_He] look[p_s()] extremely disgusted."
*/
	var/apparent_blood_volume = get_blood_circulation()
	if(dna.species.use_skintones && skin_tone == "albino")
		apparent_blood_volume -= ALBINO_BLOOD_REDUCTION // enough to knock you down one tier
	switch(apparent_blood_volume)
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			msg += "<B>It's pale as whiteshroom.</B>"
		if(-INFINITY to BLOOD_VOLUME_BAD)
			msg += "<span class='artery'><B>It's skin is unhealthily pale.</B></span>"
/*
	if(reagents.has_reagent(/datum/reagent/teslium, needs_metabolizing = TRUE))
		msg += "[t_He] [t_is] emitting a gentle blue glow!"


	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				msg += "[t_He] [t_is][stun_absorption[i]["examine_message"]]"
*/
	//dirtiness
	switch(germ_level)
		if(GERM_LEVEL_FILTHY to GERM_LEVEL_SMASHPLAYER)
			msg += "It looks dirty!"
		if(GERM_LEVEL_SMASHPLAYER to INFINITY)
			msg += "<b>God, it stinks!</b>"
	//strength diff
	if(user.attributes && (user != src))
		switch(GET_MOB_SKILL_VALUE_RAW(user, STAT_STRENGTH)-GET_MOB_SKILL_VALUE_RAW(src, STAT_STRENGTH))
			if(-INFINITY to -3)
				msg += span_danger("It's much stronger than me.")
			if(-2, -1)
				msg += "It's stronger than me."
			if(0)
				msg += span_notice("It's as strong as me.")
			if(1, 2)
				msg += span_notice("It's weaker than me.")
			if(3 to INFINITY)
				msg += span_boldnotice("It's much weaker than me.")
	if(stat < DEAD)
		if(src != user)
			if(drunkenness && !skipface) //Drunkenness
				switch(drunkenness)
					if(11 to INFINITY)
						msg += "It's drunk."
/*
			var/datum/component/mood/mood = src.GetComponent(/datum/component/mood)
			if(mood)
				switch(mood.shown_mood)
					if(-INFINITY to MOOD_LEVEL_SAD4)
						msg += "[t_He] look[p_s()] <span style='color: [RUNE_COLOR_DARKRED];'><b>miserable</b></span>."
					if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
						msg += "[t_He] look[p_s()] <b>very sad</b>."
					if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
						msg += "[t_He] look[p_s()] a bit upset."
					if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_HAPPY2)
						msg += "<span class='notice'>[t_He] do[t_es]n't seem one way or the other.</span>"
					if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
						msg += "<span class='notice'>[t_He] look[p_s()] quite content.</span>"
					if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
						msg += "<span class='notice'>[t_He] look[p_s()] very happy.</span>"
					if(MOOD_LEVEL_HAPPY4 to INFINITY)
						msg += "<span class='notice'>[t_He] look[p_s()] <b>ecstatic</b>!</span>"
*/
			if(combat_mode)
				msg += "It's negative."
/*
			if(getOxyLoss() >= 10)
				msg += "[t_He] seem[p_s()] winded."
			if(getToxLoss() >= 10)
				msg += "[t_He] seem[p_s()] sickly."

			if(mood.sanity <= SANITY_DISTURBED)
				msg += "Видно, что психически не в порядке."
				SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "empath", /datum/mood_event/sad_empath, src)

			if(is_blind())
				msg += "[t_He] appear[p_s()] to be staring off into space."
			if(HAS_TRAIT(src, TRAIT_DEAF))
				msg += "[t_He] appear[p_s()] to not be responding to noises."
			if(bodytemperature > dna.species.bodytemp_heat_damage_limit)
				msg += "[t_He] [t_is] flushed and wheezing."
			if(bodytemperature <= dna.species.bodytemp_cold_damage_limit)
				msg += "[t_He] [t_is] shivering."
			if(HAS_TRAIT(user, TRAIT_SPIRITUAL))
				msg += "[t_He] [t_has] a holy aura about [t_him]."
				SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "religious_comfort", /datum/mood_event/religiously_comforted)
*/
		switch(stat)
			if(DEAD, UNCONSCIOUS, HARD_CRIT)
				msg += "It seems to be unconscious."
			if(SOFT_CRIT)
				msg += "It's almost conscious."
			if(CONSCIOUS)
				if(HAS_TRAIT(src, TRAIT_DUMB))
					msg += "It's fucking face is stupid."
		if(needs_lungs() && (distance <= 2) && (losebreath || undergoing_cardiac_arrest() || undergoing_nervous_system_failure()) )
			msg += "It's not breathing."
		if(getorganslot(ORGAN_SLOT_BRAIN))
			if(!key || !client)
				msg += "<span class='dead'>It has an eerie appearance.</span>"
/*
	var/scar_severity = 0
	for(var/datum/scar/scar as anything in all_scars)
		if(scar.is_visible(user))
			scar_severity += scar.severity

	switch(scar_severity)
		if(1 to 4)
			msg += "<span class='tinynoticeital'>[t_He] [t_has] visible scarring, you can look again to take a closer look...</span>"
		if(5 to 8)
			msg += "<span class='smallnoticeital'>[t_He] [t_has] several bad scars, you can look again to take a closer look...</span>"
		if(9 to 11)
			msg += "<span class='notice'><i>[t_He] [t_has] significantly disfiguring scarring, you can look again to take a closer look...</i></span>"
		if(12 to INFINITY)
			msg += "<span class='notice'><b><i>[t_He] [t_is] just absolutely fucked up, you can look again to take a closer look...</i></b></span>"
*/
	if(LAZYLEN(msg))
		. += "<span class='warning'>[msg.Join("\n")]</span>"

	var/trait_exam = common_trait_examine()
	if(!isnull(trait_exam))
		. += trait_exam
	//NOOOOO AHHHHHHHH

/*
	var/list/slot_to_name = list(ORGAN_SLOT_PENIS = "dick",\
								ORGAN_SLOT_TESTICLES = "balls",\
								ORGAN_SLOT_VAGINA = "vagina",\
								ORGAN_SLOT_BREASTS = "breasts",\
								ORGAN_SLOT_WOMB = "womb",\
								ORGAN_SLOT_ANUS = "anus",\
								)
*/
	// Genital examination section
	var/get_aroused = FALSE
	var/mob/living/carbon/human/human_user = user

	// Only proceed with genital checks if we're close enough
	if(distance <= 1)
		// Check if groin is visible
		var/groin_visible = FALSE
		var/obj/item/bodypart/groin_bp = get_bodypart_nostump(BODY_ZONE_PRECISE_GROIN)
		if(groin_bp && !LAZYLEN(clothingonpart(groin_bp)))
			if(!underwear || underwear == "Nude" || (underwear_visibility & UNDERWEAR_HIDE_UNDIES))
				groin_visible = TRUE

		// Check if chest is visible
		var/chest_visible = FALSE
		var/obj/item/bodypart/chest_bp = get_bodypart_nostump(BODY_ZONE_CHEST)
		if(chest_bp && !LAZYLEN(clothingonpart(chest_bp)))
			if(!undershirt || undershirt == "Nude" || (underwear_visibility & UNDERWEAR_HIDE_SHIRT))
				chest_visible = TRUE

		// PENIS
		var/list/penises = getorganslotlist(ORGAN_SLOT_PENIS)
		if(groin_visible)
			if(!length(penises) && should_have_genital(ORGAN_SLOT_PENIS))
				. += "<span class='danger'>It has no dick!</span>"
			else if(length(penises))
				for(var/obj/item/organ/genital/penis/penis in penises)
					var/parsed_name = lowertext(penis.genital_name)
					var/circumcised_text = (penis.circumcised ? "circumcised" : "intact")
					. += span_abductor("[p_they(TRUE)] [p_have()] [prefix_a_or_an(circumcised_text)] [circumcised_text] [penis.translate_size_to_examine()] long, [penis.translate_girth_to_examine()] circumference [parsed_name] [penis.name].")
					var/arousal = penis.get_arousal_examine()
					if(arousal)
						. += arousal
					get_aroused = (damage_value < 50)

		// TESTICLES
		var/list/testicles = getorganslotlist(ORGAN_SLOT_TESTICLES)
		if(groin_visible)
			if(!length(testicles) && should_have_genital(ORGAN_SLOT_TESTICLES))
				. += "<span class='danger'>It has no balls!</span>"
			else if(length(testicles))
				for(var/obj/item/organ/genital/testicles/balls in testicles)
					var/parsed_name = lowertext(balls.genital_name)
					if(parsed_name == "pair")
						parsed_name = "pair of"
					. += span_abductor("[p_they(TRUE)] [p_have()] [prefix_a_or_an(parsed_name)] [balls.translate_size_to_examine()] [parsed_name] [balls.name].")
					get_aroused = (damage_value < 50)

		// VAGINA
		var/list/vaginas = getorganslotlist(ORGAN_SLOT_VAGINA)
		if(groin_visible)
			if(!length(vaginas) && should_have_genital(ORGAN_SLOT_VAGINA))
				. += "<span class='danger'>It has no vagina!</span>"
			else if(length(vaginas))
				for(var/obj/item/organ/genital/vagina/vagina in vaginas)
					var/parsed_name = lowertext(vagina.genital_name)
					. += span_abductor("[p_they(TRUE)] [p_have()] \a [parsed_name][parsed_name == "cloaca" ? "" : " [vagina.name]"].")
					var/arousal = vagina.get_arousal_examine()
					if(arousal)
						. += arousal
					get_aroused = (damage_value < 50)

		// ANUS (always present, but check visibility)
		if(groin_visible)
			var/list/anuses = getorganslotlist(ORGAN_SLOT_ANUS)
			if(length(anuses))
				for(var/obj/item/organ/genital/anus/anus in anuses)
					var/parsed_name = lowertext(anus.genital_name)
					. += span_abductor("[p_they(TRUE)] [p_have()] \a [parsed_name] [anus.name].")
					get_aroused = (damage_value < 50)

		// BREASTS
		var/list/breasts = getorganslotlist(ORGAN_SLOT_BREASTS)
		if(chest_visible)
			if(!length(breasts) && should_have_genital(ORGAN_SLOT_BREASTS))
				. += "<span class='danger'>It has no breasts!</span>"
			else if(length(breasts))
				for(var/obj/item/organ/genital/breasts/boobs in breasts)
					var/parsed_name = lowertext(boobs.genital_name)
					. += span_abductor("[p_they(TRUE)] [p_have()] [prefix_a_or_an(parsed_name)] [boobs.translate_size_to_examine()] [parsed_name] [boobs.name].")
					get_aroused = (damage_value < 50)

		// Apply arousal effect to viewer if appropriate
		if((user != src) && get_aroused && istype(human_user) && (stat < DEAD) && (human_user.stat == CONSCIOUS))
			human_user.adjust_arousal(300)

	var/perpname = get_face_name(get_id_name(""))
	if(perpname && (HAS_TRAIT(user, TRAIT_SECURITY_HUD) || HAS_TRAIT(user, TRAIT_MEDICAL_HUD)))
		var/datum/data/record/R = find_record("name", perpname, GLOB.data_core.general)
		if(R)
			. += "<span class='deptradio'>Rank:</span> [R.fields["rank"]]\n<a href='?src=[REF(src)];hud=1;photo_front=1'>\[Front photo\]</a><a href='?src=[REF(src)];hud=1;photo_side=1'>\[Side photo\]</a>"
		if(HAS_TRAIT(user, TRAIT_MEDICAL_HUD))
			var/cyberimp_detect
			for(var/obj/item/organ/cyberimp/CI in internal_organs)
				if(CI.status == ORGAN_ROBOTIC && !CI.scanner_hidden)
					cyberimp_detect += "[!cyberimp_detect ? "[CI.get_examine_string(user)]" : ", [CI.get_examine_string(user)]"]"
			if(cyberimp_detect)
				. += "<span class='notice ml-1'>Detected cybernetic modifications:</span>"
				. += "<span class='notice ml-2'>[cyberimp_detect]</span>"
			if(R)
				var/health_r = R.fields["p_stat"]
				. += "<a href='?src=[REF(src)];hud=m;p_stat=1'>\[[health_r]\]</a>"
				health_r = R.fields["m_stat"]
				. += "<a href='?src=[REF(src)];hud=m;m_stat=1'>\[[health_r]\]</a>"
			R = find_record("name", perpname, GLOB.data_core.medical)
			if(R)
				. += "<a href='?src=[REF(src)];hud=m;evaluation=1'>\[Medical evaluation\]</a><br>"
			. += "<a href='?src=[REF(src)];hud=m;quirk=1'>\[See quirks\]</a>"

		if(HAS_TRAIT(user, TRAIT_SECURITY_HUD))
			if(user.stat < UNCONSCIOUS && !HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
				var/criminal = "None"

				R = find_record("name", perpname, GLOB.data_core.security)
				if(R)
					criminal = R.fields["criminal"]

				. += "<span class='deptradio'>Criminal status:</span> <a href='?src=[REF(src)];hud=s;status=1'>\[[criminal]\]</a>"
				. += jointext(list("<span class='deptradio'>Security record:</span> <a href='?src=[REF(src)];hud=s;view=1'>\[View\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_citation=1'>\[Add citation\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_crime=1'>\[Add crime\]</a>",
					"<a href='?src=[REF(src)];hud=s;view_comment=1'>\[View comment log\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_comment=1'>\[Add comment\]</a>"), "")
//	if(isobserver(user))
//		. += "<span class='info'><b>Traits:</b> [get_quirk_string(FALSE, CAT_QUIRK_ALL)]</span>"
	. += "</span>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)
	if(on_examined_check(user, FALSE))
		user.on_examine_atom(src, FALSE)

/mob/living/carbon/human/examine_more(mob/user)
	var/sanitized_chat_color = sanitize_hexcolor(chat_color)
	var/fancy_name = name
	if(chat_color)
		fancy_name = "<span style='color: [sanitized_chat_color];text-shadow: 0 0 3px [sanitized_chat_color];'>[name]</span>"
	var/obscure_name = FALSE
	if(isliving(user))
		var/mob/living/living_user = user
		if(HAS_TRAIT(living_user, TRAIT_PROSOPAGNOSIA))
			obscure_name = TRUE

	. = list(span_notice("<i>I examine <EM>[obscure_name ? "Unknown" : fancy_name]</EM> closer, and I notice...</i>"), "<br><hr class='infohr'>")

	var/box = ""
	var/distance = get_dist(user, src)

	var/list/damaged_bodypart_text = list()
	var/list/clothing = list(head, wear_mask, wear_neck, wear_suit, w_uniform, wear_id, belt, back, s_store, ears, ears_extra, gloves, shoes)
	for(var/thingprequel in bodyparts)
		var/obj/item/bodypart/limb = thingprequel
		var/obj/item/hidden
		//yes the splint will cover gauze up
		if(limb.current_splint)
			hidden = limb.current_splint
			damaged_bodypart_text += "<span class='info'>It's [limb.name] is splinted with <a href='?src=[REF(limb)];gauze=1;'>[limb.current_splint]</a>.</span>"
			if(limb.current_gauze)
				damaged_bodypart_text += "<span class='info'>It's [limb.name] is bandaged with [limb.current_gauze].</span>"
		else if(limb.current_gauze)
			hidden = limb.current_gauze
			damaged_bodypart_text += "<span class='info'>It's [limb.name] is bandaged with <a href='?src=[REF(limb)];gauze=1;'>[limb.current_gauze]</a>.</span>"

		if(!hidden)
			for(var/thing in clothing)
				var/obj/item/clothing/clothes = thing
				if(istype(clothes) && CHECK_BITFIELD(clothes.body_parts_covered, limb.body_part))
					hidden = clothes
					break
			if(hidden)
				damaged_bodypart_text += "<span class='info'>[limb.name] is covered thanks to [hidden.name]."
/*
		if(limb.etching && !hidden)
			damaged_bodypart_text += "<span class='warning'>[t_His] [limb.name] has \"[limb.etching]\" etched on it!</span>"
*/
		for(var/thing in limb.embedded_objects)
			var/obj/item/embedded = thing
			if(embedded.isEmbedHarmless())
				damaged_bodypart_text += "<span class='info'>It has [icon2html(embedded, user)] [embedded] stucked in it's [limb.name]!</span>"

		for(var/i in limb.wounds)
			var/datum/wound/iter_wound = i
			if(hidden && !CHECK_BITFIELD(iter_wound.wound_flags, WOUND_VISIBLE_THROUGH_CLOTHING))
				continue
			damaged_bodypart_text += "[iter_wound.get_examine_description(user)]"

		if(hidden)
			var/thicc = FALSE
			var/obj/item/clothing/clothing_thing = hidden
			if(istype(clothing_thing) && (clothing_thing.clothing_flags & THICKMATERIAL))
				thicc = TRUE
			if(limb.get_bleed_rate() && !thicc)
				damaged_bodypart_text += "<span class='warning'>It has blood oozing from it's [hidden.name] near it's <span class='meatymeat'>[limb.name]</span>!</span>"
		else
			var/hurted = limb.get_injuries_desc()
			if(hurted)
				damaged_bodypart_text += "<span class='danger'>It has [hurted] on it's <span class='meatymeat'>[limb.name]</span>.</span>"

		if(distance <= 1)
			if(HAS_TRAIT(limb, TRAIT_ROTTEN))
				damaged_bodypart_text += "<span class='necrosis'><B><span class='meatymeat'>[limb.name]</span> is rotten!</B></span>"
			if(HAS_TRAIT(limb, TRAIT_DEFORMED))
				damaged_bodypart_text += "<span class='danger'><B><span class='meatymeat'>[limb.name]</span> is deformed!</B></span>"
			if(limb.is_compound_fractured())
				damaged_bodypart_text += "<span class='boned'><B><U><span class='meatymeat'>[limb.name]</span> is broken!</U></B></span>"
			else if(limb.is_fractured())
				damaged_bodypart_text += "<span class='boned'><B><span class='meatymeat'>[limb.name]</span> is broken!</B></span>"
			else if(limb.is_dislocated())
				damaged_bodypart_text += "<span class='alert'><span class='meatymeat'>[limb.name]</span> is dislocated!</span>"
		else if(HAS_TRAIT(limb, TRAIT_ROTTEN) || HAS_TRAIT(limb, TRAIT_DEFORMED) || limb.is_fractured() || limb.is_dislocated())
			damaged_bodypart_text += "<span class='alert'>[limb.name] in a bad condition.</span>"
	if(length(damaged_bodypart_text))
		box += jointext(damaged_bodypart_text, "\n")
	else
		box += "<span class='info'>It has no noticeable wounds.</span>"
	. += box
	if(on_examined_check(user, TRUE))
		user.on_examine_atom(src, TRUE)