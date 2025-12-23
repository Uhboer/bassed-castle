// Base class for all tank parts
/obj/structure/tank_part
	name = "tank part"
	desc = "A part of a tank."
	icon = 'modular_pod/icons/obj/things/tank.dmi'
	density = TRUE
	anchored = TRUE
	var/obj/structure/tank_core/core
	var/list/parts = list()
	var/health = 100
	var/max_health = 100
	var/last_move_time = 0
	var/move_delay = 2 SECONDS

/obj/structure/tank_part/Initialize(mapload)
	. = ..()
	// Search for tank core in a larger radius
	for(var/obj/structure/tank_core/C in range(3, src))
		core = C
		C.parts += src
		break

/obj/structure/tank_part/Destroy()
	if(core)
		core.parts -= src
		core.check_integrity()
	. = ..()

// Tank core
/obj/structure/tank_core
	name = "tank core"
	desc = "The main control unit of a tank."
	icon = 'modular_pod/icons/obj/things/tank.dmi'
	icon_state = "tank_core"
	density = TRUE
	anchored = TRUE
	var/mob/living/driver = null
	var/list/parts = list()
	var/health = 200
	var/max_health = 200
	var/last_move_time = 0
	var/move_delay = 2 SECONDS
	var/list/tracks = list()
	var/gun = null

/obj/structure/tank_core/Initialize(mapload)
	. = ..()
	// Search for connected parts in a larger radius
	for(var/obj/structure/tank_part/P in range(3, src))
		if(P != src)
			parts += P
			P.core = src
			if(istype(P, /obj/structure/tank_track))
				tracks += P
			else if(istype(P, /obj/structure/tank_gun))
				gun = P

/obj/structure/tank_core/proc/check_integrity()
	// Check tank integrity
	if(length(tracks) < 2)
		// If less than 2 parts, tank cannot move
		return FALSE
	return TRUE

/obj/structure/tank_core/proc/try_move(direction)
	if(world.time < last_move_time + move_delay)
		return FALSE

	last_move_time = world.time

	// Check movement possibility for all parts
	var/list/parts_to_move = parts.Copy()
	parts_to_move += src

	for(var/obj/structure/tank_part/P in parts_to_move)
		var/turf/T = get_step(P, direction)
		if(!T || T.density)
			return FALSE

	// Move all parts
	for(var/obj/structure/tank_part/P in parts_to_move)
		P.forceMove(get_step(P, direction))

	return TRUE

// Tank tracks
/obj/structure/tank_track
	name = "tank track"
	desc = "A tank track that provides movement."
	icon_state = "tank_track"
	density = TRUE
	anchored = TRUE
	var/health = 120
	var/max_health = 120
	var/move_speed = 2
	var/turn_speed = 1
	var/obj/structure/tank_core/core

// Tank gun
/obj/structure/tank_gun
	name = "tank gun"
	desc = "A tank gun capable of firing."
	icon_state = "tank_gun"
	density = TRUE
	anchored = TRUE
	var/health = 150
	var/max_health = 150
	var/fire_delay = 5 SECONDS
	var/last_fire_time = 0
	var/obj/structure/tank_core/core

/obj/structure/tank_gun/proc/fire()
	if(world.time < last_fire_time + fire_delay)
		return FALSE

	last_fire_time = world.time
	// Here will be firing logic
	return TRUE