/obj/item/organ/genital
	name = "Genital"
	desc = "One of the most valuable organs."
	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.5
	high_threshold = STANDARD_ORGAN_THRESHOLD * 0.4
	low_threshold = STANDARD_ORGAN_THRESHOLD * 0.1
	pain_multiplier = 1.5 //oof

	//should be about right most of the time
	organ_volume = 0.5

	reagent_vol = 60

	///If we produce any reagent, set it here
	var/fluid_reagent
	///The rate we produce fluids at, per second, when we have an owner
	var/fluid_production_rate = 0.2 //almost 4 minutes to fill up with cum
	///The organ slot we actually provide our fluid to - If empty, fill ourselves
	var/fluid_receiving_slot
	///Amount of fluid we expel on orgasm
	var/fluid_amount_orgasm = 15
	///The splatter we create if we don't want to create a fluid flood
	var/splatter_type
	///Pollutant we release on orgasm
	var/pollutant_type
	///Amount of pollutant we release on orgasm
	var/pollutant_amount = 10

	///General genital flags
	var/genital_flags = GENITAL_CAN_CLIMAX
	///Size value of the genital, needs to be translated to proper lengths/diameters/cups
	var/genital_size = 1
	///Sprite name of the genital, it's what shows up on character creation
	var/genital_name = "Human"
	///Type of the genital - For penises tapered/horse/human etc, for breasts quadruple/sixtuple etc... Used in icon_state
	var/genital_type = "human"
	///Used for input from the user whether to show a genital through clothing or not, always or never etc.
	var/genital_visibility = GENITAL_HIDDEN_BY_CLOTHES
	///Used for determining what sprite is being used, derrives from size and type
	var/sprite_suffix = ""
	///Whether the organ is aroused, matters for sprites, use AROUSAL_CANT, AROUSAL_NONE, AROUSAL_PARTIAL or AROUSAL_FULL
	var/arousal_state = AROUSAL_NONE
	///What we change our greyscale_colors var to when skintoned
	var/skintoned_colors = "#fcccb3"
	var/arousal_verb = "You feel aroused"
	var/unarousal_verb = "You no longer feel aroused"

/obj/item/organ/genital/Initialize()
	. = ..()
	if(!reagents)
		create_reagents(reagent_vol, REAGENT_HOLDER_ALIVE)
	else
		reagents.flags |= REAGENT_HOLDER_ALIVE
		
	// Set the appropriate current_zone based on organ slot
	if(organ_efficiency)
		var/slot = ""
		for(var/efficiency in organ_efficiency)
			slot = efficiency
			break
		
		switch(slot)
			if(ORGAN_SLOT_PENIS, ORGAN_SLOT_TESTICLES, ORGAN_SLOT_VAGINA, ORGAN_SLOT_ANUS, ORGAN_SLOT_WOMB)
				current_zone = BODY_ZONE_PRECISE_GROIN
			if(ORGAN_SLOT_BREASTS)
				current_zone = BODY_ZONE_CHEST

/obj/item/organ/genital/proc/set_arousal_state(new_state)
	if(!(arousal_state & AROUSAL_CANT))
		return FALSE
	if(!((HAS_TRAIT(owner,TRAIT_PERMABONER) && !new_state) || HAS_TRAIT(owner,TRAIT_NEVERBONER) && new_state))
		arousal_state = new_state
	return arousal_state

/obj/item/organ/genital/on_life(delta_time, times_fired)
	. = ..()
	regenerate_cummies(delta_time, times_fired)

/obj/item/organ/genital/examine(mob/user)
	. = ..()
	var/peepee_exam = get_genital_examine(TRUE)
	if(peepee_exam)
		. |= peepee_exam

/obj/item/organ/genital/update_icon_state()
	. = ..()
	update_sprite_suffix()
	icon_state = "[base_icon_state][sprite_suffix ? "_[sprite_suffix]" : ""]"

