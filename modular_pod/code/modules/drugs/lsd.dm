// Datum shit   !!! lysergic acid diethylamide

/datum/reagent/medicine/lsd
	name = "LSD"
	description = "The most popular psychodelic."
	ph = 7
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_METABOLISM * 0.10
	self_consuming = FALSE
	color = "#ffffff0a"
	overdose_threshold = INFINITY

/datum/reagent/medicine/lsd/overdose_start(mob/living/M)
	. = ..()

/datum/reagent/medicine/morphine/on_mob_metabolize(mob/living/L)
	. = ..()

/datum/reagent/medicine/morphine/on_mob_end_metabolize(mob/living/L)
	. = ..()

/datum/reagent/medicine/lsd/on_mob_metabolize(mob/living/L)


	. = ..()

/datum/reagent/medicine/lsd/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	if(current_cycle >= 300)
		var/effect_rand = rand(10, 91)
		switch(effect_rand)
			if(10 to 20)
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/happiness_drug_bad_od)
			if(21 to 31)
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/stimulant_medium)
			if(32 to 43)
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/narcotic_medium)
			if(44 to 55)
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/narcotic_heavy)
			if(56 to 67)
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/happiness_drug)
			if(68 to 79)
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/happiness_drug_good_od)
			if(80 to 91)
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/eigentrip)
	return ..()

// ITEMS

/obj/item/reagent_containers/glass/bottle/lsd
	name = "LSD bottle"
	desc = "A small bottle of LSD."
	list_reagents = list(/datum/reagent/medicine/lsd = 30)

/obj/item/reagent_containers/syringe/lsd
	name = "LSD syringe"
	desc = "Contains LSD."
	list_reagents = list(/datum/reagent/medicine/lsd = 15)

/obj/item/reagent_containers/food/drinks/bottle/small/lsd
	list_reagents = list(
		/datum/reagent/medicine/lsd = 50,
	)

/obj/item/food/marka_lsd
	name = "cardboard"
	desc = "This thing looks like cardboard soaked with LSD."
	w_class = WEIGHT_CLASS_TINY
	icon = 'modular_pod/icons/obj/items/drugs.dmi'
	icon_state = "acid"
	food_reagents = list(/datum/reagent/medicine/lsd = 1)
	max_volume = 1
	eat_time = 0
	tastes = "it has no taste."
	eatverbs = "swallow"





