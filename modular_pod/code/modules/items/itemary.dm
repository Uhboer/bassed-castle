/obj/item/oxygolot
	name = "Oxygolot"
	desc = "You know."
	icon = 'modular_septic/icons/obj/items/melee/pipe.dmi'
	icon_state = "oxygolot"

/obj/item/oxygolot/attack_self(mob/living/carbon/user, modifiers)
	. = ..()
	user.adjustOxyLoss((rand(40, 55)) - GET_MOB_ATTRIBUTE_VALUE(user, STAT_ENDURANCE))

/obj/item/craftorshit/instrument/swopper
	name = "Swopper"
	desc = "Your tool."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "swopper"

/obj/item/craftorshit/instrument/teether
	name = "Teether"
	desc = "Your tool."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "teether"

/obj/item/craftorshit/thing
	var/ready_to_be = FALSE
	var/will_be = null
	var/statustate = "NOT_READY"
	var/hits = 5
	var/hardnessizm = DICE_SUCCESS

/*
	var/attached_handle = FALSE
	var/attached_rings = FALSE
	var/attached_gold = FALSE
	var/attached_steel = FALSE
	var/attached_silver = FALSE
*/

/obj/item/craftorshit/thing/examine(mob/user)
	. = ..()
	if(statustate)
		if(statustate == "NOT_READY")
			. += span_notice("Right now, this thing isn't ready for anything.")
		if(statustate == "ARMOR")
			. += span_notice("This thing is ready to be armor.")
		if(statustate == "WEAPON")
			. += span_notice("This thing is ready to be weapon.")

/obj/item/craftorshit/thing/retarded
	name = "Retarded Thing"
	desc = "Its strange and retarded."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "retardedthing"

/obj/item/craftorshit/thing/retarded/alchemical
	name = "Retarded Thing"
	desc = "Its strange and retarded. Magical."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "retardedthing_magic"

/obj/item/craftorshit/thing/wooden
	name = "Wooden Thing"
	desc = "Its strange. Can be used for crafting."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "woodenthing"

/obj/item/craftorshit/thing/steel
	name = "Steel Thing"
	desc = "Very, very strange."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "steelthing"

/obj/item/craftorshit/thing/blood
	name = "Blood Thing"
	desc = "Very, very strange."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "bloodthing"

/obj/item/craftorshit/thing/iron
	name = "Iron Thing"
	desc = "Its strange. Can be used for crafting."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "ironthing"

/obj/item/craftorshit/thing/attackby(obj/item/I, mob/living/carbon/user, params)
	. = ..()
	if(istype(I, /obj/item/craftorshit/instrument/swopper))
		if(user.a_intent == INTENT_GRAB)
			playsound(get_turf(src), 'sound/items/ratchet.ogg', 75 , FALSE, FALSE)
			if(statustate == "NOT_READY")
				user.visible_message(span_notice("[user] readies the using of [src]."),span_notice("You ready the using of [src]."), span_hear("You hear the interesting sound."))
				statustate = "ARMOR"
			else if(statustate == "ARMOR")
				user.visible_message(span_notice("[user] changes the way of using [src]."),span_notice("You changing the way of using [src]."), span_hear("You hear the interesting sound."))
				statustate = "WEAPON"
			else if(statustate == "WEAPON")
				user.visible_message(span_notice("[user] changes the way of using [src]."),span_notice("You changing the way of using [src]."), span_hear("You hear the interesting sound."))
				statustate = "ARMOR"

	else if(istype(I, /obj/item/melee/bita/hammer/stone))
		if(user.a_intent == INTENT_HARM)
			if(will_be == null)
				if(statustate == "WEAPON")
					weaponize(user)
				else if(statustate == "ARMOR")
					armorize(user)
			else
				playsound(get_turf(src), 'modular_pod/sound/eff/anvili.ogg', 75 , FALSE, FALSE)
				if(hits > 0)
					hits -= 1
					user.visible_message(span_notice("[user] forges [src]."),span_notice("You forge [src]."), span_hear("You hear the sound of smithing."))
					sound_hint()
					var/obj/item/melee/bita/hammer/stone/V = I
					V.damageItem("HARD")
					user.changeNext_move(V.attack_delay)
					user.adjustFatigueLoss(10)
				else
					var/diceroll = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_SMITHING), context = DICE_CONTEXT_PHYSICAL)
					if(diceroll >= hardnessizm)
						user.visible_message(span_notice("[user] forged the item!"),span_notice("You forge the item."), span_hear("You hear the sound of smithing."))
						sound_hint()
						var/obj/item/melee/bita/hammer/stone/V = I
						V.damageItem("HARD")
						user.changeNext_move(V.attack_delay)
						user.adjustFatigueLoss(10)
						new will_be(get_turf(src))
						qdel(src)
					else
						user.visible_message(span_notice("[user] failed to forge something."),span_notice("You failed to forge something."), span_hear("You hear the sound of smithing."))
						sound_hint()
						var/obj/item/melee/bita/hammer/stone/V = I
						V.damageItem("HARD")
						user.changeNext_move(V.attack_delay)
						user.adjustFatigueLoss(10)
						new /obj/item/craftorshit/thing/retarded(get_turf(src))
						qdel(src)

