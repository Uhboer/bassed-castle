// Code for handling falling through openspace and causing damage when landing on other mobs
// When an object or mob falls through openspace, this will process causing damage to mobs below

/// Define for the minimum damage needed to consider a falling impact
#define MIN_FALL_DAMAGE 5

/**
 * Handles the aftermath of something falling onto a turf
 *
 * For mobs: applies damage both to the falling mob and any mobs it lands on
 * Uses the weight system for more realistic damage calculations.
 * 
 * Arguments:
 * * falling_atom - The atom that fell
 * * levels_fallen - How many z-levels the atom fell before landing
 */
/turf/proc/handle_fall_impact(atom/movable/falling_atom, levels_fallen = 1)
	if(!falling_atom || !levels_fallen)
		return
	
	// Minimum of 1 level fallen
	levels_fallen = max(levels_fallen, 1)
	
	// Base damage modifier based on levels fallen
	var/damage_mod = levels_fallen * 0.5
	
	// Check if there are any mobs on this turf to damage
	var/list/potential_victims = list()
	for(var/mob/living/victim in src)
		if(victim != falling_atom)
			potential_victims += victim
	
	// If we have potential victims, apply damage
	if(length(potential_victims))
		// If the falling atom is a mob, they also take damage from the landing
		if(isliving(falling_atom))
			var/mob/living/falling_mob = falling_atom
			// Calculate falling damage to the mob itself based on weight and height fallen
			var/self_damage = 0
			
			// Get falling mob's weight
			var/falling_weight = 0
			if(iscarbon(falling_mob))
				var/mob/living/carbon/falling_carbon = falling_mob
				falling_weight = falling_carbon.carry_weight
				
				// Factor in attributes for damage calculation
				var/strength_val = GET_MOB_ATTRIBUTE_VALUE(falling_carbon, STAT_STRENGTH)
				var/endurance_val = GET_MOB_ATTRIBUTE_VALUE(falling_carbon, STAT_ENDURANCE)
				
				// Damage scaling with strength and endurance
				// Higher strength = less damage to self from falling (better landing)
				var/attribute_modifier = 1 - ((strength_val - ATTRIBUTE_MIDDLING) * 0.02)
				attribute_modifier = max(0.7, attribute_modifier) // Cap damage reduction
				
				// Higher endurance = less damage from falling
				if(endurance_val > ATTRIBUTE_MIDDLING)
					attribute_modifier -= ((endurance_val - ATTRIBUTE_MIDDLING) * 0.01)
				
				// Calculate self damage
				self_damage = (falling_weight * levels_fallen * 0.2) * attribute_modifier
			else
				// Rough approximation for non-carbon mobs
				falling_weight = falling_mob.mob_size * 5
				self_damage = falling_weight * levels_fallen * 0.15
			
			// Minimum damage amount
			self_damage = max(5, self_damage)
			
			// Cap damage to prevent one-shots
			self_damage = min(self_damage, 50)
			
			// Check for armor to reduce falling damage
			var/armor_block = falling_mob.run_armor_check(null, MELEE, "Your armor absorbs the impact!", "Your armor softens the impact!")
			self_damage = max(0, self_damage * (100 - armor_block) / 100)
			
			// Apply damage to the falling mob
			var/obj/item/bodypart/bodypart_to_damage
			var/list/possible_limbs = list()
			
			// Generate list of possible limbs to damage for the falling mob
			if(iscarbon(falling_mob))
				var/mob/living/carbon/carbon_mob = falling_mob
				possible_limbs = list(
					carbon_mob.get_bodypart(BODY_ZONE_R_LEG),
					carbon_mob.get_bodypart(BODY_ZONE_L_LEG),
					carbon_mob.get_bodypart(BODY_ZONE_CHEST)
				)
				// Filter out null limbs
				for(var/i = 1, i <= length(possible_limbs), i++)
					if(!possible_limbs[i])
						possible_limbs.Remove(possible_limbs[i])
						i--
			
			// Apply damage to a random limb, or just apply general damage if no limbs available
			if(length(possible_limbs))
				bodypart_to_damage = pick(possible_limbs)
				// Apply damage to the falling mob's limb
				bodypart_to_damage.receive_damage(brute = self_damage)
				// Add a visible message for the falling damage
				falling_mob.visible_message(span_danger("<b>[falling_mob]</b> crashes to the ground, landing on [falling_mob.p_their()] [bodypart_to_damage.name]!"), 
										  span_userdanger("I crash to the ground, landing on my [bodypart_to_damage.name]!"))
			else
				// Just apply general damage if we couldn't find limbs
				falling_mob.apply_damage(self_damage, BRUTE)
				falling_mob.visible_message(span_danger("<b>[falling_mob]</b> crashes to the ground!"), 
										  span_userdanger("I crash to the ground!"))
				
			// Formula for knock down chance based on weight, height, and damage
			var/knockdown_chance = min(80, self_damage * 2 + levels_fallen * 10)
			
			// Higher chance to get knocked down with higher weight or falling from higher levels
			if(self_damage > 20 || levels_fallen >= 2)
				if(prob(knockdown_chance))
					var/stun_time = clamp(levels_fallen * 1 SECONDS, 2 SECONDS, 5 SECONDS)
					falling_mob.Paralyze(stun_time)
					falling_mob.visible_message(span_warning("<b>[falling_mob]</b> is knocked down by the impact!"), 
											   span_userdanger("The impact knocks me to the ground!"))
		
		// Now handle damage to victims the falling atom landed on
		for(var/mob/living/victim in potential_victims)
			// If the victim is a carbon with bodyparts, target a specific bodypart
			if(iscarbon(victim))
				var/mob/living/carbon/carbon_victim = victim
				var/list/possible_hit_zones = list(
					BODY_ZONE_HEAD,
					BODY_ZONE_CHEST,
					BODY_ZONE_L_ARM,
					BODY_ZONE_R_ARM,
					BODY_ZONE_PRECISE_VITALS
				)
				// Randomly select a hit zone
				var/hit_zone = pick(possible_hit_zones)
				var/obj/item/bodypart/bodypart_to_damage = carbon_victim.get_bodypart(hit_zone)
				
				if(bodypart_to_damage)
					// Use the enhanced bodypart receive_falling_damage which includes armor checks
					var/damage_type = WOUND_BLUNT  // Default to blunt damage for all falling objects
					
					// Let the bodypart handle the fall impact with the falling atom
					bodypart_to_damage.receive_falling_damage(falling_atom, damage_mod + (levels_fallen * 0.3), damage_type)
					
					// Additional knockdown chance for victims
					var/victim_knockdown_chance = 0
					
					// Calculate knockdown chance based on falling atom's properties
					if(isliving(falling_atom))
						var/mob/living/falling_mob = falling_atom
						var/falling_weight = 0
						
						// Get falling mob's weight 
						if(iscarbon(falling_mob))
							var/mob/living/carbon/falling_carbon = falling_mob
							falling_weight = falling_carbon.carry_weight
						else
							falling_weight = falling_mob.mob_size * 5
						
						// Calculate knockdown chance based on weight difference
						var/victim_weight = 0
						if(iscarbon(victim))
							var/mob/living/carbon/carbon_victim = victim
							victim_weight = carbon_victim.carry_weight
						else
							victim_weight = victim.mob_size * 5
						
						// Heavier mob falling on lighter mob = higher knockdown chance
						if(falling_weight > victim_weight)
							victim_knockdown_chance = min(80, ((falling_weight/victim_weight) * 25) + (levels_fallen * 8))
						else 
							victim_knockdown_chance = min(50, 20 + (levels_fallen * 10))
					else
						// Objects have a base knockdown chance
						victim_knockdown_chance = 20 + (levels_fallen * 5)
					
					// Roll for knockdown
					if(prob(victim_knockdown_chance))
						var/stun_time = clamp(levels_fallen * 1 SECONDS, 1 SECONDS, 3 SECONDS)
						victim.Paralyze(stun_time)
						victim.visible_message(span_warning("The impact knocks <b>[victim]</b> to the ground!"), 
											   span_userdanger("The impact knocks me to the ground!"))
					
					// Check for crush damage if the falling object is heavy enough
					if(isliving(falling_atom))
						var/mob/living/falling_mob = falling_atom
						var/falling_weight = 0
						
						if(iscarbon(falling_mob))
							var/mob/living/carbon/falling_carbon = falling_mob
							falling_weight = falling_carbon.carry_weight
							
							// If the falling mob is heavy enough, attempt crush damage
							if(falling_weight > 45)
								handle_crush_damage(victim, falling_mob, falling_weight, levels_fallen)
						else if(falling_mob.mob_size >= MOB_SIZE_HUMAN)
							// For non-carbon mobs, approximate weight
							falling_weight = falling_mob.mob_size * 5
							if(falling_weight > 45)
								handle_crush_damage(victim, falling_mob, falling_weight, levels_fallen)
					
					continue
			
			// Fallback for non-carbon mobs or if bodypart couldn't be found
			if(isliving(falling_atom))
				var/mob/living/falling_mob = falling_atom
				var/falling_weight = 0
				
				// Calculate impact damage based on weight
				if(iscarbon(falling_mob))
					var/mob/living/carbon/falling_carbon = falling_mob
					falling_weight = falling_carbon.carry_weight
					
					// Create descriptive message based on weight
					if(falling_weight > 50) 
						victim.visible_message(span_danger("<b>[victim]</b> is <i>crushed</i> by the weight of <b>[falling_mob]</b> ([falling_weight]kg) falling on [victim.p_them()]!"), 
											span_userdanger("The full weight of <b>[falling_mob]</b> crushes down on me!"))
					else
						victim.visible_message(span_danger("<b>[victim]</b> is hit by <b>[falling_mob]</b> falling on [victim.p_them()]!"), 
											span_userdanger("<b>[falling_mob]</b> falls on me!"))
					
					// Calculate impact damage (weight-based)
					var/impact_damage = (falling_weight * levels_fallen * 0.15)
					
					// Apply armor reduction
					var/armor_block = victim.run_armor_check(null, MELEE, "Your armor absorbs the impact!", "Your armor softens the impact!")
					impact_damage = max(0, impact_damage * (100 - armor_block) / 100)
					
					// Apply damage
					victim.apply_damage(impact_damage, BRUTE)
					
					// Try crush damage from heavy mobs
					if(falling_weight > 45)
						handle_crush_damage(victim, falling_mob, falling_weight, levels_fallen)
					
					// Check for knockdown
					var/knockdown_chance = min(65, (falling_weight/3) + (levels_fallen * 10))
					if(prob(knockdown_chance))
						victim.Paralyze(2 SECONDS)
				else
					// Non-carbon mob fallback
					var/impact_damage = falling_mob.mob_size * levels_fallen * 0.8
					victim.apply_damage(impact_damage, BRUTE)
					
					victim.visible_message(span_danger("<b>[victim]</b> is hit by <b>[falling_mob]</b> falling on [victim.p_them()]!"), 
										span_userdanger("<b>[falling_mob]</b> falls on me!"))
			
			else if(isobj(falling_atom))
				// Handle object falling damage
				var/obj/O = falling_atom
				var/obj_weight = 1
				
				// Get object weight
				if(isitem(O))
					var/obj/item/I = O
					obj_weight = I.get_carry_weight()
				else
					// Approximation for non-item objects
					obj_weight = O.w_class || 2
					if(O.density)
						obj_weight += 5
				
				// Calculate impact damage
				var/impact_damage = obj_weight * levels_fallen * 0.2
				impact_damage = max(3, impact_damage) // Minimum damage floor
				
				// Apply armor reduction
				var/armor_block = victim.run_armor_check(null, MELEE, "Your armor absorbs the impact!", "Your armor softens the impact!")
				impact_damage = max(0, impact_damage * (100 - armor_block) / 100)
				
				// Apply damage
				victim.apply_damage(impact_damage, BRUTE)
				
				// Check for crush damage from heavy objects
				if(obj_weight > 45 || (O.density && obj_weight > 35))
					handle_crush_damage(victim, O, obj_weight, levels_fallen)
				
				victim.visible_message(span_danger("<b>[O]</b> ([obj_weight]kg) falls on <b>[victim]</b>!"), 
									span_userdanger("<b>[O]</b> falls on me!"))
	
	// Create visual effect for the landing
	if(isliving(falling_atom))
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(falling_atom))
		playsound(falling_atom, 'sound/weapons/genhit.ogg', 50, TRUE)
	else if(isobj(falling_atom))
		var/obj/O = falling_atom
		if(O.w_class >= WEIGHT_CLASS_NORMAL || O.density)
			playsound(falling_atom, 'sound/weapons/genhit.ogg', 50, TRUE)

