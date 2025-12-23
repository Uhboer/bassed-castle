/obj/structure/wayto/podpol
	name = "Underfloor"
	desc = "What's there?"
	icon = 'modular_pod/icons/obj/things/things_4.dmi'
	icon_state = "podpol"
	anchored = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	pixel_x = -16
	pixel_y = -16
	var/up = FALSE
	var/down = TRUE
	light_range = 2
	light_power = 1
	light_color = "#e1dfe1"

/obj/structure/wayto/podpol/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	use(user, TRUE)

/obj/structure/wayto/podpol/attackby(obj/item/I, mob/living/user, params)
	use(user, TRUE)
	return TRUE

/obj/structure/wayto/podpol/proc/use(mob/living/carbon/human/user, going_up = TRUE, is_ghost = FALSE)
	if(user.truerole != "Ladax")
		to_chat(user, span_notice("The boys there won't accept me."))
		return
	if(!in_range(src, user) || user.incapacitated())
		return
//	if(user.loc != loc)
//		return
	if(!do_after(user, 4, target = src))
		to_chat(user, span_danger(xbox_rage_msg()))
		user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return
	if(up)
		var/turf/above_turf = SSmapping.get_turf_above(get_turf(src))
		var/atom/movable/AM
		if(user.pulling)
			AM = user.pulling
			AM.forceMove(above_turf)
		user.forceMove(above_turf)
		if(AM)
			user.start_pulling(AM)
	if(down)
		var/turf/below_turf = SSmapping.get_turf_below(get_turf(src))
		var/atom/movable/AM
		if(user.pulling)
			AM = user.pulling
			AM.forceMove(below_turf)
		user.forceMove(below_turf)
		if(AM)
			user.start_pulling(AM)

/obj/structure/wayto/podpol/up
	icon_state = "podpol2"
	up = TRUE
	down = FALSE

/obj/structure/table/goody
	name = "Table"
	desc = "Nice. Cute. Good."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "tablera"
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
	frame = null

/obj/structure/table/goody/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!QDELETED(src))
			qdel(src)

/obj/structure/bed/mattress
	name = "Mattress"
	desc = "The main thing is to get enough sleep."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "mattress"

/obj/structure/bed/peasanto
	name = "Bed"
	desc = "Good old bed."
	icon = 'modular_pod/icons/obj/things/things_2.dmi'
	icon_state = "peasant_bed"

/obj/structure/bed/peasanto/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!QDELETED(src))
			qdel(src)

/obj/structure/closet/crate/freezer/podozl
	name = "Fridge"
	desc = "In this state... Somehow it cools."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "holodos"
	open_sound = 'modular_pod/sound/eff/open_holodos.ogg'
	close_sound = 'modular_pod/sound/eff/close_holodos.ogg'
	door_anim_time = 0

/particles/fire
	icon = 'icons/effects/particles/bonfire.dmi'
	icon_state = "bonfire"
	width = 64
	height = 128
	count = 100
	spawning = 7
	lifespan = 2 SECONDS
	fade = 1 SECONDS
	color = 0
	color_change = 0.1
	gradient = list("#FBDB28", "#FCE6B6", "#FF532B")
	position = generator("box", list(-16,-12,-32), list(16,32,32), NORMAL_RAND)
	drift = generator("vector", list(-0.1,0), list(0.1,0.2), UNIFORM_RAND)
	scale = generator("vector", list(0.5,0.5), list(2,2), NORMAL_RAND)
	spin = generator("num", list(-30,30), NORMAL_RAND)

/particles/fog
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("chill_1" = 2, "chill_2" = 2, "chill_3" = 1)

/particles/fog/breath
	count = 1
	spawning = 1
	lifespan = 1 SECONDS
	fade = 0.5 SECONDS
	grow = 0.05
	spin = 2
	color = "#fcffff77"

/obj/structure/lighterfire
	name = "Barrel"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "barrel"
	desc = "Fascinating."
	plane = GAME_PLANE_BLOOM
	density = 1
	anchored = 1
	light_range = 4
	light_power = 1
	light_color = "#e19644"
	var/datum/looping_sound/firee/soundloop
	var/proj_pass_rate = 100

/obj/structure/lighterfire/CanAllowThrough(atom/movable/mover, border_dir)//So bullets will fly over and stuff.
	. = ..()
	if(locate(/obj/structure/lighterfire) in get_turf(mover))
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

/obj/structure/lighterfire/Initialize(mapload)
	. = ..()
	soundloop = new(src, FALSE)
	soundloop.start()

/obj/structure/lighterfire/Destroy()
	. = ..()
	QDEL_NULL(soundloop)

/obj/structure/lighterfire/New()
	..()
	add_particle_holder("embers", /atom/movable/particle_holder/fire)
	add_particle_holder("smoke", /atom/movable/particle_holder/fire_smoke)
/*
/datum/looping_sound/musicloop
	mid_sounds = list('modular_pod/sound/mus/boombox.ogg' = 1)
	mid_length = 161 SECONDS
	volume = 70
	falloff_exponent = 10
	falloff_distance = 3
*/
/obj/item/musicshit/boombox
	name = "Boombox"
	desc = "Fucking amazing."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "boombox"
//	var/datum/looping_sound/musicloop/soundloop
	var/playc = FALSE
	var/list/rangers = list()

//obj/item/musicshit/boombox/Initialize(mapload)
//	. = ..()
//	soundloop = new(src,  FALSE)

//obj/item/musicshit/boombox/Destroy()
//	QDEL_NULL(soundloop)
//	. = ..()

/obj/item/musicshit/boombox/attack_self(mob/user)
	. = ..()
	if(playc)
		playc = FALSE
		STOP_PROCESSING(SSobj, src)
		for(var/mob/living/L in rangers)
			if(!L || !L.client)
				continue
			L.stop_sound_channel(CHANNEL_JUKEBOX)
		rangers = list()
//	else
//		playc = TRUE
//		START_PROCESSING(SSobj, src)
	user.changeNext_move(CLICK_CD_MELEE)
/*
/obj/item/musicshit/boombox/process()
	if(playc)
		var/turf/turf_source = get_turf(src)
		if(!turf_source)
			return
		var/source_z = turf_source.z
		var/turf/above_turf = SSmapping.get_turf_above(turf_source)
		var/turf/below_turf = SSmapping.get_turf_below(turf_source)
		rangers += SSmobs.clients_by_zlevel[source_z]
		rangers += SSmobs.dead_players_by_zlevel[source_z]
		if(above_turf && istransparentturf(above_turf))
			rangers += SSmobs.clients_by_zlevel[above_turf.z]
			rangers += SSmobs.dead_players_by_zlevel[above_turf.z]
		if(below_turf && istransparentturf(turf_source))
			rangers += SSmobs.clients_by_zlevel[below_turf.z]
			rangers += SSmobs.dead_players_by_zlevel[below_turf.z]
		for(var/mob/living/listening_mob as anything in rangers)
			var/distance = get_dist(listening_mob, turf_source)
			if(distance <= 13)
				if(listening_mob.listen_juke)
					return
				if(!listening_mob || !listening_mob.client)
					continue
				listening_mob.listen_juke = TRUE
//				listening_mob.playsound_local(turf_source, 'modular_pod/sound/mus/boombox.ogg', 60, CHANNEL_JUKEBOX, 11, 3, TRUE)
//				listening_mob.playsound_local(turf_source, 'modular_pod/sound/mus/boombox.ogg', 60, channel = CHANNEL_JUKEBOX, use_reverb = TRUE, repeater = TRUE)
//				playsound(src, 'modular_pod/sound/mus/boombox.ogg', 60, channel = CHANNEL_JUKEBOX, use_reverb = TRUE, repeater = TRUE, ignore_walls = TRUE, vary = FALSE, falloff_exponent = 13, falloff_distance = 7, extra)
				playsound(src, 'modular_pod/sound/mus/boombox.ogg', volume = 60, vary = FALSE, extra_range = 1, falloff_exponent = 13, falloff_distance = 4, channel = CHANNEL_JUKEBOX)
			else
				listening_mob.listen_juke = FALSE
				rangers -= listening_mob
				if(!listening_mob || !listening_mob.client)
					continue
				listening_mob.stop_sound_channel(CHANNEL_JUKEBOX)
	else
		for(var/mob/living/listening_mob as anything in rangers)
			listening_mob.listen_juke = FALSE
			rangers -= listening_mob
			if(!listening_mob || !listening_mob.client)
				continue
			listening_mob.stop_sound_channel(CHANNEL_JUKEBOX)
*/
/obj/structure/chair/podpolsit
	name = "Throne"
	desc = "It's time to find out what power is."
	icon = 'modular_pod/icons/obj/things/things_5.dmi'
	icon_state = "sit"
	max_integrity = 10000
	light_range = 4
	light_power = 2
	light_color = "#ff7d00"

/obj/structure/chair/podpolsit/deconstruct()
	new /obj/item/podpol_weapon/sword/steel(get_turf(src))

/obj/structure/chair/podpolsit/post_buckle_mob(mob/living/M)
	. = ..()
	if(iscarbon(M))
		M.pixel_y += 5
		M.visible_message(span_notice("[M] sits down on [src]."),span_notice("I sit down on [src]."), span_hear("I hear something."))
		if(do_after(M, 3 SECONDS, target=src))
			if(!M.buckled)
				to_chat(M, span_meatymeat("We need to sit on the throne!"))
				return
			to_chat(M, span_meatymeat("I feel some kind of fucked up!"))
			M.fully_heal(TRUE)

/obj/structure/chair/podpolsit/post_unbuckle_mob(mob/living/M)
	if(iscarbon(M))
		M.pixel_y -= 5

/obj/structure/column/power
	name = "Statue"
	desc = "That which inspires fear."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "power"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	anchored = 1
	density = 1
	obj_flags = NONE
	max_integrity = 1000

/obj/structure/column/hidran
	name = "Hidran"
	desc = "He is in search of himself."
	icon = 'modular_pod/icons/obj/things/things_2.dmi'
	icon_state = "hidran"
//	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	anchored = 1
	density = 1
	obj_flags = NONE
	max_integrity = 100

/obj/structure/column/hidran/attackby(obj/item/I, mob/living/user, params)
	return

/obj/effect/decal/metalpodpol
	name = "Metal Tiles"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "metal1"
	layer = TURF_PLATING_DECAL_LAYER
	alpha = 255
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/metalpodpol/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "metal2"

/obj/effect/decal/grassgood
	name = "Grass"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "grass1"
	layer = TURF_PLATING_DECAL_LAYER
	resistance_flags = FLAMMABLE
	alpha = 255
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/grassgood/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "grass2"

/obj/effect/decal/grassbad
	name = "Grass"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "plant1"
	layer = TURF_PLATING_DECAL_LAYER
	resistance_flags = FLAMMABLE
	alpha = 255
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/grassbad/Initialize(mapload)
	. = ..()
	icon_state = pick("plant2", "plant1", "plant3")

/obj/effect/decal/grassnice
	name = "Grass"
	icon = 'modular_pod/icons/obj/things/things.dmi'
	icon_state = ""
	layer = TURF_PLATING_DECAL_LAYER
	resistance_flags = FLAMMABLE
	alpha = 255
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/grassnice/Initialize(mapload)
	. = ..()
	icon_state = pick("planty_1", "planty_2", "planty_3", "planty_4")

/obj/effect/decal/grassev
	name = "Grass"
	icon = 'modular_pod/icons/obj/things/things_6.dmi'
	icon_state = "travinka1"
	layer = TURF_PLATING_DECAL_LAYER
	resistance_flags = FLAMMABLE
	alpha = 255
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/grassev/Initialize(mapload)
	. = ..()
	icon_state = pick("travinka1", "travinka2", "travinka3")

/obj/effect/decal/grassevc
	name = "Grass"
	icon = 'modular_pod/icons/obj/things/things_6.dmi'
	icon_state = "long1"
	layer = TURF_PLATING_DECAL_LAYER
	resistance_flags = FLAMMABLE
	alpha = 255
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/grassevc/Initialize(mapload)
	. = ..()
	icon_state = pick("long1", "long2", "long3")

/obj/effect/decal/darky
	name = "Darky Grass"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "darky_grass"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	resistance_flags = FLAMMABLE
	alpha = 255
