/turf/open/floor/plating/polovich
	var/trapturf = FALSE

/turf/open/floor/plating/polovich/way/station
	name = "Floor"
	icon = 'modular_pod/icons/turf/floors_4.dmi'

/turf/open/floor/plating/polovich/way/station/hotfloor
	icon_state = "hotfloor"
	footstep = FOOTSTEP_METAL
	barefootstep = FOOTSTEP_METAL
	clawfootstep = FOOTSTEP_METAL
	heavyfootstep = FOOTSTEP_METAL
	light_range = 3
	light_power = 3
	light_color = "#c2281b"
	powerfloor = 18

/turf/open/floor/plating/polovich/way/station/mystic
	icon_state = "mystic"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/station/mystic/crazy
	var/crazy_id = "station"
	special_floor = TRUE

/turf/open/floor/plating/polovich/way/station/mystic/crazy/special_thing(mob/living/user)
	for(var/turf/open/floor/plating/polovich/way/station/mystic/crazy/spawn_point in world)
		if(spawn_point.crazy_id == "earth")
			user.visible_message(span_meatymeat("[user] телепортируется!"),span_meatymeat("Я телепортируюсь!"), span_hear("Я слышу чё-то."))
			user.forceMove(spawn_point)

/turf/open/floor/plating/polovich/way/station/mystic/crazy/back
	crazy_id = "earth"

/turf/open/floor/plating/polovich/way/station/mystic/crazy/back/special_thing(mob/living/user)
	for(var/turf/open/floor/plating/polovich/way/station/mystic/crazy/spawn_point in world)
		if(spawn_point.crazy_id == "station")
			user.visible_message(span_meatymeat("[user] телепортируется!"),span_meatymeat("Я телепортируюсь!"), span_hear("Я слышу чё-то."))
			user.forceMove(spawn_point)

/turf/open/floor/plating/polovich/way/station/notgood
	icon_state = "notgood"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/station/enga
	icon_state = "enga"
	footstep = FOOTSTEP_PLATING
	powerfloor = 18

/turf/open/floor/plating/polovich/way/station/enga2
	icon_state = "enga2"
	footstep = FOOTSTEP_PLATING
	powerfloor = 18

/turf/open/floor/plating/polovich/way/station/web
	icon_state = "web"
	footstep = FOOTSTEP_PLATING
	powerfloor = 18

/turf/open/floor/plating/polovich/way/station/wayt
	icon_state = "wayt"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18




// PHASE TWO



/turf/open/floor/plating/polovich/way/for4
	name = "Dirt"
	icon_state = "for4"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	var/finished = FALSE
	trapturf = TRUE
	icon = 'modular_pod/icons/content_5.dmi'
	slowdown = 1

/*
/turf/open/floor/plating/polovich/way/for4/Initialize(mapload)
	. = ..()
//	dir = rand(0,4)
	var/near_t = range(1, src)
	for(var/turf/open/floor/plating/polovich/way/muddy/generat in near_t)
		if(!generat.finished)
			continue
		if(prob(10))
			generat.ChangeTurf(/turf/open/floor/plating/polovich/way/for4, null, CHANGETURF_IGNORE_AIR)
/*	if(SSantagonists.crazy_traps)
		if(trapturf)
			for(var/obj/M in get_turf(src))
				if(M && !M.can_spawn_various_shit)
					return
			if(prob(70))
				new /obj/structure/barbwire(get_turf(src))
			if(prob(50))
				new /obj/structure/mineexplosive/mineplit(get_turf(src))
*/
//			dir = rand(0,4)
*/

/turf/open/floor/plating/polovich/way/for2
	name = "Dirt"
	icon_state = "for2"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	var/finished = FALSE
	var/flora = TRUE
	trapturf = TRUE
	icon = 'modular_pod/icons/content_5.dmi'
	slowdown = 1

/*
/turf/open/floor/plating/polovich/way/muddy/Initialize(mapload)
	. = ..()
	dir = rand(0,4)
*/

