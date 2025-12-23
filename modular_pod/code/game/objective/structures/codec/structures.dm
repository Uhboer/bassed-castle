/obj/structure/codec/lampala
	name = "Lamp"
	desc = "Why the hell should we see all this?"
	icon = 'modular_pod/icons/obj/things/things.dmi'
	icon_state = "lampala"
	plane = GAME_PLANE_BLOOM
	layer = FLY_LAYER
	density = TRUE
	anchored = TRUE
	light_range = 4
	light_power = 1
	light_color = "#faf5e9"

/obj/structure/codec/svetilka
	name = "Lamp"
	desc = "Lights up the room and enlightens your rotten soul."
	icon = 'modular_pod/icons/obj/things/things.dmi'
	icon_state = "svetilka"
	plane = GAME_PLANE_BLOOM
	layer = FLY_LAYER
	density = TRUE
	anchored = TRUE
	light_range = 4
	light_power = 1
	light_color = "#f9619f"
	var/proj_pass_rate = 100

/obj/structure/codec/svetilka/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(locate(/obj/structure/codec/svetilka) in get_turf(mover))
		return TRUE
	else if(istype(mover, /obj/projectile))
		if(!anchored)
			return TRUE
		var/obj/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return TRUE
		if(prob(proj_pass_rate))
			return TRUE
		return FALSE

/obj/structure/codec/firething
	name = "Lamp"
	desc = "It's really warm?"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "lighter"
	plane = GAME_PLANE_BLOOM
	layer = FLY_LAYER
	density = TRUE
	anchored = TRUE
	light_range = 4
	light_power = 2
	light_color = "#ffb04a"

/obj/structure/codec/bulb
/*
	var/flickering = FALSE
	var/flickering_now = FALSE
	var/flicker_prob = 5
	var/random_flicker_amount = TRUE
	var/flicker_amount = null
	var/works = TRUE
	var/cant_work = FALSE
	var/cant_flicker = FALSE
	var/enabled = TRUE

/obj/structure/codec/bulb/update_icon_state()
	if(enabled)
		icon_state = "[base_icon_state]"
		plane = GAME_PLANE_BLOOM
		set_light_on(TRUE)
	else
		icon_state = "[base_icon_state]-disabled"
		plane = GAME_PLANE
		set_light_on(FALSE)
	return ..()

/obj/structure/codec/bulb/Initialize()
	. = ..()
	if(flickering)
		if(prob(flicker_prob))
			playsound(get_turf(src), 'modular_septic/sound/machinery/broken_bulb_sound.ogg', 50, FALSE, 0)
			flicker(flicker_amount)

/obj/structure/codec/bulb/proc/flicker(amount)
	set waitfor = FALSE
	if(flickering_now)
		return
	if(cant_flicker)
		return
	if(random_flicker_amount)
		flicker_amount = rand(5,15)
	flickering_now = TRUE
	if(works)
		for(var/i = 0; i < amount; i++)
			if(!works)
				break
			if(cant_flicker)
				break
			enabled = !enabled
			update(FALSE)
			sleep(rand(3, 15))
		enabled = FALSE
		update(FALSE)
	flickering_now = FALSE

/obj/structure/codec/bulb/proc/update(trigger = TRUE)
	if(cant_work)
		cant_flicker = TRUE
	update_appearance()
*/

/obj/structure/codec/bulb/green
	name = "Bulb"
	desc = "It’s as if it’s not shining, but on the contrary."
	icon = 'modular_pod/icons/obj/things/things_2.dmi'
	icon_state = "bulb_green"
	base_icon_state = "bulb_green"
	plane = GAME_PLANE_BLOOM
//	layer = FLY_LAYER
	density = FALSE
	anchored = TRUE
	max_integrity = 100
	light_range = 3
	light_power = 1
	light_color = "#cbe395"

/obj/structure/codec/bulb/yellow
	name = "Bulb"
	desc = "Do we really need this light?"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "bulb_belo"
	base_icon_state = "bulb_belo"
	plane = GAME_PLANE_BLOOM
//	layer = FLY_LAYER
	density = FALSE
	anchored = TRUE
	max_integrity = 100
	light_range = 3
	light_power = 1
	light_color = "#e3cf91"

/obj/structure/codec/bulb/pank
	name = "Bulb"
	desc = "Do we really need this light?"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "bulb_pank"
	base_icon_state = "bulb_pank"
	plane = GAME_PLANE_BLOOM