/*
	else if(istype(I, /obj/item/craftorshit/instrument/teether))
		if(user.a_intent == INTENT_DISARM)
			if(condition > 0)
				if(statustate == "READY_HANDLE")
					if(hits > 0)
						if(!handle)
							hits -= 1
							user.visible_message(span_notice("[user] sawing [src]."),span_notice("You saw [src]."), span_hear("You hear the interesting sound."))
							sound_hint()
							user.changeNext_move(10)
							user.adjustFatigueLoss(5)
					else
						if(!handle)
							var/diceroll = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_SMITHING), context = DICE_CONTEXT_PHYSICAL)
							if(diceroll >= DICE_SUCCESS)
								user.visible_message(span_notice("[user] made a handle!"),span_notice("You made the handle."), span_hear("You hear the sound of smithing."))
								sound_hint()
								user.changeNext_move(10)
								user.adjustFatigueLoss(5)
								handle = TRUE
							else
								user.visible_message(span_notice("[user] failed to make handle."),span_notice("You failed to make handle."), span_hear("You hear the sound of smithing."))
								sound_hint()
								user.changeNext_move(10)
								user.adjustFatigueLoss(5)
								new /obj/item/craftorshit/thing/retarded(get_turf(src))
								qdel(src)
*/

///obj/item/craftorshit/thing/steel/attackby(obj/item/I, mob/living/carbon/user, params)
//	. = ..()

/*
	if(istype(I, /obj/item/craftorshit/instrument/teether))
		if(user.a_intent == INTENT_DISARM)
			if(condition > 0)
				if(statustate == "ARMOR")
					if(hits > 0)
*/

/*
						if(!attached_rings)
							hits -= 1
							user.visible_message(span_notice("[user] sawing [src]."),span_notice("You saw [src]."), span_hear("You hear the interesting sound."))
							sound_hint()
							user.changeNext_move(10)
							user.adjustFatigueLoss(5)
						else
							var/diceroll = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_SMITHING), context = DICE_CONTEXT_PHYSICAL)
							if(diceroll >= DICE_SUCCESS)
								user.visible_message(span_notice("[user] made ouroboros rings!"),span_notice("You made ouroboros rings."), span_hear("You hear the sound of smithing."))
								sound_hint()
								user.changeNext_move(10)
								user.adjustFatigueLoss(5)
								new /obj/item/craftorshit/thing/ouroboros(get_turf(src))
								qdel(src)
							else
								user.visible_message(span_notice("[user] failed to make ouroboros rings."),span_notice("You failed to make ouroboros rings."), span_hear("You hear the sound of smithing."))
								sound_hint()
								user.changeNext_move(10)
								user.adjustFatigueLoss(5)
								new /obj/item/craftorshit/thing/retarded(get_turf(src))
								qdel(src)
*/

/obj/item/craftorshit/thing/proc/weaponize(mob/living/carbon/user)
	var/thing = tgui_input_list(user, "What kind of weapon do you want to make?",, list("Sharp", "Blunt", "Unusual", ))
	if(!thing)
		return
	if(will_be != null)
		return
	if(thing == "Sharp")
		sharp_craft(user)
//	if(thing == "Blunt")
//		blunt_craft(user)
//	if(thing == "Unusual")
//		unusual_craft(user)

/obj/item/craftorshit/thing/proc/armorize(mob/living/carbon/user)
	var/thing = tgui_input_list(user, "What kind of armor do you want to make?",, list("Head", "Upper", "Under"))
	if(!thing)
		return
	if(will_be != null)
		return
//	if(thing == "Head")
//		head_craft(user)
//	if(thing == "Upper")
//		upper_craft(user)
//	if(thing == "Under")
//		under_craft(user)

