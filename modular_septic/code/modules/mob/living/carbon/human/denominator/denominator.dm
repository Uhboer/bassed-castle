/mob/living/carbon/human/species/denominator
	icon = 'modular_septic/icons/obj/items/books.dmi'
	icon_state = "glorytotheccp" //for mapping
	race = /datum/species/denominator

/mob/living/carbon/human/species/weakwillet
	icon = 'modular_septic/icons/obj/items/books.dmi'
	icon_state = "glorytotheccp" //for mapping
	race = /datum/species/weakwillet
	see_in_dark = 5

/mob/living/carbon/human/species/pighuman
	icon = 'modular_septic/icons/obj/items/books.dmi'
	icon_state = "glorytotheccp" //for mapping
	race = /datum/species/pighuman

/mob/living/carbon/human/species/boarhuman
	icon = 'modular_septic/icons/obj/items/books.dmi'
	icon_state = "glorytotheccp" //for mapping
	race = /datum/species/boarhuman

/mob/living/carbon/human/species/cockroach
	icon = 'modular_septic/icons/obj/items/books.dmi'
	icon_state = "glorytotheccp" //for mapping
	race = /datum/species/cockroach

/mob/living/carbon/human/species/halbermensch
	icon = 'modular_septic/icons/obj/items/books.dmi'
	icon_state = "glorytotheccp" //for mapping
	race = /datum/species/halbermensch
//	max_fatigue = 200
//	base_max_fatigue = 200
//	fatigue = 200

/mob/living/carbon/human/species/tendonishe
	icon = 'modular_septic/icons/obj/items/books.dmi'
	icon_state = "glorytotheccp" //for mapping
	race = /datum/species/tendonishe

/mob/living/carbon/human/crazy_npc
	/// Whether the NPC is currently in angry state
	var/angry = FALSE
	/// Whether the NPC can become angry
	var/can_be_angry = TRUE
	/// Chance to miss attacks (higher = more likely to miss)
	var/miss_chance = 5
	/// Primary outfit to use
	var/primary_outfit = /datum/outfit/villagar
	/// Secondary outfit to use (25% chance)
	var/secondary_outfit = /datum/outfit/villagargar
	/// Attribute holder sheet
	var/attribute_sheet = /datum/attribute_holder/sheet/job/venturer
	/// Whether to use random name generation
	var/use_random_name = TRUE
	/// Special name for non-random names
	var/special_name = ""
	/// Whether this NPC should be inactive
	var/inactive = FALSE
	/// Current target for the NPC
	var/mob/living/carbon/target

/mob/living/carbon/human/crazy_npc/villager
	truerole = "Villager"
	pod_faction = "Village"
	inactive = TRUE

/mob/living/carbon/human/crazy_npc/feral
	use_random_name = FALSE
	special_name = "Feral"
	pod_faction = "Wilders"
	truerole = "Feral"
	primary_outfit = null
	secondary_outfit = null

/mob/living/carbon/human/crazy_npc/Initialize(mapload)
	. = ..()
	chat_color = ""

	// Set up name
	setup_name()

	// Set up appearance
	setup_appearance()

	// Set up attributes and traits
	setup_attributes()

	// Set up babble component for speech
	setup_voice()

	// Complete setup
	dna.features["body_size"] = BODY_SIZE_NORMAL
	dna.update_body_size()
	dna.update_dna_identity()
	attributes?.update_attributes()
	regenerate_icons()
	emote("hem")

	// Start behavior loop if not dead
	if(stat != DEAD)
		start_behavior_loop()

/**
 * Sets up the NPC's name
 */
/mob/living/carbon/human/crazy_npc/proc/setup_name()
	var/our_name
	if(use_random_name)
		our_name = generate_name()
	else
		our_name = special_name

	way_type = pick("Unprocess", "Process")
	if(way_type == "Process")
		real_name = "卐 [our_name]"
	else
		real_name = "卍 [our_name]"

	name = real_name

/**
 * Sets up the NPC's appearance
 */
