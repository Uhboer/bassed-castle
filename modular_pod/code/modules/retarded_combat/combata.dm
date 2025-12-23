/*
/obj/item/bodypart/proc/another_special_destroying(mob/living/carbon/human/owner, mob/living/carbon/human/user, obj/item/bodypart/affected, obj/item/weapon, damage = 0, damage_flag = MELEE, damage_type = BRUTE, sharpness = NONE, def_zone = BODY_ZONE_CHEST, intended_zone = BODY_ZONE_CHEST, wound_messages = TRUE, list/modifiers)
	return

/obj/item/bodypart/mouth/another_special_destroying(mob/living/carbon/human/owner, mob/living/carbon/human/user, obj/item/bodypart/affected, obj/item/weapon, damage = 0, damage_flag = MELEE, damage_type = BRUTE, sharpness = NONE, def_zone = BODY_ZONE_CHEST, intended_zone = BODY_ZONE_CHEST, wound_messages = TRUE, list/modifiers)
	if(damage_flag == MELEE)
		if((sharpness & SHARP_POINTY) || (sharpness & SHARP_IMPALING))
			if(damage > 10)
				var/edge_protection = 0
				var/resultt = 0
				edge_protection = owner.get_edge_protection(src)
				resultt = (edge_protection - weapon.edge_protection_penetration)
				if(resultt <= 0)
					var/obj/item/organ/brain/brain = owner.getorganslot(ORGAN_SLOT_BRAIN)
					if(brain)
						brain.applyOrganDamage(damage/1.1)

/obj/item/bodypart/r_eyelid/another_special_destroying(mob/living/carbon/human/owner, mob/living/carbon/human/user, obj/item/bodypart/affected, obj/item/weapon, damage = 0, damage_flag = MELEE, damage_type = BRUTE, sharpness = NONE, def_zone = BODY_ZONE_CHEST, intended_zone = BODY_ZONE_CHEST, wound_messages = TRUE, list/modifiers)
	if(damage_flag == MELEE)
		if((sharpness & SHARP_POINTY) || (sharpness & SHARP_IMPALING))
			if(damage > 10)
				var/edge_protection = 0
				var/resultt = 0
				edge_protection = owner.get_edge_protection(src)
				resultt = (edge_protection - weapon.edge_protection_penetration)
				if(resultt <= 0)
					var/obj/item/organ/brain/brain = owner.getorganslot(ORGAN_SLOT_BRAIN)
					if(brain)
						brain.applyOrganDamage(damage/1.1)

/obj/item/bodypart/l_eyelid/another_special_destroying(mob/living/carbon/human/owner, mob/living/carbon/human/user, obj/item/bodypart/affected, obj/item/weapon, damage = 0, damage_flag = MELEE, damage_type = BRUTE, sharpness = NONE, def_zone = BODY_ZONE_CHEST, intended_zone = BODY_ZONE_CHEST, wound_messages = TRUE, list/modifiers)
	if(damage_flag == MELEE)
		if((sharpness & SHARP_POINTY) || (sharpness & SHARP_IMPALING))
			if(damage > 10)
				var/edge_protection = 0
				var/resultt = 0
				edge_protection = owner.get_edge_protection(src)
				resultt = (edge_protection - weapon.edge_protection_penetration)
				if(resultt <= 0)
					var/obj/item/organ/brain/brain = owner.getorganslot(ORGAN_SLOT_BRAIN)
					brain.applyOrganDamage(damage/1.1)
*/

// Base special gore effects for bodyparts
/obj/item/bodypart/proc/special_gore(mob/living/carbon/human/owner, obj/item/bodypart/affected, damage = 0, sharpness = NONE, wound_messages = TRUE)
	return TRUE

/obj/item/bodypart/chest/special_gore(mob/living/carbon/human/owner, obj/item/bodypart/affected, damage = 0, sharpness = NONE, wound_messages = TRUE)
	// Requirements for reproductive damage
	if(damage <= 8 || !sharpness || prob(50))
		return FALSE

	if(limb_integrity < (max_damage/2))
		return FALSE

	var/edge_protection = owner.get_edge_protection(src)
	if(edge_protection > 0)
		return FALSE

	// Check and handle different reproductive organs
	var/breastse = owner.getorganslot(ORGAN_SLOT_BREASTS)

	if(!breastse)
		return FALSE

	// Penis removal
	if(breastse && prob(60))
		var/list/breasts = getorganslotlist(ORGAN_SLOT_BREASTS)
		for(var/obj/item/organ/breastss in breasts)
			breastss.Remove(breastss.owner)
			if(QDELETED(breastss))
				continue

			breastss.organ_flags |= ORGAN_CUT_AWAY
			var/turf/drop_location = owner.drop_location()
			if(istype(drop_location))
				breastss.forceMove(owner.drop_location())

			SEND_SIGNAL(owner, COMSIG_CARBON_ADD_TO_WOUND_MESSAGE, span_bolddanger(" [span_big("Breasts are cut off!")]"))
			owner.custom_pain("MY BREASTS!", rand(30, 40), affecting = src)
			if(!owner.IsUnconscious() || (owner.get_chem_effect(CE_PAINKILLER) < 50))
				owner.death_scream()