/obj/item/craftorshit/thing/proc/sharp_craft(mob/living/carbon/user)
	var/thingy = tgui_input_list(user, "What kind of sharp weapon do you want to make?",, list("Steel Sword", "Steel Saber"))
	if(!thingy)
		return
	if(get_dist(src, user) >= 2)
		return
	switch(thingy)
		if("Steel Sword")
			if(!istype(src, /obj/item/craftorshit/thing/steel))
				to_chat(user, span_notice("Need a different material to create this item."))
				user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
				return
			will_be = /obj/item/podpol_weapon/sword
			hits = 10
		if("Steel Saber")
			if(!istype(src, /obj/item/craftorshit/thing/steel))
				to_chat(user, span_notice("Need a different material to create this item."))
				user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
				return
			will_be = /obj/item/podpol_weapon/sword
			hits = 7
			hardnessizm = DICE_CRIT_SUCCESS
		else
			return

/*
					if(user.zone_selected == BODY_ZONE_PRECISE_L_HAND)
						if(attached_handle)
							if(hits > 0)
								hits -= 1
								user.visible_message(span_notice("[user] forges [src]."),span_notice("You forge [src]."), span_hear("You hear the sound of smithing."))
								sound_hint()
								var/obj/item/melee/bita/hammer/stone/V = I
								V.damageItem("HARD")
								user.changeNext_move(V.attack_delay)
								user.adjustFatigueLoss(10)
							else
								var/diceroll = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_SMITHING), context = DICE_CONTEXT_PHYSICAL)
								if(diceroll >= DICE_SUCCESS)
									user.visible_message(span_notice("[user] forged the sword!"),span_notice("You forge the sword."), span_hear("You hear the sound of smithing."))
									sound_hint()
									var/obj/item/melee/bita/hammer/stone/V = I
									V.damageItem("HARD")
									user.changeNext_move(V.attack_delay)
									user.adjustFatigueLoss(10)
									new /obj/item/changeable_attacks/slashstabbash/sword/medium/steel(get_turf(src))
									qdel(src)
								else
									user.visible_message(span_notice("[user] failed to forge [src]."),span_notice("You failed to forge [src]."), span_hear("You hear the sound of smithing."))
									sound_hint()
									var/obj/item/melee/bita/hammer/stone/V = I
									V.damageItem("HARD")
									user.changeNext_move(V.attack_delay)
									user.adjustFatigueLoss(10)
									new /obj/item/craftorshit/thing/retarded(get_turf(src))
									qdel(src)
				else if(statustate == "READY_ARMOR")
					if(user.zone_selected == BODY_ZONE_CHEST)
						if(attached_rings)
							if(hits > 0)
								hits -= 1
								user.visible_message(span_notice("[user] forges [src]."),span_notice("You forge [src]."), span_hear("You hear the sound of smithing."))
								sound_hint()
								var/obj/item/melee/bita/hammer/stone/V = I
								V.damageItem("HARD")
								user.changeNext_move(V.attack_delay)
								user.adjustFatigueLoss(10)
							else
								var/diceroll = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_SMITHING), context = DICE_CONTEXT_PHYSICAL)
								if(diceroll >= DICE_SUCCESS)
									user.visible_message(span_notice("[user] forged the chainmail armor!"),span_notice("You forge the chainmail armor."), span_hear("You hear the sound of smithing."))
									sound_hint()
									var/obj/item/melee/bita/hammer/stone/V = I
									V.damageItem("HARD")
									user.changeNext_move(V.attack_delay)
									user.adjustFatigueLoss(10)
									new /obj/item/clothing/suit/armor/vest/chainmail/steel(get_turf(src))
									qdel(src)
								else
									user.visible_message(span_notice("[user] failed to forge [src]."),span_notice("You failed to forge [src]."), span_hear("You hear the sound of smithing."))
									sound_hint()
									var/obj/item/melee/bita/hammer/stone/V = I
									V.damageItem("HARD")
									user.changeNext_move(V.attack_delay)
									user.adjustFatigueLoss(10)
									new /obj/item/craftorshit/thing/retarded(get_turf(src))
									qdel(src)



/obj/item/craftorshit/thing/golden
	name = "Golden Thing"
	desc = "Its strange. Can be used for crafting."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "goldenthing"
	metallic = TRUE

/obj/item/craftorshit/thing/golden/attackby(obj/item/I, mob/living/carbon/user, params)
	. = ..()
	if(istype(I, /obj/item/craftorshit/instrument/swopper))
		if(user.a_intent == INTENT_GRAB)
			if(condition > 0)
				if(statustate == "NOT_READY")
					user.visible_message(span_notice("[user] readies the using of [src]."),span_notice("You ready the using of [src]."), span_hear("You hear the interesting sound."))
					sound_hint()
					statustate = "READY_WEAPON"
				else if(statustate == "READY_WEAPON")
					user.visible_message(span_notice("[user] changes the way of using [src]."),span_notice("You changing the way of using [src]."), span_hear("You hear the interesting sound."))
					sound_hint()
					statustate = "READY_ARMOR"
				else if(statustate == "READY_ARMOR")
					user.visible_message(span_notice("[user] changes the way of using [src]."),span_notice("You changing the way of using [src]."), span_hear("You hear the interesting sound."))
					sound_hint()
					statustate = "READY_WEAPON"
	else if(istype(I, /obj/item/craftorshit/thing/golden))
		if(user.a_intent == INTENT_GRAB)
			if(condition > 0)
				if(statustate == "READY_ARMOR")
					if(attached_gold)
						return
					var/diceroll = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_SMITHING), context = DICE_CONTEXT_PHYSICAL)
					if(diceroll >= DICE_SUCCESS)
						user.visible_message(span_notice("[user] combined gold!"),span_notice("You combine the gold."), span_hear("You hear the sound of smithing."))
						sound_hint()
						user.changeNext_move(10)
						user.adjustFatigueLoss(5)
						attached_gold = TRUE
					else
						user.visible_message(span_notice("[user] failed to combine gold."),span_notice("You failed to combine gold."), span_hear("You hear the sound of smithing."))
						sound_hint()
						user.changeNext_move(10)
						user.adjustFatigueLoss(5)
	else if(istype(I, /obj/item/melee/bita/hammer/stone))
		if(user.a_intent == INTENT_HARM)
			if(condition > 0)
				if(statustate == "READY_ARMOR")
					if(user.zone_selected == BODY_ZONE_HEAD)
						if(attached_gold)
							if(hits > 0)
								hits -= 1
								user.visible_message(span_notice("[user] forges [src]."),span_notice("You forge [src]."), span_hear("You hear the sound of smithing."))
								sound_hint()
								var/obj/item/melee/bita/hammer/stone/V = I
								V.damageItem("HARD")
								user.changeNext_move(V.attack_delay)
								user.adjustFatigueLoss(10)
							else
								var/diceroll = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_SMITHING), context = DICE_CONTEXT_PHYSICAL)
								if(diceroll >= DICE_SUCCESS)
									user.visible_message(span_notice("[user] forged the golden helmet!"),span_notice("You forge the golden helmet."), span_hear("You hear the sound of smithing."))
									sound_hint()
									var/obj/item/melee/bita/hammer/stone/V = I
									V.damageItem("HARD")
									user.changeNext_move(V.attack_delay)
									user.adjustFatigueLoss(10)
									new /obj/item/clothing/head/helmet/golden/full(get_turf(src))
									qdel(src)
								else
									user.visible_message(span_notice("[user] failed to forge [src]."),span_notice("You failed to forge [src]."), span_hear("You hear the sound of smithing."))
									sound_hint()
									var/obj/item/melee/bita/hammer/stone/V = I
									V.damageItem("HARD")
									user.changeNext_move(V.attack_delay)
									user.adjustFatigueLoss(10)
									new /obj/item/craftorshit/thing/retarded(get_turf(src))
									qdel(src)

/obj/item/craftorshit/thing/silver
	name = "Silver Thing"
	desc = "Its strange. Can be used for crafting."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "silverthing"
	metallic = TRUE

/obj/item/craftorshit/thing/silver/attackby(obj/item/I, mob/living/carbon/user, params)
	. = ..()
	if(istype(I, /obj/item/craftorshit/instrument/swopper))
		if(user.a_intent == INTENT_GRAB)
			if(condition > 0)
				if(statustate == "NOT_READY")
					user.visible_message(span_notice("[user] readies the using of [src]."),span_notice("You ready the using of [src]."), span_hear("You hear the interesting sound."))
					sound_hint()
					statustate = "READY_WEAPON"
				else if(statustate == "READY_WEAPON")
					user.visible_message(span_notice("[user] changes the way of using [src]."),span_notice("You changing the way of using [src]."), span_hear("You hear the interesting sound."))
					sound_hint()
					statustate = "READY_ARMOR"
					hits = 10
				else if(statustate == "READY_ARMOR")
					user.visible_message(span_notice("[user] changes the way of using [src]."),span_notice("You changing the way of using [src]."), span_hear("You hear the interesting sound."))
					sound_hint()
					statustate = "READY_WEAPON"
					hits = 10

	else if(istype(I, /obj/item/melee/bita/hammer/stone))
		if(user.a_intent == INTENT_HARM)
			if(condition > 0)
				if(statustate == "READY_ARMOR")
					if(user.zone_selected == BODY_ZONE_HEAD)
						if(attached_silver)
							if(hits > 0)
								hits -= 1
								user.visible_message(span_notice("[user] forges [src]."),span_notice("You forge [src]."), span_hear("You hear the sound of smithing."))
								sound_hint()
								var/obj/item/melee/bita/hammer/stone/V = I
								V.damageItem("HARD")
								user.changeNext_move(V.attack_delay)
								user.adjustFatigueLoss(10)
							else
								var/diceroll = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_SMITHING), context = DICE_CONTEXT_PHYSICAL)
								if(diceroll >= DICE_SUCCESS)
									user.visible_message(span_notice("[user] forged the silver helmet!"),span_notice("You forge the silver helmet."), span_hear("You hear the sound of smithing."))
									sound_hint()
									var/obj/item/melee/bita/hammer/stone/V = I
									V.damageItem("HARD")
									user.changeNext_move(V.attack_delay)
									user.adjustFatigueLoss(10)
									new /obj/item/clothing/head/helmet/silver/full(get_turf(src))
									qdel(src)
								else
									user.visible_message(span_notice("[user] failed to forge [src]."),span_notice("You failed to forge [src]."), span_hear("You hear the sound of smithing."))
									sound_hint()
									var/obj/item/melee/bita/hammer/stone/V = I
									V.damageItem("HARD")
									user.changeNext_move(V.attack_delay)
									user.adjustFatigueLoss(10)
									new /obj/item/craftorshit/thing/retarded(get_turf(src))
									qdel(src)

	else if(istype(I, /obj/item/craftorshit/thing/silver))
		if(user.a_intent == INTENT_GRAB)
			if(condition > 0)
				if(statustate == "READY_ARMOR")
					if(attached_silver)
						return
					var/diceroll = user.diceroll(GET_MOB_SKILL_VALUE(user, SKILL_SMITHING), context = DICE_CONTEXT_PHYSICAL)
					if(diceroll >= DICE_SUCCESS)
						user.visible_message(span_notice("[user] combined silver!"),span_notice("You combine the silver."), span_hear("You hear the sound of smithing."))
						sound_hint()
						user.changeNext_move(10)
						user.adjustFatigueLoss(5)
						attached_silver = TRUE
						qdel(src)
					else
						user.visible_message(span_notice("[user] failed to combine silver."),span_notice("You failed to combine silver."), span_hear("You hear the sound of smithing."))
						sound_hint()
						user.changeNext_move(10)
						user.adjustFatigueLoss(5)

/obj/item/craftorshit/thing/ouroboros
	name = "Ouroboros Rings"
	desc = "Its strange. Can be used for crafting."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "ouro_rings"
	metallic = TRUE
*/

