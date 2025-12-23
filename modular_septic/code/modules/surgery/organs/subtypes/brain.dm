#define BRAIN_TRAIT "brain"

/obj/item/organ/brain
	name = "Brain"
	desc = "Compact cluster of neurons and synapses."
	icon_state = "brain"
	throw_speed = 3
	throw_range = 5
	layer = ABOVE_MOB_LAYER
	zone = BODY_ZONE_HEAD
	organ_efficiency = list(ORGAN_SLOT_BRAIN = 100)
	unique_slot = ORGAN_SLOT_BRAIN
	organ_flags = ORGAN_EDIBLE|ORGAN_VITAL|ORGAN_INDESTRUCTIBLE
	attack_verb_continuous = list("attacks", "slaps", "whacks")
	attack_verb_simple = list("attack", "slap", "whack")
	w_class = WEIGHT_CLASS_NORMAL

	// The brain's organ variables are significantly more different than the other organs, with half the decay rate for balance reasons, and twice the maxHealth
	maxHealth = BRAIN_DAMAGE_DEATH
	healing_factor = BRAIN_DAMAGE_DEATH/200
	low_threshold = BRAIN_DAMAGE_DEATH * 0.25
	high_threshold = BRAIN_DAMAGE_DEATH * 0.75
	pain_multiplier = 0 // We don't count towards bodypart pain for balance reasons
	internal_damage_modifier = 2 // Brains are easy to hurty

	// head cavity volume is 6
	organ_volume = 2
	max_blood_storage = 25
	current_blood = 25
	blood_req = 5
	oxygen_req = 10
	nutriment_req = 10
	hydration_req = 10

	/// This is stuff
	var/damage_threshold_value = BRAIN_DAMAGE_DEATH/10
	/// Suicide is fucking retarded
	var/suicided = FALSE
	/// The actual mob, if for some reason the brain got lobbed off
	var/mob/living/brain/brainmob
	/// If it's a fake brain with no brainmob assigned. Feedback messages will be faked as if it does have a brainmob. See changelings & dullahans.
	var/decoy_override = FALSE
	/// Brain traumas
	var/list/datum/brain_trauma/traumas = list()
	/// List of skillchip items, their location should be this brain.
	var/list/obj/item/skillchip/skillchips
	/// Maximum skillchip complexity we can support before they stop working. Do not reference this var directly and instead call get_max_skillchip_complexity()
	var/max_skillchip_complexity = 3
	/// Maximum skillchip slots available. Do not reference this var directly and instead call get_max_skillchip_slots()
	var/max_skillchip_slots = 5

	// Permanent brain damage effects tracking
	var/permanent_damage = 0
	var/damage_threshold_mild = 30
	var/damage_threshold_medium = 60
	var/damage_threshold_severe = 90
	var/damage_threshold_critical = 120
	var/has_permanent_effects = FALSE
	var/current_severity_level = 0 // 0 = none, 1 = mild, 2 = medium, 3 = severe, 4 = critical

	// Track cumulative damage for gameplay progression
	var/cumulative_damage = 0
	var/cumulative_damage_threshold = 150 // At this point, permanent effects start
	var/last_damage_time = 0
	var/damage_recovery_rate = 0.5 // How much cumulative damage is reduced per second when no new damage occurs

	// Brain region damage tracking - realistic neurological subsystems
	var/frontal_lobe_damage = 0 // Decision making, impulse control, personality
	var/temporal_lobe_damage = 0 // Memory, language processing, emotion
	var/parietal_lobe_damage = 0 // Sensory processing, spatial awareness
	var/occipital_lobe_damage = 0 // Visual processing
	var/cerebellar_damage = 0 // Motor control, coordination, balance
	var/brainstem_damage = 0 // Autonomic functions (breathing, heart rate)

	// Brain damage effect triggers
	var/memories_damaged = FALSE // Memory system damage
	var/motor_damaged = FALSE // Motor control system damage
	var/emotion_damaged = FALSE // Emotional regulation system damage
	var/language_damaged = FALSE // Language processing system damage
	var/sensory_damaged = FALSE // Sensory processing system damage
	var/autonomic_damaged = FALSE // Autonomic function damage

	// Brain region damage thresholds
	var/region_damage_threshold = 15 // When regions start showing effects
	var/region_critical_threshold = 40 // When regions are severely impaired
	var/region_recovery_rate = 0.2 // How much region damage recovers per life tick

/obj/item/organ/brain/Insert(mob/living/carbon/new_owner, special = FALSE, drop_if_replaced = TRUE, new_zone = null, no_id_transfer = FALSE)
	. = ..()
	name = initial(name)
	if(new_owner.mind?.has_antag_datum(/datum/antagonist/changeling) && !no_id_transfer) //congrats, you're trapped in a body you don't control
		if(brainmob && !(new_owner.stat == DEAD || (HAS_TRAIT(new_owner, TRAIT_DEATHCOMA))))
			to_chat(brainmob, span_danger("I can't feel the body! I'm just a brain!"))
		forceMove(new_owner)
		return

	if(brainmob)
		if(new_owner.key)
			new_owner.ghostize()

		if(brainmob.mind)
			brainmob.mind.transfer_to(new_owner)
		else
			new_owner.key = brainmob.key

		QDEL_NULL(brainmob)

	for(var/datum/brain_trauma/trauma as anything in traumas)
		trauma.owner = owner
		trauma.on_gain()

	// Apply permanent damage effects to the new owner
	if(has_permanent_effects && new_owner)
		apply_permanent_effects(new_owner)

	// Apply region-specific damage effects
	apply_regional_effects(new_owner)

/obj/item/organ/brain/Remove(mob/living/carbon/old_owner, special = FALSE, no_id_transfer = FALSE)
	// Remove all brain-related traits
	if(old_owner)
		REMOVE_TRAIT(old_owner, TRAIT_CLUMSY, BRAIN_TRAIT)
		REMOVE_TRAIT(old_owner, TRAIT_DUMB, BRAIN_TRAIT)
		REMOVE_TRAIT(old_owner, TRAIT_UNSTABLE, BRAIN_TRAIT)
		REMOVE_TRAIT(old_owner, TRAIT_ANXIOUS, BRAIN_TRAIT)
		REMOVE_TRAIT(old_owner, TRAIT_SLEEPINESS, BRAIN_TRAIT)
		REMOVE_TRAIT(old_owner, TRAIT_DEPRESSION, BRAIN_TRAIT)

	// Delete skillchips first as parent proc sets owner to null, and skillchips need to know the brain's owner.
	if(!QDELETED(old_owner) && length(skillchips))
		to_chat(old_owner, span_notice("I feel my skillchips enable emergency power saving mode, deactivating as my brain leaves my body..."))
		for(var/chip in skillchips)
			var/obj/item/skillchip/skillchip = chip
			// Run the try_ proc with force = TRUE.
			skillchip.try_deactivate_skillchip(FALSE, TRUE)
	. = ..()
	for(var/X in traumas)
		var/datum/brain_trauma/trauma = X
		trauma.on_lose(TRUE)
		trauma.owner = null

	if(!QDELETED(src) && !QDELETED(old_owner) && !no_id_transfer)
		transfer_identity(old_owner)

