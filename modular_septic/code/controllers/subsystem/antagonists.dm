SUBSYSTEM_DEF(antagonists)
	name = "Antagonists"
	flags = SS_NO_FIRE

	var/fog_world = FALSE
	var/rain_mode = FALSE
	var/gay_guns = FALSE
	var/muzon_ears = FALSE
//	var/blue_mode = FALSE

	var/dead_earth = FALSE
	var/list/johny_event = list()
//	var/crazy_traps = FALSE

/datum/controller/subsystem/antagonists/Initialize(start_timeofday)
	. = ..()
	GLOB.syndicate_employers = list("Dream Agent", "Dream HVAX")
	GLOB.normal_employers = list("Dream Agent", "Dream KVAX")
	GLOB.hijack_employers = list("Dream HVAX")
	GLOB.nanotrasen_employers = list("Dream KVAX")

/*
	if(!SSmapping.config?.war_gamemode)
		var/list/haos = list("Narco", "Postbellum", "Alarming Fog", "Shitteria", "Acid Party", "Baby Dream")
		var/list/xaos = list("Narco", "Postbellum", "Alarming Fog", "Shitteria", "Acid Party", "Baby Dream", "Ego Noise")
		if(prob(50))
			johny_event += pick(haos)
		else
			var/alexer = pick(xaos)
			johny_event += alexer
			haos -= alexer
			johny_event += pick(haos)
//		johny_event += "Postbellum"

//	if("Dead Earth" in SSantagonists.johny_event)
//		dead_earth = TRUE

	else
		if(prob(50))
			fog_world = TRUE
		if(prob(50))
			gay_guns = TRUE
		if(prob(100))
			rain_mode = TRUE
		if(prob(100))
			johny_event += "Ego Noise"
*/

	loadMappa()
//		if(prob(60))
//			blue_mode = TRUE
//	if(prob(50))
//		crazy_traps = TRUE

	if(fog_world)
		for(var/area/maintenance/polovich/warwar/C in world)
			if(C.fogger)
				for(var/turf/T in C)
					new /obj/effect/foga(T)
/*
	if(rain_mode)
		for(var/area/maintenance/polovich/warwar/C in world)
			if(C.rainer)
				for(var/turf/T in C)
					new /obj/effect/foga(T)

	if(blue_mode)
		SSticker.login_music = 'modular_septic/xtal.ogg'
		for(var/area/maintenance/polovich/lobby/C in world)
			if(C.crazy)
				for(var/turf/T in C)
					T.color = pick("#00abd2", "#0090f5")
				for(var/obj/structure/kaos/blackwindow/window in C)
					window.set_light(8, 4, "#0000b9")
*/

/datum/controller/subsystem/antagonists/proc/loadMappa()
	for(var/turf/open/floor/plating/polovich/way/dirtc/xoh in world)
		if(prob(9))
			var/should = TRUE
			for(var/obj/M in get_turf(xoh))
				if(M && M.density)
					should = FALSE
			if (should)
				new /obj/structure/flora/tree/evil/long(get_turf(xoh))
		else
			if(prob(20))
				var/should = TRUE
				for(var/obj/M in get_turf(xoh))
					if(M && M.density)
						should = FALSE
				if (should)
					new /obj/effect/decal/grassev(get_turf(xoh))
			else
				if(prob(30))
					var/should = TRUE
					for(var/obj/M in get_turf(xoh))
						if(M && M.density)
							should = FALSE
					if (should)
						new /obj/effect/decal/grassevc(get_turf(xoh))
		if(prob(70))
			xoh.ChangeTurf(/turf/open/floor/plating/polovich/way/grassc, null, CHANGETURF_IGNORE_AIR)
		else
			if(prob(30))
				xoh.ChangeTurf(/turf/open/floor/plating/polovich/way/dirtcv, null, CHANGETURF_IGNORE_AIR)
		if(prob(9))
			var/should = TRUE
			for(var/obj/M in get_turf(xoh))
				if(M && M.density)
					should = FALSE
			if (should)
				new /obj/item/stone(get_turf(xoh))
		else
			if(prob(10))
				var/should = TRUE
				for(var/obj/M in get_turf(xoh))
					if(M && M.density)
						should = FALSE
				if (should)
					new /obj/item/melee/bita/branch(get_turf(xoh))

		if(prob(10))
			var/should = TRUE
			for(var/obj/M in get_turf(xoh))
				if(M && M.density)
					should = FALSE
			if (should)
				new /obj/structure/flora/ausbushes/bushkac(get_turf(xoh))

	for(var/turf/open/floor/plating/polovich/way/dirtclobby/loba in world)
		if(prob(9))
			var/should = TRUE
			for(var/obj/M in get_turf(loba))
				if(M && M.density)
					should = FALSE
			if (should)
				new /obj/structure/flora/tree/evil/long/lobby(get_turf(loba))
		else
			if(prob(20))
				var/should = TRUE
				for(var/obj/M in get_turf(loba))
					if(M && M.density)
						should = FALSE
				if (should)
					new /obj/effect/decal/grassev(get_turf(loba))
			else
				if(prob(30))
					var/should = TRUE
					for(var/obj/M in get_turf(loba))
						if(M && M.density)
							should = FALSE
					if (should)
						new /obj/effect/decal/grassevc(get_turf(loba))
		if(prob(70))
			loba.ChangeTurf(/turf/open/floor/plating/polovich/way/grassc, null, CHANGETURF_IGNORE_AIR)
		else
			if(prob(30))
				loba.ChangeTurf(/turf/open/floor/plating/polovich/way/dirtcv, null, CHANGETURF_IGNORE_AIR)
		if(prob(9))
			var/should = TRUE
			for(var/obj/M in get_turf(loba))
				if(M && M.density)
					should = FALSE
			if (should)
				new /obj/item/stone(get_turf(loba))
		else
			if(prob(10))
				var/should = TRUE
				for(var/obj/M in get_turf(loba))
					if(M && M.density)
						should = FALSE
				if (should)
					new /obj/item/melee/bita/branch(get_turf(loba))

		if(prob(10))
			var/should = TRUE
			for(var/obj/M in get_turf(loba))
				if(M && M.density)
					should = FALSE
			if (should)
				new /obj/structure/flora/ausbushes/bushkac(get_turf(loba))