/mob/living/carbon/human/crazy_npc/proc/setup_appearance()
	age = rand(14, 100)

	var/crazyagelook
	if(prob(50))
		crazyagelook = age - rand(0, 4)
	else
		crazyagelook = age + rand(0, 4)
	looks_age = crazyagelook

	hairstyle = pick("Bedhead 2", "Bald")
	facial_hairstyle = pick("Shaved", "Beard (Very Long)")
	hair_color = pick("#000000", "#1f120f", "#d7d49f")
	underwear = "Nude"
	undershirt = "Nude"

	// Setup gender and body type
	gender = pick(MALE, FEMALE)
	if(gender == MALE)
		body_type = MALE
		genitals = GENITALS_MALE
	else if(gender == FEMALE)
		body_type = FEMALE
		genitals = GENITALS_FEMALE
	else
		body_type = MALE
		genitals = pick(GENITALS_DICKGIRL, GENITALS_CUNTBOY, GENITALS_FUTA)

	// Setup genitals
	setup_genitals()

	// Setup eye color
	var/eye_coloring = pick("#000000", "#1f120f", "#c30000", "#00ffff", "#156d0a", "#ff00b3")
	for(var/obj/item/organ/eyes/organ_eyes in internal_organs)
		if(organ_eyes.current_zone == BODY_ZONE_PRECISE_L_EYE)
			left_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			dna.update_ui_block(DNA_LEFT_EYE_COLOR_BLOCK)
		else
			right_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			dna.update_ui_block(DNA_RIGHT_EYE_COLOR_BLOCK)

	// Setup height based on age
	if(age < 18)
		ADD_TRAIT(src, TRAIT_CHILDO, "special_childo")
		height = HUMAN_HEIGHT_SHORTEST
	else
		height = pick(HUMAN_HEIGHT_SHORTEST, HUMAN_HEIGHT_SHORT, HUMAN_HEIGHT_MEDIUM, HUMAN_HEIGHT_TALL, HUMAN_HEIGHT_TALLEST)

	// Setup width based on age
//	if(age < 18)
//		width = HUMAN_WIDTH_THIN
//	else
//		width = pick(HUMAN_WIDTH_THIN, HUMAN_WIDTH_SLIGHTLY_THIN, HUMAN_WIDTH_AVERAGE, HUMAN_WIDTH_SLIGHTLY_WIDE, HUMAN_WIDTH_WIDE)

	// Setup handedness
	handed_flags = pick(RIGHT_HANDED, LEFT_HANDED, AMBIDEXTROUS)

/**
 * Sets up the NPC's genitals
 */
/mob/living/carbon/human/crazy_npc/proc/setup_genitals()
	// Remove existing genitals
	for(var/obj/item/organ/genital/genital in internal_organs)
		qdel(genital)

	// Set up basic DNA features for genitals
	dna.features["breasts_size"] = BREASTS_DEFAULT_SIZE
	dna.features["breasts_lactation"] = BREASTS_DEFAULT_LACTATION
	dna.features["penis_size"] = PENIS_DEFAULT_LENGTH
	dna.features["penis_girth"] = PENIS_DEFAULT_GIRTH
	dna.features["penis_sheath"] = SHEATH_NONE
	dna.features["penis_circumcised"] = FALSE
	dna.features["balls_size"] = BALLS_DEFAULT_SIZE

	// Get the genital set based on assigned gender
	var/genitals_set = genitals

	// Create the needed genital organs
	for(var/genital_slot in GLOB.genital_sets[genitals_set])
		// Find the appropriate genital type for this slot
		var/obj/item/genital_type
		switch(genital_slot)
			if(ORGAN_SLOT_PENIS)
				genital_type = /obj/item/organ/genital/penis
			if(ORGAN_SLOT_TESTICLES)
				genital_type = /obj/item/organ/genital/testicles
			if(ORGAN_SLOT_VAGINA)
				genital_type = /obj/item/organ/genital/vagina
			if(ORGAN_SLOT_WOMB)
				genital_type = /obj/item/organ/genital/womb
			if(ORGAN_SLOT_BREASTS)
				genital_type = /obj/item/organ/genital/breasts
			if(ORGAN_SLOT_ANUS)
				genital_type = /obj/item/organ/genital/anus

		if(genital_type)
			// Create and insert the organ
			var/obj/item/organ/genital/new_genital = new genital_type()
			new_genital.Insert(src, FALSE, FALSE)

			// Update its appearance from DNA
			if(new_genital.mutantpart_key)
				dna.mutant_bodyparts[new_genital.mutantpart_key] = list(
					MUTANT_INDEX_NAME = new_genital.genital_name,
					MUTANT_INDEX_COLOR = list("#FFFFFF", "#FFFFFF", "#FFFFFF")
				)
				new_genital.build_from_dna(dna, new_genital.mutantpart_key)
				new_genital.update_icon_state()