// Groin - handles reproductive organ dismemberment
/obj/item/bodypart/groin/special_gore(mob/living/carbon/human/owner, obj/item/bodypart/affected, damage = 0, sharpness = NONE, wound_messages = TRUE)
	// Requirements for reproductive damage
	if(damage <= 8 || !sharpness || prob(50))
		return FALSE

	if(limb_integrity < (max_damage/2))
		return FALSE

	var/edge_protection = owner.get_edge_protection(src)
	if(edge_protection > 0)
		return FALSE

	// Check and handle different reproductive organs
	var/penid = owner.getorganslot(ORGAN_SLOT_PENIS)
	var/balld = owner.getorganslot(ORGAN_SLOT_TESTICLES)
	var/vagind = owner.getorganslot(ORGAN_SLOT_VAGINA)

	if(!penid && !balld && !vagind)
		return FALSE

	// Penis removal
	if(penid && prob(60))
		var/list/peniss = getorganslotlist(ORGAN_SLOT_PENIS)
		for(var/obj/item/organ/penis in peniss)
			penis.Remove(penis.owner)
			if(QDELETED(penis))
				continue

			penis.organ_flags |= ORGAN_CUT_AWAY
			var/turf/drop_location = owner.drop_location()
			if(istype(drop_location))
				penis.forceMove(owner.drop_location())

			SEND_SIGNAL(owner, COMSIG_CARBON_ADD_TO_WOUND_MESSAGE, span_bolddanger(" [span_big("Penis is cut off!")]"))
			owner.custom_pain("MY PENIS!", rand(30, 40), affecting = src)
			if(!owner.IsUnconscious() || (owner.get_chem_effect(CE_PAINKILLER) < 50))
				owner.death_scream()

	// Testicles removal
	else if(balld && prob(60))
		var/list/ballss = getorganslotlist(ORGAN_SLOT_TESTICLES)
		for(var/obj/item/organ/balls in ballss)
			balls.Remove(balls.owner)
			if(QDELETED(balls))
				continue

			balls.organ_flags |= ORGAN_CUT_AWAY
			var/turf/drop_location = owner.drop_location()
			if(istype(drop_location))
				balls.forceMove(owner.drop_location())

			SEND_SIGNAL(owner, COMSIG_CARBON_ADD_TO_WOUND_MESSAGE, span_bolddanger(" [span_big("Balls are cut off!")]"))
			owner.custom_pain("MY BALLS!", rand(30, 40), affecting = src)
			if(!owner.IsUnconscious() || (owner.get_chem_effect(CE_PAINKILLER) < 50))
				owner.death_scream()

	// Vagina removal
	else if(vagind && prob(60))
		var/list/vaginaa = getorganslotlist(ORGAN_SLOT_VAGINA)
		for(var/obj/item/organ/vagina in vaginaa)
			vagina.Remove(vagina.owner)
			if(QDELETED(vagina))
				continue

			vagina.organ_flags |= ORGAN_CUT_AWAY
			var/turf/drop_location = owner.drop_location()
			if(istype(drop_location))
				vagina.forceMove(owner.drop_location())

			SEND_SIGNAL(owner, COMSIG_CARBON_ADD_TO_WOUND_MESSAGE, span_bolddanger(" [span_big("Vagina is cut off!")]"))
			owner.custom_pain("MY VAGINA!", rand(30, 40), affecting = src)
			if(!owner.IsUnconscious() || (owner.get_chem_effect(CE_PAINKILLER) < 50))
				owner.death_scream()