/**
 * Handles checking if falling atoms should pass through openspace based on solidity
 * Allows for better handling of interactions like falling mobs passing through tables
 *
 * Arguments:
 * * passing_atom - The atom trying to pass through 
 * * height_fallen - How many Z-levels it has already fallen
 */
/turf/open/zPassIn(atom/movable/passing_atom, direction, turf/source)
	if(direction != DOWN)
		return ..()
	
	// Calculate total height fallen so far
	var/height_fallen = passing_atom.get_fall_height ? passing_atom.get_fall_height() : 0
	
	// Check for special handlers that might block the fall
	for(var/atom/movable/AM in contents)
		// Dense objects prevent falling through unless they allow pass
		if(AM.density && !AM.CanPass(passing_atom, source))
			// The atom has landed on something dense
			if(passing_atom.falling)
				// Stop falling and handle impact
				passing_atom.falling = FALSE
				handle_fall_impact(passing_atom, height_fallen)
			return FALSE
	
	// If we're falling, increase the height fallen
	if(passing_atom.falling)
		passing_atom.fall_height++
	
	return TRUE

// Add a fall_height variable to track how far something has fallen
/atom/movable
	var/falling = FALSE
	var/fall_height = 0
	
	/// Gets the current fall height for damage calculations
	/atom/movable/proc/get_fall_height()
		return fall_height
	
	/// Resets the falling state and height
	/atom/movable/proc/reset_falling()
		falling = FALSE
		fall_height = 0