//	layer = FLY_LAYER
	density = FALSE
	anchored = TRUE
	max_integrity = 100
	light_range = 3
	light_power = 1
	light_color = "#e0c0bb"

/obj/structure/codec/bulb/belo
	name = "Bulb"
	desc = "Do we really need this light?"
	icon = 'modular_pod/icons/obj/things/things_2.dmi'
	icon_state = "bulb_def"
	base_icon_state = "bulb_def"
	plane = GAME_PLANE_BLOOM
//	layer = FLY_LAYER
	density = FALSE
	anchored = TRUE
	max_integrity = 100
	light_range = 3
	light_power = 1
	light_color = "#e0e1df"

/obj/structure/codec/window
	max_integrity = 800
	integrity_failure = 0.1
	pass_flags = LETPASSTHROW
//	plane = ABOVE_GAME_PLANE
	layer = BELOW_MOB_LAYER
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	obj_flags = CAN_BE_HIT|BLOCK_Z_OUT_DOWN|BLOCK_Z_OUT_UP|BLOCK_Z_IN_DOWN|BLOCK_Z_IN_UP
	var/open = FALSE
	var/opaque_closed = FALSE
	var/can_walk = TRUE
	var/can_touch = TRUE
	var/knocksound = 'sound/effects/Glassknock.ogg'
	var/proj_pass_rate = 100

/obj/structure/codec/window/green
	name = "Window"
	desc = "Maybe it's dirt on it. Or maybe it's just green."
	icon = 'modular_pod/icons/obj/things/things_2.dmi'
	icon_state = "window_green-closed"
	base_icon_state = "window_green"

/obj/structure/codec/window/red
	name = "Beautiful Window"
	desc = "You can't see the blood on it, but it's there."
	icon = 'modular_pod/icons/obj/things/things_2.dmi'
	icon_state = "window_va-closed"
	base_icon_state = "window_va"
	opaque_closed = TRUE

/obj/structure/codec/window/Initialize(mapload)
	. = ..()
	if(!open)
		if(opaque_closed)
			set_opacity(TRUE)

/obj/structure/codec/window/proc/toggle()
	open = !open
	if(can_walk)
		if(open)
			set_density(FALSE)
			set_opacity(FALSE)
			air_update_turf(TRUE, FALSE)
		else
			for(var/atom/movable/M in get_turf(src))
				if(M.density && M != src)
					return
			set_density(TRUE)
			air_update_turf(TRUE, TRUE)
			if(opaque_closed)
				set_opacity(TRUE)

	update_appearance()

/obj/structure/codec/window/update_icon_state()
	icon_state = "[base_icon_state]-[open ? "open" : "closed"]"
	return ..()

/obj/structure/codec/window/attack_hand_secondary(mob/living/user, list/modifiers)
	. = ..()
	if(can_touch)
		if(user.a_intent == INTENT_GRAB)
//		playsound(loc, 'sound/effects/curtain.ogg', 50, TRUE)
			if(!open)
				user.visible_message(span_notice("[user] opens [src]."), \
									span_notice("I open [src]."))
			else
				user.visible_message(span_notice("[user] closes [src]."), \
						span_notice("I close [src]."))
			toggle()

/obj/structure/codec/window/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.a_intent != INTENT_GRAB)
		if(open)
			return
		user.visible_message(span_notice("[user] knocks on [src]."), \
			span_notice("I knock on [src]."))
		user.changeNext_move(CLICK_CD_WRENCH)
		playsound(src, knocksound, 50, TRUE)

/obj/structure/codec/window/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(open)
		if(istype(mover) && (mover.pass_flags & PASSTABLE))
			return TRUE
		if(mover.throwing)
			return TRUE
	return ..()

/obj/structure/codec/window/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(istype(mover, /obj/projectile))
		if(!anchored)
			return TRUE
		var/obj/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return TRUE
		if(prob(proj_pass_rate))
			return TRUE
		return FALSE

#define DOOR_CLOSE_WAIT 60

/obj/machinery/codec/door
	name = "Door"
	desc = "It's better not to open."
	icon = 'modular_pod/icons/obj/things/things_2.dmi'
	icon_state = "door_blue1"
	base_icon_state = "door_blue"
	opacity = TRUE
	density = TRUE