/**
 * Sets up the NPC's attributes and traits
 */
/mob/living/carbon/human/crazy_npc/proc/setup_attributes()
	// Add attribute sheet
	attributes?.add_sheet(attribute_sheet)

	// Equip outfit
	if(prob(25))
		equipOutfit(secondary_outfit)
	else
		equipOutfit(primary_outfit)

	// Fully heal
	fully_heal(TRUE)

	// Add random trait
	var/my_trait = pick(TRAIT_DEPRESSION, TRAIT_PAINLOVER, TRAIT_HYPERSENT, TRAIT_MISANTHROPE)
	ADD_TRAIT(src, my_trait, "special_trait")

	// Modify organ stats based on attributes
	for(var/obj/item/organ/plushp in internal_organs)
		plushp.maxHealth += GET_MOB_ATTRIBUTE_VALUE(src, STAT_ENDURANCE)

	for(var/obj/item/bodypart/plusbodyhp as anything in bodyparts)
		plusbodyhp.max_damage += GET_MOB_ATTRIBUTE_VALUE(src, STAT_ENDURANCE)
		plusbodyhp.max_stamina_damage += GET_MOB_ATTRIBUTE_VALUE(src, STAT_ENDURANCE)

	gain_extra_effort(1, TRUE)

/**
 * Sets up the NPC's voice
 */
/mob/living/carbon/human/crazy_npc/proc/setup_voice()
	var/voice_file

	if(age >= 18)
		voice_file = gender != FEMALE ? 'modular_septic/sound/voice/babble/babble_male.ogg' : 'modular_septic/sound/voice/babble/babble_female.ogg'
	else
		voice_file = 'modular_septic/sound/voice/babble/plimpus.ogg'

	var/datum/component/babble/babble = GetComponent(/datum/component/babble)
	if(!babble)
		AddComponent(/datum/component/babble, voice_file)
	else
		babble.babble_sound_override = voice_file
		babble.volume = BABBLE_DEFAULT_VOLUME
		babble.duration = BABBLE_DEFAULT_DURATION

/**
 * Generates a random name for the NPC
 */
/mob/living/carbon/human/crazy_npc/proc/generate_name()
	var/first_names = list(
		"Hack", "Sideless", "Moan", "Hax", "Morx", "Nok", "Nox",
		"Garrett", "Haramec", "Enclave", "Vial", "Torner",
		"Web", "Hvax", "Coiler", "Boyd", "Hex", "Sacrec", "Rave"
	)

	var/second_names = list("Moon", "Stone", "Black")
	var/roman_numerals = list("I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X")

	var/result_name = pick(first_names)

	if(prob(40))
		result_name = "[result_name] [pick(second_names)]"

	if(prob(10))
		if(findtext(result_name, " "))
			result_name = "[result_name] [pick(roman_numerals)]"
		else
			result_name = "[result_name] [pick(roman_numerals)]"

	return result_name

/**
 * Starts the NPC behavior loop
 */
/mob/living/carbon/human/crazy_npc/proc/start_behavior_loop()
	addtimer(CALLBACK(src, PROC_REF(process_behavior)), 10)

/**
 * Main behavior processing loop
 */
/mob/living/carbon/human/crazy_npc/proc/process_behavior()
	if(stat != DEAD)
		process_ai_behavior()
		addtimer(CALLBACK(src, PROC_REF(process_behavior)), 10)

/**
 * Process AI behavior each tick
 */
/mob/living/carbon/human/crazy_npc/proc/process_ai_behavior()
	// Skip behavior if inactive
	if(inactive)
		return

	// Stop movement if incapacitated
	if(stat == UNCONSCIOUS || stat == HARD_CRIT || stat == DEAD)
		walk_to(src, 0)
		return

	// Handle basic behavior
	if(body_position == LYING_DOWN)
		toggle_resting()
	combat_mode = 0

	// Try to find a weapon
	find_weapon()

	// Try to pick up and equip clothing
	find_clothing()

	// Handle current target or find a new one
	handle_targeting()

	// Handle random movement and speech
	handle_idle_behavior()