//	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/darky/ComponentInitialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/shag,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/decal/darky/proc/shag(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!isliving(AM))
		return
	var/mob/living/walker = AM
	if(istype(walker))
		if((GET_MOB_ATTRIBUTE_VALUE(walker, STAT_DEXTERITY) >= 13) && walker.combat_mode)
			return
	playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/effect/decal/darky/attackby(obj/item/I, mob/living/user, params)
	if(I.sharpness && I.force > 5)
		if(!do_after(user, 1 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
		user.changeNext_move(I.attack_delay)
		user.adjustFatigueLoss(5)
		sound_hint()
		playsound(loc,'modular_pod/sound/eff/hitgrass.ogg', 30, TRUE)
		new /obj/item/grazzers/darky(loc)
		qdel(src)

/obj/effect/decal/grassgogan
	name = "Gogan Grass"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "gogan_grass1"
	layer = TURF_PLATING_DECAL_LAYER
	resistance_flags = FLAMMABLE
	alpha = 255
//	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/grassgogan/attackby(obj/item/I, mob/living/user, params)
	if(I.sharpness && I.force > 5)
		if(!do_after(user, 1 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
		user.changeNext_move(I.attack_delay)
		user.adjustFatigueLoss(5)
		sound_hint()
		playsound(loc,'modular_pod/sound/eff/hitgrass.ogg', 30, TRUE)
		new /obj/item/grazzers/gogan(loc)
		qdel(src)

/obj/effect/decal/grassgogan/Initialize(mapload)
	. = ..()
	icon_state = pick("gogan_grass1", "gogan_grass2", "gogan_grass3")

/obj/effect/decal/grassburmuha
	name = "Burmuha Grass"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "burmuha_grass"
	layer = TURF_PLATING_DECAL_LAYER
	resistance_flags = FLAMMABLE
	alpha = 255
//	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/grassburmuha/attackby(obj/item/I, mob/living/user, params)
	if(I.sharpness && I.force > 5)
		if(!do_after(user, 1 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
		user.changeNext_move(I.attack_delay)
		user.adjustFatigueLoss(5)
		sound_hint()
		playsound(loc,'modular_pod/sound/eff/hitgrass.ogg', 30, TRUE)
		new /obj/item/grazzers/burmuha(loc)
		qdel(src)

/obj/item/grazzers/gogan
	name = "Gogan Grass"
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "gogan"
	carry_weight = 100 GRAMS

/obj/item/grazzers/burmuha
	name = "Burmuha Grass"
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "burmuha"
	carry_weight = 100 GRAMS

/obj/item/grazzers/darky
	name = "Darky Grass"
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "darky"
	carry_weight = 100 GRAMS

/obj/item/grazzers/alienseeds
	name = "Alien Seeds"
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "alien_seeds"
	carry_weight = 100 GRAMS

/obj/item/grazzers/alienseeds/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_pinkdang("I'm starting to plant seeds."))
	if(!do_after(user, 3 SECONDS, target = src))
		to_chat(user, span_danger(xbox_rage_msg()))
		user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return
	src.visible_message(span_pinkdang("[user] grows an Alien Organ!"), \
						span_pinkdang("I grow an Alien Organ!"), \
						span_hear("I hear cosmic thing."))
	playsound(get_turf(src), 'modular_pod/sound/eff/grow_up.ogg', 80 , FALSE, FALSE)
	new /obj/structure/alien_organ(get_turf(user))
	ADD_TRAIT(user, TRAIT_ALIENOID, "john")
	qdel(src)

/obj/item/grazzers/burmuha/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/grazzers/gogan))
		if(!do_after(user, 1 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
		new /obj/item/clothing/mask/cigarette/rollie/cannabis(loc)
		qdel(src)
		qdel(I)
	if(istype(I, /obj/item/grazzers/darky))
		if(!do_after(user, 1 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
		new /obj/item/stack/medical/suture(loc)
		qdel(src)
		qdel(I)

/obj/item/grazzers/gogan/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/grazzers/burmuha))
		if(!do_after(user, 1 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
		new /obj/item/clothing/mask/cigarette/rollie/cannabis(loc)
		qdel(src)
		qdel(I)
	if(istype(I, /obj/item/grazzers/darky))
		if(!do_after(user, 1 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
		new /obj/item/stack/medical/gauze(loc)
		qdel(src)
		qdel(I)

/obj/item/grazzers/darky/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/grazzers/burmuha))
		if(!do_after(user, 1 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
		new /obj/item/stack/medical/suture(loc)
		qdel(src)
		qdel(I)
	if(istype(I, /obj/item/grazzers/gogan))
		if(!do_after(user, 1 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
			return
		new /obj/item/stack/medical/gauze(loc)
		qdel(src)
		qdel(I)

/obj/effect/decal/shroomworms
	name = "Shroomworms"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "shroomworms"
	layer = TURF_PLATING_DECAL_LAYER
	alpha = 255
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/flora/ausbushes/cactus
	name = "Cactus"
	desc = "The bitch is prickly. I would like to get some water from it."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "cactus1"
//	plane = ABOVE_GAME_PLANE
//	layer = FLY_LAYER
	resistance_flags = FLAMMABLE
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	var/proj_pass_rate = 100

/obj/structure/flora/ausbushes/cactus/Initialize(mapload)
	. = ..()
	create_reagents(70, INJECTABLE | DRAINABLE)
	reagents.add_reagent(/datum/reagent/water, 70)
	icon_state = pick("cactus1", "cactus2", "cactus3")

/obj/structure/flora/ausbushes/cactus/on_density(mob/living/carbon/human/rammer)
	var/obj/item/bodypart/affecting = rammer.get_bodypart(ran_zone(BODY_ZONE_CHEST, 50))
	if(affecting)
		var/cloth_cover = LAZYLEN(rammer.clothingonpart(affecting))
		if(!cloth_cover)
/*
			M.apply_damage(10, BRUTE, affecting, wound_bonus = 2, sharpness = SHARP_POINTY)
			affecting.adjust_germ_level(100)
*/
			var/obj/item/cactus_needle
			cactus_needle = new /obj/item/cactus_needle(loc)
			var/embed_attempt = cactus_needle.tryEmbed(target = affecting, forced = TRUE, silent = TRUE)
			if(embed_attempt & COMPONENT_EMBED_SUCCESS)
				rammer.visible_message(span_pinkdang("The needle gets stuck in [rammer] [affecting]!"), \
									span_pinkdang("The needle gets stuck in [affecting]!"), \
									span_hear("I hear meat."))
			else
				qdel(cactus_needle)
				rammer.visible_message(span_meatymeat("[rammer] pricks himself on [src]!"),span_meatymeat("I prick myself on [src]!"), span_hear("I hear meat."))
				rammer.apply_damage(10, BRUTE, affecting, rammer.run_armor_check(affecting, MELEE), wound_bonus = 2, sharpness = SHARP_POINTY)
				affecting.adjust_germ_level(100)
			if(rammer.get_chem_effect(CE_PAINKILLER) < 30)
				to_chat(rammer, span_userdanger("FUCK CACTUSES!"))
				rammer.agony_scream()
		else
			to_chat(rammer, span_meatymeat("[src] almost pricked me!"))

/obj/structure/flora/ausbushes/cactus/examine(mob/user)
	. = ..()
	if(reagents.total_volume > 0)
		. += span_notice("The cactus is not dried.")
	else
		. += span_notice("Cactus is dried.")

/obj/structure/flora/ausbushes/cactus/attackby(obj/item/W, mob/living/carbon/user, params)
/*
	if(!W.sharpness)
		if(istype(W, /obj/item/reagent_containers))
			var/obj/item/reagent_containers/RG = W
			if(reagents.total_volume <= 0)
				to_chat(user, span_notice("[src] высушен."))
				return FALSE
			if(RG.is_refillable())
				if(!RG.reagents.holder_full())
					reagents.trans_to(RG, RG.amount_per_transfer_from_this, transfered_by = user)
					to_chat(user, span_notice("Я наполняю [RG] из [src]."))
					return TRUE
				to_chat(user, span_notice("[RG] полно."))
				return FALSE
*/
	if(user.a_intent == INTENT_HARM)
		if(W.sharpness)
			if(W.force >= 5)
				user.visible_message(span_notice("[user] cuts [src]."),span_notice("I cut [src]."), span_hear("I hear cutting."))
				user.changeNext_move(W.attack_delay)
				user.adjustFatigueLoss(5)
				sound_hint()
				W.damageItem("SOFT")
				deconstruct(FALSE)
/*
	else
		if(!special_objj)
			special_objj = W
			qdel(W)
*/
/*
/obj/structure/flora/ausbushes/cactus/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.a_intent == INTENT_GRAB)
		user.changeNext_move(CLICK_CD_MELEE)
		user.adjustFatigueLoss(5)
		sound_hint()
		new /obj/item/modular_computer/laptop/preset/civilian(get_turf(user))
		H.special_item = null
*/
/obj/structure/flora/ausbushes/cactus/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		chem_splash(loc, 3, list(reagents))
		playsound(loc,'modular_pod/sound/eff/hitcrazy.ogg', 30, TRUE)
	qdel(src)

/obj/structure/flora/ausbushes/cactus/CanAllowThrough(atom/movable/mover, border_dir)//So bullets will fly over and stuff.
	. = ..()
	if(locate(/obj/structure/flora/ausbushes/cactus) in get_turf(mover))
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

/obj/item/cactus_needle
	name = "Cactus Needle"
	desc = "Probably, I can... Inject someone?"
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "needle"
	inhand_icon_state = null
	worn_icon_state = null
	hitsound = list('modular_pod/sound/eff/weapon/stab_hit.ogg')
	w_class = WEIGHT_CLASS_SMALL
	wound_bonus = 1
	bare_wound_bonus = 3
	min_force = 1
	force = 6
	throwforce = 5
	sharpness = SHARP_POINTY
	embedding = list("pain_mult" = 6, "rip_time" = 1, "embed_chance" = 70, "jostle_chance" = 3.5, "pain_stam_pct" = 0.5, "pain_jostle_mult" = 6, "fall_chance" = 0.5, "ignore_throwspeed_threshold" = TRUE)
	skill_melee = SKILL_KNIFE
	carry_weight = 0.5 KILOGRAMS
	attack_fatigue_cost = 4
	attack_delay = 10
	parrying_flags = null
	parrying_modifier = null
	havedurability = TRUE
	durability = 10
	tetris_width = 16
	tetris_height = 32
	sellkaotiks = 10
	canlockpick = TRUE
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("stabs", "needles")
	attack_verb_simple = list("stab", "needle")

/obj/structure/flora/ausbushes/granat
	name = "Pomegranate"
	desc = "A wonderful fruit that has miraculously retained its benefits."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "granat"
//	plane = ABOVE_GAME_PLANE
//	layer = FLY_LAYER
	resistance_flags = FLAMMABLE
	density = FALSE
	anchored = TRUE
	opacity = FALSE
	var/granats = 3

/obj/structure/flora/ausbushes/granat/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!do_after(user, 2 SECONDS, target = src))
		to_chat(user, span_danger(xbox_rage_msg()))
		return
	user.visible_message(span_notice("[user] tears off a piece from [src]."),span_notice("I tear off a piece from [src]."), span_hear("I hear collecting."))
	playsound(loc,'modular_pod/sound/eff/tearthing.ogg', 30, TRUE)
	var/obj/item/granat = new /obj/item/food/grown/granat(loc)
	user.put_in_active_hand(granat)
	user.changeNext_move(5)
	granats--
	if(granats <= 0)
		qdel(src)

/obj/structure/flora/ausbushes/granat/attackby(obj/item/W, mob/living/carbon/user, params)
	return

/obj/structure/wiresa
	name = "Провода"
	desc = "ЛУЧШЕ не лезть."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "wires"
//	plane = GAME_PLANE
	layer = 1
	density = FALSE
	anchored = TRUE
	opacity = FALSE

/obj/structure/kaotikmachine
	name = "Kaotik Machine"
	desc = "BUY EQUIPMENT!"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "kaotik_machine"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = 1
	density = 1
	obj_flags = NONE
	light_range = 5
	light_power = 2
	light_color = "#8e0000"
	var/lockeda = FALSE

/obj/structure/kaotikmachine/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.client)
		return
	if(!lockeda)
		if(user.client?.prefs)
			var/thing = input(user, "What do I want?", "I want...") as null|anything in list("Melee", "Guns", "Armor", "Ammo", "Traps", "Tools", "Other")
			if(!thing)
				return
			playsound(get_turf(src), 'modular_pod/sound/eff/kaotika.ogg', 90 , FALSE, FALSE)
			if(thing == "Melee")
				melee_find(user)
			if(thing == "Guns")
				guns_find(user)
			if(thing == "Armor")
				armor_find(user)
			if(thing == "Ammo")
				ammo_find(user)
			if(thing == "Traps")
				traps_find(user)
			if(thing == "Tools")
				tools_find(user)
			if(thing == "Other")
				other_find(user)

/obj/structure/kaotikmachine/proc/melee_find(mob/living/carbon/human/user)
	var/list/meleelist = list("Sword (50)", "Spear (40)", "Buckler (40)", "Rebar (30)", "Flail (40)", "Knife (20)")
	var/thingy = input(user, "What kind of weapon I want?", "I want...") as null|anything in sort_list(meleelist)
	var/datum/preferences/pref_source = user.client?.prefs
	if(!thingy)
		return
	if(get_dist(src, user) >= 2)
		return
	if((!pref_source.bobux_amount) || (pref_source.bobux_amount <= 0))
		to_chat(user, span_meatymeat("Need kaotiks!"))
		return
	switch(thingy)
		if("Sword (50)")
			if(pref_source.bobux_amount < 50)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/podpol_weapon/sword/steel(get_turf(user))
			pref_source.bobux_amount -= 50
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Spear (40)")
			if(pref_source.bobux_amount < 40)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/podpol_weapon/spear/wooden(get_turf(user))
			pref_source.bobux_amount -= 40
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Buckler (40)")
			if(pref_source.bobux_amount < 40)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/melee/shieldo/buckler/wooden(get_turf(user))
			pref_source.bobux_amount -= 40
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Rebar (30)")
			if(pref_source.bobux_amount < 30)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/melee/bita/rebar(get_turf(user))
			pref_source.bobux_amount -= 30
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Flail (40)")
			if(pref_source.bobux_amount < 40)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/melee/bita/cep/iron(get_turf(user))
			pref_source.bobux_amount -= 40
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Knife (20)")
			if(pref_source.bobux_amount < 20)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/podpol_weapon/steelknife(get_turf(user))
			pref_source.bobux_amount -= 20
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		else
			return

/obj/structure/kaotikmachine/proc/guns_find(mob/living/carbon/user)
	var/list/gunslist = list()
	if(SSantagonists.gay_guns)
		gunslist = list("Bobox (20)", "Revolver Nova (10)", "Federson (40)", "SMG Bolsa (80)", "SMG Cesno Thump (90)")
	else
		gunslist = list("Bobox (70)", "Revolver Nova (60)", "Federson (130)"/*, "SMG Bolsa (120)", "SMG Cesno Thump (200)"*/)
	var/thingy = input(user, "What kind of gun do I want?", "I want...") as null|anything in sort_list(gunslist)
	var/datum/preferences/pref_source = user.client?.prefs
	if(!thingy)
		return
	if(get_dist(src, user) >= 2)
		return
	if((!pref_source.bobux_amount) || (pref_source.bobux_amount <= 0))
		to_chat(user, span_meatymeat("Need kaotiks!"))
		return
	if(GLOB.world_deaths_crazy < 20)
		to_chat(user, span_meatymeat("Not enough deaths in the world! Need 20."))
		return
	if(SSantagonists.gay_guns)
		switch(thingy)
			if("Bobox (20)")
				if(pref_source.bobux_amount < 20)
					to_chat(user, span_meatymeat("Need kaotiks!"))
					return
				new /obj/item/gun/ballistic/shotgun/doublebarrel/bobox(get_turf(user))
				pref_source.bobux_amount -= 20
				playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
				to_chat(user, span_meatymeat("Purchase done!"))
			if("Revolver Nova (10)")
				if(pref_source.bobux_amount < 10)
					to_chat(user, span_meatymeat("Need kaotiks!"))
					return
				new /obj/item/gun/ballistic/revolver/remis/nova(get_turf(user))
				pref_source.bobux_amount -= 10
				playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
				to_chat(user, span_meatymeat("Purchase done!"))
			if("Federson (40)")
				if(GLOB.phase_of_war != "Second")
					to_chat(user, span_meatymeat("We need Second War Phase!"))
					return
				if(pref_source.bobux_amount < 40)
					to_chat(user, span_meatymeat("Need kaotiks!"))
					return
				new /obj/item/gun/ballistic/rifle/boltaction/remis/federson(get_turf(user))
				pref_source.bobux_amount -= 40
				playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
				to_chat(user, span_meatymeat("Purchase done!"))
			if("SMG Bolsa (80)")
				if(GLOB.phase_of_war != "Third")
					to_chat(user, span_meatymeat("We need Third War Phase!"))
					return
				if(pref_source.bobux_amount < 80)
					to_chat(user, span_meatymeat("Need kaotiks!"))
					return
				new /obj/item/gun/ballistic/automatic/remis/smg/bolsa(get_turf(user))
				pref_source.bobux_amount -= 80
				playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
				to_chat(user, span_meatymeat("Purchase done!"))
			if("SMG Cesno Thump (90)")
				if(GLOB.phase_of_war != "Third")
					to_chat(user, span_meatymeat("We need Third War Phase!"))
					return
				if(pref_source.bobux_amount < 90)
					to_chat(user, span_meatymeat("Need kaotiks!"))
					return
				new /obj/item/gun/ballistic/automatic/remis/smg/thump(get_turf(user))
				pref_source.bobux_amount -= 90
				playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
				to_chat(user, span_meatymeat("Purchase done!"))
			else
				return
	else
		switch(thingy)
			if("Bobox (70)")
				if(pref_source.bobux_amount < 70)
					to_chat(user, span_meatymeat("Need kaotiks!"))
					return
				new /obj/item/gun/ballistic/shotgun/doublebarrel/bobox(get_turf(user))
				pref_source.bobux_amount -= 70
				playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
				to_chat(user, span_meatymeat("Purchase done!"))
			if("Revolver Nova (60)")
				if(pref_source.bobux_amount < 60)
					to_chat(user, span_meatymeat("Need kaotiks!"))
					return
				new /obj/item/gun/ballistic/revolver/remis/nova(get_turf(user))
				pref_source.bobux_amount -= 60
				playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
				to_chat(user, span_meatymeat("Purchase done!"))
			if("Federson (130)")
				if(GLOB.phase_of_war != "Third")
					to_chat(user, span_meatymeat("We need Third War Phase!"))
					return
				if(pref_source.bobux_amount < 130)
					to_chat(user, span_meatymeat("Need kaotiks!"))
					return
				new /obj/item/gun/ballistic/rifle/boltaction/remis/federson(get_turf(user))
				pref_source.bobux_amount -= 130
				playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
				to_chat(user, span_meatymeat("Purchase done!"))
			else
				return

/obj/structure/kaotikmachine/proc/armor_find(mob/living/carbon/user)
	var/list/otherlist = list("Light Bulletproofer (50)", "Chainmail (50)", "Gloves (30)", "Jackboots (30)", "Ballistic Mask (40)", "Powerarmor (1500)")
	var/thingy = input(user, "What kind of armor do I want?", "I want...") as null|anything in sort_list(otherlist)
	var/datum/preferences/pref_source = user.client?.prefs
	if(!thingy)
		return
	if(get_dist(src, user) >= 2)
		return
	if((!pref_source.bobux_amount) || (pref_source.bobux_amount <= 0))
		to_chat(user, span_meatymeat("Need kaotiks!"))
		return
	if(GLOB.world_deaths_crazy < 10)
		to_chat(user, span_meatymeat("Not enough deaths in the world! Need 10."))
		return
	switch(thingy)
		if("Light Bulletproofer (50)")
			if(pref_source.bobux_amount < 50)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/clothing/suit/armor/vest/bulletproofer(get_turf(user))
			pref_source.bobux_amount -= 50
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Chainmail (50)")
			if(pref_source.bobux_amount < 50)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/clothing/suit/armor/vest/chainmail/steel(get_turf(user))
			pref_source.bobux_amount -= 50
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Gloves (30)")
			if(pref_source.bobux_amount < 30)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/clothing/gloves/thickleather(get_turf(user))
			pref_source.bobux_amount -= 30
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Jackboots (30)")
			if(pref_source.bobux_amount < 30)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/clothing/shoes/jackboots(get_turf(user))
			pref_source.bobux_amount -= 30
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Ballistic Mask (40)")
			if(pref_source.bobux_amount < 40)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/clothing/mask/gas/ballisticarmor(get_turf(user))
			pref_source.bobux_amount -= 40
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Powerarmor (1500)")
			if(pref_source.bobux_amount < 1500)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			if(GLOB.phase_of_war != "Third")
				to_chat(user, span_meatymeat("We need Third War Phase!"))
				return
			new /obj/item/clothing/suit/armor/powerarmor(get_turf(user))
			pref_source.bobux_amount -= 1500
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		else
			return

/obj/structure/kaotikmachine/proc/ammo_find(mob/living/carbon/user)
	var/list/otherlist = list("Buckshot (30)", ".38 Bullets (20)", ".276 Bullets (40)", "9mm Magazine (30)", ".45 Magazine (30)")
	var/thingy = input(user, "What kind of ammo do I want?", "I want...") as null|anything in sort_list(otherlist)
	var/datum/preferences/pref_source = user.client?.prefs
	if(!thingy)
		return
	if(get_dist(src, user) >= 2)
		return
	if((!pref_source.bobux_amount) || (pref_source.bobux_amount <= 0))
		to_chat(user, span_meatymeat("Need kaotiks!"))
		return
/*
	if(GLOB.world_deaths_crazy < 15)
		to_chat(user, span_meatymeat("Недостаточно смертей в мире!"))
		return
*/
	switch(thingy)
		if("Buckshot (30)")
			if(pref_source.bobux_amount < 30)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/ammo_box/magazine/ammo_stack/shotgunbuckshot/loaded(get_turf(user))
			pref_source.bobux_amount -= 30
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if(".38 Bullets (20)")
			if(pref_source.bobux_amount < 20)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/ammo_box/magazine/ammo_stack/c38/loaded(get_turf(user))
			pref_source.bobux_amount -= 20
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if(".276 Bullets (40)")
			if(pref_source.bobux_amount < 40)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/ammo_box/magazine/ammo_stack/a276/loaded(get_turf(user))
			pref_source.bobux_amount -= 40
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("9mm Magazine (30)")
			if(pref_source.bobux_amount < 30)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/ammo_box/magazine/uzi9mm(get_turf(user))
			pref_source.bobux_amount -= 30
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if(".45 Magazine (30)")
			if(pref_source.bobux_amount < 30)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/ammo_box/magazine/thump45(get_turf(user))
			pref_source.bobux_amount -= 30
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		else
			return

/obj/structure/kaotikmachine/proc/traps_find(mob/living/carbon/user)
	var/list/otherlist = list("Barbed Wire Installer (40)", "Mine Installer (80)", "Pressure Mine Installer (70)")
	var/thingy = input(user, "What kind of trap do I want?", "I want...") as null|anything in sort_list(otherlist)
	var/datum/preferences/pref_source = user.client?.prefs
	if(!thingy)
		return
	if(get_dist(src, user) >= 2)
		return
	if((!pref_source.bobux_amount) || (pref_source.bobux_amount <= 0))
		to_chat(user, span_meatymeat("Need kaotiks!"))
		return
//	if(GLOB.world_deaths_crazy < 15)
//		to_chat(user, span_meatymeat("Недостаточно смертей в мире!"))
//		return
	switch(thingy)
		if("Barbed Wire Installer (40)")
			if(pref_source.bobux_amount < 40)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/barbsetup(get_turf(user))
			pref_source.bobux_amount -= 40
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Mine Installer (80)")
			if(pref_source.bobux_amount < 80)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/minesetup(get_turf(user))
			pref_source.bobux_amount -= 80
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Pressure Mine Installer (70)")
			if(pref_source.bobux_amount < 70)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/minesetuplita(get_turf(user))
			pref_source.bobux_amount -= 70
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		else
			return

/obj/structure/kaotikmachine/proc/tools_find(mob/living/carbon/user)
	var/list/otherlist = list("Pickaxe (50)", "Disarmer (30)", "Pomegranate Tea (30)")
	var/thingy = input(user, "What kind of tool do I want?", "I want...") as null|anything in sort_list(otherlist)
	var/datum/preferences/pref_source = user.client?.prefs
	if(!thingy)
		return
	if(get_dist(src, user) >= 2)
		return
	if((!pref_source.bobux_amount) || (pref_source.bobux_amount <= 0))
		to_chat(user, span_meatymeat("Need kaotiks!"))
		return
	switch(thingy)
		if("Disarmer (30)")
			if(pref_source.bobux_amount < 30)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/minedisarmer(get_turf(user))
			pref_source.bobux_amount -= 30
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Pickaxe (50)")
			if(pref_source.bobux_amount < 50)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/melee/hehe/pickaxe/iron(get_turf(user))
			pref_source.bobux_amount -= 50
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Pomegranate Tea (30)")
			if(pref_source.bobux_amount < 30)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/reagent_containers/food/drinks/bottle/thermos(get_turf(user))
			pref_source.bobux_amount -= 30
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		else
			return

/obj/structure/kaotikmachine/proc/other_find(mob/living/carbon/user)
	var/list/otherlist = list("Frag Grenade (40)", "Gas Grenade (40)", "Flare (10)", "Night Eyes (70)", "Shoulder Satchel (50)")
	var/thingy = input(user, "What kind of thing do I want?", "I want...") as null|anything in sort_list(otherlist)
	var/datum/preferences/pref_source = user.client?.prefs
	if(!thingy)
		return
	if(get_dist(src, user) >= 2)
		return
	if((!pref_source.bobux_amount) || (pref_source.bobux_amount <= 0))
		to_chat(user, span_meatymeat("Need kaotiks!"))
		return
	if(GLOB.world_deaths_crazy < 10)
		to_chat(user, span_meatymeat("Not enough deaths in the world! Need 10."))
		return
	switch(thingy)
		if("Frag Grenade (40)")
			if(pref_source.bobux_amount < 40)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/grenade/frag(get_turf(user))
			pref_source.bobux_amount -= 40
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Gas Grenade (40)")
			if(pref_source.bobux_amount < 40)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/grenade/gas/incredible_gas(get_turf(user))
			pref_source.bobux_amount -= 40
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Flare (10)")
			if(pref_source.bobux_amount < 10)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/flashlight/flare(get_turf(user))
			pref_source.bobux_amount -= 10
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Night Eyes (70)")
			if(pref_source.bobux_amount < 70)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/clothing/glasses/night(get_turf(user))
			pref_source.bobux_amount -= 70
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		if("Shoulder Satchel (50)")
			if(pref_source.bobux_amount < 50)
				to_chat(user, span_meatymeat("Need kaotiks!"))
				return
			new /obj/item/storage/belt/military/itobe(get_turf(user))
			pref_source.bobux_amount -= 50
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase done!"))
		else
			return

/obj/structure/torgovka
	name = "Trader"
	desc = "Sell ​​into me."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "torgovka"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = 1
	density = 1
	obj_flags = NONE

/obj/structure/torgovka/attackby(obj/item/W, mob/living/carbon/user, params)
	if(W.sellkaotiks > 0)
//		var/datum/preferences/pref_source = user.client?.prefs
//		pref_source.bobux_amount += W.sellkaotiks
		var/zombiekao = W.sellkaotiks
		user.client?.prefs?.adjust_bobux(zombiekao, "<span class='bobux'>I sold [W]! +[zombiekao] Kaotiks!</span>")
//		to_chat(GR, span_meatymeat("I'm selling [W]!"))
		sound_hint()
		playsound(src, 'modular_pod/sound/eff/torgovka.ogg', 70, FALSE)
		qdel(W)
	else
		to_chat(user, span_meatymeat("I can't sell this!"))
		user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return





/obj/structure/transfer_machine
	name = "Transfer Machine"
	desc = "Kaotiks to evil jewels! Evil jewels to kaotiks!"
	icon = 'modular_pod/icons/obj/things/things_2.dmi'
	icon_state = "transferMachine"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = 1
	density = 1
	obj_flags = NONE
	light_range = 5
	light_power = 2
	light_color = "#bf00ac"
	var/lockeda = FALSE
	var/proj_pass_rate = 100

/obj/structure/transfer_machine/CanAllowThrough(atom/movable/mover, border_dir)//So bullets will fly over and stuff.
	. = ..()
	if(locate(/obj/structure/transfer_machine) in get_turf(mover))
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

/obj/structure/transfer_machine/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.client)
		return
	if(get_dist(src, user) >= 2)
		return
	if(user.client?.prefs)
		var/thing = input(user, "What do I want?", "I want...") as null|anything in list("Get jewels")
		if(!thing)
			return
		playsound(get_turf(src), 'modular_pod/sound/eff/kaotika.ogg', 90 , FALSE, FALSE)
		if(thing == "Get jewels")
			get_jewels(user)


/obj/structure/transfer_machine/attackby(obj/item/I, mob/living/carbon/user, params)
	. = ..()
	if(istype(I, /obj/item/stack/eviljewel))
		var/obj/item/stack/eviljewel/M = I
		user.visible_message(span_meatymeat("[user] inserts [M] in [src]."),span_meatymeat("I insert [M] in [src]."), span_hear("You hear the sound of inserting."))
		sound_hint()
		playsound(get_turf(src), 'modular_pod/sound/eff/thingg.ogg', 100 , FALSE, FALSE)
		user.client?.prefs?.adjust_bobux(M.amount, "<span class='bobux'>I insert [M]. +[M.amount] Kaotiks!</span>")
		user.flash_kaosgain()
		qdel(M)

/obj/structure/transfer_machine/proc/get_jewels(mob/living/carbon/human/user)
	var/datum/preferences/pref_source = user.client?.prefs
	if(get_dist(src, user) >= 2)
		return
	if((!pref_source.bobux_amount) || (pref_source.bobux_amount <= 0))
		to_chat(user, span_meatymeat("Need kaotiks!"))
		return
	var/thing = input(user, "How much evil jewels do I need?", "I need...") as num|null
	if(!thing)
		return
	if(thing > pref_source.bobux_amount)
		to_chat(user, span_meatymeat("I don't have that much kaotiks!"))
		return
	if(thing > 32)
		to_chat(user, span_meatymeat("Maximum to pick is 32!"))
		return
	if(get_dist(src, user) >= 2)
		return
	pref_source.bobux_amount -= thing
	new /obj/item/stack/eviljewel(get_turf(user), thing)
	playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 100 , FALSE, FALSE)

/obj/structure/kaos/blackwindow
	name = "Black Glass"
	desc = "?"
	icon = 'modular_pod/icons/turf/floors_4.dmi'
	icon_state = "blackwindow"
//	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	obj_flags = NONE
	anchored = TRUE
	density = FALSE
	var/static/list/available_roles = list(
		"Battle Brother"
	)
//	var/lightchoose

/obj/structure/kaos/blackwindow/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/kaos/blackwindow/proc/on_entered(datum/source, atom/movable/AM)
	if(!isobserver(AM))
		return
	var/mob/dead/observer/L = AM
	attack_ghost(L)

/obj/structure/kaos/blackwindow/attack_ghost(mob/dead/observer/user)
	. = ..()
	if(.)
		return
	if(user.still_choose)
		return
	if(!user.client)
		return
	user.forceMove(src)
	var/crazyalert = alert(user, "Do I want to make myself, or am I random?",,"Make myself!","Random!","Cancel")
	switch(crazyalert)
		if("Make myself!")
			user.client.ready_char = TRUE
			name_make(user)

		if("Random!")
			user.client.name_ch = name_generate()
			if(prob(70))
				user.client.age_ch = rand(18, 40)
			else
				user.client.age_ch = rand(14, 100)
			user.client.ready_char = TRUE
			chooseRole(user)

		if("Cancel")
			return

/obj/structure/kaos/blackwindow/proc/name_make(mob/dead/observer/user)
	var/nama = input(user, "What name?", "") as text
	if(!nama)
		alert(user, "Give name...")
		user.client.ready_char = FALSE
		return
	nama = reject_bad_name(nama)
	if(nama)
		user.client.name_ch = nama
		old_make(user)
	else
		alert(user, "Give normal name...")
		user.client.ready_char = FALSE
		return

/obj/structure/kaos/blackwindow/proc/old_make(mob/dead/observer/user)
	var/namaa = input(user, "How old?", "") as num
	if(namaa < 14 || namaa > 100)
		alert(user, "Give normal age...")
		user.client.ready_char = FALSE
		return
	user.client.age_ch = namaa
	hair_make(user)

/obj/structure/kaos/blackwindow/proc/hair_make(mob/dead/observer/user)
	var/namaa = input(user, "What hair?", "") as anything in list("Bedhead 2", "Bald")
	beard_make(user, hair_type = namaa)

/obj/structure/kaos/blackwindow/proc/beard_make(mob/dead/observer/user, hair_type)
	var/namkaa = input(user, "What beard?", "") as anything in list("Shaved", "Beard (Very Long)")
	chooseRole(user, hair_type, beard_type = namkaa)

/obj/structure/kaos/blackwindow/proc/name_generate()
	var/special_name
	var/first_thing = pick("Jack", "Ivan", "Dontero", "John")
	special_name = "[first_thing]"
	return special_name


/obj/structure/kaos/blackwindow/proc/chooseRole(mob/dead/observer/user, hair_type, beard_type)
	if(!user.client)
		return
	if(!SSmapping.config?.war_gamemode)
		var/rolevich = input(user, "What role?", "") as null|anything in available_roles
		if(!rolevich)
			alert("Need to choose your role.")
			user.client.ready_char = FALSE
			return

		switch(rolevich)
			if("Battle Brother")
				user.client.role_ch = "Battle Brother"
			else
				alert("Unclear. The role of the common Battle Brother.")
				user.client.role_ch = "Battle Brother"
	else
		var/rolevich = input("Wait, what role?", "") as null|anything in available_roles
		switch(rolevich)
			if("Ladax")
				var/numba = GLOB.kapnoe - GLOB.aashol
				if(numba >= 1)
					alert("Too much of them. Play as Kador.")
					user.client.ready_char = FALSE
					return
				user.client.role_ch = "ladax"
			if("Kador")
				var/numbar = GLOB.aashol - GLOB.kapnoe
				if(numbar >= 1)
					alert("Too much of them. Play as Ladax.")
					user.client.ready_char = FALSE
					return
				user.client.role_ch = "kador"
			else
				var/numba = GLOB.kapnoe - GLOB.aashol
				var/numbor = GLOB.aashol - GLOB.kapnoe
				if(numba <= 1)
					alert("Unclear. The role of the common Ladax.")
					user.client.role_ch = "ladax"
				else
					if(numbor <= 1)
						alert("Unclear. The role of the common Kador.")
						user.client.role_ch = "kador"
	dolboEbism(user, hair_type, beard_type)


/obj/structure/kaos/blackwindow/proc/dolboEbism(mob/dead/observer/user, hair_type, beard_type)
	var/crazyalert = alert(user, "Or maybe there was another role?",,"Let's continue!","Yes, it seems like a different role...")
	switch(crazyalert)
		if("Let's continue!")
			for(var/obj/effect/landing/spawn_point as anything in GLOB.jobber_list)
				if(user.client)
					if(spawn_point.name == user.client.role_ch)
						if(spawn_point.spending > 0)
							var/list/spawn_locs = list()
							if(isturf(spawn_point.loc))
								spawn_locs += spawn_point.loc
							if(!spawn_locs)
								alert(user, "In fact, something bad is happening there...")
								user.client.ready_char = FALSE
								return FALSE
							GLOB.new_people_crazy += 1
							user.client.ready_char = FALSE
							switch(user.client.role_ch)
								if("cockroach")
									spawn_point.spending--
									var/mob/living/carbon/human/species/cockroach/character = new((pick(spawn_locs)))
									important(character, user.client)
									things(character, user.client, hair_type, beard_type)
									things_two(character, user.client, user)
								if("pighuman")
									if(prob(10))
										user.special_zvanie = "Boar"
										spawn_point.spending--
										var/mob/living/carbon/human/species/boarhuman/character = new((pick(spawn_locs)))
										important(character, user.client)
										things(character, user.client, hair_type, beard_type)
										things_two(character, user.client, user)
									else
										spawn_point.spending--
										var/mob/living/carbon/human/species/pighuman/character = new((pick(spawn_locs)))
										important(character, user.client)
										things(character, user.client, hair_type, beard_type)
										things_two(character, user.client, user)
								else
									spawn_point.spending--
									var/mob/living/carbon/human/character = new((pick(spawn_locs)))
									important(character, user.client)
									things(character, user.client, hair_type, beard_type)
									things_two(character, user.client, user)
						else
							alert(user, "No more slots.")
							user.client.ready_char = FALSE
							return FALSE
		if("Yes, it seems like a different role...")
			user.client.ready_char = FALSE
			return FALSE


/obj/structure/kaos/blackwindow/proc/important(mob/living/carbon/human/our, client/john)
	our.gender = pick(MALE, FEMALE)

	if(our.gender == MALE)
		our.body_type = MALE
		our.genitals = GENITALS_MALE
	else if(our.gender == FEMALE)
		our.body_type = FEMALE
		our.genitals = GENITALS_FEMALE
	else
		our.body_type = MALE
		our.genitals = pick(GENITALS_DICKGIRL, GENITALS_CUNTBOY, GENITALS_FUTA)

	our.underwear = "Nude"
	our.undershirt = "Nude"

	// Create the actual genital organs
	give_genital_organs(our)

//	our.way_type = pick("Unprocess", "Process")
	our.chat_color = ""
//	if(our.way_type == "Process")
//		our.real_name = "卐 [john.name_ch]"
//	else
//		our.real_name = "卍 [john.name_ch]"
	our.name = our.real_name

	our.age = john.age_ch
	var/crazyagelook
	if(prob(50))
		crazyagelook = our.age - rand(0, 4)
	else
		crazyagelook = our.age + rand(0, 4)
	our.looks_age = crazyagelook
	var/hander = pick(RIGHT_HANDED, LEFT_HANDED, AMBIDEXTROUS)
	our.handed_flags = hander

/obj/structure/kaos/blackwindow/proc/give_genital_organs(mob/living/carbon/human/H)
	// First, remove any existing genital organs
	for(var/obj/item/organ/genital/genital in H.internal_organs)
		qdel(genital)

	// Set up basic DNA features for genitals
	H.dna.features["breasts_size"] = rand(1, 7)
	H.dna.features["breasts_lactation"] = BREASTS_DEFAULT_LACTATION
	H.dna.features["penis_size"] = rand(1, 23)
	H.dna.features["penis_girth"] = PENIS_DEFAULT_GIRTH
	H.dna.features["penis_sheath"] = SHEATH_NONE
	H.dna.features["penis_circumcised"] = FALSE
	H.dna.features["balls_size"] = rand(1, 3)

	// Get the genital set based on assigned gender
	var/genitals_set = H.genitals

	// Create the needed genital organs
	for(var/genital_slot in GLOB.genital_sets[genitals_set])
		// Find the appropriate genital type for this slot
		var/obj/item/genital_type
		switch(genital_slot)
			if(ORGAN_SLOT_PENIS)
				genital_type = /obj/item/organ/genital/penis
			if(ORGAN_SLOT_TESTICLES)
				genital_type = /obj/item/organ/genital/testicles
			if(ORGAN_SLOT_VAGINA)
				genital_type = /obj/item/organ/genital/vagina
			if(ORGAN_SLOT_WOMB)
				genital_type = /obj/item/organ/genital/womb
			if(ORGAN_SLOT_BREASTS)
				genital_type = /obj/item/organ/genital/breasts
			if(ORGAN_SLOT_ANUS)
				genital_type = /obj/item/organ/genital/anus

		if(genital_type)
			// Create and insert the organ
			var/obj/item/organ/genital/new_genital = new genital_type()
			new_genital.Insert(H, FALSE, FALSE)

			// Update its appearance from DNA
			if(new_genital.mutantpart_key)
				H.dna.mutant_bodyparts[new_genital.mutantpart_key] = list(
					MUTANT_INDEX_NAME = new_genital.genital_name,
					MUTANT_INDEX_COLOR = list("#FFFFFF", "#FFFFFF", "#FFFFFF")
				)
				new_genital.build_from_dna(H.dna, new_genital.mutantpart_key)
				new_genital.update_icon_state()

	// Update the body
	H.update_body()

/obj/structure/kaos/blackwindow/proc/things(mob/living/carbon/human/our, client/john, hair_type, beard_type)
	if(our.age < 18)
		ADD_TRAIT(our, TRAIT_CHILDO, "special_childo")
	if(("Baby Dream" in SSantagonists.johny_event) && (!HAS_TRAIT(our, TRAIT_CHILDO)))
		our.age = rand(14, 17)
		var/crazyagelook
		if(prob(50))
			crazyagelook = our.age - rand(0, 4)
		else
			crazyagelook = our.age + rand(0, 4)
		our.looks_age = crazyagelook
		ADD_TRAIT(our, TRAIT_CHILDO, "special_childo")
//	if(!SSmapping.config?.war_gamemode)
//		if(prob(10))
//			ADD_TRAIT(our, TRAIT_DMT, "special_dmt")
	if(HAS_TRAIT(our, TRAIT_CHILDO))
		our.height = HUMAN_HEIGHT_SHORTEST
//		our.width = HUMAN_WIDTH_THIN
	else
		var/height_choose = pick(HUMAN_HEIGHT_SHORTEST, HUMAN_HEIGHT_SHORT, HUMAN_HEIGHT_MEDIUM, HUMAN_HEIGHT_TALL, HUMAN_HEIGHT_TALLEST)
		our.height = height_choose
//		our.width = pick(HUMAN_WIDTH_THIN, HUMAN_WIDTH_SLIGHTLY_THIN, HUMAN_WIDTH_AVERAGE, HUMAN_WIDTH_SLIGHTLY_WIDE, HUMAN_WIDTH_WIDE)
	switch(john.role_ch)
		if("venturer")
			our.truerole = "Venturer"
			our.pod_faction = "Forest"
			our.hairstyle = "Bedhead 2"
			our.facial_hairstyle = "Shaved"
			our.hair_color = pick("#000000", "#1f120f", "#d7d49f")
		if("villager")
			our.truerole = "Villager"
			our.pod_faction = "Village"
			our.hairstyle = "Bedhead 2"
			our.facial_hairstyle = "Shaved"
			our.hair_color = pick("#000000", "#1f120f", "#d7d49f")
		if("Battle Brother")
			our.truerole = "Battle Brother"
			our.pod_faction = "Seekers"
			our.hairstyle = pick("Bedhead 2", "Bald")
			our.facial_hairstyle = pick("Shaved", "Beard (Very Long)")
			our.hair_color = pick("#000000", "#1f120f", "#d7d49f")
			our.facial_hair_color = our.hair_color
		if("guard")
			our.truerole = "Guard"
			our.pod_faction = "Village"
			our.hairstyle = "Bald"
			our.facial_hairstyle = "Shaved"
//			our.hair_color = pick("#000000", "#1f120f", "#d7d49f")
		if("cockroach")
			our.truerole = "Cockroach"
			our.pod_faction = "Evil"
			our.facial_hairstyle = "Shaved"
			our.kaotiks_body = 10
		if("pighuman")
			our.pod_faction = "Slaving"
			our.truerole = "Pighuman"
			our.hairstyle = "Bald"
			our.facial_hairstyle = "Shaved"
			our.kaotiks_body = 10
		if("jailed")
			our.pod_faction = "Slaving"
			our.truerole = "Jailed"
			our.hairstyle = "Bald"
			our.facial_hairstyle = "Shaved"
		if("black witcher")
			our.pod_faction = "Forest"
			our.truerole = "Black Witcher"
			our.hairstyle = "Bald"
			our.facial_hairstyle = "Shaved"
		if("ladax")
			our.truerole = "Ladax"
			our.pod_faction = "ladax"
			our.hairstyle = "Bedhead 2"
			our.facial_hairstyle = "Shaved"
			our.hair_color = pick("#000000", "#1f120f", "#d7d49f")
			our.facial_hair_color = our.hair_color
			GLOB.kapnoe += 1
		if("kador")
			our.truerole = "Kador"
			our.pod_faction = "kador"
			our.hairstyle = "Bald"
			our.facial_hairstyle = "Shaved"
			GLOB.aashol += 1
	if(hair_type)
		our.hairstyle = hair_type
	if(beard_type)
		our.facial_hairstyle = beard_type
	switch(our.truerole)
		if("Venturer")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/venturer)
			if("Narco" in SSantagonists.johny_event)
				our.equipOutfit(/datum/outfit/ventura/drug)
			else
				our.equipOutfit(/datum/outfit/ventura)
		if("Villager")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/venturer)
			our.equipOutfit(/datum/outfit/villagar)
		if("Battle Brother")
//			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/lifedrinker)
			our.equipOutfit(/datum/outfit/lifedrinker)
		if("Guard")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/venturergoer)
			our.equipOutfit(/datum/outfit/sentinel)
		if("Jailed")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/prisoner)
		if("Black Witcher")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blackwitcher)
			our.equipOutfit(/datum/outfit/witcher)
		if("Cockroach")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/prisoner)
		if("Pighuman")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/konch)
			our.equipOutfit(/datum/outfit/pigger)
		if("Ladax")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/kapno)
			if(prob(10))
				our.equipOutfit(/datum/outfit/kapnofather)
				our.special_zvanie = "Ladax Father"
			else
				switch(GLOB.phase_of_war)
					if("First")
						our.equipOutfit(/datum/outfit/kapno)
					if("Second")
						if(prob(20))
							our.equipOutfit(/datum/outfit/kapnosec)
						else
							our.equipOutfit(/datum/outfit/kapno)
					if("Third")
						if(prob(20))
							our.equipOutfit(/datum/outfit/kapnosec)
						else
							our.equipOutfit(/datum/outfit/kapno)
		if("Kador")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/konch)
			if(prob(10))
				our.equipOutfit(/datum/outfit/mostkonch)
				our.special_zvanie = "Worst Kador"
			else
				switch(GLOB.phase_of_war)
					if("First")
						our.equipOutfit(/datum/outfit/konch)
					if("Second")
						if(prob(20))
							our.equipOutfit(/datum/outfit/konchsec)
						else
							our.equipOutfit(/datum/outfit/konch)
					if("Third")
						if(prob(20))
							our.equipOutfit(/datum/outfit/konchsec)
						else
							our.equipOutfit(/datum/outfit/konch)