//	plane = ABOVE_GAME_PLANE
	layer = BELOW_MOB_LAYER
	obj_flags = CAN_BE_HIT|BLOCK_Z_OUT_DOWN|BLOCK_Z_OUT_UP|BLOCK_Z_IN_DOWN|BLOCK_Z_IN_UP
	var/doorOpen = 'modular_septic/sound/doors/door_metal_open.ogg'
	var/doorClose = 'modular_septic/sound/doors/door_metal_close.ogg'
	var/doorDeni = list('modular_septic/sound/doors/door_metal_try1.ogg', 'modular_septic/sound/doors/door_metal_try2.ogg')
	var/kicksuccess = 'modular_septic/sound/doors/smod_freeman.ogg'
	COOLDOWN_DECLARE(key_cooldown)
	var/key_cooldown_duration = 1 SECONDS
	var/key_worthy = FALSE
	var/open_cooldown_duration = 2 SECONDS
	COOLDOWN_DECLARE(open_cooldown)
	var/locked = FALSE
	var/autoclose = FALSE
	var/autolock = FALSE
	var/visible = TRUE

/obj/machinery/codec/door/attack_foot(mob/user)
	. = ..()
	if(!density)
		return
	gordan_freeman_speedrunner(user, src)

/obj/machinery/codec/door/proc/gordan_freeman_speedrunner(mob/living/user)
	if(!isliving(user) || !user.Adjacent(src) || user.incapacitated())
		return
	playsound(src, kicksuccess, 90, FALSE, 2)
	sound_hint()
	src.visible_message(span_danger("[user] kicks [src]!"))
//	to_chat(user, span_danger("Я пинаю [src]."))
	user.changeNext_move(CLICK_CD_WRENCH)
	if(!locked)
		open()

/obj/machinery/codec/door/proc/open(mob/living/carbon/user)
	if(!COOLDOWN_FINISHED(src, open_cooldown))
		return
	if(!density)
		return 1
	if(locked)
		playsound(src, doorDeni, 70, FALSE)
		sound_hint()
		COOLDOWN_START(src, open_cooldown, open_cooldown_duration)
		src.visible_message(span_notice("<b>[user]</b> shakes [src] handle.</span>"))
		return
	set_opacity(0)
	set_density(FALSE)
	flags_1 &= ~PREVENT_CLICK_UNDER_1
//	layer = initial(layer)
	update_appearance()
	set_opacity(0)
	air_update_turf(TRUE, FALSE)
	if(autoclose)
		autoclose_in(DOOR_CLOSE_WAIT)
	playsound(src, doorOpen, 65, FALSE)
	COOLDOWN_START(src, open_cooldown, open_cooldown_duration)
	return 1

/obj/machinery/codec/door/proc/close()
	if(!COOLDOWN_FINISHED(src, open_cooldown))
		return
	if(density)
		return TRUE
	for(var/atom/movable/M in get_turf(src))
		if(M.density && M != src) //something is blocking the door
//			if(autoclose)
//				autoclose_in(DOOR_CLOSE_WAIT)
			return

//	if(locate(/obj/) in get_turf(src))
//		return
	if(autolock)
		if(locked)
			return
		locked = TRUE
	set_density(TRUE)
	flags_1 |= PREVENT_CLICK_UNDER_1
	update_appearance()
	if(visible)
		set_opacity(1)
	air_update_turf(TRUE, TRUE)
	playsound(src, doorClose, 65, FALSE)
	COOLDOWN_START(src, open_cooldown, open_cooldown_duration)
	return TRUE

/obj/machinery/codec/door/proc/try_door_unlock(user)
	if(allowed(user))
		if(locked)
			unlock()
		else
			lock()
	return TRUE