/**
 * Look for and pick up weapons
 */
/mob/living/carbon/human/crazy_npc/proc/find_weapon()
	var/obj/item/weapon = locate(/obj/item) in held_items
	if(!weapon)
		for(var/obj/item/item in range(1, src.loc))
			if((item.force >= 8) || isgun(item))
				put_in_active_hand(item)
				break

/**
 * Look for and equip clothing
 */
/mob/living/carbon/human/crazy_npc/proc/find_clothing()
	for(var/obj/item/clothing/cloth in range(1, src.loc))
		if(cloth.slot_flags)
			put_in_inactive_hand(cloth)
			if(!equip_to_appropriate_slot(cloth))
				dropItemToGround(cloth, TRUE)

/**
 * Handle targeting behavior - pursue target or look for a new one
 */
/mob/living/carbon/human/crazy_npc/proc/handle_targeting()
	// Find better target if current target is too far
	if(target)
		for(var/mob/living/carbon/potential_target in range(10, src.loc))
			// Skip dead mobs, other NPCs, and mobs we can't see
			if(potential_target.stat == DEAD || !can_see(src, potential_target, 10) || istype(potential_target, /mob/living/carbon/human/crazy_npc))
				continue

			// Check if new target is closer and we should switch
			if(get_dist(src, target) >= get_dist(src, potential_target) && prob(50))
				if(can_be_angry && potential_target.stat != DEAD)
					target = potential_target
					break

		// Clear target if dead
		if(target?.stat == DEAD)
			target = null
			walk_to(src, 0)
			return

		var/distance = get_dist(src, target)

		// Handle target if within range
		if(target in orange(10, src))
			// Handle shooting if we have a gun
			var/obj/item/gun/gun = locate() in held_items
			if(gun)
				var/can_shoot = gun?.can_shoot() || FALSE
				if(!can_shoot)
					throw_item(target)
				gun.afterattack(target, src, FALSE)

			// Handle melee range
			if(distance <= 1)
				attack_target(target)
			// Handle approach
			else if(distance > 1 && distance < 10)
				approach_target(target)
		else
			// Clear target if out of range
			target = null
			walk_to(src, 0)

	// Look for threats and react
	look_for_threats()

/**
 * Look for threats in the environment
 */
/mob/living/carbon/human/crazy_npc/proc/look_for_threats()
	if(prob(90))
		for(var/mob/living/carbon/human/potential_threat in range(5, src.loc))
			if(!can_see(src, potential_threat, 10))
				continue
			if(!istype(potential_threat, /mob/living/carbon/human/crazy_npc))
				combat_mode = 1

				if(prob(95))
					// If being pulled, resist
					if(pulledby)
						walk_to(src, 0)
						resist()
					else if(can_be_angry && potential_threat.stat != DEAD)
						target = potential_threat
						attack_target(target)
				return TRUE
	return FALSE

/**
 * Approach target and navigate obstacles
 */
/mob/living/carbon/human/crazy_npc/proc/approach_target(mob/living/carbon/human/target)
	if(!target || LAZYLEN(do_afters))
		return

	var/turf/target_turf = get_turf(target)
	var/dir_to_target = get_dir(src, target)

	face_atom(target)

	// Handle obstacles like climbable structures
	for(var/obj/structure/obstacle in get_step(src, dir_to_target))
		if(obstacle.density && HAS_TRAIT(obstacle, TRAIT_CLIMBABLE))
			obstacle.MouseDropReceive(src, src)

	// Restrict movement to cardinal directions only (no diagonals)
	if(dir_to_target in GLOB.cardinals)
		// Only move in cardinal directions
		walk_to(src, target_turf, 0, update_movespeed())
	else
		// For diagonal directions, pick a cardinal direction to move in
		var/list/possible_dirs = list()
		if(dir_to_target & NORTH)
			possible_dirs += NORTH
		if(dir_to_target & SOUTH)
			possible_dirs += SOUTH
		if(dir_to_target & EAST)
			possible_dirs += EAST
		if(dir_to_target & WEST)
			possible_dirs += WEST

		var/move_dir = pick(possible_dirs)
		var/turf/step_turf = get_step(src, move_dir)
		walk_to(src, step_turf, 0, update_movespeed())