/obj/item/organ/brain/handle_blood(delta_time, times_fired)
	var/effective_blood_oxygenation = GET_EFFECTIVE_BLOOD_VOL(owner.get_blood_oxygenation(), owner.total_blood_req)
	var/arterial_efficiency = get_slot_efficiency(ORGAN_SLOT_ARTERY)
	var/in_bleedout = owner.in_bleedout()
	if(arterial_efficiency && !is_failing())
		// Arteries get an extra flat 5 blood regen
		current_blood = min(current_blood + 5 * (0.5 * delta_time) * (arterial_efficiency/ORGAN_OPTIMAL_EFFICIENCY), max_blood_storage)
		return
	if(!blood_req)
		return
	if(!in_bleedout && (effective_blood_oxygenation >= BLOOD_VOLUME_SAFE))
		current_blood = min(current_blood + (blood_req * (0.5 * delta_time)), max_blood_storage)
		return
	if(in_bleedout)
		current_blood = max(current_blood - (blood_req * (0.5 * delta_time)), 0)
	else
		current_blood = max(current_blood - (blood_req * ((BLOOD_VOLUME_NORMAL-effective_blood_oxygenation)/BLOOD_VOLUME_NORMAL) * (0.5 * delta_time)), 0)
	// When all blood is lost, take blood from blood vessels
	if(!current_blood)
		var/obj/item/organ/artery
		var/obj/item/bodypart/parent = owner.get_bodypart(current_zone)
		for(var/thing in shuffle(parent?.getorganslotlist(ORGAN_SLOT_ARTERY)))
			var/obj/item/organ/candidate = thing
			if(candidate.current_blood && (candidate.get_slot_efficiency(ORGAN_SLOT_ARTERY) >= ORGAN_FAILING_EFFICIENCY))
				artery = candidate
				break
		if(artery?.current_blood)
			var/prev_blood = artery.current_blood
			artery.current_blood = max(artery.current_blood - (blood_req * 0.5 * delta_time), 0)
			current_blood = max(prev_blood - artery.current_blood, 0)
		//Don't apply damage, this is handled by the organ process datum, if necessary

/obj/item/organ/brain/organ_failure(delta_time)
	if(HAS_TRAIT(owner, TRAIT_NOHARDCRIT))
		REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, CRIT_HEALTH_TRAIT)
		return
	if(owner.stat < UNCONSCIOUS)
		owner.visible_message(span_danger("<b>[owner]</b> starts to convulse!"), \
							span_userdanger("I'm convulsing!"))
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, CRIT_HEALTH_TRAIT)
	owner.Jitter(1000)
	owner.Unconscious(4 SECONDS)

/obj/item/organ/brain/on_owner_examine(datum/source, mob/user, list/examine_list)
	if(!ishuman(owner) || !is_failing())
		return
	if(owner.jitteriness >= 300)
		examine_list += span_flashingdanger(span_big("<b>[owner]</b> convulses!"))

/obj/item/organ/brain/can_heal(delta_time, times_fired)
	. = TRUE
	if(!owner)
		return FALSE
	if(healing_factor <= 0)
		return FALSE
	if(is_dead())
		return FALSE
	if(current_blood <= 0)
		return FALSE
	if(owner.undergoing_cardiac_arrest())
		return FALSE
	var/effective_blood_oxygenation = GET_EFFECTIVE_BLOOD_VOL(owner.get_blood_oxygenation(), owner.total_blood_req)
	if(effective_blood_oxygenation < BLOOD_VOLUME_SAFE)
		return FALSE
	// if stable and not too damaged we can heal
	if(!past_damage_threshold(3) && owner.get_chem_effect(CE_STABLE))
		return TRUE
	// else, we only naturally regen to basically get rounded
	if(!(damage % damage_threshold_value) || owner.get_chem_effect(CE_BRAIN_REGEN))
		return FALSE

/obj/item/organ/brain/transfer_to_limb(obj/item/bodypart/new_limb, mob/living/carbon/human/was_owner)
	. = ..()
	new_limb.brain = src
	if(brainmob)
		new_limb.brainmob = brainmob
		brainmob = null
		new_limb.brainmob.forceMove(new_limb)
		new_limb.brainmob.set_stat(DEAD)