/obj/item/melee/hehe/pickaxe/iron
	name = "Pickaxe"
	desc = "DIG, SLAVE!"
	icon = 'modular_pod/icons/obj/items/weapons.dmi'
	lefthand_file = 'modular_septic/icons/mob/inhands/remis_lefthand.dmi'
	righthand_file = 'modular_septic/icons/mob/inhands/remis_righthand.dmi'
	icon_state = "ironpickaxe"
	inhand_icon_state = "ironpickaxe"
	worn_icon = 'modular_septic/icons/mob/clothing/belt.dmi'
	worn_icon_state = "ironpickaxe"
	equip_sound = 'modular_pod/sound/eff/weapon/sheath_default.ogg'
	pickup_sound = 'modular_pod/sound/eff/weapon/draw_default.ogg'
	miss_sound = list('modular_pod/sound/eff/weapon/swing_default.ogg')
	drop_sound = 'modular_septic/sound/effects/fallsmall.ogg'
	hitsound = list('modular_pod/sound/eff/weapon/hit_default.ogg')
	w_class = WEIGHT_CLASS_NORMAL
	wound_bonus = 5
	bare_wound_bonus = 6
	min_force = 15
	force = 18
	min_force_strength = 1
	throwforce = 8
	force_strength = 1.8
	sharpness = SHARP_POINTY
	embedding = list("pain_mult" = 10, "rip_time" = 5, "embed_chance" = 60, "jostle_chance" = 5, "pain_stam_pct" = 2, "pain_jostle_mult" = 9, "fall_chance" = 0.1, "ignore_throwspeed_threshold" = TRUE)
	skill_melee = SKILL_IMPACT_WEAPON
	readying_flags = READYING_FLAG_JUSTCAUSE
	carry_weight = 2 KILOGRAMS
	attack_fatigue_cost = 17
	attack_delay = 25
	armor_damage_modifier = 3
	edge_protection_penetration = 10
	subtractible_armour_penetration = 50
