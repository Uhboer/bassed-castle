/datum/lighting_object
	///the underlay we are currently applying to our turf to apply light
//	var/mutable_appearance/current_underlay
//	var/image/current_underlay
	var/image/CU
	var/current_color
	var/tmp/atom/movable/lighting_animator
	var/tmp/animating = FALSE

	///whether we are already in the SSlighting.objects_queue list
	var/needs_update = FALSE

	///the turf that our light is applied to
	var/turf/affected_turf

/datum/lighting_object/New(turf/source)
	if(!isturf(source))
		qdel(src, force=TRUE)
		stack_trace("a lighting object was assigned to [source], a non turf! ")
		return
	. = ..()

	CU = image(icon = LIGHTING_ICON, icon_state = "transparent")
	CU.layer = source.z
	CU.alpha = 255
	CU.plane = LIGHTING_PLANE
	CU.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	CU.mouse_opacity = 0

	current_color = list(
		1, 1, 1, 0,
		1, 1, 1, 0,
		1, 1, 1, 0,
		1, 1, 1, 0,
		0, 0, 0, 1
	)
	CU.color = current_color
	source.underlays += CU

/*
	CU.icon = LIGHTING_ICON
	CU.icon_state = "transparent"
	CU.layer = source.z
	CU.plane = LIGHTING_PLANE
	CU.alpha = 255
	CU.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
*/

	affected_turf = source
	if (affected_turf.lighting_object)
		qdel(affected_turf.lighting_object, force = TRUE)
		stack_trace("a lighting object was assigned to a turf that already had a lighting object!")

	affected_turf.lighting_object = src
	affected_turf.luminosity = 0

	for(var/turf/open/space/space_tile in RANGE_TURFS(1, affected_turf))
		space_tile.update_starlight()

	needs_update = TRUE
	SSlighting.objects_queue += src

/datum/lighting_object/Destroy(force)
	if (!force)
		return QDEL_HINT_LETMELIVE

	SSlighting.objects_queue -= src

	// Clean up animation if it's in progress
	if(animating && lighting_animator && affected_turf)
		affected_turf.vis_contents -= lighting_animator
		animate(lighting_animator, alpha = 0, time = 0) // Cancel any ongoing animations

	// Clean up the animator
	if(lighting_animator)
		qdel(lighting_animator)
		lighting_animator = null

	if(isturf(affected_turf))
		affected_turf.lighting_object = null
		affected_turf.luminosity = 1
		affected_turf.underlays -= CU

		if(!force)
			affected_turf.update_light()

	affected_turf = null
	return ..()

/datum/lighting_object/proc/do_animation(var/list/color_to)
	set waitfor = FALSE
	if(animating)
		return
	animating = TRUE

	if(!lighting_animator)
		lighting_animator = new(affected_turf)
		lighting_animator.icon = LIGHTING_ICON
		lighting_animator.plane = LIGHTING_PLANE
		lighting_animator.move_resist = INFINITY
		lighting_animator.layer = affected_turf.layer + 1
		lighting_animator.alpha = 255
		lighting_animator.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
		lighting_animator.mouse_opacity = 0

		// Make the animator explosion-proof
		if(istype(lighting_animator, /atom/movable))
			var/atom/movable/LA = lighting_animator
			LA.resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
			LA.flags_1 |= PREVENT_CONTENTS_EXPLOSION_1

	lighting_animator.icon_state = CU.icon_state
	lighting_animator.color = CU.color
	affected_turf.vis_contents += lighting_animator
	animate(lighting_animator, color = color_to, time = 4)
	sleep(1) // This is safe because we set waitfor = FALSE

	if(QDELETED(src) || QDELETED(affected_turf))
		return

	affected_turf.vis_contents -= lighting_animator
	CU.color = color_to
	affected_turf.underlays -= CU
	affected_turf.underlays += CU
	animating = FALSE

/datum/lighting_object/proc/update()
	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	var/static/datum/lighting_corner/dummy/dummy_lighting_corner = new

	var/datum/lighting_corner/red_corner = affected_turf.lighting_corner_SW || dummy_lighting_corner
	var/datum/lighting_corner/green_corner = affected_turf.lighting_corner_SE || dummy_lighting_corner
	var/datum/lighting_corner/blue_corner = affected_turf.lighting_corner_NW || dummy_lighting_corner
	var/datum/lighting_corner/alpha_corner = affected_turf.lighting_corner_NE || dummy_lighting_corner

	var/max = max(red_corner.largest_color_luminosity, green_corner.largest_color_luminosity, blue_corner.largest_color_luminosity, alpha_corner.largest_color_luminosity)

	var/rr = red_corner.cache_r
	var/rg = red_corner.cache_g
	var/rb = red_corner.cache_b

	var/gr = green_corner.cache_r
	var/gg = green_corner.cache_g
	var/gb = green_corner.cache_b

	var/br = blue_corner.cache_r
	var/bg = blue_corner.cache_g
	var/bb = blue_corner.cache_b

	var/ar = alpha_corner.cache_r
	var/ag = alpha_corner.cache_g
	var/ab = alpha_corner.cache_b

	#if LIGHTING_SOFT_THRESHOLD != 0
	var/set_luminosity = max > LIGHTING_SOFT_THRESHOLD
	#else
	// Because of floating points™?, it won't even be a flat 0.
	// This number is mostly arbitrary.
	var/set_luminosity = max > 1e-6
	#endif

	var/list/new_color

	if((rr & gr & br & ar) && (rg + gg + bg + ag + rb + gb + bb + ab == 8))
		//anything that passes the first case is very likely to pass the second, and addition is a little faster in this case
		CU.icon_state = "transparent"
		new_color = list(
			1, 1, 1, 0,
			1, 1, 1, 0,
			1, 1, 1, 0,
			1, 1, 1, 0,
			0, 0, 0, 1
		)
	else if(!set_luminosity)
		CU.icon_state = "dark"
		new_color = list(
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 1
		)
	else
		CU.icon_state = null
		new_color = list(
			rr, rg, rb, 00,
			gr, gg, gb, 00,
			br, bg, bb, 00,
			ar, ag, ab, 00,
			00, 00, 00, 01
		)

	do_animation(new_color)
	affected_turf.luminosity = set_luminosity