/obj/item/organ/brain/handle_organ_attack(obj/item/tool, mob/living/user, params)
	if(owner && DOING_INTERACTION_WITH_TARGET(user, owner))
		return TRUE
	else if(DOING_INTERACTION_WITH_TARGET(user, src))
		return TRUE
	if(owner && CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		for(var/thing in attaching_items)
			if(istype(tool, thing))
				handle_attaching_item(tool, user, params)
				return TRUE
	for(var/thing in healing_items)
		if(istype(tool, thing))
			handle_healing_item(tool, user, params)
			return TRUE
	for(var/thing in healing_tools)
		if(tool.tool_behaviour == thing)
			handle_healing_item(tool, user, params)
			return TRUE
	// LOBOTOMITE
	if(owner && (tool.tool_behaviour == TOOL_HEMOSTAT))
		handle_lobotomy(tool, user, params)
		return TRUE
	if(owner && CHECK_BITFIELD(tool.get_sharpness(), SHARP_EDGED) && !CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		handle_cutting_away(tool, user, params)
		return TRUE
	// Attempt to heal the brain
	if(is_failing() && tool.is_drainable() && tool.reagents.has_reagent(/datum/reagent/medicine/mannitol))
		if(brainmob?.health <= HEALTH_THRESHOLD_DEAD) //if the brain is fucked anyway, do nothing
			to_chat(user, span_warning("[src] too damaged... And there's nothing I can do about it."))
			return TRUE
		if(!tool.reagents.has_reagent(/datum/reagent/medicine/mannitol, 10))
			to_chat(user, span_warning("Not enough for healing [src]!"))
			return TRUE
		user.visible_message(span_notice("<b>[user]</b> начинает лить жидкость из [tool] на [src]."),
						span_notice("Я начинаю лить жидкость из [tool] на [src]."))
		if(!do_after(user, 5 SECONDS, src))
			to_chat(user, span_warning("Я провалился в своей затее!"))
			return TRUE
		user.visible_message(span_notice("<b>[user]</b> льёт жидкость из [tool] на [src], заставляя его изменить свою первоначальную форму и приобрести более яркий оттенок розового."), \
						span_notice("Я лью жидкость из [tool] на [src], заставляя его изменить свою первоначальную форму и приобрести более яркий оттенок розового."))
		var/healby = tool.reagents.get_reagent_amount(/datum/reagent/medicine/mannitol)
		applyOrganDamage(-healby*2) //heals 2 damage per unit of mannitol
		tool.reagents.clear_reagents()
		return TRUE
	// Cutting out skill chips.
	if(length(skillchips) && (tool.get_sharpness() & SHARP_EDGED))
		to_chat(user,span_notice("I begin to excise skillchips from [src]."))
		if(do_after(user, 10 SECONDS, target = src))
			for(var/chip in skillchips)
				var/obj/item/skillchip/skillchip = chip
				if(!istype(skillchip))
					stack_trace("Item of type [skillchip.type] qdel'd from [src] skillchip list.")
					qdel(skillchip)
					continue
				remove_skillchip(skillchip)
				if(skillchip.removable)
					skillchip.forceMove(drop_location())
					continue
				qdel(skillchip)
			skillchips = null
		return TRUE

/obj/item/organ/brain/handle_healing_item(obj/item/tool, mob/living/user, params)
	var/obj/item/stack/stack = tool
	if(organ_flags & (ORGAN_DESTROYED|ORGAN_DEAD))
		to_chat(user, span_warning("\[src] is too damaged..."))
		return
	if(!damage && !length(traumas))
		to_chat(user, span_notice("\[src] in excellent quality."))
		return
	user.visible_message(span_notice("<b>[user]</b> begins to heal \[src]..."), \
					span_notice("I'm starting to heal \[src]..."), \
					vision_distance = COMBAT_MESSAGE_RANGE)
	if(owner)
		owner.custom_pain("OH! Something touches my [src]!", 30, FALSE, owner.get_bodypart(current_zone))
		if(!do_mob(user, owner, 5 SECONDS))
			to_chat(user, span_warning("I need to stay still!"))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
	else
		if(!do_after(user, 5 SECONDS, src))
			to_chat(user, span_warning("I need to stay still!"))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
	if(istype(stack))
		if(!stack.use(2))
			to_chat(user, span_warning("It's not enough to heal \[src]!"))
			return
	user.visible_message(span_notice("<b>[user]</b> heals \[src]."), \
						span_notice("I heal \[src]."))
	applyOrganDamage(-min(maxHealth/2, 50))
	cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)

/obj/item/organ/brain/surgical_examine(mob/user)
	. = ..()
	if(length(skillchips) >= 2)
		. += span_info("It has some skillchips embedded in it.")
	else if(length(skillchips))
		. += span_info("It has a skillchip embedded in it.")
	if((brainmob && (brainmob.client || brainmob.get_ghost())) || decoy_override)
		if(is_failing())
			. += span_info("Damaged, but there's still some energy here...")
		else if(damage >= BRAIN_DAMAGE_DEATH*0.5)
			. += span_info("A little damaged, but there are still sparks of life.")
		else
			. += span_info("There is a spark of life.")
	else
		. += span_info("It's completely devoid of life.")

/obj/item/organ/brain/Destroy(force)
	if(brainmob)
		QDEL_NULL(brainmob)
	QDEL_LIST(traumas)
	destroy_all_skillchips()
	if(owner)
		//You aren't allowed to return to brains that don't exist
		owner.mind?.set_current(null)
		var/obj/item/bodypart/parent_part = owner.get_bodypart(current_zone)
		//Delete the brain mob first, don't leave it stranded
		if(parent_part.brainmob)
			QDEL_NULL(parent_part.brainmob)
	return ..()

/obj/item/organ/brain/applyOrganDamage(amount, maximum = maxHealth, silent = FALSE)
	if(!amount) //Micro-optimization.
		return
	if(maximum < damage)
		damage = maximum
	if(damage < 0 && owner?.get_chem_effect(CE_BRAIN_REGEN))
		damage *= 2
	prev_damage = damage
	damage = clamp(damage + amount, 0, maximum)
	var/mess = check_damage_thresholds(owner)
	if(owner)
		if(mess && !silent)
			to_chat(owner, mess)
		if(organ_flags & ORGAN_LIMB_SUPPORTER)
			var/obj/item/bodypart/affected = owner.get_bodypart(current_zone)
			affected?.update_limb_efficiency()
		if(amount >= 10)
			var/damage_side_effect = CEILING(amount/2, 1)
			if(damage_side_effect >= 1)
				owner.flash_pain(damage_side_effect*4)
//				owner.blur_eyes(damage_side_effect)
				owner.add_confusion(damage_side_effect)
				switch(rand(0,3))
					if(1)
						owner.stuttering += damage_side_effect
					if(2)
						owner.slurring += damage_side_effect
					if(3)
						owner.cultslurring += damage_side_effect
				if(damage_side_effect >= 5)
					if(prob(50))
						owner.shit(FALSE)
					else
						owner.piss(FALSE)
				owner.CombatKnockdown(damage_side_effect*2, damage_side_effect, (damage_side_effect >= 5 ? damage_side_effect : null), damage_side_effect >= 5)
		if(!is_failing())
			REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, CRIT_HEALTH_TRAIT)

	// Process brain region damage when any damage is applied
	if(amount > 0)
		// Track cumulative damage for permanent effects
		cumulative_damage += amount
		last_damage_time = world.time

		// Process permanent damage
		var/perm_damage_to_add = 0
		if(amount >= 15)
			// Serious hits cause permanent damage
			perm_damage_to_add = amount * 0.15
		else if(amount >= 8)
			// Moderate hits cause less permanent damage
			perm_damage_to_add = amount * 0.08
		else
			// Small hits cause minimal permanent damage
			perm_damage_to_add = amount * 0.03

		// Critical hits cause more permanent damage
		if(damage > (maxHealth * 0.6))
			perm_damage_to_add *= 1.5

		permanent_damage += perm_damage_to_add
		update_permanent_effects()

		// Apply damage to specific brain regions based on injury type
		// Different types of brain damage affect different regions
		distribute_brain_damage(amount)