/obj/machinery/codec/door/attackby(obj/item/I, mob/living/user, params)
	if(!COOLDOWN_FINISHED(src, key_cooldown))
		to_chat(user, span_warning("Need to calm down."))
		return
	if(!density)
		return
	if(istype(I, /obj/item/key) && key_worthy)
		var/obj/item/key/key = I
		if(key.door_allowed(src)) //I...?
			if(!locked)
				locked = TRUE
			else
				locked = FALSE
			to_chat(user, span_notice("I use [I] on [src]."))
			playsound(src, 'modular_septic/sound/effects/keys_use.ogg', 75, FALSE)
		else
			to_chat(user, span_warning("Not this."))
			playsound(src, 'modular_septic/sound/effects/keys_remove.ogg', 75, FALSE)
		add_fingerprint(user)
		sound_hint()
		COOLDOWN_START(src, key_cooldown, key_cooldown_duration)
		return TRUE

	if(istype(I, /obj/item/storage/belt/keychain))
		for (var/obj/item/key/podpol/KK in I.contents)
			if(KK.door_allowed(src) && key_worthy)
				if(locked)
					visible_message("<span class = 'notice'>[user] unlocks [src].</span>")
					playsound(src, 'modular_septic/sound/effects/keys_use.ogg', 75, FALSE)
					locked = FALSE
				else
					visible_message("<span class = 'notice'>[user] locks [src].</span>")
					playsound(src, 'modular_septic/sound/effects/keys_use.ogg', 75, FALSE)
					locked = TRUE
			else
				to_chat(user, span_warning("Not this."))
				playsound(src, 'modular_septic/sound/effects/keys_remove.ogg', 75, FALSE)
//	return ..()

/obj/machinery/codec/door/allowed(mob/M, obj/item/key/key)
	if(key?.door_allowed(src))
		return TRUE
	return ..()

/obj/machinery/codec/door/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(density)
		open(user)
	else
		close()

/obj/machinery/codec/door/update_icon_state()
	icon_state = "[base_icon_state][density]"
	return ..()

/obj/machinery/codec/door/proc/autoclose()
	if(!QDELETED(src) && !density && !locked && autoclose)
		close()
		if(autolock)
			if(locked)
				return
			locked = TRUE

/obj/machinery/codec/door/proc/autoclose_in(wait)
	addtimer(CALLBACK(src, PROC_REF(autoclose)), wait, TIMER_UNIQUE | TIMER_NO_HASH_WAIT | TIMER_OVERRIDE)

/obj/machinery/codec/door/proc/lock()
	return

/obj/machinery/codec/door/proc/unlock()
	return

/obj/machinery/codec/door/red
	name = "Door"
	desc = "DEFAULT!"
	icon_state = "door_red1"
	base_icon_state = "door_red"

/obj/machinery/codec/door/kapno
	name = "Door"
	desc = "Old! Retarded!"
	icon_state = "door_kapno1"
	base_icon_state = "door_kapno"
	doorOpen = 'modular_septic/sound/doors/wood/door_wooden_open.ogg'
	doorClose = 'modular_septic/sound/doors/wood/door_wooden_close.ogg'
	doorDeni = 'modular_septic/sound/doors/wood/door_wooden_try.ogg'
	autoclose = TRUE

/obj/machinery/codec/door/konch
	name = "Door"
	desc = "Not really old! Retarded!"
	icon_state = "door_konch1"
	base_icon_state = "door_konch"
	doorOpen = 'modular_septic/sound/doors/wood/door_wooden_open.ogg'
	doorClose = 'modular_septic/sound/doors/wood/door_wooden_close.ogg'
	doorDeni = 'modular_septic/sound/doors/wood/door_wooden_try.ogg'
	autoclose = TRUE
	locked = TRUE
	key_worthy = TRUE
	id_tag = "konchkey"

/obj/machinery/codec/door/kapno/father
	locked = TRUE
	key_worthy = TRUE
	id_tag = "kapnoroom"

/obj/machinery/codec/door/villager
	name = "Door"
	desc = "Old!"
	icon_state = "door_ka1"
	base_icon_state = "door_ka"
	doorOpen = 'modular_septic/sound/doors/wood/door_wooden_open.ogg'
	doorClose = 'modular_septic/sound/doors/wood/door_wooden_close.ogg'
	doorDeni = 'modular_septic/sound/doors/wood/door_wooden_try.ogg'
	autoclose = FALSE
	locked = TRUE
	key_worthy = TRUE
	id_tag = "villager"

/obj/machinery/codec/door/jail
	name = "Jaildoor"
	desc = "Rib-like rods."
	icon_state = "door_jail1"
	base_icon_state = "door_jail"
	doorOpen = 'modular_pod/sound/eff/open_jo.ogg'
	doorClose = 'modular_pod/sound/eff/close_jo.ogg'
	doorDeni = 'modular_pod/sound/eff/tryjail.ogg'
	autoclose = TRUE
	locked = TRUE
	key_worthy = TRUE
	id_tag = "jail"
	visible = FALSE
	opacity = FALSE
	var/proj_pass_rate = 100

