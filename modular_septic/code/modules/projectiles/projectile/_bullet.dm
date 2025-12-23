/obj/projectile/bullet
	embedding = list("embed_chance"=35, \
					"fall_chance"=0, \
					"jostle_chance"=5, \
					"ignore_throwspeed_threshold"=TRUE, \
					"pain_stam_pct"=0.5, \
					"pain_mult"=0, \
					"pain_jostle_mult"=6,
					"rip_time"=20)
	wound_falloff_tile = -2
	embed_falloff_tile = 0
	ricochets_max = 2
	ricochet_chance = 20
	ricochet_incidence_leeway = 45
	sharpness = SHARP_IMPALING

/obj/projectile/bullet/on_hit(atom/target, blocked, pierce_hit, reduced, edge_protection)
	. = ..()
	if(. && isliving(target))
		var/mob/living/living_target = target
		if(!ishuman(living_target))
			return
			
		// Only apply special effects if damage is significant
		if(damage <= 10)
			return
			
		var/mob/living/carbon/human/human_target = living_target
		var/damage_dealt = damage
		
		// Calculate actual damage after blocking/protection
		if(blocked < 100)
			damage_dealt = damage - (damage * (blocked/100)) - reduced
		
		// Check for immobilization (endurance roll)
		if(human_target.diceroll(GET_MOB_ATTRIBUTE_VALUE(human_target, STAT_ENDURANCE), context = DICE_CONTEXT_MENTAL) <= DICE_SUCCESS)
			human_target.Immobilize(1.5 SECONDS)
		
		// Check for stun (endurance roll + damage check)
		if(damage_dealt > edge_protection && human_target.diceroll(GET_MOB_ATTRIBUTE_VALUE(human_target, STAT_ENDURANCE), context = DICE_CONTEXT_MENTAL) <= DICE_SUCCESS)
			human_target.Stun(1.5 SECONDS)
		
		// Check for stumble (dexterity roll)
		if(human_target.diceroll(GET_MOB_ATTRIBUTE_VALUE(human_target, STAT_DEXTERITY), context = DICE_CONTEXT_MENTAL) <= DICE_FAILURE)
			human_target.Stumble(2 SECONDS)
		
		// Check for confusion (endurance roll)
		if(human_target.diceroll(GET_MOB_ATTRIBUTE_VALUE(human_target, STAT_ENDURANCE), context = DICE_CONTEXT_MENTAL) <= DICE_FAILURE)
			// Scale confusion based on damage
			var/confusion_amount = min(round(damage_dealt / 5), 4)
			if(confusion_amount > 0)
				human_target.add_confusion(confusion_amount)
