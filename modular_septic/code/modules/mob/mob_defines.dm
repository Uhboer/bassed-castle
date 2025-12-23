/mob
	inspect_icon_state = "mob"
	examine_cursor_icon = null
//	base_pixel_z = MOB_PIXEL_Z //Are you ready to suffer?
//	pixel_z = MOB_PIXEL_Z
	/// Skill holder
	var/datum/attribute_holder/attributes
	/// Extra effort that can be spent on efforts
	var/extra_effort = 0
	/// Sound we play to the player who controls us on death
	var/deathsound_local = sound('modular_septic/sound/effects/death.ogg', FALSE, 0, CHANNEL_EAR_RING, 100)
	/// Works like client.movement_locked, but handled mob-wise
	var/movement_locked = FALSE
	/// Hydration level of the mob
	var/hydration = HYDRATION_LEVEL_START_MIN // Randomised in Initialize
	/// Intents
	var/a_intent
	var/list/possible_a_intents
	var/list/possible_a_boosts
	var/a_boost = BOOST_STR
	/// Combat style
	var/combat_style = CS_STRONG
	/// Dodge/parry
	var/dodge_parry = DP_DODGE
	/// Middle click special attacks
	var/special_attack = SPECIAL_ATK_NONE

	var/transition = FALSE
	var/special_zvanie = null

	var/awakened = FALSE
	var/wake_level = 0
	var/way_type = null

	var/pod_faction = null