/obj/machinery/codec/door/jail/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(locate(/obj/machinery/codec/door/jail) in get_turf(mover))
		return TRUE
	else if(istype(mover, /obj/projectile))
		if(!anchored)
			return TRUE
		var/obj/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return TRUE
		if(prob(proj_pass_rate))
			return TRUE
		return FALSE


/obj/item/key/podpol/woody
	slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_EARS | ITEM_SLOT_BELT | ITEM_SLOT_ID
	worn_icon_state = "shard"
	w_class = WEIGHT_CLASS_TINY
	inhand_icon_state = null
//	worn_icon = null

/obj/item/key/podpol/woody/villagerkey
	name = "Key"
	desc = "To the Village house door."
	icon_state = "key_father"
	id_tag = "villager"
	slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_EARS | ITEM_SLOT_BELT | ITEM_SLOT_ID | ITEM_SLOT_POCKETS
	inhand_icon_state = null
	worn_icon_state = "shard"

/obj/item/key/podpol/woody/witcherkey
	name = "Key"
	desc = "To the Witcher house door."
	icon_state = "key_father"
	id_tag = "witcher"
	slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_EARS | ITEM_SLOT_BELT | ITEM_SLOT_ID | ITEM_SLOT_POCKETS
	inhand_icon_state = null
	worn_icon_state = "shard"

/obj/item/key/podpol/woody/guardokey
	name = "Key"
	desc = "To the Guard house door."
	icon_state = "key_father"
	id_tag = "guardo"
	slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_EARS | ITEM_SLOT_BELT | ITEM_SLOT_ID | ITEM_SLOT_POCKETS
	inhand_icon_state = null
	worn_icon_state = "shard"

/obj/item/key/podpol/woody/kapnokey
	name = "Key"
	desc = "To the door of the Ladax Father room."
	icon_state = "key_father"
	id_tag = "kapnoroom"
	slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_EARS | ITEM_SLOT_BELT | ITEM_SLOT_ID
	inhand_icon_state = null
	worn_icon_state = "shard"

/obj/item/key/podpol/woody/kapnodvorkey
	name = "Key"
	desc = "To the door of the Ladax courtyard."
	icon_state = "key_father"
	id_tag = "kapnodvor"
	slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_EARS | ITEM_SLOT_BELT | ITEM_SLOT_ID
	inhand_icon_state = null
	worn_icon_state = "shard"

/obj/item/key/podpol/woody/konchkey
	name = "Key"
	desc = "To the door of the Kador courtyard."
	icon_state = "key_konch"
	id_tag = "konchkey"
	slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_EARS | ITEM_SLOT_BELT | ITEM_SLOT_ID
	inhand_icon_state = null
	worn_icon_state = "shard"

/obj/item/key/podpol/steel
	name = "Key"
	desc = "To the cage door."
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "jailkey"
	id_tag = "jail"
	slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_EARS | ITEM_SLOT_BELT | ITEM_SLOT_ID
	worn_icon_state = "shard"
	w_class = WEIGHT_CLASS_TINY
	inhand_icon_state = null

#undef DOOR_CLOSE_WAIT

/obj/structure/sign/poster/contraband/codec/o
	name = "Гедвяница"
	desc = "Считалось символом язычества, обозначающий падающее солнце как конец света. Теперь же это символ других фанатиков, и я думаю, мы знаем про каких фанатиков мы говорим."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "poster_o"

/obj/structure/sign/poster/contraband/codec/ring
	name = "Ring"
	desc = "This scares me!"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "symb_1"
	light_range = 3
	light_power = 2
	light_color = "#f89852"

/obj/structure/sign/poster/contraband/codec/strong
	name = "Face"
	desc = "Celebrate the strength within you."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "eviln"

/obj/structure/sign/poster/contraband/codec/painting/m
	name = "Painting"
	desc = "Love."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "painting_1"

/obj/structure/newgrille/codec
	name = "Grille"
	desc = "It's here for a reason."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "grille"
	base_icon_state = "grille"
	density = TRUE
	anchored = TRUE
	var/electro = FALSE
	var/openede = FALSE
	var/special_openeda = FALSE
	var/id = null
	var/opaque_closed = FALSE
	var/open = FALSE

/obj/structure/newgrille/codec/Initialize(mapload)
	. = ..()
	if(special_openeda)
		GLOB.button_slaves += src
	if(!open)
		if(opaque_closed)
			set_opacity(TRUE)