/*
/turf/open/floor/plating/polovich/way/for2/Initialize(mapload)
	. = ..()
	if(flora)
		if(prob(15))
			for(var/obj/M in get_turf(src))
				if(M && !M.can_spawn_various_shit)
					return
			if(prob(70))
				new /obj/structure/flora/ausbushes/cactus(get_turf(src))
				var/near_tt = range(1, src)
				for(var/turf/open/floor/plating/polovich/way/for2 in get_turf(near_tt))
					for(var/obj/M in get_turf(near_tt))
						if(M && !M.can_spawn_various_shit)
							continue
					if(prob(93))
						new /obj/structure/flora/ausbushes/cactus(get_turf(near_tt))
		if(prob(5))
			for(var/obj/M in get_turf(src))
				if(M && !M.can_spawn_various_shit)
					return
			new /obj/structure/flora/ausbushes/granat(get_turf(src))
		if(prob(10))
			for(var/obj/M in get_turf(src))
				if(M && !M.can_spawn_various_shit)
					return
			new /obj/effect/decal/grassnice(get_turf(src))
/*	if(SSantagonists.crazy_traps)
		if(trapturf)
			for(var/obj/M in get_turf(src))
				if(M && !M.can_spawn_various_shit)
					return
			if(prob(70))
				new /obj/structure/barbwire(get_turf(src))
			if(prob(50))
				new /obj/structure/mineexplosive/mineplit(get_turf(src))
*/
/*
	if(prob(40))
		var/near_t = range(1, src)
		for(var/turf/open/floor/plating/polovich/way/for2/generat in near_t)
			if(prob(10))
				generat.ChangeTurf(/turf/open/floor/plating/polovich/way/redd, null, CHANGETURF_IGNORE_AIR)
			if(prob(20))
				generat.ChangeTurf(/turf/open/floor/plating/polovich/way/for4, null, CHANGETURF_IGNORE_AIR)
//				generat.dir = rand(0,4)
			if(prob(20))
				generat.ChangeTurf(/turf/open/floor/plating/polovich/way/for3, null, CHANGETURF_IGNORE_AIR)
			if(prob(20))
				generat.ChangeTurf(/turf/open/floor/plating/polovich/way/for1, null, CHANGETURF_IGNORE_AIR)
*/
		finished = TRUE
*/

/turf/open/floor/plating/polovich/way/for3
	name = "Body Floor"
	desc = "Interesting."
	icon_state = "for3"
	footstep = FOOTSTEP_MEAT
	barefootstep = FOOTSTEP_MEAT
	clawfootstep = FOOTSTEP_MEAT
	heavyfootstep = FOOTSTEP_MEAT
	var/finished = FALSE
	trapturf = TRUE
	icon = 'modular_pod/icons/content_5.dmi'
/*
/turf/open/floor/plating/polovich/way/for3/Initialize(mapload)
	. = ..()
	if(SSantagonists.crazy_traps)
		if(trapturf)
			for(var/obj/M in get_turf(src))
				if(M && !M.can_spawn_various_shit)
					return
			if(prob(70))
				new /obj/structure/barbwire(get_turf(src))
			if(prob(50))
				new /obj/structure/mineexplosive/mineplit(get_turf(src))
*/
/turf/open/floor/plating/polovich/way/for1
	name = "Mud"
	icon_state = "for1"
	footstep = FOOTSTEP_MEAT
	barefootstep = FOOTSTEP_MEAT
	clawfootstep = FOOTSTEP_MEAT
	heavyfootstep = FOOTSTEP_MEAT
	var/finished = FALSE
	trapturf = TRUE
	icon = 'modular_pod/icons/content_5.dmi'
	slowdown = 1
/*
/turf/open/floor/plating/polovich/way/for1/Initialize(mapload)
	. = ..()
	var/turf/south = get_step(get_turf(src), SOUTH)
	var/turf/north = get_step(get_turf(src), NORTH)
	var/turf/west = get_step(get_turf(src), WEST)
	var/turf/east = get_step(get_turf(src), EAST)
	if(locate(/turf/open/floor/plating/polovich/way/for2) in south)
		if(prob(10))
			south.ChangeTurf(/turf/open/floor/plating/polovich/way/for1, null, CHANGETURF_IGNORE_AIR)
	if(locate(/turf/open/floor/plating/polovich/way/for2) in north)
		if(prob(10))
			north.ChangeTurf(/turf/open/floor/plating/polovich/way/for1, null, CHANGETURF_IGNORE_AIR)
	if(locate(/turf/open/floor/plating/polovich/way/for2) in east)
		if(prob(50))
			east.ChangeTurf(/turf/open/floor/plating/polovich/way/for1, null, CHANGETURF_IGNORE_AIR)
	if(locate(/turf/open/floor/plating/polovich/way/for2) in west)
		if(prob(50))
			west.ChangeTurf(/turf/open/floor/plating/polovich/way/for1, null, CHANGETURF_IGNORE_AIR)
/*	if(SSantagonists.crazy_traps)
		if(trapturf)
			for(var/obj/M in get_turf(src))
				if(M && !M.can_spawn_various_shit)
					return
			if(prob(70))
				new /obj/structure/barbwire(get_turf(src))
			if(prob(50))
				new /obj/structure/mineexplosive/mineplit(get_turf(src))
*/
*/
/turf/open/floor/plating/polovich/way/for5
	name = "Dirt"
	icon_state = "for5"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	var/finished = FALSE
	trapturf = TRUE
	icon = 'modular_pod/icons/content_5.dmi'
	slowdown = 1