/obj/structure/kaos/blackwindow/proc/things_two(mob/living/carbon/human/our, client/john, mob/dead/observer/user)
	var/eye_coloring = pick("#000000", "#1f120f","#c30000","#00ffff","#156d0a","#ff00b3")
	switch(john.role_ch)
		if("Pighuman")
			eye_coloring = pick("#000000","#c30000")
	for(var/obj/item/organ/eyes/organ_eyes in our.internal_organs)
		if(organ_eyes.current_zone == BODY_ZONE_PRECISE_L_EYE)
			our.left_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			our.dna.update_ui_block(DNA_LEFT_EYE_COLOR_BLOCK)
		else
			our.right_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			our.dna.update_ui_block(DNA_RIGHT_EYE_COLOR_BLOCK)

	// Check if the human has genital organs, if not create them
	var/has_genitals = FALSE
	for(var/obj/item/organ/genital/organ in our.internal_organs)
		has_genitals = TRUE
		break

	if(!has_genitals)
		// If no genitals were found, we'll need to create them
		// Re-assign genitals based on gender if it wasn't set properly
		if(!our.genitals)
			if(our.gender == MALE)
				our.genitals = GENITALS_MALE
			else if(our.gender == FEMALE)
				our.genitals = GENITALS_FEMALE
			else
				our.genitals = pick(GENITALS_DICKGIRL, GENITALS_CUNTBOY, GENITALS_FUTA)

		// Now create the organs
		give_genital_organs(our)

	user.still_choose = TRUE