/obj/structure/newgrille/codec/Destroy()
	GLOB.button_slaves.Remove(src)

/obj/structure/newgrille/codec/Bumped(atom/movable/AM)
	if(electro)
		if(!ismob(AM))
			return
		var/mob/living/carbon/M = AM
		M.electrocute_act(30, src, flags = SHOCK_NOGLOVES)

/obj/structure/newgrille/codec/attackby(obj/item/W, mob/living/carbon/user, params)
	if(electro)
		user.electrocute_act(30, src, flags = SHOCK_NOGLOVES)

/obj/structure/newgrille/codec/proc/toggle()
	if(!openede)
		return
	open = !open
	if(open)
		set_density(FALSE)
		set_opacity(FALSE)
	else
		set_density(TRUE)
		if(opaque_closed)
			set_opacity(TRUE)

	playsound(get_turf(src), 'modular_pod/sound/eff/open_grille.ogg', 100 , vary = FALSE, falloff_exponent = 18, falloff_distance = 2)
	update_appearance()

/obj/structure/newgrille/codec/update_icon_state()
	if(openede)
		icon_state = "[base_icon_state]-[open ? "open" : "closed"]"
	return ..()

/obj/structure/newgrille/codec/darker
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "darkg"
	base_icon_state = "darkg"

/obj/structure/newgrille/codec/arena
	electro = TRUE
	special_openeda = TRUE
	openede = TRUE
	id = "arena"

/obj/structure/buttona/codec
	name = "Button"
	desc = "Interesting."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "buttona"
	var/cooldown = FALSE
	var/opens_grilles = FALSE
	var/ultra_arena = FALSE
	var/id = null
	var/signal_got = FALSE
	var/blocked = FALSE
	var/should_block = FALSE
	var/blue = FALSE
	var/red = FALSE

/obj/structure/buttona/codec/Initialize(mapload)
	. = ..()
	GLOB.buttons_masters += src

/obj/structure/buttona/codec/Destroy()
	GLOB.buttons_masters.Remove(src)

/obj/structure/buttona/codec/attack_hand(mob/user)
	if(user.a_intent != INTENT_DISARM)
		return
	if(cooldown)
		return
	cooldown = TRUE
	visible_message("<span class = 'notice'>[user] clicks on [src].</span>")
	if(opens_grilles)
		if(ultra_arena)
			for(var/obj/structure/buttona/codec/M in (GLOB.buttons_masters - src))
				if(M.ultra_arena)
					if(!M.signal_got)
						M.signal_got = TRUE
						if(red)
							priority_announce("КРАСНЫЕ КНОПКУ НАЖАЛИ!", "КОПЕНГАГЕН", has_important_message = TRUE)
							SEND_SOUND(world, sound('modular_pod/sound/mus/announce.ogg'))
						if(blue)
							priority_announce("СИНИЕ КНОПКУ НАЖАЛИ!", "КОПЕНГАГЕН", has_important_message = TRUE)
							SEND_SOUND(world, sound('modular_pod/sound/mus/announce.ogg'))
					else
						if(signal_got)
							ultra_arena = FALSE
							M.ultra_arena = FALSE
		else
			if(blocked)
				return
			for(var/obj/structure/newgrille/codec/M in GLOB.button_slaves)
				if(M.id == src.id)
					INVOKE_ASYNC(M, /obj/structure/newgrille/codec.proc/toggle)
					if(should_block)
						blocked = TRUE
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 10)

/obj/structure/buttona/codec/arena/red
	opens_grilles = TRUE
	id = "arena"
	ultra_arena = TRUE
	red = TRUE
	should_block = TRUE

/obj/structure/buttona/codec/arena/blue
	opens_grilles = TRUE
	id = "arena"
	ultra_arena = TRUE
	blue = TRUE
	should_block = TRUE

/obj/structure/codec/bulb/caramel
	name = "Bulb"
	desc = "So many colours.."
	icon = 'modular_pod/icons/obj/things/things_2.dmi'
	icon_state = "bulb_caramelldansen"
	base_icon_state = "bulb_caramelldansen"
	plane = GAME_PLANE_BLOOM
	density = FALSE
	anchored = TRUE
	max_integrity = 100
	light_range = 3
	light_power = 1
	light_color = "#C979DB"