/*
/turf/open/floor/plating/polovich/way/for5/Initialize(mapload)
	. = ..()
	if(SSantagonists.crazy_traps)
		if(trapturf)
			for(var/obj/M in get_turf(src))
				if(M && !M.can_spawn_various_shit)
					return
			if(prob(70))
				new /obj/structure/barbwire(get_turf(src))
			if(prob(50))
				new /obj/structure/mineexplosive/mineplit(get_turf(src))
*/

// PRISON




/turf/open/floor/plating/polovich/way/stolfl
	icon_state = "stolfl"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/stolfl/Initialize(mapload)
	. = ..()
	dir = rand(0,4)

/turf/open/floor/plating/polovich/way
	name = "Floor"

/turf/open/floor/plating/polovich/way/spider
	icon_state = "spider"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/spadero
	icon_state = "spadero"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/ston
	icon_state = "ston"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/our_mother
	name = "Dirt"
	icon_state = "our_mother"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	icon = 'modular_pod/icons/content_6.dmi'
	slowdown = 1

/turf/open/floor/plating/polovich/way/cute_bed
	name = "Dirt"
	icon_state = "cute_bed"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	icon = 'modular_pod/icons/content_6.dmi'
	slowdown = 1

/turf/open/floor/plating/polovich/way/father
	name = "Mud"
	icon_state = "father"
	footstep = FOOTSTEP_MEAT
	barefootstep = FOOTSTEP_MEAT
	clawfootstep = FOOTSTEP_MEAT
	heavyfootstep = FOOTSTEP_MEAT
	icon = 'modular_pod/icons/content_6.dmi'
	slowdown = 1

/turf/open/floor/plating/polovich/way/dreamer
	icon_state = "dreamer"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/pryt
	icon_state = "pryt"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_METAL
	barefootstep = FOOTSTEP_METAL
	clawfootstep = FOOTSTEP_METAL
	heavyfootstep = FOOTSTEP_METAL
	powerfloor = 18

/turf/open/floor/plating/polovich/way/stola
	icon_state = "stola"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_METAL
	barefootstep = FOOTSTEP_METAL
	clawfootstep = FOOTSTEP_METAL
	heavyfootstep = FOOTSTEP_METAL
	powerfloor = 18

/turf/open/floor/plating/polovich/way/qiwi
	name = "Qiwi"
	icon_state = "qiwi"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_CRUMBLE
	barefootstep = FOOTSTEP_CRUMBLE
	clawfootstep = FOOTSTEP_CRUMBLE
	heavyfootstep = FOOTSTEP_CRUMBLE
	slowdown = 1

/turf/open/floor/plating/polovich/way/ditraa
	name = "Dirt"
	icon_state = "ditraa"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	icon = 'modular_pod/icons/content_6.dmi'
	slowdown = 1

/turf/open/floor/plating/polovich/way/murda
	name = "Mud"
	icon_state = "murda"
	footstep = FOOTSTEP_MEAT
	barefootstep = FOOTSTEP_MEAT
	clawfootstep = FOOTSTEP_MEAT
	heavyfootstep = FOOTSTEP_MEAT
	icon = 'modular_pod/icons/content_6.dmi'
	slowdown = 1

/turf/open/floor/plating/polovich/way/wiider
	icon_state = "wiider"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_WOOD
	resistance_flags = FLAMMABLE
	powerfloor = 18



// PODPOL                                               2




/turf/open/floor/plating/polovich/way/crazy_attack
	name = "Body"
	icon_state = "crazy_attack"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_MEAT
	barefootstep = FOOTSTEP_MEAT
	clawfootstep = FOOTSTEP_MEAT
	heavyfootstep = FOOTSTEP_MEAT
	slowdown = 1
	var/flora = TRUE

/turf/open/floor/plating/polovich/way/super_crazy_toxic
	name = "Dirt"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "super_crazy_toxic_"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	slowdown = 1
	var/flora = TRUE

/turf/open/floor/plating/polovich/way/super_crazy_toxic_war
	name = "Dirt"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "super_crazy_toxic_"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	slowdown = 1
	var/flora = TRUE