/**
 * Special helper for when a heavy object or mob crushes someone on landing
 * Chance to cause more severe injuries like organ damage or fractures
 * 
 * @param mob/living/victim The mob being crushed
 * @param atom/movable/crusher The mob or object doing the crushing
 * @param falling_weight The calculated weight of the falling object/mob
 * @param levels_fallen How many z-levels were fallen through
 */
/proc/handle_crush_damage(mob/living/victim, atom/movable/crusher, falling_weight, levels_fallen)
	if(!victim || !crusher || falling_weight < 45)
		return FALSE
	
	// Calculate crush severity based on weight difference and height fallen
	var/crush_severity = 1
	
	// Higher weight = more severe crushing
	if(falling_weight > 100)
		crush_severity = 3
	else if(falling_weight > 75)
		crush_severity = 2
		
	// Higher fall = more severe impact
	crush_severity += min(levels_fallen - 1, 2)
	
	// Handle dense objects as more damaging (like furniture, machinery)
	if(isobj(crusher) && crusher.density)
		crush_severity += 1
	
	// Dice roll to determine effects - affected by endurance
	var/injury_chance = 30 + (crush_severity * 10)
//	var/organ_injury_chance = 15 + (crush_severity * 8)
//	var/bone_break_chance = 10 + (crush_severity * 12)
	
	// Apply attribute modifiers if victim is carbon
	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		var/endurance_value = GET_MOB_ATTRIBUTE_VALUE(carbon_victim, STAT_ENDURANCE)
		
		// Higher endurance reduces injury chance
		if(endurance_value > ATTRIBUTE_MIDDLING)
			var/reduction = (endurance_value - ATTRIBUTE_MIDDLING) * 2
			injury_chance = max(10, injury_chance - reduction)