//	to_chat(user, span_dead("I reflect myself in all possible colors thanks to the black glass, in all possible directions, giving birth to Maya and hoping that some time I will wake up from this dream. Now I'm playing."))
	hello_special_trait(our)

	our.key = user.key
	if(check_rights_for(our.client, R_ADMIN))
		our.client.verbs += /client/proc/debug_variables
	updateshit(our, user)

/obj/structure/kaos/blackwindow/proc/updateshit(mob/living/carbon/human/our, mob/dead/observer/user)
	user.still_choose = FALSE
	qdel(user)
	our << output(null,"output")

	var/datum/component/babble/babble = our.GetComponent(/datum/component/babble)
	if(!babble)
		switch(our.truerole)
			if("Venturer" || "Villager" || "Guard" || "Jailed" || "Black Witcher" || "Battle Brother")
				if(our.age >= 18)
					if(our.gender != FEMALE)
						our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_male.ogg')
					else
						our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_female.ogg')
				else
					our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/plimpus.ogg')
			if("Cockroach")
				our.AddComponent(/datum/component/babble, 'modular_pod/sound/voice/cockroach/cock_hu3.ogg')
				our.remove_language(/datum/language/common, TRUE, TRUE, LANGUAGE_HALBER)
				our.grant_language(/datum/language/aphasia, TRUE, TRUE, LANGUAGE_HALBER)
				our.language_holder.selected_language = /datum/language/aphasia
			if("Pighuman")
				our.AddComponent(/datum/component/babble, 'modular_pod/sound/eff/pigtalk.ogg')
				our.remove_language(/datum/language/common, TRUE, TRUE, LANGUAGE_HALBER)
				our.grant_language(/datum/language/yoinky, TRUE, TRUE, LANGUAGE_HALBER)
				our.language_holder.selected_language = /datum/language/yoinky
			if("Ladax")
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/plimpus.ogg')
			if("Kador")
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_male.ogg')
			else
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/gakster.ogg')
	else
		switch(our.truerole)
			if("Venturer" || "Villager" || "Guard" || "Jailed" || "Black Witcher" || "Battle Brother")
				if(our.age >= 18)
					if(our.gender != FEMALE)
						babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_male.ogg'
					else
						babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_female.ogg'
				else
					babble.babble_sound_override = 'modular_septic/sound/voice/babble/plimpus.ogg'
			if("Cockroach")
				babble.babble_sound_override = 'modular_pod/sound/voice/cockroach/cock_hu3.ogg'
				our.remove_language(/datum/language/common, TRUE, TRUE, LANGUAGE_HALBER)
				our.grant_language(/datum/language/aphasia, TRUE, TRUE, LANGUAGE_HALBER)
				our.language_holder.selected_language = /datum/language/aphasia
			if("Pighuman")
				babble.babble_sound_override = 'modular_pod/sound/eff/pigtalk.ogg'
				our.remove_language(/datum/language/common, TRUE, TRUE, LANGUAGE_HALBER)
				our.grant_language(/datum/language/yoinky, TRUE, TRUE, LANGUAGE_HALBER)
				our.language_holder.selected_language = /datum/language/yoinky
			if("Ladax")
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/plimpus.ogg'
			if("Kador")
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_male.ogg'
			else
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/gakster.ogg'
		babble.volume = BABBLE_DEFAULT_VOLUME
		babble.duration = BABBLE_DEFAULT_DURATION

	our.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	var/area/joined_area = get_area(our.loc)
	if(joined_area)
		joined_area.on_joining_game(our)
