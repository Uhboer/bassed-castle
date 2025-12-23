/obj/item/modular_computer/laptop
	name = "laptop"
	desc = "A portable laptop computer."

	icon = 'icons/obj/modular_laptop.dmi'
	icon_state = "laptop-closed"
	icon_state_powered = "laptop"
	icon_state_unpowered = "laptop-off"
	icon_state_menu = "menu"
	display_overlays = FALSE

	hardware_flag = PROGRAM_LAPTOP
	max_hardware_size = 2
	w_class = WEIGHT_CLASS_NORMAL
	max_bays = 4

	// No running around with open laptops in hands.
	item_flags = SLOWS_WHILE_IN_HAND

	screen_on = FALSE // Starts closed
	var/start_open = TRUE // unless this var is set to 1
	var/icon_state_closed = "laptop-closed"
	var/w_class_open = WEIGHT_CLASS_BULKY
	var/slowdown_open = TRUE

/obj/item/modular_computer/laptop/examine(mob/user)
	. = ..()
	if(screen_on)
		. += span_notice("Alt-click to close it.")

/obj/item/modular_computer/laptop/Initialize(mapload)
	. = ..()

	if(start_open && !screen_on)
		toggle_open()

/obj/item/modular_computer/laptop/update_icon_state()
	if(!screen_on)
		icon_state = icon_state_closed
		return
	return ..()

/obj/item/modular_computer/laptop/update_overlays()
	if(!screen_on)
		cut_overlays()
		return
	return ..()

/obj/item/modular_computer/laptop/attack_self(mob/user)
	if(!screen_on)
		try_toggle_open(user)
	else
		return ..()

/obj/item/modular_computer/laptop/verb/open_computer()
	set name = "Toggle Open"
	set category = null
	set src in view(1)

	try_toggle_open(usr)

/obj/item/modular_computer/laptop/MouseDrop(obj/over_object, src_location, over_location)
	. = ..()
	if(over_object == usr || over_object == src)
		try_toggle_open(usr)
		return
	if(istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over_object
		var/mob/M = usr

		if(M.stat != CONSCIOUS || HAS_TRAIT(M, TRAIT_HANDS_BLOCKED))
			return
		if(!isturf(loc) || !Adjacent(M))
			return
		M.put_in_hand(src, H.held_index)

/obj/item/modular_computer/laptop/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(screen_on && isturf(loc))
		return attack_self(user)

/obj/item/modular_computer/laptop/proc/try_toggle_open(mob/living/user)
	if(issilicon(user))
		return
	if(!isturf(loc) && !ismob(loc)) // No opening it in backpack.
		return
	if(!user.canUseTopic(src, BE_CLOSE))
		return

	toggle_open(user)


/obj/item/modular_computer/laptop/AltClick(mob/user)
	. = ..()
	if(!can_interact(user))
		return
	if(screen_on) // Close it.
		try_toggle_open(user)
	else
		return ..()

/obj/item/modular_computer/laptop/proc/toggle_open(mob/living/user=null)
	if(screen_on)
		to_chat(user, span_notice("You close \the [src]."))
		slowdown = initial(slowdown)
		w_class = initial(w_class)
	else
		to_chat(user, span_notice("You open \the [src]."))
		slowdown = slowdown_open
		w_class = w_class_open

	screen_on = !screen_on
	display_overlays = screen_on
	update_appearance()



// Laptop frame, starts empty and closed.
/obj/item/modular_computer/laptop/buildable
	start_open = FALSE


/obj/item/laptop_podpol
	name = "DMT Laptop"
	desc = "Super dangerous thing."

	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "laptop"

	w_class = WEIGHT_CLASS_NORMAL

	var/can_get_armor = TRUE
	var/can_get_gun = TRUE
	var/can_get_ammo = TRUE

	var/head_inside = FALSE
	var/neck_inside = FALSE

/obj/item/laptop_podpol/attackby(obj/item/W, mob/living/carbon/user, params)
	if(istype(W, /obj/item/bodypart/head))
		qdel(W)
		head_inside = TRUE
	if(istype(W, /obj/item/bodypart/neck))
		qdel(W)
		neck_inside = TRUE

/obj/item/laptop_podpol/attack_self(mob/living/carbon/user, modifiers)
	. = ..()
	var/thing = input(user, "What do I want?", "I want...") as null|anything in list("Equipment", "Explosion")
	if(!thing)
		return
	if(thing == "Equipment")
		equipment(user)

	if(thing == "Explosion")
		explosion(user)

/obj/item/laptop_podpol/proc/explosion(mob/living/carbon/user)
	if(!head_inside)
		to_chat(user, span_dead("I need to insert head inside."))
		return
	if(!neck_inside)
		to_chat(user, span_dead("I need to insert neck inside."))
		return
	explosion(src, 30, 30, 30, 30)
	priority_announce("THE DREAM IS OVER! DREAM-TERRORIST COMMITED A NUCLEAR EXPLOSION!", "DREAM", has_important_message = TRUE)
	SEND_SOUND(world, sound('modular_pod/sound/mus/announce.ogg'))
	SSticker.force_ending = 1

/obj/item/laptop_podpol/proc/equipment(mob/living/carbon/user)
	var/thing = input(user, "What do I want?", "I want...") as null|anything in list("Armor", "Gun", "Ammo")
	if(!thing)
		return
	switch(thing)
		if("Armor")
			if (can_get_armor)
				if(get_dist(src, user) >= 2)
					return
				can_get_armor = FALSE
				new /obj/item/clothing/suit/armor/vest/bulletproofer(get_turf(user))
		if("Gun")
			if (can_get_gun)
				if(get_dist(src, user) >= 2)
					return
				can_get_gun = FALSE
				new /obj/item/gun/ballistic/revolver/remis/nova(get_turf(user))
		if("Ammo")
			if (can_get_ammo)
				if(get_dist(src, user) >= 2)
					return
				can_get_ammo = FALSE
				new /obj/item/ammo_box/magazine/ammo_stack/c38/loaded(get_turf(user))