//	armour_penetration = 10
	parrying_flags = BLOCK_FLAG_UNARMED
	havedurability = TRUE
	durability = 130
	tetris_width = 32
	tetris_height = 64
	slot_flags = ITEM_SLOT_BELT
	can_dig = TRUE
	attack_verb_continuous = list("stabs")
	attack_verb_simple = list("stab")

/obj/item/pinker_caller
	name = "PINKER Caller"
	desc = "CALL HIM!"
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "pinker"
	var/usedy = FALSE

/obj/item/pinker_caller/attack_self(mob/living/carbon/user, modifiers)
	. = ..()
	if(usedy)
		return
	var/srd = CONFIG_GET(number/shuttle_refuel_delay)
	if(world.time - SSticker.round_start_time < srd)
		to_chat(user, span_notice("The PINKER is getting ready. Please wait [DisplayTimeText(srd - (world.time - SSticker.round_start_time))] before attempting to call."))
		return
	SSshuttle.emergency.request()
	usedy = TRUE
	user.client?.prefs?.adjust_bobux(100, "<span class='bobux'>I called the PINKER! +100 kaotiks!</span>")

/obj/item/atrat
	name = "Atrat"
	desc = "Femboy sex."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "atrat"
	var/usedy = FALSE

/*
/obj/item/atrat/attack_self(mob/living/carbon/user, modifiers)
	. = ..()
	if(usedy)
		return
	usedy = TRUE
	addtimer(CALLBACK(src, .proc/restart_use), 50 SECONDS)
*/