//	for(var/obj/item/organ/genital/genital in our.internal_organs)
//		genital.build_from_dna(our.dna, genital.mutantpart_key)
		// Make sure the icon state is properly set for each genital
//		genital.update_icon_state()
	for(var/obj/item/organ/plushp in our.internal_organs)
		plushp.maxHealth += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
	for(var/obj/item/bodypart/plusbodyhp as anything in our.bodyparts)
		plusbodyhp.max_damage += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
		plusbodyhp.max_stamina_damage += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
	our.gain_extra_effort(1, TRUE)
	switch(our.truerole)
		if("Ladax")
			to_chat(our, span_dead("On a physical level I feel like I want to kill the Kadors."))
			our.playsound_local(our, 'modular_pod/sound/eff/ladax.ogg', 90, FALSE)
		if("Kador")
			to_chat(our, span_dead("On a physical level I feel like I want to kill the Ladaxes."))
			our.playsound_local(our, 'modular_pod/sound/eff/kador.ogg', 60, FALSE)
		else
			if (HAS_TRAIT(our, TRAIT_DMT))
				to_chat(our, span_dead("I am a dream terrorist. I must go to any tree and pull out a laptop from there, with which I can get tools and cause a nuclear explosion. I must blow up this dream, turning it into a singular horror."))
			our.playsound_local(our, 'modular_pod/sound/eff/podpol_hello.ogg', 90, FALSE)
	our.cursings()
	if(our.special_zvanie)
		switch(our.special_zvanie)
			if("Ladax Father")
				to_chat(our, span_yellowteamradio("I'm Ladax Father!"))
			if("Worst Kador")
				to_chat(our, span_yellowteamradio("I'm Worst Kador!"))
			if("Boar")
				to_chat(our, span_redteamradio("I'm BOARhuman!"))

	our.dna.features["body_size"] = BODY_SIZE_NORMAL
	our.dna.update_body_size()
	our.dna.update_dna_identity()
	our.attributes?.update_attributes()
	our.regenerate_icons()
	our.fully_heal(TRUE)