/obj/item/organ/genital/build_from_dna(datum/dna/dna_datum, associated_key)
	if(!dna_datum.species.mutant_bodyparts[associated_key])
		return
	mutantpart_key = associated_key
	mutantpart_info = dna_datum.species.mutant_bodyparts[associated_key].Copy()
	var/datum/sprite_accessory/genital/sprite_accessory = GLOB.sprite_accessories[associated_key][dna_datum.species.mutant_bodyparts[associated_key][MUTANT_INDEX_NAME]]
	genital_name = sprite_accessory.name
	genital_type = sprite_accessory.icon_state
	var/mob/living/carbon/human/human = dna_datum.holder
	if(dna_datum.features["uses_skintones"] && istype(human) && human.skin_tone)
		skintoned_colors = sanitize_hexcolor(skintone2hex(human.skin_tone), 6, TRUE)
		var/skin_tone_sanitized = sanitize_hexcolor(skintoned_colors, 6)
		mutantpart_info[MUTANT_INDEX_COLOR] = list(skin_tone_sanitized, skin_tone_sanitized, skin_tone_sanitized)
		set_greyscale(skintoned_colors)
	else
		set_greyscale(sanitize_hexcolor(mutantpart_info[MUTANT_INDEX_COLOR][1], 6, TRUE, "#FFFFFF"))
	update_sprite_suffix()

/// Handle cooming
/obj/item/organ/genital/proc/handle_climax(atom/target, method = INGEST, spill = TRUE)
	var/efficiency = get_slot_efficiency(organ_efficiency[1])
	if(efficiency < ORGAN_FAILING_EFFICIENCY)
		return
	var/volume = fluid_amount_orgasm * efficiency
	var/datum/reagents/cum_holder = new(1000)
	reagents.trans_id_to(cum_holder, fluid_reagent, volume)
	if(isturf(target))
		if(!splatter_type)
			var/turf/cummy_turf = target
			cummy_turf.add_liquid_from_reagents(cum_holder)
		else
			var/obj/effect/decal/cleanable/cummy_decal
			if(istype(splatter_type, /obj/effect/decal/cleanable/blood))
				cummy_decal = locate(/obj/effect/decal/cleanable/blood) in target
			if(!cummy_decal)
				cummy_decal = new splatter_type(target)
				if(cummy_decal.reagents)
					cummy_decal.reagents.remove_all(1000)
			cum_holder.trans_to(cummy_decal, cum_holder.total_volume, methods = method)
	else
		cum_holder.expose(target, method)
		if(spill)
			var/turf/cummy_turf = get_turf(target)
			if(!splatter_type)
				cummy_turf.add_liquid_from_reagents(cum_holder)
			else
				var/atom/movable/cummy_decal = locate(splatter_type) in cummy_turf
				if(istype(splatter_type, /obj/effect/decal/cleanable/blood))
					cummy_decal = locate(/obj/effect/decal/cleanable/blood) in cummy_turf
				if(!cummy_decal)
					cummy_decal = new splatter_type(target)
					if(cummy_decal.reagents)
						cummy_decal.reagents.remove_all(1000)
				cum_holder.trans_to(cummy_decal, cum_holder.total_volume, methods = method)
	if(pollutant_type)
		var/turf/open/target_turf = get_turf(target)
		if(istype(target_turf))
			target_turf.pollute_turf(pollutant_type, pollutant_amount)
	qdel(cum_holder)
	return TRUE

///Sets the size and updates the sprite
/obj/item/organ/genital/proc/set_size(size)
	genital_size = size
	update_sprite_suffix()

///Checks if the genital is visible
/obj/item/organ/genital/proc/is_visible()
	// If we don't have an owner, always visible (when dropped)
	if(!owner)
		return TRUE
		
	// Never show visibility setting - always hidden
	if(genital_visibility == GENITAL_SKIP_VISIBILITY || genital_visibility == GENITAL_NEVER_SHOW)
		return FALSE
		
	// Always show visibility setting - bypass clothing checks
	if(genital_visibility == GENITAL_ALWAYS_SHOW)
		return TRUE
		
	// For GENITAL_HIDDEN_BY_CLOTHES, check if the required body part is uncovered
	if(genital_visibility == GENITAL_HIDDEN_BY_CLOTHES)
		var/mob/living/carbon/human/human_owner = owner
		if(!istype(human_owner))
			return TRUE  // Not a human, show it
			
		// Check which body zone we're working with
		var/zone_to_check = (current_zone == BODY_ZONE_CHEST) ? BODY_ZONE_CHEST : BODY_ZONE_PRECISE_GROIN
		
		// If we're checking groin, check underwear
		if(zone_to_check == BODY_ZONE_PRECISE_GROIN)
			if(human_owner.underwear && (human_owner.underwear != "Nude"))
				if(!(human_owner.underwear_visibility & UNDERWEAR_HIDE_UNDIES))
					return FALSE
			
		// If we're checking chest, check undershirt
		if(zone_to_check == BODY_ZONE_CHEST)
			if(human_owner.undershirt && (human_owner.undershirt != "Nude"))
				if(!(human_owner.underwear_visibility & UNDERWEAR_HIDE_SHIRT))
					return FALSE
			
		// Get the bodypart and check if clothing covers it
		var/obj/item/bodypart/bp = owner.get_bodypart_nostump(zone_to_check)
		if(!bp)
			return FALSE
			
		// No clothing means it's visible!
		if(!LAZYLEN(human_owner.clothingonpart(bp)))
			return TRUE
			
		// If we got here with clothing, it's not visible
		return FALSE
		
	// Default - not visible
	return FALSE

