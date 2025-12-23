#define CLOUD_POSITION_DAMAGE "CLOUD_POSITION_DAMAGE"
#define CLOUD_POSITION_W_BONUS "CLOUD_POSITION_W_BONUS"
#define CLOUD_POSITION_BW_BONUS "CLOUD_POSITION_BW_BONUS"
#define CLOUD_POSITION_O_BONUS "CLOUD_POSITION_O_BONUS"
#define CLOUD_POSITION_BO_BONUS "CLOUD_POSITION_BO_BONUS"
#define CLOUD_POSITION_SHARPNESS "CLOUD_POSITION_SHARPNESS"

/datum/component/pellet_cloud
	var/suppressed = SUPPRESSED_NONE
	var/list/embed_count = null
	var/list/armor_stopped_count = null
	var/list/through_count = null

/datum/component/pellet_cloud/Destroy(force, silent)
	embed_count = null
	through_count = null
	return ..()

/datum/component/pellet_cloud/create_casing_pellets(obj/item/ammo_casing/shell, atom/target, mob/living/user, fired_from, randomspread, spread, zone_override, params, distro)
	shooter = user
	var/turf/target_loc = get_turf(target)

	// things like mouth executions and gunpoints can multiply the damage and wounds of projectiles, so this makes sure those effects are applied to each pellet instead of just one
	var/original_damage = shell.loaded_projectile.damage
	var/original_wb = shell.loaded_projectile.wound_bonus
	var/original_bwb = shell.loaded_projectile.bare_wound_bonus
	var/original_ob = shell.loaded_projectile.organ_bonus
	var/original_bob = shell.loaded_projectile.bare_organ_bonus

	//make dummy bullet
	shell.ready_proj(target, user, null, zone_override, fired_from)
	suppressed = shell.loaded_projectile.suppressed
	zone_override = shell.loaded_projectile.def_zone
	QDEL_NULL(shell.loaded_projectile)

	for(var/i in 1 to num_pellets)
		shell.newshot()
		shell.ready_proj(target, user, SUPPRESSED_VERY, zone_override, fired_from)
		if(distro)
			if(randomspread)
				spread = round((rand() - 0.5) * distro)
			//Smart spread
			else
				spread = round(((i / num_pellets) - 0.5) * distro)

		RegisterSignal(shell.loaded_projectile, COMSIG_PELLET_CLOUD_EMBEDDED, .proc/projectile_embedded)
		RegisterSignal(shell.loaded_projectile, COMSIG_PELLET_CLOUD_STOPPED_BY_ARMOR, .proc/projectile_stopped_by_armor)
		RegisterSignal(shell.loaded_projectile, COMSIG_PELLET_CLOUD_WENT_THROUGH, .proc/projectile_went_through)
		RegisterSignal(shell.loaded_projectile, COMSIG_PROJECTILE_SELF_ON_HIT, .proc/pellet_hit)
		RegisterSignal(shell.loaded_projectile, list(COMSIG_PROJECTILE_RANGE_OUT, COMSIG_PARENT_QDELETING), .proc/pellet_range)
		shell.loaded_projectile.damage = original_damage
		shell.loaded_projectile.wound_bonus = original_wb
		shell.loaded_projectile.bare_wound_bonus = original_bwb
		shell.loaded_projectile.organ_bonus = original_ob
		shell.loaded_projectile.bare_organ_bonus = original_bob
		
		// Make sure pellets is initialized as a list
		if(!islist(pellets))
			pellets = list()
		LAZYADD(pellets, shell.loaded_projectile)
		
		var/turf/current_loc = get_turf(user)
		if (!istype(target_loc) || !istype(current_loc) || !(shell.loaded_projectile))
			return
		INVOKE_ASYNC(shell, /obj/item/ammo_casing/proc/throw_proj, target, target_loc, shooter, params, spread)

/datum/component/pellet_cloud/pellet_hit(obj/projectile/projectile, atom/movable/firer, atom/target, Angle, hit_zone)
	if(islist(pellets))
		LAZYREMOVE(pellets, projectile)
	terminated++
	hits++
	var/obj/item/bodypart/hit_part
	var/no_damage = FALSE
	if(iscarbon(target) && hit_zone)
		var/mob/living/carbon/hit_carbon = target
		hit_part = hit_carbon.get_bodypart(hit_zone)
		if(hit_part)
			target = hit_part
			// unfortunately, due to how pellet clouds handle finalizing only after every pellet is accounted for,
			// that also means there might be a short delay in dealing wounds if one pellet goes wide
			// while buckshot may reach a target or miss it all in one tick, we also have to account for possible ricochets
			// that may take a bit longer to hit the target
			if(isnull(wound_info_by_part[hit_part]))
				wound_info_by_part[hit_part] = list(
					CLOUD_POSITION_DAMAGE = 0,
					CLOUD_POSITION_W_BONUS = 0,
					CLOUD_POSITION_BW_BONUS = 0,
					CLOUD_POSITION_O_BONUS = 0,
					CLOUD_POSITION_BO_BONUS = 0,
					CLOUD_POSITION_SHARPNESS = 0
				)
			// these account for decay
			var/sharpness = projectile.get_sharpness()
			var/armor_block = hit_carbon.run_armor_check(hit_part.body_zone, projectile.flag, sharpness = sharpness)
			var/armor_reduce = hit_carbon.run_subarmor_check(hit_part.body_zone, projectile.flag, sharpness = sharpness)
			var/damage_dealt = max(0, projectile.damage - (projectile.damage * armor_block/100) - armor_reduce)
			wound_info_by_part[hit_part][CLOUD_POSITION_DAMAGE] += damage_dealt
			wound_info_by_part[hit_part][CLOUD_POSITION_W_BONUS] += projectile.wound_bonus
			wound_info_by_part[hit_part][CLOUD_POSITION_BW_BONUS] += projectile.bare_wound_bonus
			wound_info_by_part[hit_part][CLOUD_POSITION_O_BONUS] += projectile.organ_bonus
			wound_info_by_part[hit_part][CLOUD_POSITION_BO_BONUS] += projectile.bare_organ_bonus
			wound_info_by_part[hit_part][CLOUD_POSITION_SHARPNESS] = sharpness
			projectile.wound_bonus = CANT_WOUND
			projectile.organ_bonus = CANT_ORGAN
	else if(isobj(target))
		var/obj/hit_object = target
		if(hit_object.damage_deflection > projectile.damage || !projectile.damage)
			no_damage = TRUE

	LAZYADDASSOC(targets_hit[target], "hits", 1)
	if(targets_hit[target]["hits"] == 1)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, .proc/on_target_qdel, override = TRUE)
	LAZYSET(targets_hit[target], "no damage", no_damage)
	UnregisterSignal(projectile, list(COMSIG_PARENT_QDELETING, COMSIG_PROJECTILE_RANGE_OUT, COMSIG_PROJECTILE_SELF_ON_HIT))
	if(terminated == num_pellets)
		finalize()