//	var/obj/item/cardydocs/crazy = new(get_turf(src))
//	our.put_in_hands(crazy)
//	var/height_str = capitalize_like_old_man(our.height)
//	var/handa = unparse_handedness(our.handed_flags)
//	crazy.info_about_me = "Name: [our.real_name]\n"
//	crazy.info_about_me += "Date of Birth: [our.age] years ago\n"
//	crazy.info_about_me += "Sex: [our.gender]\n"
//	crazy.info_about_me += "Height: [height_str]\n"
//	crazy.info_about_me += "Dominant Hand: [handa]\n"

//	our.can_fly = TRUE

/obj/structure/kaos/blackwindow/proc/hello_special_trait(mob/living/carbon/human/our)
	var/my_trait = pick(TRAIT_DEPRESSION, TRAIT_PAINLOVER, TRAIT_HYPERSENT, TRAIT_MISANTHROPE)
	ADD_TRAIT(our, my_trait, "special_trait")


/datum/outfit/lifedrinker
	name = "Lifedrinker Uniform"
	suit = /obj/item/clothing/suit/armor/vest/chainmail/hauberk
	pants = /obj/item/clothing/pants/steelmailpants/based
	neck = /obj/item/clothing/neck/coif
	r_hand = /obj/item/podpol_weapon/sword/horsecutter

/datum/outfit/villagar
	name = "Villager Uniform"
	uniform = /obj/item/clothing/under/grayka
	pants = /obj/item/clothing/pants/codec/graya
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/simcard
	r_pocket = /obj/item/key/podpol/woody/villagerkey
	id = /obj/item/cellphone

/datum/outfit/villagargar
	name = "Villagerer Uniform"
	uniform = /obj/item/clothing/under/grayka
	pants = /obj/item/clothing/pants/codec/graya
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/simcard
	r_pocket = /obj/item/key/podpol/woody/villagerkey
	r_hand = /obj/item/melee/bita/rebar
	id = /obj/item/cellphone

/datum/outfit/sentinel
	name = "Sentinel Uniform"
	uniform = /obj/item/clothing/under/grayka
	suit = /obj/item/clothing/suit/armor/vest/shell/steel
	head = /obj/item/clothing/head/helmet/steel
	gloves = /obj/item/clothing/gloves/steel
	pants = /obj/item/clothing/pants/armored/steel
	shoes = /obj/item/clothing/shoes/steel
	l_pocket = /obj/item/simcard
	r_pocket = /obj/item/storage/belt/keychain/guarder
	id = /obj/item/cellphone

/datum/outfit/witcher
	name = "Witcher Uniform"
	back = /obj/item/podpol_weapon/sword/iron/big
	uniform = /obj/item/clothing/under/codec/maika/blacka
	suit = /obj/item/clothing/suit/armor/vest/draggon
	pants = /obj/item/clothing/pants/codec/blacka
	shoes = /obj/item/clothing/shoes/jackers
	l_pocket = /obj/item/simcard
	r_pocket = /obj/item/key/podpol/woody/witcherkey
	id = /obj/item/cellphone

/datum/outfit/pigger
	name = "Pigger Uniform"
	pants = /obj/item/clothing/pants/codec/graya
	l_pocket = /obj/item/simcard
	r_pocket = /obj/item/key/podpol/steel
	id = /obj/item/cellphone

/*
/obj/structure/kaos/blackwindow/Initialize(mapload)
	. = ..()
	lightchoose = rand(1, 2)
	switch(lightchoose)
		if(1)
			set_light(8, 4, "#b90000")
		if(2)
			set_light(8, 4, "#b900b9")
//		if(3)
//			set_light(4, 3, "#b90000")
*/
/obj/structure/blockrole
	name = "Oh"
	desc = "Can't go any further."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "turboa"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = 1
	obj_flags = NONE
	var/allow_role = null

/obj/structure/blockrole/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(ishuman(mover))
		var/mob/living/carbon/human/H = mover
		if(H.truerole == allow_role)
			if(do_after(H, 1 SECONDS, target=src))
				return TRUE
	return FALSE

/obj/structure/blockrole/konch
	allow_role = "Kador"

/obj/structure/sign/poster/contraband/codec/lians
	name = "Karza"
	desc = "How many lives saved..."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "wallight"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/lightchoose

/obj/structure/sign/poster/contraband/codec/lians/Initialize(mapload)
	. = ..()
	lightchoose = rand(1, 3)
	switch(lightchoose)
		if(1)
			set_light(4, 2, "#0017ff")
		if(2)
			set_light(4, 2, "#008dff")
		if(3)
			set_light(4, 2, "#3c00ff")

/obj/structure/sign/poster/contraband/codec/balbosh
	name = "Balbosh"
	desc = "Suppuration mixed with saliva..."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "balbosh"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = GAME_PLANE_BLOOM
	var/lightchoose

/obj/structure/sign/poster/contraband/codec/balbosh/Initialize(mapload)
	. = ..()
	lightchoose = rand(1, 3)
	switch(lightchoose)
		if(1)
			set_light(2, 2, "#a3a3a3")
		if(2)
			set_light(2, 2, "#ffffff")
		if(3)
			set_light(2, 2, "#cfcfcf")

/obj/structure/sign/poster/contraband/codec/purpella
	name = "Purplea"
	desc = "Coating."
	icon = 'modular_pod/icons/turf/closed/cavera.dmi'
	icon_state = "purpela"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/lightchoose

/obj/structure/sign/poster/contraband/codec/purpella/Initialize(mapload)
	. = ..()
	lightchoose = rand(1, 4)
	switch(lightchoose)
		if(1)
			set_light(2, 2, "#d1a5a0")
		if(2)
			set_light(3, 2, "#c680c8")
		if(3)
			set_light(4, 2, "#a180ed")
		if(4)
			set_light(1, 3, "#894ab6")

/obj/structure/medica
	name = "Medika"
	desc = "All it takes for Medika to cure me is..."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "medica"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = 1
	density = 0
	obj_flags = NONE
	light_range = 3
	light_power = 2
	light_color = "#75a743"
	verb_say = "cutes"
	verb_ask = "cutes"
	verb_exclaim = "cutes"
	var/datum/looping_sound/medika/soundloop
	var/words_list = list("I will heal you, and your soul!", "You are my only one!", "I'm always here, just come to me.", "I will never betray you.", "I've been waiting for you...")

/obj/structure/medica/proc/speak(message)
	if(!message)
		return
	say(message)

/obj/structure/medica/Initialize(mapload)
	. = ..()
	soundloop = new(src, FALSE)
	soundloop.start()

/obj/structure/medica/Destroy()
	. = ..()
	QDEL_NULL(soundloop)

/obj/structure/medica/attack_jaw(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(do_after(user, 4 SECONDS, target=src))
		user.visible_message(span_notice("[user] does something with [src]."),span_notice("I do something with [src]."), span_hear("I hear strange things."))
		user.changeNext_move(CLICK_CD_MELEE)
		user.adjustFatigueLoss(10)
		sound_hint()
		playsound(src, 'modular_pod/sound/eff/anime-wow-1.ogg', 55, FALSE)

/obj/structure/medica/attackby(obj/item/W, mob/living/carbon/user, params)
	if(istype(W, /obj/item/grab))
		var/mob/living/GR = user.pulling
		if(GR == null)
			return
		if(user.stat != DEAD)
			if(do_after(user, 3 SECONDS, target=src))
				to_chat(GR, span_meatymeat("I feel some kind of fucked up!"))
				GR.fully_heal(TRUE, FALSE)
				var/words = pick(words_list)
				speak(words)
				sound_hint()
				playsound(src, 'modular_pod/sound/voice/my.ogg', 55, FALSE)
	else
		return

/obj/structure/medica/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.stat != DEAD)
		if(do_after(user, 2 SECONDS, target=src))
			to_chat(user, span_meatymeat("I feel some kind of fucked up!"))
			user.fully_heal(TRUE, FALSE)
			var/words = pick(words_list)
			speak(words)
			sound_hint()
			playsound(src, 'modular_pod/sound/voice/my.ogg', 55, FALSE)

/*
/obj/item/paperpodpol
	name = "Бумажка"
	desc = "Нужно ли мне подобное читать?"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "paper"
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound = 'sound/items/handling/paper_pickup.ogg'
	throw_range = 1
	throw_speed = 1
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	var/info

/obj/item/paperpodpol/attack_self(mob/user)
	. = ..()
	if(.)
		return
	readshit(user)

/obj/item/paperpodpol/proc/readshit(mob/user)
//	user << browse_rsc('html/book.png')
	if(!user.client)
		return
//	if(!user.hud_used.reads)
//		return
	if(!user.can_read(src))
		return
	if(in_range(user, src) || isobserver(user))
//		var/obj/screen/read/R = user.hud_used.reads
//		user.hud_used.reads.icon_state = "scrap"
//		user.hud_used.reads.show()
		var/dat = list()
		dat += "[info]<br>"
//		dat += "<a href='?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
		dat += "</body></html>"
		user << browse(dat, "window=reading;size=600x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1")
		onclose(user, "reading", src)
	else
		return "<span class='warning'>Слишком далеко.</span>"

/obj/item/paperpodpol/first
	info = "Я потерялся в этой хуйне. Свет дурманит меня, лучше бы оказался во тьме. Я насчитал уже 30 узоров на этом... На этой... Не знаю что это. Кажись, я понял, что они недооценивают меня, я осознал это. Пора спать."
*/
/obj/structure/barbwire
	name = "Barbed Wire"
	desc = "DO NOT TOUCH ME."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "barbwire"
	density = FALSE
	anchored = TRUE
	opacity = FALSE
	istrap = TRUE