/obj/structure/codec/bulb/caramel/process()
	. = ..()
	light_color = "#C979DB"
	sleep(1 SECONDS)
	light_color = "#79BEDB"
	sleep(1 SECONDS)
	light_color = "#DBAA79"
	sleep(1 SECONDS)
	light_color = "#7EDB79"
	sleep(1 SECONDS)
	light_color = "#BFDB79"


// Boombox implementation - fixed version
// Boombox implementation - simplified version compatible with existing codebase
// Boombox implementation - fixed version
/obj/item/portable_jukebox
    name = "Boombox"
    desc = "It can blast your favorite tunes."
    icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
    icon_state = "boombox"
    w_class = WEIGHT_CLASS_NORMAL
    throwforce = 2
    throw_speed = 2
    throw_range = 5
    force = 5

    var/playing = FALSE
    var/datum/jukebox_track/loaded_track = null
    var/volume = 35
    var/radius = 13
    var/max_radius = 13
    var/obj/item/disk/jukebox_disk/inserted_cassette = null
    var/playback_timer = null // Timer ID for looping
    var/list/current_listeners = list() // Track who's listening
    var/sound_channel = 1024 // Use a specific channel for boombox sounds

/obj/item/portable_jukebox/Initialize()
    . = ..()
    current_listeners = list()

/obj/item/portable_jukebox/Destroy()
    stop_playing()
    if(loaded_track)
        QDEL_NULL(loaded_track)
    if(inserted_cassette)
        inserted_cassette.forceMove(get_turf(src))
        inserted_cassette = null
    return ..()

/obj/item/portable_jukebox/examine(mob/user)
    . = ..()
    . += span_notice("It is currently [playing ? "playing" : "stopped"].")
    . += span_notice("Volume: [volume]%")
    . += span_notice("Playback radius: [radius] tiles.")
    if(loaded_track)
        . += span_notice("Loaded track: [loaded_track.name]")
    if(inserted_cassette)
        . += span_notice("Cassette inserted: [inserted_cassette.name]")
    else
        . += span_notice("No cassette inserted.")
    . += span_notice("Alt-click to adjust volume. Right-click to eject cassette.")

/obj/item/portable_jukebox/attackby(obj/item/W, mob/living/carbon/user, params)
    if(istype(W, /obj/item/disk/jukebox_disk))
        var/obj/item/disk/jukebox_disk/D = W
        if(!D.track)
            to_chat(user, span_warning("The cassette is empty!"))
            return

        if(inserted_cassette)
            eject_cassette(user)

        inserted_cassette = D
        loaded_track = D.track.copy()
        // Remove from user's hand/inventory
        user.transferItemToLoc(D, src)
        to_chat(user, span_notice("You insert [D.name] into [src]."))
        playsound(src, 'sound/machines/click.ogg', 20, TRUE)
        return TRUE
    return ..()

/obj/item/portable_jukebox/attack_hand_secondary(mob/user, list/modifiers)
    eject_cassette(user)
    return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/portable_jukebox/proc/eject_cassette(mob/living/carbon/user)
    if(!inserted_cassette)
        to_chat(user, span_warning("No cassette to eject!"))
        return
    stop_playing()
    to_chat(user, span_notice("You eject [inserted_cassette.name] from [src]."))
    user.put_in_hands(inserted_cassette)
    loaded_track = null
    inserted_cassette = null
    playsound(src, 'sound/machines/click.ogg', 20, TRUE)

/obj/item/portable_jukebox/AltClick(mob/living/carbon/user)
    if(!user.canUseTopic(src, BE_CLOSE))
        return

    var/new_volume = input(user, "Set volume (0-100)", "Volume", volume) as null|num
    if(isnull(new_volume) || !user.canUseTopic(src, BE_CLOSE))
        return

    volume = clamp(new_volume, 0, 100)
    to_chat(user, span_notice("You set the volume to [volume]%."))
    
    // Update volume if currently playing
    if(playing)
        stop_playing()
        start_playing()

/obj/item/portable_jukebox/attack_self(mob/living/carbon/user)
    if(!playing)
        start_playing(user)
    else
        stop_playing(user)

/obj/item/portable_jukebox/proc/start_playing(mob/user)
    if(playing || !loaded_track || !loaded_track.path)
        if(user && !loaded_track)
            to_chat(user, span_warning("There's no cassette inserted!"))
        return

    playing = TRUE
    play_music()
    playsound(src, 'sound/machines/click.ogg', 20, TRUE)
    if(user)
        user.visible_message(span_notice("[user] turns on [src]."), span_notice("You turn on [src]."))
    
    // Update icon to show it's playing
    icon_state = "boombox_on"