/datum/component/pellet_cloud/finalize()
	var/obj/projectile/projectile = projectile_type

	for(var/atom/target in targets_hit)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
		var/mob/living/carbon/carbon_target
		if(iscarbon(target))
			carbon_target = target
		if(carbon_target)
			SEND_SIGNAL(carbon_target, COMSIG_CARBON_CLEAR_WOUND_MESSAGE)

		var/obj/item/bodypart/hit_part
		if(isbodypart(target))
			hit_part = target
			target = hit_part.owner
			carbon_target = target
			if(wound_info_by_part[hit_part] && \
				(initial(projectile.damage_type) == BRUTE || initial(projectile.damage_type) == BURN))
				// Make sure the wound info is properly structured
				if(!islist(wound_info_by_part[hit_part]))
					wound_info_by_part[hit_part] = list(
						CLOUD_POSITION_DAMAGE = 0,
						CLOUD_POSITION_W_BONUS = 0,
						CLOUD_POSITION_BW_BONUS = 0,
						CLOUD_POSITION_O_BONUS = 0,
						CLOUD_POSITION_BO_BONUS = 0,
						CLOUD_POSITION_SHARPNESS = 0
					)
					
				// Access the associative array using define constants
				var/damage_dealt = wound_info_by_part[hit_part][CLOUD_POSITION_DAMAGE]
				var/w_bonus = wound_info_by_part[hit_part][CLOUD_POSITION_W_BONUS]
				var/bw_bonus = wound_info_by_part[hit_part][CLOUD_POSITION_BW_BONUS]
				var/wound_type = (initial(projectile.damage_type) == BRUTE) ? WOUND_BLUNT : WOUND_BURN
				var/o_bonus = wound_info_by_part[hit_part][CLOUD_POSITION_O_BONUS]
				var/bo_bonus = wound_info_by_part[hit_part][CLOUD_POSITION_BO_BONUS]
				var/sharpness = wound_info_by_part[hit_part][CLOUD_POSITION_SHARPNESS]
				
				// Use default values if any are null
				damage_dealt = isnull(damage_dealt) ? 0 : damage_dealt
				w_bonus = isnull(w_bonus) ? 0 : w_bonus
				bw_bonus = isnull(bw_bonus) ? 0 : bw_bonus
				o_bonus = isnull(o_bonus) ? 0 : o_bonus
				bo_bonus = isnull(bo_bonus) ? 0 : bo_bonus
				
				hit_part.painless_wound_roll(wound_type, damage_dealt, w_bonus, bw_bonus, sharpness)
				hit_part.damage_internal_organs(wound_type, damage_dealt, o_bonus, bo_bonus)
				wound_info_by_part -= hit_part

	for(var/mob/living/martyr as anything in purple_hearts)
		if(martyr.stat == DEAD && martyr.client)
			martyr.client.give_award(/datum/award/achievement/misc/lookoutsir, martyr)
	UnregisterSignal(parent, COMSIG_PARENT_PREQDELETED)
	if(queued_delete)
		qdel(parent)
	qdel(src)

/datum/component/pellet_cloud/proc/projectile_embedded(obj/projectile/source, obj/item/bodypart/hit_limb)
	SIGNAL_HANDLER

	LAZYINITLIST(embed_count)
	if(!embed_count[hit_limb])
		embed_count[hit_limb] = 1
	else
		embed_count[hit_limb]++

/datum/component/pellet_cloud/proc/projectile_stopped_by_armor(obj/projectile/source, obj/item/bodypart/hit_limb)
	SIGNAL_HANDLER

	LAZYINITLIST(armor_stopped_count)
	if(!armor_stopped_count[hit_limb])
		armor_stopped_count[hit_limb] = 1
	else
		armor_stopped_count[hit_limb]++

/datum/component/pellet_cloud/proc/projectile_went_through(obj/projectile/source, obj/item/bodypart/hit_limb)
	SIGNAL_HANDLER

	LAZYINITLIST(through_count)
	if(!through_count[hit_limb])
		through_count[hit_limb] = 1
	else
		through_count[hit_limb]++

#undef CLOUD_POSITION_DAMAGE
#undef CLOUD_POSITION_W_BONUS
#undef CLOUD_POSITION_BW_BONUS
#undef CLOUD_POSITION_O_BONUS
#undef CLOUD_POSITION_BO_BONUS
#undef CLOUD_POSITION_SHARPNESS