/obj/structure/barbwire/ComponentInitialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(dont_step),
		COMSIG_ATOM_EXIT = PROC_REF(on_uncrossed),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/barbwire/proc/dont_step(datum/source, atom/movable/AM, thrown_at = FALSE)
	SIGNAL_HANDLER
	if(!isturf(loc) || !isliving(AM))
		return
	var/mob/living/L = AM
	if(!thrown_at && L.movement_type & (FLYING|FLOATING))
		return
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		var/obj/item/bodypart/affecting = C.get_bodypart_nostump(ran_zone(BODY_ZONE_CHEST, 50))
		var/armor_block = C.run_armor_check(affecting, MELEE, sharpness = SHARP_EDGED)
		var/armor_reduce = C.run_subarmor_check(affecting, MELEE, sharpness = SHARP_EDGED)
		C.visible_message(span_meatymeat("[C] gets hurt by [src]!"),span_meatymeat("I get hurt by [src]!"), span_hear("I hear hurting."))
		C.apply_damage(10, BRUTE, affecting, armor_block, wound_bonus = 5, sharpness = SHARP_EDGED, reduced = armor_reduce)
		affecting.adjust_germ_level(50)
		playsound(get_turf(src), 'modular_septic/sound/weapons/melee/sharpy1.ogg', 100 , FALSE, FALSE)

/obj/structure/barbwire/proc/on_uncrossed(datum/source, atom/movable/gone, direction)
	SIGNAL_HANDLER
	if(ishuman(gone))
		var/mob/living/carbon/human/H = gone
		if(prob(60))
			H.visible_message(span_meatymeat("[H] tries to get out of the [src]!"))
			var/obj/item/bodypart/affecting = H.get_bodypart_nostump(ran_zone(BODY_ZONE_CHEST, 50))
			var/armor_block = H.run_armor_check(affecting, MELEE, sharpness = SHARP_EDGED)
			var/armor_reduce = H.run_subarmor_check(affecting, MELEE, sharpness = SHARP_EDGED)
			H.apply_damage(10, BRUTE, affecting, armor_block, wound_bonus = 5, sharpness = SHARP_EDGED, reduced = armor_reduce)
			affecting.adjust_germ_level(50)
			return COMPONENT_ATOM_BLOCK_EXIT
		else
			H.visible_message(span_meatymeat("[H] gets out of the [src]!"))
			return

/obj/structure/barbwire/attackby(obj/item/W, mob/living/carbon/user, params)
	if(istype(W, /obj/item/minedisarmer))
		user.visible_message(span_meatymeat("[user] tries to disarm [src]!"))
		sound_hint()
		user.changeNext_move(CLICK_CD_MELEE)
		if(!do_after(user, 4 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		user.visible_message(span_meatymeat("[user] disarms [src]!"))
		qdel(src)
		user.changeNext_move(CLICK_CD_MELEE)
		sound_hint()
	else
		return

/obj/item/barbsetup
	name = "Installer"
	desc = "This is how you can install the wire."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "setupper"
	inhand_icon_state = null
	worn_icon = null
	worn_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	wound_bonus = 1
	bare_wound_bonus = 3
	min_force = 1
	force = 8
	throwforce = 5
	carry_weight = 4 KILOGRAMS
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("hits")
	attack_verb_simple = list("hit")
	var/zaryad = 3

/obj/item/detonatormine
	name = "Detonator"
	desc = "For my mine."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "detonator"
	inhand_icon_state = "flashbang"
	worn_icon_state = "grenade"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	inhand_icon_state = null
	worn_icon = null
	worn_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	wound_bonus = 1
	bare_wound_bonus = 1
	min_force = 1
	force = 2
	throwforce = 1
	carry_weight = 0.5 KILOGRAMS
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("hits")
	attack_verb_simple = list("hit")
	var/id_detonator = null

/obj/item/detonatormine/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(id_detonator)
		user.visible_message(span_meatymeat("[user] clicks on [src]."))
		user.changeNext_move(CLICK_CD_MELEE)
		for(var/obj/structure/mineexplosive/M in world)
			if(M.mineid != src.id_detonator)
				continue
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/structure/mineexplosive/, detonate))
//			INVOKE_ASYNC(M, /obj/structure/mineexplosive.proc/detonate)

/obj/item/minesetup
	name = "Mine Installer"
	desc = "Model Bajas, 3. You also need a detonator. It's like it's inside."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "mine"
	inhand_icon_state = null
	worn_icon = null
	worn_icon_state = "shard"
	w_class = WEIGHT_CLASS_BULKY
	wound_bonus = 1
	bare_wound_bonus = 3
	min_force = 1
	force = 8
	throwforce = 5
	carry_weight = 3 KILOGRAMS
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("bits")
	attack_verb_simple = list("hit")
	var/install_mine = /obj/structure/mineexplosive/based
	var/detonator = 1
	var/id_mine = null

/obj/item/minesetup/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(!detonator)
		to_chat(user, span_danger("No detonator inside!"))
		user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return
	GLOB.minenew += 1
	var/obj/item/detonatormine/detonatorr = new /obj/item/detonatormine(get_turf(user))
	user.put_in_hands(detonatorr)
	detonator--
	var/idd = GLOB.minenew
	id_mine = idd
	detonatorr.id_detonator = id_mine
	to_chat(user, span_notice("I'm getting the detonator."))
	user.changeNext_move(CLICK_CD_MELEE)

/obj/item/minesetuplita
	name = "Mine Installer"
	desc = "Model Repeater. After installation, it will be enough to step on this."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "mineplit_thing"
	inhand_icon_state = null
	worn_icon = null
	worn_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	wound_bonus = 1
	bare_wound_bonus = 3
	min_force = 1
	force = 8
	throwforce = 5
	carry_weight = 3 KILOGRAMS
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("hits")
	attack_verb_simple = list("hit")
	var/install_mine = /obj/structure/mineexplosive/mineplit

/obj/structure/mineexplosive
	name = "Installed Mine"
	desc = "DON'T CLIMB."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "installed"
	density = FALSE
	anchored = TRUE
	opacity = FALSE
	istrap = TRUE
	var/activated = FALSE
	var/mineid = null
	var/work = TRUE
	var/normal_way = TRUE
	var/ex_dev = 0
	///how big of a heavy explosion radius on prime
	var/ex_heavy = 0
	///how big of a light explosion radius on prime
	var/ex_light = 0
	///how big of a flame explosion radius on prime
	var/ex_flame = 0
	// dealing with creating a [/datum/component/pellet_cloud] on detonate
	/// if set, will spew out projectiles of this type
	var/shrapnel_type
	/// the higher this number, the more projectiles are created as shrapnel
	var/shrapnel_radius
	/// Did we add the component responsible for spawning sharpnel to this?
	var/shrapnel_initialized

/obj/structure/mineexplosive/examine(mob/user)
	. = ..()
	if(!work)
		. += span_notice("Mine doesn't work, eh.")

/obj/structure/mineexplosive/attackby(obj/item/W, mob/living/carbon/user, params)
	if(istype(W, /obj/item/minedisarmer))
		if(!work)
			return
		user.visible_message(span_meatymeat("[user] tries to disarm [src]!"))
		sound_hint()
		if(!do_after(user, 4 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		var/epic_success = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_ELECTRONICS), context = DICE_CONTEXT_PHYSICAL)
		if(epic_success >= DICE_SUCCESS)
			user.visible_message(span_meatymeat("[user] disarms [src]!"))
			work = FALSE
		else
			user.visible_message(span_meatymeat("[user] failed to disarm [src]!"))
			return
		user.changeNext_move(CLICK_CD_MELEE)
		sound_hint()
//			normal_way = FALSE
//			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/mineexplosive, detonate))
	return

/obj/structure/mineexplosive/proc/detonate(mob/living/lanced_by)
	SIGNAL_HANDLER
	if(normal_way)
		if(!work)
			return
		if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
			shrapnel_initialized = TRUE
			AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
		SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, lanced_by)
		if(ex_dev || ex_heavy || ex_light || ex_flame)
			var/turf/explosionturf = get_turf(src)
			if(explosionturf)
				explosionturf.pollute_turf(/datum/pollutant/dust, 350)
				explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
				if(!QDELETED(src))
					qdel(src)
	else
		if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
			shrapnel_initialized = TRUE
			AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
		SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, lanced_by)
		if(ex_dev || ex_heavy || ex_light || ex_flame)
			var/turf/explosionturf = get_turf(src)
			if(explosionturf)
				explosionturf.pollute_turf(/datum/pollutant/dust, 350)
				explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
				if(!QDELETED(src))
					qdel(src)

/obj/structure/mineexplosive/based
	shrapnel_type = /obj/projectile/bullet/shrapnel/mine
	shrapnel_radius = 6
	ex_heavy = 3
	ex_light = 4
	ex_flame = 3

/obj/structure/mineexplosive/mineplit
	name = "Installed Mine"
	desc = "DON'T CLIMB."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "mineplit"
	density = FALSE
	anchored = TRUE
	opacity = FALSE
	istrap = TRUE
	shrapnel_type = /obj/projectile/bullet/shrapnel/mine
	shrapnel_radius = 6
	ex_heavy = 4
	ex_light = 2
	ex_flame = 3
	var/friendo = "Nobodiers"

/obj/structure/mineexplosive/mineplit/ComponentInitialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(detonated),
		COMSIG_ATOM_EXITED = PROC_REF(dontt_step),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/mineexplosive/mineplit/attackby(obj/item/W, mob/living/carbon/user, params)
	if(istype(W, /obj/item/minedisarmer))
		if(!work)
			return
		user.visible_message(span_meatymeat("[user] tries to disarm [src]!"))
		sound_hint()
		if(!do_after(user, 4 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		var/epic_success = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_ELECTRONICS), context = DICE_CONTEXT_PHYSICAL)
		if(epic_success >= DICE_SUCCESS)
			user.visible_message(span_meatymeat("[user] disarms [src]!"))
			work = FALSE
		else
			user.visible_message(span_meatymeat("[user] failed to disarm [src]!"))
			return
		user.changeNext_move(CLICK_CD_MELEE)
		sound_hint()
	return

/obj/structure/mineexplosive/mineplit/proc/dontt_step(datum/source, atom/movable/AM, thrown_at = FALSE)
	SIGNAL_HANDLER
	if(activated)
		return
	if(normal_way)
		if(!istype(AM, /mob/living/carbon/human))
			return
		if(!work)
			return
		var/mob/living/carbon/human/johny = AM
		if(johny.throwing || johny.movement_type & (FLYING|FLOATING))
			return
		if(johny.body_position == LYING_DOWN)
			return
		if(johny.truerole == friendo)
			return
		activated = TRUE
		if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
			shrapnel_initialized = TRUE
			AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
		SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, johny)
		if(ex_dev || ex_heavy || ex_light || ex_flame)
			var/turf/explosionturf = get_turf(src)
			if(explosionturf)
				explosionturf.pollute_turf(/datum/pollutant/dust, 350)
				explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
				if(!QDELETED(src))
					qdel(src)
	else
		var/mob/living/carbon/human/johny = AM
		activated = TRUE
		if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
			shrapnel_initialized = TRUE
			AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
		SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, johny)
		if(ex_dev || ex_heavy || ex_light || ex_flame)
			var/turf/explosionturf = get_turf(src)
			if(explosionturf)
				explosionturf.pollute_turf(/datum/pollutant/dust, 350)
				explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
				if(!QDELETED(src))
					qdel(src)

/obj/structure/mineexplosive/mineplit/proc/detonated(datum/source, mob/living/lanced_by)
	SIGNAL_HANDLER
	if(activated)
		return
	if(normal_way)
		if(!istype(lanced_by, /mob/living))
			return
		if(!work)
			return
		if(lanced_by.throwing || lanced_by.movement_type & (FLYING|FLOATING))
			return
		if(lanced_by.body_position == LYING_DOWN)
			return
		if(lanced_by.truerole == friendo)
			return
		activated = TRUE
		if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
			shrapnel_initialized = TRUE
			AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
		SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, lanced_by)
		if(ex_dev || ex_heavy || ex_light || ex_flame)
			var/turf/explosionturf = get_turf(src)
			if(explosionturf)
				explosionturf.pollute_turf(/datum/pollutant/dust, 350)
				explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
				if(!QDELETED(src))
					qdel(src)
	else
		activated = TRUE
		if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
			shrapnel_initialized = TRUE
			AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
		SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, lanced_by)
		if(ex_dev || ex_heavy || ex_light || ex_flame)
			var/turf/explosionturf = get_turf(src)
			if(explosionturf)
				explosionturf.pollute_turf(/datum/pollutant/dust, 350)
				explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
				if(!QDELETED(src))
					qdel(src)

/obj/structure/mineexplosive/mineplit/pulsator
	name = "Installed Mine"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "pulsator"