//			organ_injury_chance = max(5, organ_injury_chance - reduction)
//			bone_break_chance = max(5, bone_break_chance - reduction)
		else if(endurance_value < ATTRIBUTE_MIDDLING)
			// Lower endurance increases injury chance
			var/increase = (ATTRIBUTE_MIDDLING - endurance_value) * 2
			injury_chance += increase
//			organ_injury_chance += increase
//			bone_break_chance += increase
	
	// Roll for effect application
	var/applied_effect = FALSE
	
	// Only do this to carbon mobs with bodyparts
	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		
		// List of potential bodyparts to damage based on impact
		var/list/potential_targets = list()
		potential_targets += carbon_victim.get_bodypart(BODY_ZONE_CHEST)
		potential_targets += carbon_victim.get_bodypart(BODY_ZONE_PRECISE_VITALS)
		
		// Add other potential targets depending on crush severity
		if(crush_severity >= 2)
			potential_targets += carbon_victim.get_bodypart(BODY_ZONE_PRECISE_GROIN)
			potential_targets += carbon_victim.get_bodypart(BODY_ZONE_HEAD)
		
		// Filter out null entries
		for(var/i = 1, i <= length(potential_targets), i++)
			if(!potential_targets[i])
				potential_targets.Remove(potential_targets[i])
				i--
		
		// Only proceed if we have valid bodyparts to damage
		if(length(potential_targets))
			// Pick a random bodypart to damage severely
			var/obj/item/bodypart/crushed_part = pick(potential_targets)
			
			// Roll for severe soft tissue damage
			if(prob(injury_chance))
				var/damage_amount = 5 + (crush_severity * 3)
				// Call receive_damage with extra wound bonus to represent crushing impact
				crushed_part.receive_damage(brute = damage_amount, wound_bonus = crush_severity * 3, bare_wound_bonus = crush_severity * 2)
				applied_effect = TRUE
				
				// Visual feedback
				if(isobj(crusher))
					carbon_victim.visible_message(span_danger("<b>[carbon_victim]'s [crushed_part.name]</b> is violently compressed by the [crusher]!"), 
										span_userdanger("My [crushed_part.name] is violently compressed by the [crusher]!"))
				else
					carbon_victim.visible_message(span_danger("<b>[carbon_victim]'s [crushed_part.name]</b> is violently compressed by the impact!"), 
										span_userdanger("My [crushed_part.name] is violently compressed by the crushing weight!"))
