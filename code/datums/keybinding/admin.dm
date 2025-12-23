/datum/keybinding/admin
	category = CATEGORY_ADMIN
	weight = WEIGHT_ADMIN

/datum/keybinding/admin/can_use(client/user)
	return user.holder ? TRUE : FALSE

/datum/keybinding/admin/admin_say
	hotkey_keys = list("F3")
	name = "admin_say"
	full_name = "Admin say"
	description = "Talk with other admins."
	keybind_signal = COMSIG_KB_ADMIN_ASAY_DOWN

/datum/keybinding/admin/admin_say/down(client/user)
	. = ..()
	if(.)
		return
	user.get_admin_say()
	return TRUE

/datum/keybinding/admin/admin_ghost
	hotkey_keys = list("F5")
	name = "admin_ghost"
	full_name = "Aghost"
	description = "Go ghost"
	keybind_signal = COMSIG_KB_ADMIN_AGHOST_DOWN

/datum/keybinding/admin/admin_ghost/down(client/user)
	. = ..()
	if(.)
		return
	user.admin_ghost()
	return TRUE

/datum/keybinding/admin/admin_special_panel
	hotkey_keys = list("F6")
	name = "admin_special_panel"
	full_name = "Admin Special Panel"
	description = "Opens the admin spawn/search menu"
	keybind_signal = COMSIG_KB_ADMIN_SPECIALPANEL_DOWN

/datum/keybinding/admin/admin_special_panel/down(client/user)
	. = ..()
	if(.)
		return
	user.openmenushka()
	return TRUE

/datum/keybinding/admin/toggle_buildmode_self
	hotkey_keys = list("F7")
	name = "toggle_buildmode_self"
	full_name = "Toggle Buildmode Self"
	description = "Toggles buildmode"
	keybind_signal = COMSIG_KB_ADMIN_TOGGLEBUILDMODE_DOWN

/datum/keybinding/admin/toggle_buildmode_self/down(client/user)
	. = ..()
	if(.)
		return
	user.togglebuildmodeself()
	return TRUE

/datum/keybinding/admin/stealthmode
	hotkey_keys = list("CtrlF8")
	name = "stealth_mode"
	full_name = "Stealth mode"
	description = "Enters stealth mode"
	keybind_signal = COMSIG_KB_ADMIN_STEALTHMODETOGGLE_DOWN

/datum/keybinding/admin/stealthmode/down(client/user)
	. = ..()
	if(.)
		return
	user.stealth()
	return TRUE

/datum/keybinding/admin/invisimin
	hotkey_keys = list("F8")
	name = "invisimin"
	full_name = "Admin invisibility"
	description = "Toggles ghost-like invisibility (Don't abuse this)"
	keybind_signal = COMSIG_KB_ADMIN_INVISIMINTOGGLE_DOWN

/datum/keybinding/admin/invisimin/down(client/user)
	. = ..()
	if(.)
		return
	user.invisimin()
	return TRUE

/datum/keybinding/admin/startround
	hotkey_keys = list("CtrlJ")
	name = "startnow"
	full_name = "Start Now yeah"
	description = "Toggles ghost-like invisibility (Don't abuse this)"
	keybind_signal = COMSIG_KB_ADMIN_START_DOWN

/datum/keybinding/admin/startround/down(client/user)
	. = ..()
	if(.)
		return
	user.startnow()
	return TRUE

/datum/keybinding/admin/endround
	hotkey_keys = list("CtrlL")
	name = "endnow"
	full_name = "End Now yeah"
	description = "Toggles ghost-like invisibility (Don't abuse this)"
	keybind_signal = COMSIG_KB_ADMIN_START_DOWN

/datum/keybinding/admin/endround/down(client/user)
	. = ..()
	if(.)
		return
	user.end_round()
	return TRUE

/datum/keybinding/admin/startrmb
	hotkey_keys = list("CtrlK")
	name = "rmbaa"
	full_name = "Start Rmb"
	description = "Toggles ghost-like invisibility (Don't abuse this)"
	keybind_signal = COMSIG_KB_ADMIN_START_DOWN

/datum/keybinding/admin/startrmb/down(client/user)
	. = ..()
	if(.)
		return
	user.toggle_rightclickmenu()
	return TRUE

/datum/keybinding/admin/deadsay
	hotkey_keys = list("F10")
	name = "dsay"
	full_name = "deadsay"
	description = "Allows you to send a message to dead chat"
	keybind_signal = COMSIG_KB_ADMIN_DSAY_DOWN

/datum/keybinding/admin/deadsay/down(client/user)
	. = ..()
	if(.)
		return
	user.get_dead_say()
	return TRUE

/datum/keybinding/admin/deadmin
	hotkey_keys = list("Unbound")
	name = "deadmin"
	full_name = "Deadmin"
	description = "Shed your admin powers"
	keybind_signal = COMSIG_KB_ADMIN_DEADMIN_DOWN

/datum/keybinding/admin/deadmin/down(client/user)
	. = ..()
	if(.)
		return
	user.deadmin()
	return TRUE

/datum/keybinding/admin/readmin
	hotkey_keys = list("Unbound")
	name = "readmin"
	full_name = "Readmin"
	description = "Regain your admin powers"
	keybind_signal = COMSIG_KB_ADMIN_READMIN_DOWN

/datum/keybinding/admin/readmin/down(client/user)
	. = ..()
	if(.)
		return
	user.readmin()
	return TRUE