/obj/item/portable_jukebox/proc/stop_playing(mob/user)
    if(!playing)
        return

    playing = FALSE
    
    // Stop the sound for all listeners
    for(var/mob/M in current_listeners)
        M.stop_sound_channel(sound_channel)
    
    current_listeners.Cut()
    
    // Clear any pending timers
    if(playback_timer)
        deltimer(playback_timer)
        playback_timer = null
    
    playsound(src, 'sound/machines/click.ogg', 20, TRUE)
    if(user)
        user.visible_message(span_notice("[user] turns off [src]."), span_notice("You turn off [src]."))
    
    // Update icon to show it's stopped
    icon_state = "boombox"

/obj/item/portable_jukebox/proc/play_music()
    if(!playing || !loaded_track || !loaded_track.path)
        return

    // Clear previous listeners
    for(var/mob/M in current_listeners)
        M.stop_sound_channel(sound_channel)
    current_listeners.Cut()

    // Get all hearers in range
    var/list/hearers_in_range = hearers(radius, get_turf(src))

    // Play to all hearers in range
    for(var/mob/M in hearers_in_range)
        var/sound/music = sound(loaded_track.path)
        music.volume = volume / 100  // Convert to 0-1 scale
        music.channel = sound_channel // Use our dedicated channel
        music.falloff = 5
        music.y = 1 // Stereo
        music.wait = 0
        music.environment = 0
        
        SEND_SOUND(M, music)
        current_listeners |= M

    // Set up timer to loop the track
    if(playback_timer)
        deltimer(playback_timer)

    // Get the sound length or use a default
    var/sound_length = get_track_length()
    playback_timer = addtimer(CALLBACK(src, PROC_REF(play_music)), sound_length, TIMER_STOPPABLE)

/obj/item/portable_jukebox/proc/get_track_length()
    // Use track's stored length if available
    if(loaded_track && loaded_track.length > 0)
        return loaded_track.length
    
    // Otherwise use a reasonable default (30 seconds)
    return 300

// Move when the boombox moves
/obj/item/portable_jukebox/Moved(atom/OldLoc, Dir)
    . = ..()
    if(playing)
        // Update listeners when the boombox moves
        addtimer(CALLBACK(src, PROC_REF(play_music)), 1) // Small delay to avoid sound spam

/datum/jukebox_track
    var/name = "Untitled"
    var/path
    var/length = 0 // Store the track length in deciseconds

/datum/jukebox_track/proc/copy()
    var/datum/jukebox_track/T = new
    T.name = name
    T.path = path
    T.length = length
    return T

/obj/item/disk/jukebox_disk
    name = "Music Cassette"
    desc = "A cassette that can store a single track for use in a boombox."
    icon = 'modular_septic/icons/obj/structures/jukebox.dmi'
    icon_state = "jukebox_disk"
    var/datum/jukebox_track/track = null

/obj/item/disk/jukebox_disk/examine(mob/user)
    . = ..()
    if(track)
        . += span_notice("It contains the track \"[track.name]\".")
    else
        . += span_notice("It is blank.")

/obj/item/disk/jukebox_disk/attack_self(mob/user)
    if(!track)
        // List of predefined sound files to choose from
        var/list/sound_choices = list(
//            "Ambient Music" = 'sound/ambience/ambispace.ogg',
            "Space Asshole" = 'sound/ambience/title2.ogg'
//            "Clown Song" = 'sound/items/bikehorn.ogg',
//            "Thunderdome" = 'sound/ambience/ambimalf.ogg'
        )
        
        var/choice = input(user, "Choose a music track:", "Upload Music") as null|anything in sound_choices
        if(!choice)
            return TRUE
        
        var/selected_sound = sound_choices[choice]
        
        track = new
        track.name = choice
        track.path = selected_sound
        
        // Try to determine track length based on the file
        // This is a placeholder - in a real implementation you might want to use a predefined list of lengths
        track.length = 300 // Default 30 seconds
        
        name = "Cassette ([choice])"
        to_chat(user, span_notice("You record [choice] onto [src]."))
        playsound(src, 'sound/machines/ping.ogg', 20, TRUE)
        return TRUE