/obj/item/atrat/attack_atom(atom/attacked_atom, mob/living/carbon/user, params)
	if(!isturf(attacked_atom))
		return
	if(isopenspaceturf(attacked_atom) || isspaceturf(attacked_atom))
		return
	if(!usedy)
		new /atom/movable/fire(attacked_atom, 21)
		usedy = TRUE
		addtimer(CALLBACK(src, .proc/restart_use), 50 SECONDS)

/obj/item/atrat/proc/restart_use()
	if(QDELETED(src) || !usedy)
		return
	usedy = FALSE

/obj/item/craftitem/foliage
	name = "Foliage"
	desc = "It was obtained from a crystal bush."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "foliage"

/obj/item/craftitem/foliage/attack_self(mob/living/carbon/user, modifiers)
	. = ..()
	if(user.a_intent != INTENT_GRAB)
		return
	var/time = 15 SECONDS
	time -= (GET_MOB_SKILL_VALUE(user, SKILL_AGRICULTURE) * 0.75 SECONDS)
	playsound(src,'sound/effects/shelest.ogg', 60, TRUE)
	if(!do_after(user, time, target = src))
		to_chat(user, span_danger(xbox_rage_msg()))
		user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return
	user.visible_message(span_notice("[user] unties the [src]."),span_notice("You untie the [src]."), span_hear("You hear the sound of shag."))
	user.changeNext_move(CLICK_CD_MELEE)
	user.Immobilize(1 SECONDS)
	sound_hint()
	playsound(src,'sound/effects/shelest.ogg', 60, TRUE)
	new /obj/item/stack/medical/suture/three(get_turf(src))
	qdel(src)

/obj/item/reagent_containers/food/drinks/bottle/beer/polovich
	name = "Beer"
	desc = "Good fucking beer."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "pivas"
	volume = 30
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 30)
	foodtype = GRAIN | ALCOHOL
	custom_price = PAYCHECK_EASY



// Existing code above this line remains unchanged

/obj/item/weapon/mortar
	name = "Portable Mortar"
	desc = "A heavy portable mortar system that can be deployed on the ground."
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "mortar"
	w_class = WEIGHT_CLASS_HUGE // Very heavy
	slot_flags = ITEM_SLOT_BACK // Fixed: SLOT_BACK to ITEM_SLOT_BACK
	var/deployed = FALSE
	var/obj/item/mortar_shell/loaded_shell = null
	var/fire_range = 20 // Maximum firing range

/obj/item/weapon/mortar/attack_self(mob/user)
	if(!deployed)
		deploy(user)
	else
		fold(user)