///Basically the sprite suffix used for rendering
/obj/item/organ/genital/proc/update_sprite_suffix()
	return

///Translates size so it gets used in the sprite suffix
/obj/item/organ/genital/proc/translate_size_to_suffix(size = genital_size)
	return genital_size

///Translates size so it gets used in the get_genital_examine() proc
/obj/item/organ/genital/proc/translate_size_to_examine(size = genital_size)
	return genital_size

///Gets a string based on arousal for the examine
/obj/item/organ/genital/proc/get_arousal_examine()
	return

/obj/item/organ/genital/proc/get_genital_examine(direct_examine = FALSE)
	if(!is_visible())
		return
	if(direct_examine || !owner)
		return get_direct_examine()
	else
		return get_owner_examine()

/obj/item/organ/genital/proc/get_direct_examine()
	var/parsed_name = lowertext(genital_name)
	var/size_text = ""
	if(genital_size)
		size_text = translate_size_to_examine(genital_size)
		if(size_text)
			size_text = " [size_text]"
	
	var/result = span_notice("[uppertext(prefix_a_or_an(parsed_name))] [parsed_name][size_text] [name].")
	var/arousal = get_arousal_examine()
	if(arousal)
		result += arousal
	return result

/obj/item/organ/genital/proc/get_owner_examine()
	var/parsed_name = lowertext(genital_name)
	var/size_text = ""
	if(genital_size)
		size_text = translate_size_to_examine(genital_size)
		if(size_text)
			size_text = " [size_text]"
	
	var/result = span_notice("[owner.p_they(TRUE)] [owner.p_have()] \a [parsed_name][size_text] [name].")
	var/arousal = get_arousal_examine()
	if(arousal)
		result += arousal
	return result

/obj/item/organ/genital/proc/regenerate_cummies(delta_time, times_fired)
	if(is_failing() || !fluid_reagent)
		return
	var/list/receiving_organs = null
	if(fluid_receiving_slot)
		receiving_organs = owner.getorganslotlist(fluid_receiving_slot)
	var/efficiency = get_slot_efficiency(organ_efficiency[1])/ORGAN_OPTIMAL_EFFICIENCY
	var/total_cummies = 0
	var/maximum_cummies =  0
	if(!fluid_receiving_slot)
		maximum_cummies = reagents?.maximum_volume
		total_cummies = reagents?.total_volume
	else
		for(var/obj/item/organ/genital/cum_receiver as anything in receiving_organs)
			total_cummies += cum_receiver.reagents?.total_volume
			maximum_cummies += cum_receiver.reagents?.maximum_volume
	if(fluid_production_rate && LAZYLEN(organ_efficiency) && (total_cummies < maximum_cummies))
		reagents.add_reagent(fluid_reagent, fluid_production_rate * efficiency * delta_time, data = owner.get_blood_dna_list())
		owner.adjust_nutrition(-nutriment_req/100)
	for(var/obj/item/organ/genital/cum_receiver as anything in receiving_organs)
		reagents.trans_id_to(cum_receiver, fluid_reagent, fluid_production_rate * efficiency, TRUE)

/// Currently, only used by vagina and penis on blowjob and cunnilingus
/obj/item/organ/genital/proc/cum_on_face(mob/living/carbon/human/target)
	return