/obj/item/organ/brain/check_damage_thresholds(mob/M)
	. = ..()
	// if we're not more injured than before, return without gambling for a trauma
	if(damage <= prev_damage)
		return
	var/damage_delta = damage - prev_damage
	// Safeguard to prevent traumas from low damage
	if((damage_delta >= TRAUMA_ROLL_THRESHOLD) && (damage >= BRAIN_DAMAGE_MILD))
		var/is_boosted = (owner && HAS_TRAIT(owner, TRAIT_SPECIAL_TRAUMA_BOOST))
		var/intelligence_modifier = (owner ? -(GET_MOB_ATTRIBUTE_VALUE(owner, STAT_INTELLIGENCE)-ATTRIBUTE_MIDDLING) : 0)
		if(damage >= BRAIN_DAMAGE_SEVERE)
			// Base chance is the hit damage, plus intelligence mod; for every point of damage past the threshold the chance is increased by 1%
			if(prob((damage_delta+intelligence_modifier) * (1 + max(0, (damage - BRAIN_DAMAGE_SEVERE)/100))))
				if(prob(20 + (is_boosted * 30) - (intelligence_modifier * 2)))
					gain_trauma_type(BRAIN_TRAUMA_SPECIAL, is_boosted ? TRAUMA_RESILIENCE_SURGERY : null, natural_gain = TRUE)
				else
					gain_trauma_type(BRAIN_TRAUMA_SEVERE, natural_gain = TRUE)
		else
			// Base chance is the hit damage, plus intelligence mod; for every point of damage past the threshold the chance is increased by 1%
			if(prob((damage_delta+intelligence_modifier) * (1 + max(0, (damage - BRAIN_DAMAGE_MILD)/100))))
				gain_trauma_type(BRAIN_TRAUMA_MILD, natural_gain = TRUE)
	if(owner)
		var/special_message = FALSE
		if(damage >= BRAIN_DAMAGE_DEATH && prev_damage < BRAIN_DAMAGE_DEATH && (organ_flags & ORGAN_VITAL))
			var/dicerolli = owner.diceroll(GET_MOB_ATTRIBUTE_VALUE(owner, STAT_LUCK), context = DICE_CONTEXT_MENTAL)
			if(dicerolli >= DICE_CRIT_SUCCESS)
				applyOrganDamage(-min(maxHealth/3, 50))
				special_message = TRUE
			else
				owner.death()
				return
		var/brain_message
		if(prev_damage < BRAIN_DAMAGE_MILD && damage >= BRAIN_DAMAGE_MILD)
			brain_message = span_warning("I feel dizzy...")
		else if(prev_damage < BRAIN_DAMAGE_SEVERE && damage >= BRAIN_DAMAGE_SEVERE)
			brain_message = span_warning("It's like I'm losing control of my thoughts!")
		else if(prev_damage < (BRAIN_DAMAGE_DEATH - 20) && damage >= (BRAIN_DAMAGE_DEATH - 20) && damage < BRAIN_DAMAGE_DEATH)
			brain_message = span_warning("MY CONSCIOUSNESS IS BLINKING!")
		if(.)
			. += "\n[brain_message]"
		else
			if (!special_message)
				return brain_message
			else
				brain_message = span_warning("I narrowly escaped death!")
				return brain_message

/obj/item/organ/brain/before_organ_replacement(obj/item/organ/replacement)
	. = ..()
	var/obj/item/organ/brain/replacement_brain = replacement
	if(!istype(replacement_brain))
		return

	// If we have some sort of brain type or subtype change and have skillchips, engage the failsafe procedure!
	if(owner && length(skillchips) && (replacement_brain.type != type))
		activate_skillchip_failsafe(FALSE)

	// Check through all our skillchips, remove them from this brain, add them to the replacement brain.
	for(var/chip in skillchips)
		var/obj/item/skillchip/skillchip = chip

		// We're technically doing a little hackery here by bypassing the procs, but I'm the one who wrote them
		// and when you know the rules, you can break the rules.

		// Technically the owning mob is the same. We don't need to activate or deactivate the skillchips.
		// All the skillchips themselves care about is what brain they're in.
		// Because the new brain will ultimately be owned by the same body, we can safely leave skillchip logic alone.

		// Directly change the new holding_brain.
		skillchip.holding_brain = replacement_brain
		//And move the actual obj into the new brain (contents)
		skillchip.forceMove(replacement_brain)

		// Directly add them to the skillchip list in the new brain.
		LAZYADD(replacement_brain.skillchips, skillchip)

	// Any skillchips has been transferred over, time to empty the list.
	LAZYCLEARLIST(skillchips)

/obj/item/organ/brain/proc/handle_lobotomy(obj/item/tool, mob/living/user, params)
	user.visible_message(span_notice("<b>[user]</b> начинает лоботомизировать \[src]..."), \
					span_notice("Я начинаю лоботомизировать \[src]..."), \
					vision_distance = COMBAT_MESSAGE_RANGE)
	owner.custom_pain("OH GOD! My [src] is being SLASHED IN TWAIN!", 30, FALSE, owner.get_bodypart(current_zone))
	if(!do_mob(user, owner, 10 SECONDS))
		to_chat(user, span_warning("Я должен стоять смирно!"))
		return TRUE
	user.visible_message(span_notice("<b>[user]</b> лоботомизирует \[src]."), \
					span_notice("Я лоботомизирую \[src]."), \
					vision_distance = COMBAT_MESSAGE_RANGE)
	switch(owner.diceroll(GET_MOB_ATTRIBUTE_VALUE(owner, STAT_ENDURANCE), context = DICE_CONTEXT_MENTAL))
		// Cure all traumas, no penalties
		if(DICE_CRIT_SUCCESS)
			cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
		// Cure all traumas, but gain a mild one
		if(DICE_SUCCESS)
			cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
			gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_SURGERY)
		// Cure nothing, lose intelligence, go fuck yourself
		if(DICE_FAILURE)
			owner.attributes.add_attribute_modifier(/datum/attribute_modifier/lobotomy, TRUE)
		// Cure nothing, lose intelligence, gain another brain trauma, go fuck yourself
		if(DICE_CRIT_FAILURE)
			owner.attributes.add_attribute_modifier(/datum/attribute_modifier/lobotomite, TRUE)
			gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	//no matter how shitty the lobotomy, always cure brainwashing
	if(owner.mind?.has_antag_datum(/datum/antagonist/brainwashed))
		owner.mind.remove_antag_datum(/datum/antagonist/brainwashed)
	return TRUE

/obj/item/organ/brain/proc/get_current_damage_threshold()
	return FLOOR(damage / damage_threshold_value, 1)

/obj/item/organ/brain/proc/past_damage_threshold(threshold)
	return (get_current_damage_threshold() > threshold)