/obj/item/weapon/mortar/proc/deploy(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "<span class='warning'>You need to be on solid ground to deploy [src]!</span>")
		return
	
	user.visible_message("<span class='notice'>[user] starts to deploy [src]...</span>", 
						"<span class='notice'>You start to deploy [src]...</span>")
	
	if(do_after(user, 2 SECONDS, target = user)) // Takes 2 seconds to deploy
		deployed = TRUE
		anchored = TRUE
		density = TRUE
		icon_state = "mortar_installed"
		// Fixed: user.drop_item() to proper item dropping
		user.dropItemToGround(src)
		undo_messy()
		user.visible_message("<span class='notice'>[user] deploys [src].</span>", 
							"<span class='notice'>You deploy [src].</span>")
	
/obj/item/weapon/mortar/proc/fold(mob/user)
	if(loaded_shell)
		to_chat(user, "<span class='warning'>You need to remove the loaded shell first!</span>")
		return
		
	user.visible_message("<span class='notice'>[user] starts to fold [src]...</span>", 
						"<span class='notice'>You start to fold [src]...</span>")
	
	if(do_after(user, 2 SECONDS, target = user)) // Takes 2 seconds to fold
		deployed = FALSE
		anchored = FALSE
		density = FALSE
		icon_state = "mortar"
		user.put_in_hands(src)
		user.visible_message("<span class='notice'>[user] folds [src].</span>", 
							"<span class='notice'>You fold [src].</span>")

/obj/item/weapon/mortar/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mortar_shell))
		if(!deployed)
			to_chat(user, "<span class='warning'>You need to deploy [src] first!</span>")
			return
		
		if(loaded_shell)
			to_chat(user, "<span class='warning'>[src] already has a shell loaded!</span>")
			return
			
		I.forceMove(src)
		loaded_shell = I
		to_chat(user, "<span class='notice'>You load [I] into [src].</span>")
		return TRUE

/obj/item/weapon/mortar/attack_hand(mob/user)
	. = ..()
	if(deployed && loaded_shell && user.get_active_held_item() == null) // Fixed: get_active_hand to get_active_held_item
		to_chat(user, "<span class='notice'>You remove [loaded_shell] from [src].</span>")
		user.put_in_hands(loaded_shell)
		loaded_shell = null
		return TRUE
	// If the mortar is deployed but has no shell, fold it
	else if(deployed && !loaded_shell && user.get_active_held_item() == null) // Fixed: get_active_hand to get_active_held_item
		fold(user)
		return TRUE

/obj/item/weapon/mortar/MouseDrop(atom/over_object)
	if(!deployed)
		return ..()
	return FALSE

/obj/item/weapon/mortar/attack_hand_secondary(mob/user)
	if(!deployed)
		return
	
	if(!loaded_shell)
		to_chat(user, "<span class='warning'>You need to load a shell first!</span>")
		return
		
	fire_mortar(user)
	return TRUE

/obj/item/weapon/mortar/proc/fire_mortar(mob/user)
	// First prompt for direction and distance
	var/direction = input(user, "Select firing direction:", "Mortar Direction") as null|anything in list("North", "Northeast", "East", "Southeast", "South", "Southwest", "West", "Northwest")
	if(!direction)
		return
		
	var/distance = input(user, "Enter firing distance (1-[fire_range]):", "Mortar Range") as null|num
	if(!distance || distance < 1 || distance > fire_range)
		to_chat(user, "<span class='warning'>Invalid distance!</span>")
		return
	
	// Confirm firing
	var/confirm = alert(user, "Fire [loaded_shell] [distance] tiles [direction]?", "Confirm Firing", "Fire", "Cancel")
	if(confirm != "Fire")
		return
	
	// Convert direction string to actual direction
	var/dir_num = 0
	switch(direction)
		if("North") dir_num = NORTH
		if("Northeast") dir_num = NORTHEAST
		if("East") dir_num = EAST
		if("Southeast") dir_num = SOUTHEAST
		if("South") dir_num = SOUTH
		if("Southwest") dir_num = SOUTHWEST
		if("West") dir_num = WEST
		if("Northwest") dir_num = NORTHWEST
	
	// Calculate target turf
	var/turf/target = get_ranged_target_turf(get_turf(src), dir_num, distance)
	
	// Fire animation and sound
	user.visible_message("<span class='danger'>[user] fires [src]!</span>", 
						"<span class='danger'>You fire [src]!</span>")
	// Fixed: Using a sound that exists in the codebase
	playsound(src, 'sound/weapons/gun/general/heavy_shot_suppressed.ogg', 100, TRUE, 15)
	
	// Create projectile and launch it
	var/obj/projectile/mortar_projectile/P = new(get_turf(src))
	P.shell_type = loaded_shell.type
	P.set_flight_path(target)
	
	// Remove the loaded shell
	qdel(loaded_shell)
	loaded_shell = null