/obj/structure/mineexplosive/mineplit/pulsator/dontt_step(datum/source, atom/movable/AM, thrown_at = FALSE)
	SIGNAL_HANDLER
	if(activated)
		return
	if(normal_way)
		if(!istype(AM, /mob/living/carbon/human))
			return
		if(!work)
			return
		var/mob/living/carbon/human/johny = AM
		if(johny.throwing || johny.movement_type & (FLYING|FLOATING))
			return
		if(johny.body_position == LYING_DOWN)
			return
		if(johny.truerole == friendo)
			return
		activated = TRUE
		playsound(loc, 'modular_pod/sound/eff/minecra.ogg', 70, TRUE)
		spawn(9)
			if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
				shrapnel_initialized = TRUE
				AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
			SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, johny)
			if(ex_dev || ex_heavy || ex_light || ex_flame)
				var/turf/explosionturf = get_turf(src)
				if(explosionturf)
					explosionturf.pollute_turf(/datum/pollutant/dust, 350)
					explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
					if(!QDELETED(src))
						qdel(src)
	else
		var/mob/living/carbon/human/johny = AM
		activated = TRUE
		playsound(loc, 'modular_pod/sound/eff/minecra.ogg', 70, TRUE)
		spawn(9)
			if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
				shrapnel_initialized = TRUE
				AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
			SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, johny)
			if(ex_dev || ex_heavy || ex_light || ex_flame)
				var/turf/explosionturf = get_turf(src)
				if(explosionturf)
					explosionturf.pollute_turf(/datum/pollutant/dust, 350)
					explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
					if(!QDELETED(src))
						qdel(src)

/obj/structure/mineexplosive/mineplit/pulsator/detonated(datum/source, mob/living/lanced_by)
	SIGNAL_HANDLER
	if(activated)
		return
	if(normal_way)
		if(!istype(lanced_by, /mob/living))
			return
		if(!work)
			return
		if(lanced_by.throwing || lanced_by.movement_type & (FLYING|FLOATING))
			return
		if(lanced_by.body_position == LYING_DOWN)
			return
		if(lanced_by.truerole == friendo)
			return
		activated = TRUE
		playsound(loc, 'modular_pod/sound/eff/minecra.ogg', 70, TRUE)
		spawn(9)
			if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
				shrapnel_initialized = TRUE
				AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
			SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, lanced_by)
			if(ex_dev || ex_heavy || ex_light || ex_flame)
				var/turf/explosionturf = get_turf(src)
				if(explosionturf)
					explosionturf.pollute_turf(/datum/pollutant/dust, 350)
					explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
					if(!QDELETED(src))
						qdel(src)
	else
		activated = TRUE
		playsound(loc, 'modular_pod/sound/eff/minecra.ogg', 70, TRUE)
		spawn(9)
			if(shrapnel_type && shrapnel_radius && !shrapnel_initialized)
				shrapnel_initialized = TRUE
				AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_radius)
			SEND_SIGNAL(src, COMSIG_CRAZYMINE_TRIGGERED, lanced_by)
			if(ex_dev || ex_heavy || ex_light || ex_flame)
				var/turf/explosionturf = get_turf(src)
				if(explosionturf)
					explosionturf.pollute_turf(/datum/pollutant/dust, 350)
					explosion(src, ex_dev, ex_heavy, ex_light, ex_flame)
					if(!QDELETED(src))
						qdel(src)

/obj/item/minedisarmer
	name = "Disarmer"
	desc = "Mines and barbed wires are not a hindrance!"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "disarmer"
	inhand_icon_state = null
	worn_icon = null
	worn_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	wound_bonus = 1
	bare_wound_bonus = 3
	min_force = 1
	force = 4
	throwforce = 3
	carry_weight = 1 KILOGRAMS
	slot_flags = ITEM_SLOT_BELT
	attack_verb_continuous = list("hits")
	attack_verb_simple = list("hit")

/obj/structure/shopka
	name = "Shop Ball"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "shop"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = 1
	density = 1
	obj_flags = NONE
	light_range = 4
	light_power = 3
	light_color = "#bf00ac"
	var/lockeda = FALSE
	var/proj_pass_rate = 100
	var/shop_thing
	var/inserted = 0

/obj/structure/shopka/CanAllowThrough(atom/movable/mover, border_dir)//So bullets will fly over and stuff.
	. = ..()
	if(locate(/obj/structure/shopka) in get_turf(mover))
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

/obj/structure/shopka/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.client)
		return
	if(get_dist(src, user) >= 2)
		return
	var/thing = input(user, "What do I want?", "I want...") as null|anything in list("Halyab Egg (100)")
	if(!thing)
		return
	if(thing == "Halyab Egg (100)")
		if(inserted >= 100)
			if(!user.client)
				return
			if(get_dist(src, user) >= 2)
				return
			inserted -= 100
			playsound(get_turf(src), 'modular_pod/sound/eff/crystalHERE.ogg', 90 , FALSE, FALSE)
			to_chat(user, span_meatymeat("Purchase is done!"))
			new /obj/item/halyabegg(get_turf(user))

/obj/structure/shopka/attackby(obj/item/I, mob/living/carbon/user, params)
	if(istype(I, /obj/item/stack/eviljewel))
//		if(user.a_intent != INTENT_DISARM)
//			return
		var/obj/item/stack/eviljewel/M = I
		user.visible_message(span_notice("[user] inserts [M] in [src]."),span_notice("You insert [M] in [src]."), span_hear("You hear the sound of inserting."))
		sound_hint()
		playsound(get_turf(src), 'modular_pod/sound/eff/thingg.ogg', 100 , FALSE, FALSE)
		inserted += M.amount
		qdel(M)

/obj/item/fishka/hrumka
	name = "Hrumka"
	desc = "Some fish."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "hrumka"
	w_class = WEIGHT_CLASS_SMALL
	carry_weight = 1 KILOGRAMS

/obj/structure/awakener_kompik
	name = "Kompik"
	desc = "We should play!"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "kompik"
	anchored = TRUE
	density = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/once_call = TRUE
	var/really_once = TRUE

/obj/structure/awakener_kompik/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.client)
		return
	if(get_dist(src, user) >= 2)
		return
	var/thing = input(user, "What do I want?", "I want...") as null|anything in list("End This Dream", "Call People")
	if(!thing)
		return
	if(thing == "End This Dream")
		if(really_once)
			if(SSticker.current_state != GAME_STATE_FINISHED)
				if(!user.client)
					return
				if(get_dist(src, user) >= 2)
					return
				priority_announce("THE DREAM IS OVER!", "DREAM", has_important_message = TRUE)
				SEND_SOUND(world, sound('modular_pod/sound/mus/announce.ogg'))
				SSticker.force_ending = 1
				really_once = FALSE

	if(thing == "Call People")
		if(once_call)
			if(!user.client)
				return
			if(get_dist(src, user) >= 2)
				return
			for(var/mob/living/carbon/human/H in world)
				if(H == src)
					continue
				if(H.stat == DEAD)
					continue
				if(!H.client)
					continue
				var/obj/effect/landing/dream_awakener/spawn_point = locate() in world
				H.forceMove(spawn_point.loc)

			priority_announce("PEOPLE ARE CALLED!", "DREAM", has_important_message = TRUE)
			SEND_SOUND(world, sound('modular_pod/sound/mus/announce.ogg'))
			once_call = FALSE

/obj/structure/awakener
	name = "Awakener"
	desc = "We should wake up!"
	icon = 'modular_pod/icons/obj/things/things_4.dmi'
	icon_state = "awaker"
	anchored = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	pixel_x = -16
	pixel_y = -16
	var/need_amanita = TRUE
	var/need_eviljewel = TRUE
	var/need_hrumka = TRUE
	var/activated = FALSE

/obj/structure/awakener/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!activated)
		if(!need_amanita && !need_eviljewel && !need_hrumka)
			activated = TRUE
			priority_announce("AWAKENER IS ACTIVATED!", "DREAM", has_important_message = TRUE)
			SEND_SOUND(world, sound('modular_pod/sound/mus/announce.ogg'))
//			user.client?.prefs.adjust_rank(1, "<span class='rank'>I awakened Gray! +1 Rank Level!</span>")
//			user.client?.prefs.adjust_bobux(2, "<span class='bobux'>I awakened Gray! +300 Kaotiks!</span>")
	else
		if(!do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_danger(xbox_rage_msg()))
			user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		var/obj/effect/landing/dream_awakener/spawn_point = locate() in world
		user.forceMove(spawn_point.loc)

/obj/structure/awakener/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/food/grown/mushroom/muha))
		if(need_amanita)
			need_amanita = FALSE
			qdel(I)
	if(istype(I, /obj/item/stack/eviljewel))
		var/obj/item/stack/eviljewel/M = I
		if(M.amount == 1)
			need_eviljewel = FALSE
			qdel(M)
	if(istype(I, /obj/item/fishka/hrumka))
		need_hrumka = FALSE
		qdel(I)

/obj/structure/sign/poster/contraband/codec/leather
	name = "Leather Curtain"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "leather1"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	resistance_flags = FLAMMABLE

/obj/structure/sign/poster/contraband/codec/leather/two
	icon_state = "leather2"

/obj/effect/decal/woodplanks
	name = "Wooden planks"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "broken_wood"
	layer = TURF_PLATING_DECAL_LAYER
	resistance_flags = FLAMMABLE
	alpha = 255

/obj/item/ruda/steel
	name = "Steel"
	desc = "Some steel."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "steel"
	w_class = WEIGHT_CLASS_SMALL
	carry_weight = 1 KILOGRAMS

/obj/structure/steel_eater
	name = "Steel Eater"
	desc = "Give it some steel!"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "steel_eater"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = 1
	density = 1
	obj_flags = NONE
	var/proj_pass_rate = 100
	var/steel_amount = 0

/obj/structure/steel_eater/CanAllowThrough(atom/movable/mover, border_dir)//So bullets will fly over and stuff.
	. = ..()
	if(locate(/obj/structure/steel_eater) in get_turf(mover))
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

/obj/structure/steel_eater/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ruda/steel))
		qdel(I)
		steel_amount += 1

/obj/structure/steel_eater/examine(mob/user)
	. = ..()
	if(steel_amount)
		. += "<span class='notice'>Steel amount: [steel_amount].</span>"

/obj/structure/steel_eater/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.client)
		return
	if(get_dist(src, user) >= 2)
		return
	if(steel_amount < 1)
		return
	var/thing = input(user, "What do I want?", "I want...") as null|anything in list("Armor", "Weapon")
	if(!thing)
		return
	if(thing == "Armor")
		armor(user)

	if(thing == "Weapon")
		weapon(user)

/obj/structure/steel_eater/proc/armor(mob/living/carbon/human/user)
	if(!user.client)
		return
	if(get_dist(src, user) >= 2)
		return
	if(steel_amount < 1)
		return
	var/thing = input(user, "What do I want?", "I want...") as null|anything in list("Helmet", "Pants", "Mask", "Shell", "Chainmail", "Gloves", "Boots")
	if(!thing)
		return
	switch(thing)
		if("Helmet")
			if(steel_amount >= 2)
				steel_amount -= 2
				spawn_our_craft(user, /obj/item/clothing/head/helmet/steel)
		if("Mask")
			if(steel_amount >= 1)
				steel_amount -= 1
				spawn_our_craft(user, /obj/item/clothing/mask/gas/steel)
		if("Shell")
			if(steel_amount >= 3)
				steel_amount -= 3
				spawn_our_craft(user, /obj/item/clothing/suit/armor/vest/shell/steel)
		if("Chainmail")
			if(steel_amount >= 3)
				steel_amount -= 3
				spawn_our_craft(user, /obj/item/clothing/suit/armor/vest/chainmail/steel)
		if("Pants")
			if(steel_amount >= 3)
				steel_amount -= 3
				spawn_our_craft(user, /obj/item/clothing/pants/armored/steel)
		if("Gloves")
			if(steel_amount >= 2)
				steel_amount -= 2
				spawn_our_craft(user, /obj/item/clothing/gloves/steel)
		if("Boots")
			if(steel_amount >= 2)
				steel_amount -= 2
				spawn_our_craft(user, /obj/item/clothing/shoes/steel)

/obj/structure/steel_eater/proc/weapon(mob/living/carbon/human/user)
	if(!user.client)
		return
	if(get_dist(src, user) >= 2)
		return
	if(steel_amount < 1)
		return
	var/thing = input(user, "What do I want?", "I want...") as null|anything in list("Sword", "Knife")
	if(!thing)
		return
	switch(thing)
		if("Sword")
			if(steel_amount >= 2)
				steel_amount -= 2
				spawn_our_craft(user, /obj/item/podpol_weapon/sword/steel)
		if("Knife")
			if(steel_amount >= 1)
				steel_amount -= 1
				spawn_our_craft(user, /obj/item/podpol_weapon/steelknife)

/obj/structure/steel_eater/proc/spawn_our_craft(mob/living/carbon/human/user, thing)
	if(!user.client)
		return
	if(get_dist(src, user) >= 2)
		return
	new thing(get_turf(user))