/obj/item/organ/brain/proc/transfer_identity(mob/living/transferer)
	if(brainmob || decoy_override)
		return
	if(!transferer.mind)
		return
	brainmob = new(src)
	brainmob.name = transferer.real_name
	brainmob.real_name = transferer.real_name
	brainmob.timeofhostdeath = transferer.timeofdeath
	brainmob.suiciding = suicided
	if(transferer.has_dna())
		var/mob/living/carbon/carbon_transferer = transferer
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		carbon_transferer.dna.copy_dna(brainmob.stored_dna)
		if(HAS_TRAIT(carbon_transferer, TRAIT_BADDNA))
			LAZYSET(brainmob.status_traits, TRAIT_BADDNA, carbon_transferer.status_traits[TRAIT_BADDNA])
	if(transferer.mind && transferer.mind.current)
		transferer.mind.transfer_to(brainmob)
	to_chat(brainmob, span_notice("I feel very strange. This is probably normal, because now I'm just a brain, although I was one before."))

////////////////////////////////////TRAUMAS////////////////////////////////////////
/obj/item/organ/brain/proc/has_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience = TRAUMA_RESILIENCE_ABSOLUTE)
	for(var/X in traumas)
		var/datum/brain_trauma/BT = X
		if(istype(BT, brain_trauma_type) && (BT.resilience <= resilience))
			return BT

/obj/item/organ/brain/proc/get_traumas_type(brain_trauma_type = /datum/brain_trauma, resilience = TRAUMA_RESILIENCE_ABSOLUTE)
	. = list()
	for(var/trauma_type in traumas)
		var/datum/brain_trauma/brain_trauma = trauma_type
		if(istype(brain_trauma, brain_trauma_type) && (brain_trauma.resilience <= resilience))
			. += brain_trauma

/obj/item/organ/brain/proc/can_gain_trauma(datum/brain_trauma/trauma, resilience, natural_gain = FALSE)
	if(!ispath(trauma))
		trauma = trauma.type
	if(!initial(trauma.can_gain))
		return FALSE
	if(!resilience)
		resilience = initial(trauma.resilience)

	var/resilience_tier_count = 0
	for(var/X in traumas)
		if(istype(X, trauma))
			return FALSE
		var/datum/brain_trauma/existing_trauma = X
		if(resilience == existing_trauma.resilience)
			resilience_tier_count++

	var/max_traumas
	switch(resilience)
		if(TRAUMA_RESILIENCE_BASIC)
			max_traumas = TRAUMA_LIMIT_BASIC
		if(TRAUMA_RESILIENCE_SURGERY)
			max_traumas = TRAUMA_LIMIT_SURGERY
		if(TRAUMA_RESILIENCE_WOUND)
			max_traumas = TRAUMA_LIMIT_WOUND
		if(TRAUMA_RESILIENCE_LOBOTOMY)
			max_traumas = TRAUMA_LIMIT_LOBOTOMY
		if(TRAUMA_RESILIENCE_MAGIC)
			max_traumas = TRAUMA_LIMIT_MAGIC
		if(TRAUMA_RESILIENCE_ABSOLUTE)
			max_traumas = TRAUMA_LIMIT_ABSOLUTE

	if(natural_gain && resilience_tier_count >= max_traumas)
		return FALSE
	return TRUE

//Proc to use when directly adding a trauma to the brain, so extra args can be given
/obj/item/organ/brain/proc/gain_trauma(datum/brain_trauma/trauma, resilience, ...)
	var/list/arguments = list()
	if(args.len > 2)
		arguments = args.Copy(3)
	. = brain_gain_trauma(trauma, resilience, arguments)

//Direct trauma gaining proc. Necessary to assign a trauma to its brain. Avoid using directly.
/obj/item/organ/brain/proc/brain_gain_trauma(datum/brain_trauma/trauma, resilience, list/arguments)
	if(!can_gain_trauma(trauma, resilience))
		return FALSE

	var/datum/brain_trauma/actual_trauma
	if(ispath(trauma))
		if(!LAZYLEN(arguments))
			actual_trauma = new trauma() //arglist with an empty list runtimes for some reason
		else
			actual_trauma = new trauma(arglist(arguments))
	else
		actual_trauma = trauma

	if(actual_trauma.brain) //we don't accept used traumas here
		WARNING("gain_trauma was given an already active trauma.")
		return FALSE

	traumas += actual_trauma
	actual_trauma.brain = src
	if(owner)
		actual_trauma.owner = owner
		SEND_SIGNAL(owner, COMSIG_CARBON_GAIN_TRAUMA, trauma)
		actual_trauma.on_gain()
	if(resilience)
		actual_trauma.resilience = resilience
	SSblackbox.record_feedback("tally", "traumas", 1, actual_trauma.type)
	return actual_trauma

/// Add a random trauma of a certain subtype
/obj/item/organ/brain/proc/gain_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience, natural_gain = FALSE)
	var/list/datum/brain_trauma/possible_traumas = list()
	for(var/trauma_type in subtypesof(brain_trauma_type))
		var/datum/brain_trauma/brain_trauma = trauma_type
		if(can_gain_trauma(brain_trauma, resilience, natural_gain) && initial(brain_trauma.random_gain))
			possible_traumas += brain_trauma

	if(!LAZYLEN(possible_traumas))
		return

	var/trauma_type = pick(possible_traumas)
	return gain_trauma(trauma_type, resilience)

/// Cure a random trauma of a certain resilience level
/obj/item/organ/brain/proc/cure_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience = TRAUMA_RESILIENCE_BASIC)
	var/list/traumas = get_traumas_type(brain_trauma_type, resilience)
	if(LAZYLEN(traumas))
		qdel(pick(traumas))

/obj/item/organ/brain/proc/cure_all_traumas(resilience = TRAUMA_RESILIENCE_BASIC)
	var/amount_cured = 0
	var/list/traumas = get_traumas_type(resilience = resilience)
	for(var/X in traumas)
		qdel(X)
		amount_cured++
	return amount_cured

/obj/item/organ/brain/halber
	maxHealth = 200
	high_threshold = 150
	low_threshold = 140
	internal_damage_modifier = 0.5