/obj/item/mortar_shell
	name = "Mortar Shell"
	desc = "A standard explosive shell for a mortar."
	icon = 'modular_pod/icons/content_6.dmi'
	icon_state = "mortar_shell" // Make sure this icon state exists
	w_class = WEIGHT_CLASS_NORMAL
	var/explosion_range = 2
	var/explosion_power = 2

/obj/item/mortar_shell/fragmentation
	name = "Fragmentation Mortar Shell"
	desc = "A fragmentation shell for a mortar. Effective against infantry."
	icon_state = "mortar_shell_frag"
	explosion_range = 3
	explosion_power = 1
	var/shrapnel_count = 15
	var/shrapnel_range = 5

/obj/item/mortar_shell/incendiary
	name = "Incendiary Mortar Shell"
	desc = "An incendiary shell for a mortar. Sets the target area ablaze."
	icon_state = "mortar_shell_fire"
	explosion_range = 1
	explosion_power = 1
	var/fire_range = 3
	var/fire_intensity = 30

// Projectile that represents the mortar shell in flight
/obj/projectile/mortar_projectile
	name = "Mortar Shell"
//	icon = 'icons/obj/projectiles.dmi'
//	icon_state = "grenade" // Using an existing projectile icon
	// Fixed: Adding required projectile vars
	nodamage = TRUE
	damage = 0
	var/shell_type = null
	var/flight_time = 30 // Time in deciseconds before impact
	var/turf/target_turf = null

/obj/projectile/mortar_projectile/proc/set_flight_path(turf/target)
	target_turf = target
	alpha = 0 // Make invisible during flight
	
	// Start the flight
	addtimer(CALLBACK(src, .proc/impactt), flight_time)
	
	// Visual indicator at target location
	var/obj/effect/temp_visual/mortar_target/target_marker = new(target)
	// We'll set the lifespan directly instead of using duration to avoid conflicts
	target_marker.alpha = 0 // Make it visible

/obj/projectile/mortar_projectile/proc/impactt()
	if(!target_turf)
		qdel(src)
		return
		
	forceMove(target_turf)
	alpha = 255 // Make visible on impact
	
	// Fixed: Using a sound that exists in the codebase
	playsound(src, 'sound/weapons/sonic_jackhammer.ogg', 100, TRUE, 15)
	
	// Different effects based on shell type
	if(shell_type == /obj/item/mortar_shell/fragmentation)
		var/obj/item/mortar_shell/fragmentation/frag_shell = new shell_type()
		explosion(get_turf(src), 0, 1, frag_shell.explosion_range, flame_range = 0)
		create_shrapnel(frag_shell.shrapnel_count, frag_shell.shrapnel_range)
	else if(shell_type == /obj/item/mortar_shell/incendiary)
		var/obj/item/mortar_shell/incendiary/fire_shell = new shell_type()
		explosion(get_turf(src), 0, 0, fire_shell.explosion_range, flame_range = fire_shell.fire_range)
		create_fire(fire_shell.fire_range, fire_shell.fire_intensity)
	else
		var/obj/item/mortar_shell/standard_shell = new shell_type()
		explosion(get_turf(src), 0, standard_shell.explosion_power, standard_shell.explosion_range, flame_range = 1)
	
	qdel(src)

/obj/projectile/mortar_projectile/proc/create_shrapnel(count, range)
	for(var/i = 1 to count)
		var/turf/target = get_ranged_target_turf(get_turf(src), pick(GLOB.alldirs), rand(1, range))
		var/obj/projectile/bullet/shrapnel/S = new(get_turf(src))
		S.starting = get_turf(src)
		S.preparePixelProjectile(target, get_turf(src))
		S.fire()

/obj/projectile/mortar_projectile/proc/create_fire(range, intensity)
	for(var/turf/T in range(range, get_turf(src)))
		if(prob(intensity) && !T.density)
			new /obj/effect/hotspot(T)
			T.hotspot_expose(700, 50, 1)

// Visual effect for the target marker - fixed to avoid duplicate definition
/obj/effect/temp_visual/mortar_target
	name = "target marker"
	icon = 'icons/effects/effects.dmi'
	icon_state = "target_indicator" // Make sure this exists or use another icon
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	alpha = 0
	// Not defining duration here to avoid conflicts

/obj/effect/temp_visual/mortar_target/Initialize()
	. = ..()
	QDEL_IN(src, 30) // Using direct timing instead of duration
	// Fixed: Using a sound that exists in the codebase
	playsound(src, 'sound/weapons/armbomb.ogg', 70, TRUE, 15)

// Existing code below this line remains unchanged