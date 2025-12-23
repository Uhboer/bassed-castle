/datum/craftingbased
	var/name = "Crating"
	var/required_materials = list()

/datum/craftingbased/floor/wooden
	required_materials = list(
			/obj/item/melee/woodlog = 3
	)

/datum/craftingbased/wall/stone
	required_materials = list(
			/obj/item/stone = 3
	)

/atom/movable/screen/teach
	name = "special"
	icon = 'modular_septic/icons/hud/quake/screen_quake.dmi'
	icon_state = "act_teach"
	base_icon_state = "act_teach"
	screen_loc = ui_teach

/atom/movable/screen/teach/Click(location, control, params)
	. = ..()
	if(istype(usr, /mob/living/carbon/human))
		var/mob/living/carbon/human/angel = usr
		angel.choose_realizing()

/mob/living/carbon/human/proc/choose_realizing()
	if(!do_after(src, 0.5 SECONDS, target = src))
		to_chat(src, span_danger(xbox_rage_msg()))
		playsound_local(get_turf(src), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return
	var/list/options = list(
		"Faction",
		"Poo",
		"Pee"
	)
	if (vampiric)
		options += "Vampirus"
	var/thing = input(src, "What do I want to do special?", "I want...") as null|anything in options
	if(!thing)
		return
	if(thing == "Faction")
		faction()
//	if(thing == "Crafting")
//		crafting()
	if(thing == "Poo")
		defecate()
	if(thing == "Pee")
		urinate()
	if(thing == "Vampirus")
		vampirus()
//	if(thing == "Reproduction")
//		reproduction()
//	if(thing == "Zoqa")
//		do_zoqa()

/mob/living/carbon/human/proc/vampirus()
	var/thing = input(src, "What do I want to do vampirus?", "I want...") as null|anything in list("Teeth", "Heal")
	if(!thing)
		return
	switch(thing)
		if("Teeth")
			if (teeth_hidden)
				teeth_hidden = FALSE
				emote("grin")
				playsound(get_turf(src), 'modular_pod/sound/eff/hitcrazy.ogg', 80)
			else
				teeth_hidden = TRUE
				emote("grin")
		if("Heal")
			if(vampblood < 150)
				to_chat(src, span_warning("I need 150 units of blood. Current blood amount - [vampblood]"))
				return
			fully_heal()
			playsound(get_turf(src), 'modular_pod/gothica/sound/heal.ogg', 80)
			sound_hint()
			vampblood -= 150

/mob/living/carbon/human/proc/faction()
	var/list/options = list(
		"Create Faction",
		"Leave Faction",
		"Recruit People"
	)
	
	var/list/descriptions = list(
		"Create Faction" = "Start a new faction with yourself as leader",
		"Leave Faction" = "Leave your current faction or dissolve it if you're the leader",
		"Recruit People" = "Add nearby willing people to your faction"
	)
	
	// Create a formatted list for display in the input menu
	var/list/display_options = list()
	for(var/option in options)
		display_options[option] = descriptions[option]
	
	var/choice = input(src, "I need?", "Faction Management") as null|anything in display_options
	if(!choice)
		return
	
	// Now we have the direct key without needing names() function
	switch(choice)
		if("Create Faction")
			if(pod_faction)
				to_chat(src, span_warning("I'm already in the faction [pod_faction]!"))
				return
			
			var/faction_name = stripped_input(src, "What will be the name of my faction?", "Name is...")
			if(!faction_name)
				to_chat(src, span_notice("I changed my mind."))
				return
				
			if(length(faction_name) > 30) // Prevent excessively long faction names
				to_chat(src, span_warning("That name is too long!"))
				return
			
			// Disallow certain characters that might cause issues
			var/sanitized_name = replacetext(faction_name, ";", "")
			sanitized_name = replacetext(sanitized_name, "&", "and")
			
			faction_boss = TRUE
			pod_faction = sanitized_name
			to_chat(src, span_meatymeat("I created a faction [pod_faction]!"))
			
		if("Recruit People")
			if(!pod_faction)
				to_chat(src, span_warning("I need to create a faction first!"))
				return
				
			if(!faction_boss)
				to_chat(src, span_warning("Only faction leaders can recruit!"))
				return
				
			var/recruits_found = FALSE
			var/recruits_added = 0
			var/list/potential_recruits = list()
			
			// First collect potential recruits
			for(var/mob/living/carbon/human/potential_recruit in view(3, src))
				// Fixed syntax error: properly formatted if statement without problematic line breaks
				if(potential_recruit == src || potential_recruit.stat == DEAD || !potential_recruit.client || potential_recruit.pod_faction || potential_recruit.a_intent != INTENT_HELP || potential_recruit.combat_mode)
					continue
					
				potential_recruits += potential_recruit
				recruits_found = TRUE
			
			// Provide feedback and allow recruiting
			if(!recruits_found)
				to_chat(src, span_notice("There are no eligible recruits nearby."))
				return
				
			// Define a method to recruit a specific person or all eligible people
			var/list/recruit_options = list("Recruit All") + potential_recruits
			var/recruit_choice = input(src, "Who should I recruit?", "Recruiting") as null|anything in recruit_options
			
			if(!recruit_choice)
				to_chat(src, span_notice("I changed my mind."))
				return
				
			if(recruit_choice == "Recruit All")
				for(var/mob/living/carbon/human/recruit in potential_recruits)
					recruit.pod_faction = pod_faction
					recruits_added++
					to_chat(recruit, span_meatymeat("I join [pod_faction] faction!"))
			else
				var/mob/living/carbon/human/single_recruit = recruit_choice
				single_recruit.pod_faction = pod_faction
				recruits_added = 1
				to_chat(single_recruit, span_meatymeat("I join [pod_faction] faction!"))
			
			to_chat(src, span_meatymeat("I've recruited [recruits_added] member[recruits_added != 1 ? "s" : ""] to [pod_faction]."))
			
		if("Leave Faction")
			if(!pod_faction)
				to_chat(src, span_warning("I'm not in a faction!"))
				return
				
			// Add confirmation for faction leaders
			if(faction_boss)
				var/leave_choice = alert(src, "As a faction leader, leaving will dissolve the entire faction. Continue?", "Faction Dissolution", "Yes", "No")
				if(leave_choice != "Yes")
					return
					
				// Leaders dissolve the faction for everyone
				var/faction_name = pod_faction // Store before nullifying
				var/members_affected = 0
				
				for(var/mob/living/carbon/human/faction_member in GLOB.human_list)
					if(!QDELETED(faction_member) && faction_member.pod_faction == faction_name)
						if(faction_member != src)
							to_chat(faction_member, span_meatymeat("Our leader has dissolved [faction_name] faction!"))
							faction_member.pod_faction = null
							members_affected++
				
				faction_boss = FALSE
				pod_faction = null
				to_chat(src, span_meatymeat("I've dissolved [faction_name] faction affecting [members_affected] other member[members_affected != 1 ? "s" : ""]."))
			else
				// Regular members just leave
				var/faction_name = pod_faction
				pod_faction = null
				to_chat(src, span_meatymeat("I leave [faction_name] faction."))

/mob/living/carbon/human/proc/reproduction()
	if(!do_after(src, 1 SECONDS, target = src))
		to_chat(src, span_danger(xbox_rage_msg()))
		playsound_local(get_turf(src), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return
	
	// Check for cooldown
	if(next_reproduction && world.time < next_reproduction)
		to_chat(src, span_love("I need to wait a bit before attempting reproduction again."))
		return
	
	// Check if the user has enough arousal
	if(arousal < 300)
		to_chat(src, span_love("I don't really want..."))
		return
	
	// Find potential partners in close proximity
	var/list/potential_partners = list()
	for(var/mob/living/carbon/human/partner in view(1, src))
		if(partner != src && partner.stat != DEAD)
			potential_partners += partner
	
	if(!length(potential_partners))
		to_chat(src, span_meatymeat("There's no one nearby to reproduce with."))
		return
	
	// Choose a partner
	var/mob/living/carbon/human/chosen_partner = input(src, "With whom?", "Choose partner...") as null|anything in potential_partners
	if(!chosen_partner)
		return
	
	// Get user and target interactable components
	var/datum/component/interactable/user_interactable = GetComponent(/datum/component/interactable)
	var/datum/component/interactable/target_interactable = chosen_partner.GetComponent(/datum/component/interactable)
	
	if(!user_interactable || !target_interactable)
		to_chat(src, span_warning("Reproduction failed!"))
		return
	
	// Determine appropriate reproduction interaction based on genitals
	var/has_penis = (getorganslotefficiency(ORGAN_SLOT_PENIS) >= ORGAN_FAILING_EFFICIENCY)
	var/partner_has_vagina = (chosen_partner.getorganslotefficiency(ORGAN_SLOT_VAGINA) >= ORGAN_FAILING_EFFICIENCY)
	
	// Select appropriate forbidden_fruits interaction
	var/datum/interaction/forbidden_fruits/reproduction_interaction
	
	if(has_penis && partner_has_vagina)
		reproduction_interaction = new /datum/interaction/forbidden_fruits/vaginal()
	else
		// Default to another interaction if vaginal isn't possible
		reproduction_interaction = new /datum/interaction/forbidden_fruits/anal()
	
	// Check if the interaction is allowed
	if(!reproduction_interaction.allow_interaction(user_interactable, target_interactable, FALSE))
		to_chat(src, span_warning("We can't reproduce like that."))
		return
	
	// Inform participants about the start
	to_chat(src, span_love("I attempt reproduction with [chosen_partner]."))
	to_chat(chosen_partner, span_love("[src] attempts reproduction with you."))
	
	// Begin automatic interaction loop
	INVOKE_ASYNC(src, .proc/do_reproduction_loop, user_interactable, target_interactable, reproduction_interaction, chosen_partner)

/**
 * Reproduction loop that continues until climax
 *
 * @param user_interactable The user's interactable component
 * @param target_interactable The target's interactable component
 * @param reproduction_interaction The interaction to perform
 * @param partner The partner for reproduction
 */
/mob/living/carbon/human/proc/do_reproduction_loop(datum/component/interactable/user_interactable, datum/component/interactable/target_interactable, datum/interaction/forbidden_fruits/reproduction_interaction, mob/living/carbon/human/partner)
	var/max_interactions = 50 // Safety limit to prevent infinite loops
	var/interaction_count = 0
	var/user_climaxed = FALSE
	var/target_climaxed = FALSE
	
	// Continue interactions until climax or max limit
	while(interaction_count < max_interactions && !user_climaxed && !target_climaxed && !QDELETED(src) && !QDELETED(partner))
		// Check if we're still able to interact
		if(!reproduction_interaction.allow_interaction(user_interactable, target_interactable, TRUE))
			to_chat(src, span_warning("We can no longer continue."))
			break
		
		// Perform the interaction
		reproduction_interaction.do_interaction(user_interactable, target_interactable)
		
		// Check for climax conditions after interaction
		if(lust >= LUST_CLIMAX)
			user_climaxed = TRUE
			
		if(partner.lust >= LUST_CLIMAX)
			target_climaxed = TRUE
		
		// Only proceed with after_interact if neither has climaxed yet
		if(!user_climaxed && !target_climaxed)
			reproduction_interaction.after_interact(user_interactable, target_interactable)
		
		interaction_count++
		
		// Small delay between interactions for realism and to prevent lag
		sleep(1 SECONDS)
	
	// Final climax handling if it hasn't happened through normal interaction
	if(!user_climaxed && !target_climaxed && interaction_count >= max_interactions)
		to_chat(src, span_love("Despite our efforts, reproduction wasn't successful this time."))
		to_chat(partner, span_love("Despite your efforts, reproduction wasn't successful this time."))
	
	// Give a cooldown to prevent spam
	src.next_reproduction = world.time + 30 SECONDS

/*
/atom/movable/screen/teach/update_icon_state()
	. = ..()
	if(hud?.mymob && (SEND_SIGNAL(hud.mymob, COMSIG_ELEMENT_CHECK_TEACHING) || SEND_SIGNAL(hud.mymob, COMSIG_ELEMENT_CHECK_TAUGHT)))
		icon_state = "[base_icon_state]_on"
	else
		icon_state = base_icon_state
*/