/turf/open/floor/plating/polovich/way/super_crazy
	name = "Grass"
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "super_crazy"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GRASS
	var/flora = TRUE

/turf/open/floor/plating/polovich/way/system1
	name = "Kaotik System"
	icon = 'modular_pod/icons/turf/floors_4.dmi'
	icon_state = "system1"
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	density = TRUE
	opacity = TRUE

/turf/open/floor/plating/polovich/way/system2
	name = "Kaotik System"
	icon = 'modular_pod/icons/turf/floors_4.dmi'
	icon_state = "system2"
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA

/turf/open/floor/plating/polovich/way/system3
	name = "Kaotik System"
	icon = 'modular_pod/icons/turf/floors_4.dmi'
	icon_state = "system3"
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA

/turf/open/floor/plating/polovich/way/system4
	name = "Kaotik System"
	icon = 'modular_pod/icons/turf/floors_4.dmi'
	icon_state = "system4"
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	density = TRUE
	opacity = TRUE

/turf/open/floor/plating/polovich/way/system5
	name = "Kaotik System"
	icon = 'modular_pod/icons/turf/floors_4.dmi'
	icon_state = "system5"
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	density = FALSE
	opacity = FALSE

/turf/open/floor/plating/polovich/way/system6
	name = "Kaotik System"
	icon = 'modular_pod/icons/turf/floors_4.dmi'
	icon_state = "system6"
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	density = TRUE
	opacity = FALSE

/turf/open/floor/plating/polovich/way/system7
	name = "Kaotik System"
	icon = 'modular_pod/icons/turf/floors_4.dmi'
	icon_state = "system7"
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	density = TRUE
	opacity = FALSE

/turf/open/floor/plating/polovich/way/club
	icon_state = "club"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_PLATING
	clawfootstep = FOOTSTEP_PLATING
	heavyfootstep = FOOTSTEP_PLATING
	powerfloor = 18

/turf/open/floor/plating/polovich/way/govno
	icon_state = "govno"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_MEAT
	barefootstep = FOOTSTEP_MEAT
	clawfootstep = FOOTSTEP_MEAT
	heavyfootstep = FOOTSTEP_MEAT

/turf/open/floor/plating/polovich/way/warwar/blackos
	icon_state = "darkar"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/warwar/blackos2
	icon_state = "darkor"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/warwar/platka
	icon_state = "platka"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/warwar/deathstone
	icon_state = "deathstone"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/vibrat
	icon_state = "vibrat"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/solarstone
	icon_state = "solarstone"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/godstone
	icon_state = "godstone"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/krs
	icon_state = "krs"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/krs2
	icon_state = "krs2"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/hotta
	icon_state = "hotta"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/solar
	icon_state = "solar"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/solar2
	icon_state = "solar2"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/neb
	icon_state = "neb"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/neb1
	icon_state = "neb1"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/nei
	icon_state = "nei"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/krs3
	icon_state = "krs3"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/stara
	icon_state = "stara"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/krugo
	icon_state = "krugo"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/griner
	icon_state = "griner"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/kletki
	icon_state = "kletki"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/starec
	icon_state = "starec"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/tkan
	name = "Floor"
	icon_state = "tkan"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND

/turf/open/floor/plating/polovich/way/maya/blood
	icon_state = "blood"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/text
	icon_state = "text"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/blestya
	icon_state = "blestya"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_STONE
	clawfootstep = FOOTSTEP_STONE
	heavyfootstep = FOOTSTEP_STONE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/grinch
	icon_state = "grinch"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_WOOD
	resistance_flags = FLAMMABLE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/greena
	icon_state = "greena"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_WOOD
	resistance_flags = FLAMMABLE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/xax
	icon_state = "xax"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_WOOD
	resistance_flags = FLAMMABLE
	powerfloor = 18

/turf/open/floor/plating/polovich/way/maya/karpa
	icon_state = "karpa"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_CARPET_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	resistance_flags = FLAMMABLE

/turf/open/floor/plating/polovich/way/maya/krasa
	icon_state = "krasa"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_CARPET_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	resistance_flags = FLAMMABLE

/turf/open/floor/plating/polovich/way/maya/krugosvet
	icon_state = "krugosvet"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_CARPET_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	resistance_flags = FLAMMABLE

/turf/open/floor/plating/polovich/way/maya/ourglor
	icon_state = "ourglor"
	icon = 'modular_pod/icons/content_6.dmi'
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_CARPET_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	resistance_flags = FLAMMABLE