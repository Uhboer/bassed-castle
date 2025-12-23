SUBSYSTEM_DEF(station_time)
	name = "Station time"
	flags = SS_TICKER
	wait = 10 SECONDS
	init_order = INIT_ORDER_STATION_TIME
	var/last_day = 0
	var/years_advanced = 0

/datum/controller/subsystem/station_time/Initialize(timeofday)
	last_day = get_day_from_time(station_time())
	// Send message to players explaining the accelerated time
//	addtimer(CALLBACK(src, .proc/announce_time_acceleration), 10 SECONDS)
	return ..()

/datum/controller/subsystem/station_time/fire(resumed = FALSE)
	var/current_day = get_day_from_time(station_time())

	// Check if a day has passed
	if(current_day != last_day && last_day != 0)
		// A new day has begun, advance the world by 10 years
		check_day_change()

	last_day = current_day

// Check if a day has changed and trigger the time advancement if needed
/datum/controller/subsystem/station_time/proc/check_day_change(force = FALSE)
	var/current_day = get_day_from_time(station_time())

	// Check if a day has passed or if we're forcing a day change
	if(force || (current_day != last_day && last_day != 0))
		// A new day has begun, advance the world by 10 years
//		advance_world_by_years(10)
		last_day = current_day
		return TRUE

	return FALSE

// Byond is awesome and causes integer overflows with STATION_YEAR_OFFSET, keep that in mind
/datum/controller/subsystem/station_time/proc/get_station_realtime()
	// This always returns a stupid fuckoff huge number, use sparingly
	return world.realtime+SSticker.gametime_offset

/datum/controller/subsystem/station_time/proc/get_station_year()
	return text2num(time2text(get_station_realtime(), "YYYY")) + STATION_YEAR_OFFSET + years_advanced

// Get the day from station time (0-864000)
/datum/controller/subsystem/station_time/proc/get_day_from_time(time)
	// Station time is in deciseconds within a day (0-864000)
	// We want to know when it rolls over to a new day
	return FLOOR(time / MIDNIGHT_ROLLOVER, 1)

// Advance the world by a specified number of years
/datum/controller/subsystem/station_time/proc/advance_world_by_years(years_to_add)
	years_advanced += years_to_add

	to_chat(world, span_cultlarge("<b>Time passes...</b> <span style='color:red; font-size: 150%'>10 YEARS HAVE ELAPSED</span>"))
//	priority_announce("Temporal anomaly detected. Station calendar systems have been adjusted by [years_to_add] years.", "Chronometric Shift")

	// Age all humans on the station
	age_all_humans(years_to_add)

	// Process corpses - make them more decayed
	process_corpses(years_to_add)

	// Apply random diseases to some people
	apply_random_diseases()

	// Regenerate nature in caves and outdoor areas
	regenerate_nature()

// Process corpses to make them more decayed after time jump
/datum/controller/subsystem/station_time/proc/regenerate_nature()
	return

/*
	for(var/mob/living/carbon/human/H in GLOB.dead_mob_list)
		// Skip mobs that aren't actually dead
		if(H.stat != DEAD)
			continue

		// Apply decay effects - set them to fully rotted
		H.germ_level = INFECTION_LEVEL_THREE

		// Make sure all their limbs are properly rotted
		for(var/obj/item/bodypart/BP in H.bodyparts)
			BP.germ_level = INFECTION_LEVEL_THREE
			BP.kill_limb()

		// Make sure all their organs are properly rotted
		for(var/obj/item/organ/O in H.internal_organs)
			O.germ_level = INFECTION_LEVEL_THREE
			O.organ_flags |= ORGAN_DEAD

		// Add decay visual effects
		H.update_body()
		H.update_hair()

		// If they've been dead long enough, turn them into remains
		if(years >= 5)
			var/turf/T = get_turf(H)
			if(T)
				// Create remains and delete the body
				new /obj/effect/decal/remains/human(T)
				qdel(H)
*/

// Age all humans by the specified number of years
/datum/controller/subsystem/station_time/proc/age_all_humans(years_to_add)
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		// Add years to their age
		H.age += years_to_add
		var/crazyagelook
		if(prob(50))
			crazyagelook = H.age - rand(0, 4)
		else
			crazyagelook = H.age + rand(0, 4)
		H.looks_age = crazyagelook
		if(H.age >= 18)
			if(HAS_TRAIT(H, TRAIT_CHILDO))
				REMOVE_TRAIT(H, TRAIT_CHILDO, type)
/*
		// Update their ID card if they have one
		if(H.wear_id && istype(H.wear_id, /obj/item/card/id))
			var/obj/item/card/id/id_card = H.wear_id
			if(id_card.registered_age)
				id_card.registered_age = H.age
				id_card.update_label()
				id_card.update_icon()
*/
		// Update appearance based on new age
//		H.update_hair()
//		H.update_body()

// Process corpses to make them more decayed after time jump
/datum/controller/subsystem/station_time/proc/process_corpses(years)
	for(var/mob/living/carbon/human/H in GLOB.dead_mob_list)
		// Skip mobs that aren't actually dead
		if(H.stat != DEAD)
			continue

		// Apply decay effects - set them to fully rotted
		H.germ_level = INFECTION_LEVEL_THREE

		// Make sure all their limbs are properly rotted
		for(var/obj/item/bodypart/BP in H.bodyparts)
			BP.germ_level = INFECTION_LEVEL_THREE
			BP.kill_limb()

		// Make sure all their organs are properly rotted
		for(var/obj/item/organ/O in H.internal_organs)
			O.germ_level = INFECTION_LEVEL_THREE
			O.organ_flags |= ORGAN_DEAD

		// Add decay visual effects
		H.update_body()
		H.update_hair()

		// If they've been dead long enough, turn them into remains
		if(years >= 5)
			var/turf/T = get_turf(H)
			if(T)
				// Create remains and delete the body
				new /obj/effect/decal/remains/human(T)
				qdel(H)

// Apply random diseases to some people
/datum/controller/subsystem/station_time/proc/apply_random_diseases()
	// List of possible diseases to apply
	var/list/possible_diseases = list(
		/datum/disease/flu,
		/datum/disease/cold,
		/datum/disease/advance/cold,
		/datum/disease/advance/flu
	)

	// 5% chance per person to get a disease
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD)
			continue

		if(prob(5))
			// Pick a random disease
			var/disease_type = pick(possible_diseases)

			// Create and apply the disease
			var/datum/disease/D = new disease_type()
			H.ForceContractDisease(D, FALSE, TRUE)

/datum/controller/subsystem/station_time/proc/announce_time_acceleration()
	to_chat(world, span_notice("<b>NOTICE:</b> Time passes quickly in this world. A day passes every 5 minutes, and with each day, 10 years elapse. <i>Tempus fugit.</i>"))