/*
			// Roll for organ damage
			if(prob(organ_injury_chance))
				// Try to damage internal organs
				crushed_part.damage_internal_organs(WOUND_BLUNT, 5 + (crush_severity * 4), 10, 5, TRUE)
				applied_effect = TRUE
				
				// Visual feedback
				carbon_victim.visible_message(span_danger("<b>[carbon_victim]</b> coughs blood as something ruptures inside!"), 
									span_userdanger("I feel something rupture inside me!"))
				
				// Blood splatter effect
				if(prob(50))
					carbon_victim.add_splatter_floor(get_turf(carbon_victim))
			
			// Roll for bone damage
			if(prob(bone_break_chance))
				// Find bones in the crushed part
				var/list/bones = list()
				bones |= crushed_part.getorganslotlist(ORGAN_SLOT_BONE)
				
				// Only proceed if we have bones to break
				if(length(bones))
					var/obj/item/organ/bone/bone = pick(bones)
					// Calculate damage amount based on severity
					var/bone_damage_amount = (15 * crush_severity) * (1 - (bone.damage / bone.maxHealth))
					bone.receive_damage(bone_damage_amount)
					applied_effect = TRUE
					
					// Visual feedback
					carbon_victim.visible_message(span_danger("A sickening <b>CRACK</b> is heard from <b>[carbon_victim]'s [crushed_part.name]</b>!"), 
										span_userdanger("A sickening <b>CRACK</b> comes from my [crushed_part.name]!"))
					
					// Play bone break sound
					playsound(carbon_victim, 'modular_septic/sound/gore/break.ogg', 65, vary = TRUE)
*/
	return applied_effect

#undef MIN_FALL_DAMAGE 