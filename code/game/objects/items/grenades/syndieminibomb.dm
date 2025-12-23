/obj/item/grenade/syndieminibomb
	desc = "A syndicate manufactured explosive used to sow destruction and chaos."
	name = "syndicate minibomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "syndicate"
	inhand_icon_state = "flashbang"
	worn_icon_state = "minibomb"
	ex_dev = 1
	ex_heavy = 2
	ex_light = 4
	ex_flame = 2

/obj/item/grenade/syndieminibomb/detonate(mob/living/lanced_by)
	// The parent function will handle the explosion using our preset explosion variables
	. = ..()
	
	// Just handle the pollution and cleanup
	var/turf/explosionturf = get_turf(src)
	if(explosionturf)
		explosionturf.pollute_turf(/datum/pollutant/dust, 200)
	
	if(!QDELETED(src))
		qdel(src)

/obj/item/grenade/syndieminibomb/concussion
	name = "HE Grenade"
	desc = "A compact shrapnel grenade meant to devastate nearby organisms and cause some damage in the process. Pull pin and throw opposite direction."
	icon_state = "concussion"
	ex_heavy = 2
	ex_light = 3
	ex_flame = 3

/obj/item/grenade/frag
	name = "Frag Grenade"
	desc = "Another tool of destruction."
	icon_state = "frag"
	ex_heavy = 1
	ex_light = 3
	ex_flame = 2

/obj/item/grenade/frag/mega
	name = "FRAG grenade"
	desc = "An anti-everything fragmentation grenade, this weapon excels at killing anything any everything by shredding them with metal shrapnel."
	shrapnel_type = /obj/projectile/bullet/shrapnel/mega
	shrapnel_radius = 12

/obj/item/grenade/frag/detonate(mob/living/lanced_by)
	// Set the grenade to be indestructible before doing anything else to prevent the runtime
	resistance_flags |= INDESTRUCTIBLE
	
	// Get the turf before any potential nullspace operations
	var/turf/explosionturf = get_turf(src)
	if(explosionturf)
		explosionturf.pollute_turf(/datum/pollutant/dust, 200)
	
	// We already have explosion ranges set in the grenade vars
	// Just call the parent detonate without causing a double explosion
	. = ..()
	
	// Ensure the grenade gets cleaned up
	if(!QDELETED(src))
		qdel(src)

/obj/item/grenade/gluon
	desc = "An advanced grenade that releases a harmful stream of gluons inducing radiation in those nearby. These gluon streams will also make victims feel exhausted, and induce shivering. This extreme coldness will also likely wet any nearby floors."
	name = "gluon frag grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "bluefrag"
	inhand_icon_state = "flashbang"
	var/freeze_range = 4
	var/rad_range = 4
	var/rad_threshold = RAD_EXTREME_INSULATION
	var/stamina_damage = 30
	var/temp_adjust = -230

/obj/item/grenade/gluon/detonate(mob/living/lanced_by)
	// Set explosion variables to 0 to avoid parent explosion
	ex_dev = 0
	ex_heavy = 0
	ex_light = 0
	ex_flame = 0
	
	. = ..()
	update_mob()
	playsound(loc, 'sound/effects/empulse.ogg', 50, TRUE)
	radiation_pulse(src, max_range = rad_range, threshold = rad_threshold, chance = 100)
	for (var/turf/open/floor/floor in view(freeze_range, loc))
		floor.MakeSlippery(TURF_WET_PERMAFROST, 6 MINUTES)
		for(var/mob/living/carbon/victim in floor)
			victim.adjustStaminaLoss(stamina_damage)
			victim.adjust_bodytemperature(temp_adjust)
	qdel(src)
