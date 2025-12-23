/datum/effort/luckydice
	name = "Dice Concentration"
	gain_message = span_effortgained("I am focused on success.")
	lose_message = span_effortlost("I'm not anymore focused on success.")

/datum/effort/luckydice/can_use(mob/user)
	if(!user.attributes)
		return FALSE
	return TRUE

/datum/effort/luckydice/on_activation(mob/user, silent = FALSE)
	user.attributes.add_diceroll_modifier(/datum/diceroll_modifier/concentration, TRUE)
	user.attributes.update_attributes()
	user.visible_message(span_danger("[user] concentrates!"))
	playsound(get_turf(user),'modular_pod/sound/eff/cathedral.ogg', 60, TRUE)
	user.sound_hint()
	return TRUE

/datum/effort/luckydice/on_deactivation(mob/user, silent = FALSE)
	user.attributes.remove_diceroll_modifier(/datum/diceroll_modifier/concentration)
	user.attributes.update_attributes()
	return TRUE

/datum/effort/bodytension
	name = "Body Tension"
	gain_message = span_effortgained("I'm straining my body!")
	lose_message = span_effortlost("I relax my body.")

/datum/effort/luckydice/can_use(mob/user)
	if(!user.attributes)
		return FALSE
	return TRUE

/datum/effort/luckydice/on_activation(mob/user, silent = FALSE)
//	user.attributes.add_diceroll_modifier(/datum/diceroll_modifier/concentration, TRUE)
//	user.attributes.update_attributes()
	ADD_TRAIT(user, TRAIT_TENSER, "tenser")
	user.visible_message(span_danger("[user] is getting tense!"))
	playsound(get_turf(user),'modular_pod/sound/eff/cathedral.ogg', 60, TRUE)
	user.sound_hint()
	return TRUE

/datum/effort/luckydice/on_deactivation(mob/user, silent = FALSE)
//	user.attributes.remove_diceroll_modifier(/datum/diceroll_modifier/concentration)
//	user.attributes.update_attributes()
	REMOVE_TRAIT(user, TRAIT_TENSER, EFFORT_TRAIT)
	return TRUE