/obj/item/organ/brain/examine(mob/user)
	. = ..()
	if(has_permanent_effects)
		switch(current_severity_level)
			if(1)
				. += span_warning("It shows minor scarring.")
			if(2)
				. += span_warning("It shows concerning lesions and abnormal tissue.")
			if(3)
				. += span_warning("It shows severe damage to multiple areas.")
			if(4)
				. += span_warning("It is severely damaged and partially necrotic.")

	// Add region-specific damage descriptions for medical professionals
	if(HAS_TRAIT(user, TRAIT_MEDICAL_HUD) || HAS_TRAIT(user, TRAIT_SELF_AWARE))
		var/damaged_regions = ""
		if(frontal_lobe_damage >= region_damage_threshold)
			damaged_regions += "frontal lobe"
		if(temporal_lobe_damage >= region_damage_threshold)
			damaged_regions += "[damaged_regions ? ", " : ""]temporal lobe"
		if(parietal_lobe_damage >= region_damage_threshold)
			damaged_regions += "[damaged_regions ? ", " : ""]parietal lobe"
		if(occipital_lobe_damage >= region_damage_threshold)
			damaged_regions += "[damaged_regions ? ", " : ""]occipital lobe"
		if(cerebellar_damage >= region_damage_threshold)
			damaged_regions += "[damaged_regions ? ", " : ""]cerebellum"
		if(brainstem_damage >= region_damage_threshold)
			damaged_regions += "[damaged_regions ? ", " : ""]brainstem"

		if(damaged_regions)
			. += span_info("Medical scan reveals damage to the [damaged_regions].")

/**
 * Distributes damage to specific brain regions
 *
 * When brain takes damage, this determines how it affects different regions
 * Different regions control different functions, so damage patterns matter
 */
/obj/item/organ/brain/proc/distribute_brain_damage(damage_amount, head_injury = FALSE)
	// Get damage distribution - random but weighted
	var/frontal_weight = rand(10, 25)
	var/temporal_weight = rand(10, 25)
	var/parietal_weight = rand(10, 20)
	var/occipital_weight = rand(5, 15)
	var/cerebellar_weight = rand(10, 20)
	var/brainstem_weight = rand(5, 15)

	// If damage is from head injury, adjust the weights to be more severe
	if(head_injury)
		// Head injuries cause more damage to critical brain regions
		frontal_weight = rand(15, 30)
		temporal_weight = rand(15, 30)
		parietal_weight = rand(12, 25)
		occipital_weight = rand(10, 20)
		cerebellar_weight = rand(12, 25)
		brainstem_weight = rand(10, 20)

		// Increase overall damage by 25% for head injuries
		damage_amount *= 1.25

	// Normalize weights
	var/total_weight = frontal_weight + temporal_weight + parietal_weight + occipital_weight + cerebellar_weight + brainstem_weight
	frontal_weight = frontal_weight / total_weight
	temporal_weight = temporal_weight / total_weight
	parietal_weight = parietal_weight / total_weight
	occipital_weight = occipital_weight / total_weight
	cerebellar_weight = cerebellar_weight / total_weight
	brainstem_weight = brainstem_weight / total_weight

	// Apply damage to regions
	frontal_lobe_damage += damage_amount * frontal_weight
	temporal_lobe_damage += damage_amount * temporal_weight
	parietal_lobe_damage += damage_amount * parietal_weight
	occipital_lobe_damage += damage_amount * occipital_weight
	cerebellar_damage += damage_amount * cerebellar_weight
	brainstem_damage += damage_amount * brainstem_weight

	// Check for system damages from region damages
	update_brain_systems()

/**
 * Updates brain systems based on regional damage
 *
 * Different brain regions control different systems
 * When a region is damaged enough, the corresponding system begins to fail
 */
/obj/item/organ/brain/proc/update_brain_systems()
	// Check frontal lobe - executive function, personality, impulse control
	var/old_motor = motor_damaged
	var/old_emotion = emotion_damaged
	var/old_memories = memories_damaged
	var/old_language = language_damaged
	var/old_sensory = sensory_damaged
	var/old_autonomic = autonomic_damaged

	// Update system damages based on regional damages
	motor_damaged = (cerebellar_damage >= region_damage_threshold)
	emotion_damaged = (frontal_lobe_damage >= region_damage_threshold || temporal_lobe_damage >= region_damage_threshold)
	memories_damaged = (temporal_lobe_damage >= region_damage_threshold)
	language_damaged = (temporal_lobe_damage >= region_damage_threshold || frontal_lobe_damage >= region_damage_threshold)
	sensory_damaged = (parietal_lobe_damage >= region_damage_threshold || occipital_lobe_damage >= region_damage_threshold)
	autonomic_damaged = (brainstem_damage >= region_damage_threshold)

	// Apply effects when systems newly damaged
	if(owner)
		if(!old_motor && motor_damaged)
			to_chat(owner, span_warning("Your movements feel uncoordinated."))
			ADD_TRAIT(owner, TRAIT_CLUMSY, BRAIN_TRAIT)
			if(cerebellar_damage >= region_critical_threshold)
				ADD_TRAIT(owner, TRAIT_UNSTABLE, BRAIN_TRAIT)
				to_chat(owner, span_danger("Your motor control is severely impaired!"))

		if(!old_emotion && emotion_damaged)
			to_chat(owner, span_warning("Your emotions feel off-balance."))
			if((frontal_lobe_damage >= region_critical_threshold) || (temporal_lobe_damage >= region_critical_threshold))
				ADD_TRAIT(owner, TRAIT_UNSTABLE, BRAIN_TRAIT)
				ADD_TRAIT(owner, TRAIT_ANXIOUS, BRAIN_TRAIT)
				to_chat(owner, span_danger("Your emotional regulation is severely impaired!"))

		if(!old_memories && memories_damaged)
			to_chat(owner, span_warning("You're having trouble remembering things."))
			if(temporal_lobe_damage >= region_critical_threshold)
				to_chat(owner, span_danger("Your memory is severely impaired!"))
				ADD_TRAIT(owner, TRAIT_DUMB, BRAIN_TRAIT)

		if(!old_language && language_damaged)
			to_chat(owner, span_warning("You're having trouble finding words."))
			owner.slurring = 20
			if((temporal_lobe_damage >= region_critical_threshold) || (frontal_lobe_damage >= region_critical_threshold))
				owner.slurring = 50
				to_chat(owner, span_danger("Your language processing is severely impaired!"))

		if(!old_sensory && sensory_damaged)
			to_chat(owner, span_warning("Your senses feel dulled."))
			if((parietal_lobe_damage >= region_critical_threshold) || (occipital_lobe_damage >= region_critical_threshold))
				ADD_TRAIT(owner, TRAIT_DUMB, BRAIN_TRAIT)
				to_chat(owner, span_danger("Your sensory processing is severely impaired!"))

		if(!old_autonomic && autonomic_damaged)
			to_chat(owner, span_warning("Your breathing feels irregular."))
			if(brainstem_damage >= region_critical_threshold)
				to_chat(owner, span_danger("Your autonomic functions are failing!"))
				owner.adjustOxyLoss(5)
				ADD_TRAIT(owner, TRAIT_SLEEPINESS, BRAIN_TRAIT)

