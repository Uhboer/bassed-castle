/datum/keybinding/carbon
	category = CATEGORY_CARBON
	weight = WEIGHT_MOB

/datum/keybinding/carbon/can_use(client/user)
	return iscarbon(user.mob)

/datum/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R", "Southwest") // END
	name = "toggle_throw_mode"
	full_name = "Toggle throw mode"
	description = "Toggle throwing the current item or not."
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_TOGGLETHROWMODE_DOWN

/datum/keybinding/carbon/toggle_throw_mode/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/C = user.mob
	C.toggle_throw_mode()
	return TRUE

/datum/keybinding/carbon/hold_throw_mode
	hotkey_keys = list("Space")
	name = "hold_throw_mode"
	full_name = "Hold throw mode"
	description = "Hold this to turn on throw mode, and release it to turn off throw mode"
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_HOLDTHROWMODE_DOWN

/datum/keybinding/carbon/hold_throw_mode/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/carbon_user = user.mob
	carbon_user.throw_mode_on(THROW_MODE_HOLD)

/datum/keybinding/carbon/hold_throw_mode/up(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/carbon_user = user.mob
	carbon_user.throw_mode_off(THROW_MODE_HOLD)
/datum/keybinding/carbon/give
	hotkey_keys = list("G")
	name = "Give_Item"
	full_name = "Give item"
	description = "Give the item you're currently holding"
	keybind_signal = COMSIG_KB_CARBON_GIVEITEM_DOWN

/datum/keybinding/carbon/give/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/carbon_user = user.mob
	carbon_user.give()
	return TRUE
/*
/datum/keybinding/client/kaota
	hotkey_keys = list("K")
	name = "Kaot"
	full_name = "Kaota"
	keybind_signal = COMSIG_KB_CLIENT_K_DOWN

/datum/keybinding/client/kaota/down(client/user)
	. = ..()
	if(.)
		return
	if(!SSbobux || !length(SSbobux.all_bobux_rewards))
		to_chat(user, "<span class='warning'>Kaotik System is not loaded. Wait.</span>")
		return
	SSbobux.ShowChoices(user)
	return TRUE
*/
/datum/keybinding/client/whopla
	hotkey_keys = list("J")
	name = "Who"
	full_name = "Whoplays"
	keybind_signal = COMSIG_KB_CLIENT_J_DOWN

/datum/keybinding/client/whopla/down(client/user)
	. = ..()
	if(.)
		return
	user.who()
	return TRUE