// Helper function for eye damage
/obj/item/bodypart/proc/handle_eye_gore(mob/living/carbon/human/owner, obj/item/bodypart/affected, side_text)
	if(!getorganslot(ORGAN_SLOT_EYES))
		return FALSE

	if(limb_integrity < (max_damage/2))
		return FALSE

	var/edge_protection = owner.get_edge_protection(src)
	if(edge_protection > 0)
		return FALSE

	var/obj/item/organ/eyes/eyeb = getorganslot(ORGAN_SLOT_EYES)
	if (!eyeb)
		return FALSE
	eyeb.Remove(eyeb.owner)
	eyeb.organ_flags |= ORGAN_CUT_AWAY
	qdel(eyeb)

	SEND_SIGNAL(owner, COMSIG_CARBON_ADD_TO_WOUND_MESSAGE, span_bolddanger(" [span_big("Eye bursts!")]"))
	owner.custom_pain("OH! [side_text] EYE!", rand(30, 40), affecting = src)
	if(!owner.IsUnconscious() || (owner.get_chem_effect(CE_PAINKILLER) < 50))
		owner.death_scream()
	return TRUE

/obj/item/bodypart/proc/handle_eye_out(mob/living/carbon/human/owner, obj/item/bodypart/affected, side_text)
	if(!getorganslot(ORGAN_SLOT_EYES))
		return FALSE

	if(limb_integrity < (max_damage/2))
		return FALSE

	var/edge_protection = owner.get_edge_protection(src)
	if(edge_protection > 0)
		return FALSE

	var/obj/item/organ/eyes/eyeb = getorganslot(ORGAN_SLOT_EYES)
	if (!eyeb)
		return FALSE

	if(eyeb)
		eyeb.Remove(eyeb.owner)
		eyeb.organ_flags |= ORGAN_CUT_AWAY
		var/turf/drop_location = owner.drop_location()
		if(istype(drop_location))
			eyeb.forceMove(owner.drop_location())

		SEND_SIGNAL(owner, COMSIG_CARBON_ADD_TO_WOUND_MESSAGE, span_bolddanger(" [span_big("Eye is knocked out!")]"))
		owner.custom_pain("OH! [side_text] EYE!", rand(30, 40), affecting = src)
		if(!owner.IsUnconscious() || (owner.get_chem_effect(CE_PAINKILLER) < 50))
			owner.death_scream()

// Left eye handling
/obj/item/bodypart/l_eyelid/special_gore(mob/living/carbon/human/owner, obj/item/bodypart/affected, damage = 0, sharpness = NONE, wound_messages = TRUE)
	if(damage > 8 && prob(50))
		if (prob(50))
			handle_eye_gore(owner, affected, "MY LEFT")
		else
			handle_eye_out(owner, affected, "MY LEFT")

// Right eye handling
/obj/item/bodypart/r_eyelid/special_gore(mob/living/carbon/human/owner, obj/item/bodypart/affected, damage = 0, sharpness = NONE, wound_messages = TRUE)
	if(damage > 8 && prob(50))
		if (prob(50))
			handle_eye_gore(owner, affected, "MY RIGHT")
		else
			handle_eye_out(owner, affected, "MY RIGHT")

// Vitals - handles intestines spilling
/obj/item/bodypart/vitals/special_gore(mob/living/carbon/human/owner, obj/item/bodypart/affected, damage = 0, sharpness = NONE, wound_messages = TRUE)
	if(damage < 8 || !sharpness || prob(40))
		return FALSE

	var/edge_protection = owner.get_edge_protection(src)
	if(edge_protection > 0)
		return FALSE

	if(!getorganslot(ORGAN_SLOT_INTESTINES) || spilled)
		return FALSE

	if(limb_integrity < (max_damage/2))
		return FALSE

	var/list/intestines = getorganslotlist(ORGAN_SLOT_INTESTINES)
	for(var/obj/item/organ/gut in intestines)
		gut.Remove(gut.owner)
		if(QDELETED(gut))
			continue

		gut.organ_flags |= ORGAN_CUT_AWAY
		var/sound_effect = list('modular_septic/sound/gore/spill1.ogg', 'modular_septic/sound/gore/spill2.ogg')
		playsound(owner, pick(sound_effect), 100, TRUE)

		spilled = TRUE
		owner.bleed(20)
		owner.update_damage_overlays()
		SEND_SIGNAL(owner, COMSIG_CARBON_ADD_TO_WOUND_MESSAGE, span_bolddanger(" [span_big("Guts are spilled!")]"))

		var/turf/drop_location = owner.drop_location()
		if(istype(drop_location))
			gut.forceMove(owner.drop_location())
			owner.AddComponent(/datum/component/rope, gut, 'modular_septic/icons/effects/beam.dmi', "gut_beam2", 3, TRUE, /obj/effect/ebeam/gut, CALLBACK(owner, /mob/living/carbon/proc/gut_cut))
		else
			qdel(gut)

	for(var/obj/item/grab/grabber as anything in grasped_by)
		grabber.update_grab_mode()