/obj/item/organ/brain/proc/update_permanent_effects()
	// Determine current severity level
	var/old_severity = current_severity_level
	if(permanent_damage >= damage_threshold_critical)
		current_severity_level = 4
	else if(permanent_damage >= damage_threshold_severe)
		current_severity_level = 3
	else if(permanent_damage >= damage_threshold_medium)
		current_severity_level = 2
	else if(permanent_damage >= damage_threshold_mild)
		current_severity_level = 1
	else
		current_severity_level = 0

	// Set permanent effects flag
	has_permanent_effects = (current_severity_level > 0)

	// Apply effects if severity increased
	if(current_severity_level > old_severity && owner)
		apply_permanent_effects(owner)

/obj/item/organ/brain/proc/apply_permanent_effects(mob/living/carbon/brain_owner)
	// Apply appropriate effects based on severity
	switch(current_severity_level)
		if(1) // Mild brain damage
			// Apply mild effects
			to_chat(brain_owner, span_warning("You feel something change in your mind."))
			ADD_TRAIT(brain_owner, TRAIT_CLUMSY, TRAUMA_TRAIT)
			if(prob(50))
				ADD_TRAIT(brain_owner, TRAIT_DUMB, TRAUMA_TRAIT)

		if(2) // Medium brain damage
			// Apply medium effects (includes mild)
			to_chat(brain_owner, span_danger("Your mind feels significantly altered."))
			ADD_TRAIT(brain_owner, TRAIT_CLUMSY, TRAUMA_TRAIT)
			ADD_TRAIT(brain_owner, TRAIT_DUMB, TRAUMA_TRAIT)
			if(prob(40))
				brain_owner.gain_trauma(/datum/brain_trauma/mild, permanent = TRUE)
			if(prob(30))
				ADD_TRAIT(brain_owner, TRAIT_UNSTABLE, TRAUMA_TRAIT)
			if(prob(30))
				brain_owner.remove_language(/datum/language/uncommon)

		if(3) // Severe brain damage
			// Apply severe effects (includes medium)
			to_chat(brain_owner, span_danger("Your mind feels severely damaged!"))
			ADD_TRAIT(brain_owner, TRAIT_CLUMSY, TRAUMA_TRAIT)
			ADD_TRAIT(brain_owner, TRAIT_DUMB, TRAUMA_TRAIT)
			ADD_TRAIT(brain_owner, TRAIT_UNSTABLE, TRAUMA_TRAIT)
			ADD_TRAIT(brain_owner, TRAIT_ANXIOUS, TRAUMA_TRAIT)
			brain_owner.gain_trauma(/datum/brain_trauma/severe, permanent = TRUE)
			if(prob(50))
				brain_owner.gain_trauma(/datum/brain_trauma/mild, permanent = TRUE)
			if(prob(50))
				ADD_TRAIT(brain_owner, TRAIT_DEPRESSION, TRAUMA_TRAIT)
			brain_owner.remove_language(/datum/language/uncommon)

		if(4) // Critical brain damage
			// Apply critical effects (includes severe)
			to_chat(brain_owner, span_danger("Your mind feels broken beyond repair!"))
			ADD_TRAIT(brain_owner, TRAIT_CLUMSY, TRAUMA_TRAIT)
			ADD_TRAIT(brain_owner, TRAIT_DUMB, TRAUMA_TRAIT)
			ADD_TRAIT(brain_owner, TRAIT_UNSTABLE, TRAUMA_TRAIT)
			ADD_TRAIT(brain_owner, TRAIT_ANXIOUS, TRAUMA_TRAIT)
			ADD_TRAIT(brain_owner, TRAIT_DEPRESSION, TRAUMA_TRAIT)
			brain_owner.gain_trauma(/datum/brain_trauma/special, permanent = TRUE)
			brain_owner.gain_trauma(/datum/brain_trauma/severe, permanent = TRUE)
			brain_owner.gain_trauma(/datum/brain_trauma/mild, permanent = TRUE)
			brain_owner.remove_language(/datum/language/uncommon)
			brain_owner.remove_language(/datum/language/common)
			// Add slurred speech
			brain_owner.cultslurring += 100

/**
 * Applies regional damage effects to the owner
 *
 * Called when brain is inserted or when regional damage occurs
 */
/obj/item/organ/brain/proc/apply_regional_effects(mob/living/carbon/brain_owner)
	if(!brain_owner)
		return

	// Apply motor damage effects
	if(motor_damaged)
		ADD_TRAIT(brain_owner, TRAIT_CLUMSY, BRAIN_TRAIT)
		if(cerebellar_damage >= region_critical_threshold)
			ADD_TRAIT(brain_owner, TRAIT_UNSTABLE, BRAIN_TRAIT)

	// Apply emotion damage effects
	if(emotion_damaged)
		if((frontal_lobe_damage >= region_critical_threshold) || (temporal_lobe_damage >= region_critical_threshold))
			ADD_TRAIT(brain_owner, TRAIT_UNSTABLE, BRAIN_TRAIT)
			ADD_TRAIT(brain_owner, TRAIT_ANXIOUS, BRAIN_TRAIT)

	// Apply memory damage effects
	if(memories_damaged && (temporal_lobe_damage >= region_critical_threshold))
		ADD_TRAIT(brain_owner, TRAIT_DUMB, BRAIN_TRAIT)

	// Apply language damage effects
	if(language_damaged)
		brain_owner.slurring = max(brain_owner.slurring, 20)
		if((temporal_lobe_damage >= region_critical_threshold) || (frontal_lobe_damage >= region_critical_threshold))
			brain_owner.slurring = max(brain_owner.slurring, 50)

	// Apply sensory damage effects
	if(sensory_damaged)
		if((parietal_lobe_damage >= region_critical_threshold) || (occipital_lobe_damage >= region_critical_threshold))
			ADD_TRAIT(brain_owner, TRAIT_DUMB, BRAIN_TRAIT)

	// Apply autonomic damage effects
	if(autonomic_damaged && (brainstem_damage >= region_critical_threshold))
		brain_owner.adjustOxyLoss(5)
		ADD_TRAIT(brain_owner, TRAIT_SLEEPINESS, BRAIN_TRAIT)