/**
 * Attack a target at melee range
 */
/mob/living/carbon/human/crazy_npc/proc/attack_target(mob/living/carbon/human/target)
	if(!target)
		return FALSE

	// Stop attacking if target is dead or we are incapacitated
	if(target?.stat == DEAD || stat == DEAD || stat == HARD_CRIT || stat == UNCONSCIOUS)
		if(target?.stat == DEAD)
			target = null
		walk_to(src, 0)
		return FALSE

	// Check if we can make a move yet
	if(next_move > world.time)
		return FALSE

	// Set combat intent and targeted body part
	SET_HARM_INTENT(src)
	if(prob(60))
		zone_selected = pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_PRECISE_VITALS, BODY_ZONE_PRECISE_GROIN)
	else
		zone_selected = pick(BODY_ZONE_PRECISE_FACE, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_MOUTH)

	// Get target turf
	var/turf/turf_of_target = get_turf(target)

	// Attack based on what we're equipped with
	var/obj/item/weapon = locate(/obj/item) in held_items
	var/obj/item/gun/gun = locate() in held_items

	if(get_dist(src, target) <= 1)
		if(weapon)
			// Ready weapon if needed
			if(HAS_TRAIT_FROM(weapon, TRAIT_WEAPON_UNREADY, ATTACKING_TRAIT))
				weapon.attack_self_secondary(src)

			// Attack target or miss based on miss chance
			if(prob(miss_chance))
				turf_of_target.attackby(weapon, src)
			else
				target.attackby(weapon, src)
		else if(gun)
			// Use gun if it can shoot, otherwise throw it
			var/can_shoot = gun?.can_shoot() || FALSE
			if(!can_shoot)
				throw_item(target)
			gun.afterattack(target, src, FALSE)
		else
			// Unarmed attack based on available body parts
			var/obj/item/bodypart/arm = hand_bodyparts[active_hand_index]
			if(!arm || arm?.bodypart_disabled)
				var/obj/item/bodypart/check_foot = get_active_foot()
				if(!check_foot || check_foot?.bodypart_disabled)
					// Use jaw if no arms or legs
					if(prob(miss_chance))
						turf_of_target.attack_jaw(src)
					else
						unarmed_jaw(target, null, null)
				else
					// Use feet if no arms
					if(prob(miss_chance))
						turf_of_target.attack_foot(src)
					else
						unarmed_foot(target, null, null)
			else
				// Use hands
				if(prob(miss_chance))
					turf_of_target.attack_hand(src)
				else
					unarmed_hand(target, null, null)

	return TRUE

/**
 * Handle random idle behaviors when not targeting
 */
/mob/living/carbon/human/crazy_npc/proc/handle_idle_behavior()
	// Random movement - only in cardinal directions
	if(prob(25))
		var/move_dir = pick(GLOB.cardinals) // This ensures only N, S, E, W directions (no diagonals)
		Move(get_step(src, move_dir), move_dir)

	// Random facing direction
	if(prob(10))
		face_atom(get_step(src, pick(GLOB.cardinals)))

	// Random emotes
	if(prob(4))
		emote("hem")

	// Random speech
	if(prob(3) && (SSticker.current_state == GAME_STATE_PLAYING || SSticker.current_state == GAME_STATE_FINISHED))
		speak_random_phrase()

/**
 * Make the NPC say a random phrase
 */
/mob/living/carbon/human/crazy_npc/proc/speak_random_phrase()
	var/random_number = rand(1, 9999)
	var/list/phrases = list(
		"Fish has become expensive.",
		"Retarded faggots.",
		"There are many creatures. But only one sleeps.",
		"Count to [random_number].",
		"There are [GLOB.world_deaths_crazy] deaths in the world.",
		"Retardness.",
		"Retardation.",
		"Chaos.",
		"Chirality.",
		"Everything has an opposite.",
		"Happiness and suffering are the same."
	)
	say(pick(phrases))
