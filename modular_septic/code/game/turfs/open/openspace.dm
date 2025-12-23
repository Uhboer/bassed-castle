/turf/open/openspace
	icon = 'modular_septic/icons/turf/floors.dmi'
	icon_state = "transparent"
//	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_range = 1
	light_power = 1
	light_color = COLOR_WHITE

/turf/open/openspace/return_screentip(mob/user, params)
	if(flags_1 & NO_SCREENTIPS_1)
		return ""
	return SCREENTIP_OPENSPACE(uppertext(name))

/turf/open/openspace/bullet_act(obj/projectile/P)
	var/turf/T = get_step_multiz(P, DOWN)
	if(T)
		P.trajectory_ignore_forcemove = TRUE
		P.forceMove(T)
		P.trajectory_ignore_forcemove = FALSE
		return BULLET_ACT_FORCE_PIERCE
	return BULLET_ACT_HIT

/*
/turf/open/openspace/on_hit(obj/projectile/P)
	if(P.z_levelism)
		if(P.z_levelism == TRUE)
			get_step_multiz(P, UP)
		else
			get_step_multiz(P, DOWN)
*/