/obj/item/organ/brain/on_life(delta_time, times_fired)
	. = ..()

	// Process cumulative damage recovery when not recently damaged
	if(cumulative_damage > 0 && (world.time - last_damage_time) > 30 SECONDS)
		cumulative_damage = max(0, cumulative_damage - (damage_recovery_rate * delta_time))

	// Process regional damage recovery
	if(frontal_lobe_damage > 0)
		frontal_lobe_damage = max(0, frontal_lobe_damage - (region_recovery_rate * delta_time))

	if(temporal_lobe_damage > 0)
		temporal_lobe_damage = max(0, temporal_lobe_damage - (region_recovery_rate * delta_time))

	if(parietal_lobe_damage > 0)
		parietal_lobe_damage = max(0, parietal_lobe_damage - (region_recovery_rate * delta_time))

	if(occipital_lobe_damage > 0)
		occipital_lobe_damage = max(0, occipital_lobe_damage - (region_recovery_rate * delta_time))

	if(cerebellar_damage > 0)
		cerebellar_damage = max(0, cerebellar_damage - (region_recovery_rate * delta_time))

	if(brainstem_damage > 0)
		brainstem_damage = max(0, brainstem_damage - (region_recovery_rate * delta_time))

	// Update brain systems as regions recover
	update_brain_systems()

	// Process permanent effects for game balance
	if(has_permanent_effects && owner && (owner.stat != DEAD))
		// Apply periodic effects based on severity
		switch(current_severity_level)
			if(1) // Mild brain damage effects
				if(DT_PROB(3, delta_time))
					to_chat(owner, span_warning("You momentarily forget what you were doing."))
					owner.add_confusion(3)

			if(2) // Medium brain damage effects
				if(DT_PROB(5, delta_time))
					to_chat(owner, span_warning("Your thoughts scatter."))
					owner.add_confusion(5)
					owner.Dizzy(5)
				if(DT_PROB(2, delta_time))
					owner.stuttering += 10
					to_chat(owner, span_warning("You stutter as you try to form words."))

			if(3) // Severe brain damage effects
				if(DT_PROB(8, delta_time))
					to_chat(owner, span_danger("Your mind blanks out."))
					owner.add_confusion(8)
					owner.Dizzy(10)
				if(DT_PROB(5, delta_time))
					owner.stuttering += 15
					to_chat(owner, span_danger("You struggle to speak coherently."))
				if(DT_PROB(3, delta_time))
					owner.Stun(10)
					to_chat(owner, span_danger("Your muscles fail to respond!"))

			if(4) // Critical brain damage effects
				if(DT_PROB(10, delta_time))
					to_chat(owner, span_danger("Everything goes dark!"))
					owner.add_confusion(12)
					owner.Dizzy(20)
				if(DT_PROB(8, delta_time))
					owner.stuttering += 20
					to_chat(owner, span_danger("You can't remember how to speak!"))
				if(DT_PROB(5, delta_time))
					owner.Paralyze(10)
					to_chat(owner, span_danger("Your mind disconnects from your body!"))
				if(DT_PROB(2, delta_time))
					owner.Unconscious(30)
					to_chat(owner, span_danger("You lose consciousness!"))

	// Process specific regional damage effects
	if(owner && (owner.stat != DEAD))
		process_regional_effects(delta_time)

/**
 * Process ongoing brain region effects
 *
 * Handles periodic effects from damaged brain regions
 */
/obj/item/organ/brain/proc/process_regional_effects(delta_time)
	if(!owner)
		return

	// Frontal lobe effects - impulse control, decision making, personality
	if(frontal_lobe_damage >= region_damage_threshold)
		// Mild effects - poor impulse control
		if(DT_PROB(frontal_lobe_damage * 0.2, delta_time))
			if(frontal_lobe_damage >= region_critical_threshold)
				// Serious effects - rage, compulsions, personality changes
				// Higher chance of severe impulse control issues
				if(DT_PROB(30, delta_time))
					owner.emote(pick("twitch", "scream", "laugh", "moan"))
					to_chat(owner, span_warning("I can't control myself!"))
			else
				// Minor impulse control issues
				if(DT_PROB(15, delta_time))
					owner.emote(pick("twitch", "frown"))
					to_chat(owner, span_warning("I feel a strange impulse..."))

	// Temporal lobe effects - memory, language, emotion
	if(temporal_lobe_damage >= region_damage_threshold)
		// Memory issues
		if(DT_PROB(temporal_lobe_damage * 0.15, delta_time))
			if(temporal_lobe_damage >= region_critical_threshold)
				// Severe memory loss
				to_chat(owner, span_danger("I... can't remember..."))
				owner.add_confusion(5)
			else
				// Minor memory issues
				to_chat(owner, span_warning("I can't seem to recall..."))
				owner.add_confusion(2)

	// Parietal lobe effects - sensory processing, spatial awareness
	if(parietal_lobe_damage >= region_damage_threshold)
		// Sensory processing issues
		if(DT_PROB(parietal_lobe_damage * 0.15, delta_time))
			if(parietal_lobe_damage >= region_critical_threshold)
				// Severe sensory issues - neglect syndrome, sensory overload
				to_chat(owner, span_danger("Everything feels wrong!"))
				owner.Dizzy(10)
				owner.add_confusion(5)
			else
				// Minor sensory issues
				to_chat(owner, span_warning("My perception feels off..."))
				owner.Dizzy(3)

	// Occipital lobe effects - visual processing
	if(occipital_lobe_damage >= region_damage_threshold)
		// Visual processing issues
		if(DT_PROB(occipital_lobe_damage * 0.15, delta_time))
			if(occipital_lobe_damage >= region_critical_threshold)
				// Severe visual issues - hallucinations, blindness, visual agnosia
				to_chat(owner, span_danger("My vision distorts horribly!"))
				if(prob(20))
					owner.hallucination += 10
			else
				// Minor visual issues
				to_chat(owner, span_warning("My vision blurs..."))

	// Cerebellar effects - motor coordination, balance
	if(cerebellar_damage >= region_damage_threshold)
		// Motor coordination issues
		if(DT_PROB(cerebellar_damage * 0.15, delta_time))
			if(cerebellar_damage >= region_critical_threshold)
				// Severe motor issues - ataxia, tremors
				to_chat(owner, span_danger("I lose control of my body!"))
				owner.Knockdown(5)
				if(owner.get_active_held_item() && prob(30))
					to_chat(owner, span_warning("My hand spasms!"))
					owner.drop_all_held_items()
			else
				// Minor motor issues
				to_chat(owner, span_warning("My muscles twitch..."))
				if(owner.get_active_held_item() && prob(10))
					owner.drop_all_held_items()

	// Brainstem effects - autonomic functions
	if(brainstem_damage >= region_damage_threshold)
		// Autonomic dysfunction
		if(DT_PROB(brainstem_damage * 0.15, delta_time))
			if(brainstem_damage >= region_critical_threshold)
				// Severe autonomic issues - respiratory depression, heart irregularities
				to_chat(owner, span_danger("I can't breathe!"))
				owner.adjustOxyLoss(5)
				if(prob(20))
					owner.Unconscious(10)
			else
				// Minor autonomic issues
				to_chat(owner, span_warning("My breathing feels strange..."))
				owner.adjustOxyLoss(1)