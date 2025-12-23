/datum/hud/new_player
	uses_film_grain = FALSE

/datum/hud/new_player/New(mob/owner)
	. = ..()
	for(var/atom/movable/screen/lobby/button/button in static_inventory)
		if(!button.enabled)
			button.update_appearance(UPDATE_ICON)

INITIALIZE_IMMEDIATE(/atom/movable/screen/lobby)

/atom/movable/screen/lobby/button
	var/highlight_eyeball = TRUE
	var/image/eyeball_image
	var/eyeball_scale_x = 0.32
	var/eyeball_scale_y = 0.32
	var/eyeball_pixel_x = 80
	var/eyeball_pixel_y = -22
	var/static/sound/click_sound = sound('modular_septic/sound/interface/uiclick.ogg', FALSE, 0, CHANNEL_CLICKITY_CLACK, 220)
	var/static/sound/ready_sound = sound('modular_septic/sound/interface/readyclick.ogg', FALSE, 0, CHANNEL_CLICKITY_CLACK, 220)

/atom/movable/screen/lobby/button/Initialize(mapload)
	return

/atom/movable/screen/lobby/button/update_overlays()
	. = ..()
	if(enabled && highlighted && highlight_eyeball && eyeball_image)
		. += eyeball_image

/atom/movable/screen/lobby/button/MouseEntered(location, control, params)
	. = ..()
	if(highlight_eyeball)
		update_appearance(UPDATE_OVERLAYS)

/atom/movable/screen/lobby/button/MouseExited(location, control, params)
	. = ..()
	if(highlight_eyeball)
		update_appearance(UPDATE_OVERLAYS)

/atom/movable/screen/lobby/button/Click(location, control, params)
	. = ..()
	if(usr.client && click_sound)
		SEND_SOUND(usr.client, click_sound)

/atom/movable/screen/lobby/button/ready/Click(location, control, params)
	. = ..()
	if(usr.client && click_sound)
		SEND_SOUND(usr.client, ready_sound)

/atom/movable/screen/lobby/background
	icon = null
	icon_state = null
	screen_loc = null

/atom/movable/screen/lobby/button/character_setup
	screen_loc = "SOUTH:+53,CENTER:-335"

/atom/movable/screen/lobby/button/character_setup/Initialize(mapload)
	. = ..()
	qdel(src)

/atom/movable/screen/lobby/button/settings
	screen_loc = "SOUTH:+117,CENTER:-335"

/atom/movable/screen/lobby/button/settings/Initialize(mapload)
	. = ..()
	qdel(src)

/atom/movable/screen/lobby/button/ready
	screen_loc = "SOUTH:-6,CENTER:-335"

#define FUCKING_IDIOT_MESSAGE "Главное не забыть нормально себя настроить, иначе я буду зеленоволосым инвалидом-уёбищем!"

/atom/movable/screen/lobby/button/ready/Click(location, control, params)
	. = ..()
	if(ready)
		to_chat(usr, div_infobox(span_boldwarning(FUCKING_IDIOT_MESSAGE)))

/atom/movable/screen/lobby/button/ready/Initialize(mapload)
	. = ..()
	qdel(src)

/atom/movable/screen/lobby/button/join
	screen_loc = "SOUTH:-6,CENTER:-335"

/atom/movable/screen/lobby/button/join/Click(location, control, params)
	. = ..()
	to_chat(usr, div_infobox(span_boldwarning(FUCKING_IDIOT_MESSAGE)))

/atom/movable/screen/lobby/button/join/Initialize(mapload)
	. = ..()
	qdel(src)

#undef FUCKING_IDIOT_MESSAGE

/atom/movable/screen/lobby/button/observe
	screen_loc = "SOUTH+4:-6,CENTER:-54"

/atom/movable/screen/lobby/button/observe/Initialize(mapload)
	. = ..()
	qdel(src)

/*
/atom/movable/screen/lobby/button/credits
	icon = 'modular_septic/icons/hud/lobby/credits.dmi'
	icon_state = "credits"
	base_icon_state = "credits"
	screen_loc = "SOUTH:+54,CENTER:+218"

/atom/movable/screen/lobby/button/credits/Click(location, control, params)
	. = ..()
	SScredits?.ui_interact(usr)
*/

/atom/movable/screen/lobby/button/crew_manifest
	screen_loc = "SOUTH:-24,CENTER:8"
	highlight_eyeball = FALSE

/atom/movable/screen/lobby/button/changelog_button
	enabled = FALSE
	highlight_eyeball = FALSE

/atom/movable/screen/lobby/button/poll
	enabled = FALSE
	highlight_eyeball = FALSE
