/atom/movable/screen/plane_master
	screen_loc = "MIDDLE"
	icon_state = "blank"
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	var/show_alpha = 255
	var/hide_alpha = 0

	//--rendering relay vars--
	///integer: what plane we will relay this planes render to
	var/render_relay_plane = RENDER_PLANE_MASTER
	///bool: Whether this plane should get a render target automatically generated
	var/generate_render_target = TRUE
	///integer: blend mode to apply to the render relay in case you dont want to use the plane_masters blend_mode
	var/blend_mode_override
	///reference: current relay this plane is utilizing to render
	var/atom/movable/render_plane_relay/relay

/atom/movable/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/atom/movable/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane masters need a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/atom/movable/screen/plane_master/proc/backdrop(mob/mymob)
	SHOULD_CALL_PARENT(TRUE)
	if(!isnull(render_relay_plane))
		relay_render_to_plane(mymob, render_relay_plane)

///Things rendered on "openspace"; holes in multi-z
/atom/movable/screen/plane_master/openspace
	name = "open space plane master"
	plane = OPENSPACE_PLANE
	appearance_flags = PLANE_MASTER
	render_relay_plane = RENDER_PLANE_GAME

/atom/movable/screen/plane_master/openspace_backdrop
	name = "open space backdrop plane master"
	plane = OPENSPACE_BACKDROP_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_MULTIPLY
	alpha = 255
	render_relay_plane = RENDER_PLANE_GAME

///Contains just the floor
/atom/movable/screen/plane_master/floor
	name = "floor plane master"
	plane = FLOOR_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_GAME

///Contains most things in the game world
/atom/movable/screen/plane_master/game_world
	name = "game world plane master"
	plane = GAME_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_GAME

/atom/movable/screen/plane_master/game_world/backdrop(mob/mymob)
	. = ..()
	remove_filter("AO")
	if(istype(mymob))
		add_filter("AO", 1, drop_shadow_filter(x = 0, y = -2, size = 1, offset = 1, color = "#04080FAA"))


/atom/movable/screen/plane_master/massive_obj
	name = "massive object plane master"
	plane = MASSIVE_OBJ_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_GAME

/atom/movable/screen/plane_master/ghost
	name = "ghost plane master"
	plane = GHOST_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/point
	name = "point plane master"
	plane = POINT_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_GAME

/**
 * Plane master handling byond internal blackness
 * vars are set as to replicate behavior when rendering to other planes
 * do not touch this unless you know what you are doing
 */
/atom/movable/screen/plane_master/blackness
	name = "darkness plane master"
	plane = BLACKNESS_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE
	//byond internal end
	render_relay_plane = RENDER_PLANE_GAME
	blend_mode_override = BLEND_OVERLAY

///Contains all lighting objects
/atom/movable/screen/plane_master/lighting
	name = "lighting plane master"
	plane = LIGHTING_PLANE
	blend_mode_override = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_relay_plane = RENDER_PLANE_GAME


/atom/movable/screen/plane_master/lighting/backdrop(mob/mymob)
	. = ..()
	mymob.overlay_fullscreen("lighting_backdrop_lit", /atom/movable/screen/fullscreen/lighting_backdrop/lit)
	mymob.overlay_fullscreen("lighting_backdrop_unlit", /atom/movable/screen/fullscreen/lighting_backdrop/unlit)


/*!
 * This system works by exploiting BYONDs color matrix filter to use layers to handle emissive blockers.
 *
 * Emissive overlays are pasted with an atom color that converts them to be entirely some specific color.
 * Emissive blockers are pasted with an atom color that converts them to be entirely some different color.
 * Emissive overlays and emissive blockers are put onto the same plane.
 * The layers for the emissive overlays and emissive blockers cause them to mask eachother similar to normal BYOND objects.
 * A color matrix filter is applied to the emissive plane to mask out anything that isn't whatever the emissive color is.
 * This is then used to alpha mask the lighting plane.
 */
/atom/movable/screen/plane_master/lighting/Initialize(mapload)
	. = ..()
	add_filter("emissives", 1, alpha_mask_filter(render_source = EMISSIVE_RENDER_TARGET, flags = MASK_INVERSE))
	add_filter("object_lighting", 2, alpha_mask_filter(render_source = O_LIGHTING_VISUAL_RENDER_TARGET, flags = MASK_INVERSE))
	if(SSoutdoor_effects.initialized)
		vis_contents +=  SSoutdoor_effects.sun_color //MOJAVE MODULE OUTDOOR_EFFECTS

/**
 * Handles emissive overlays and emissive blockers.
 */
/atom/movable/screen/plane_master/emissive
	name = "emissive plane master"
	plane = EMISSIVE_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = EMISSIVE_RENDER_TARGET
	render_relay_plane = null

/atom/movable/screen/plane_master/emissive/Initialize(mapload)
	. = ..()
	add_filter("em_block_masking", 1, color_matrix_filter(GLOB.em_mask_matrix))

/atom/movable/screen/plane_master/above_lighting
	name = "above lighting plane master"
	plane = ABOVE_LIGHTING_PLANE
	appearance_flags = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_GAME

///Contains space parallax
/atom/movable/screen/plane_master/parallax
	name = "parallax plane master"
	plane = PLANE_SPACE_PARALLAX
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_relay_plane = RENDER_PLANE_GAME

/atom/movable/screen/plane_master/parallax_white
	name = "parallax whitifier plane master"
	plane = PLANE_SPACE
	render_relay_plane = RENDER_PLANE_GAME

/atom/movable/screen/plane_master/camera_static
	name = "camera static plane master"
	plane = CAMERA_STATIC_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_GAME

/atom/movable/screen/plane_master/excited_turfs
	name = "atmos excited turfs"
	plane = ATMOS_GROUP_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_GAME
	alpha = 0

/atom/movable/screen/plane_master/o_light_visual
	name = "overlight light visual plane master"
	plane = O_LIGHTING_VISUAL_PLANE
	render_target = O_LIGHTING_VISUAL_RENDER_TARGET
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blend_mode = BLEND_MULTIPLY
	blend_mode_override = BLEND_MULTIPLY
	render_relay_plane = RENDER_PLANE_GAME

/atom/movable/screen/plane_master/runechat
	name = "runechat plane master"
	plane = RUNECHAT_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/runechat/backdrop(mob/mymob)
	. = ..()
	remove_filter("AO")
	if(istype(mymob))
		add_filter("AO", 1, drop_shadow_filter(x = 0, y = -2, size = 1, offset = 1, color = "#04080FAA"))

/atom/movable/screen/plane_master/gravpulse
	name = "gravpulse plane"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = GRAVITY_PULSE_PLANE
	render_target = GRAVITY_PULSE_RENDER_TARGET
	render_relay_plane = null

/atom/movable/screen/plane_master/area
	name = "area plane"
	plane = AREA_PLANE
	render_relay_plane = RENDER_PLANE_GAME

/atom/movable/screen/plane_master/radtext
	name = "radtext plane"
	plane = RAD_TEXT_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/balloon_chat
	name = "balloon alert plane"
	plane = BALLOON_CHAT_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME

/atom/movable/screen/plane_master/fullscreen
	name = "fullscreen alert plane"
	plane = FULLSCREEN_PLANE
	render_relay_plane = RENDER_PLANE_NON_GAME

//I stole this from Kapu of Daedalus. I don't know where he got it from though.
#define ATOMS_FOV_SHADOWS_RENDER_TARGET "*ATOMS_FOV_SHADOWS_PLANE"
#define WALLS_FOV_PLANE_0_RENDER_TARGET "*WALLS_FOV_PLANE_0"
#define WALLS_FOV_PLANE_1_RENDER_TARGET "*WALLS_FOV_PLANE_1"
#define WALLS_FOV_PLANE_2_RENDER_TARGET "*WALLS_FOV_PLANE_2"
#define WALLS_FOV_PLANE_3_RENDER_TARGET "*WALLS_FOV_PLANE_3"
#define WALLS_FOV_PLANE_4_RENDER_TARGET "*WALLS_FOV_PLANE_4"
#define WALLS_FOV_PLANE_5_RENDER_TARGET "*WALLS_FOV_PLANE_5"
#define WALLS_FOV_PLANE_6_RENDER_TARGET "*WALLS_FOV_PLANE_6"
#define WALLS_FOV_PLANE_7_RENDER_TARGET "*WALLS_FOV_PLANE_7"
#define WALLS_FOV_PLANE_8_RENDER_TARGET "*WALLS_FOV_PLANE_8"
#define WALLS_FOV_PLANE_9_RENDER_TARGET "*WALLS_FOV_PLANE_9"
#define FOV_WALL_ICON 'icons/walls_fov3.dmi'

/atom/movable/screen/plane_master/walls
	plane = WALL_PLANE
	blend_mode = BLEND_OVERLAY

/atom/movable/screen/plane_master/wall_fov
	render_relay_plane = null
	color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,2)

/atom/movable/screen/plane_master/wall_fov/shadows_plane
	name = "wall fov shadows plane"
	plane = ATOMS_FOV_SHADOWS_PLANE
	render_target = ATOMS_FOV_SHADOWS_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane0
	name = "wall fov plane0"
	plane = WALLS_FOV_PLANE_0
	render_target = WALLS_FOV_PLANE_0_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane0/New()
	. = ..()
	filters += filter(type = "layer", render_source = ATOMS_FOV_SHADOWS_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "1"), size = 1)
	filters += filter(type = "alpha", render_source = ATOMS_FOV_SHADOWS_RENDER_TARGET, flags = MASK_INVERSE)

/atom/movable/screen/plane_master/wall_fov/plane1
	name = "wall fov plane1"
	plane = WALLS_FOV_PLANE_1
	render_target = WALLS_FOV_PLANE_1_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane1/New()
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_0_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "1"), size = 1)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_0_RENDER_TARGET)


/atom/movable/screen/plane_master/wall_fov/plane2
	name = "wall fov plane2"
	plane = WALLS_FOV_PLANE_2
	render_target = WALLS_FOV_PLANE_2_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane2/New()
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_1_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "2"), size = 2)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_1_RENDER_TARGET)


/atom/movable/screen/plane_master/wall_fov/plane3
	name = "wall fov plane3"
	plane = WALLS_FOV_PLANE_3
	render_target = WALLS_FOV_PLANE_3_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane3/New()
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_2_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "3"), size = 4)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_2_RENDER_TARGET)


/atom/movable/screen/plane_master/wall_fov/plane4
	name = "wall fov plane4"
	plane = WALLS_FOV_PLANE_4
	render_target = WALLS_FOV_PLANE_4_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane4/New()
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_3_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "4"), size = 8)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_3_RENDER_TARGET)


/atom/movable/screen/plane_master/wall_fov/plane5
	name = "wall fov plane5"
	plane = WALLS_FOV_PLANE_5
	render_target = WALLS_FOV_PLANE_5_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane5/New()
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_4_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "5"), size = 16)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_4_RENDER_TARGET)


/atom/movable/screen/plane_master/wall_fov/plane6
	name = "wall fov plane6"
	plane = WALLS_FOV_PLANE_6
	render_target = WALLS_FOV_PLANE_6_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane6/New()
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_5_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "6"), size = 32)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_5_RENDER_TARGET)


/atom/movable/screen/plane_master/wall_fov/plane7
	name = "wall fov plane7"
	plane = WALLS_FOV_PLANE_7
	render_target = WALLS_FOV_PLANE_7_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane7/New()
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_6_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "7"), size = 64)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_6_RENDER_TARGET)


/atom/movable/screen/plane_master/wall_fov/plane8
	name = "wall fov plane8"
	plane = WALLS_FOV_PLANE_8
	render_target = WALLS_FOV_PLANE_8_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane8/New()
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_7_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "8"), size = 128)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_7_RENDER_TARGET)


/atom/movable/screen/plane_master/wall_fov/plane9
	name = "wall fov plane9"
	plane = WALLS_FOV_PLANE_9
	render_relay_plane = RENDER_PLANE_GAME
	color = null
	// render_target = WALLS_FOV_PLANE_9_RENDER_TARGET

/atom/movable/screen/plane_master/wall_fov/plane9/New()
	. = ..()
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_8_RENDER_TARGET, flags = FILTER_UNDERLAY)
	filters += filter(type = "displace", icon = icon(FOV_WALL_ICON, "9"), size = 256)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_8_RENDER_TARGET)
	filters += filter(type = "blur", size = 5)
	filters += filter(type = "layer", render_source = WALLS_FOV_PLANE_8_RENDER_TARGET)
	filters += filter(type = "blur", size = 1)

/atom/movable/atom_shadow
	name = "shadow"
	//icon = 'icons/shadow.dmi'
	icon = 'icons/solid_wall_mask.dmi'
	icon_state = "shadow"
	plane = ATOMS_FOV_SHADOWS_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/atom_shadow/door
	icon = 'icons/obj/doors/airlocks/station/airlock_mask.dmi'

/turf/closed/wall/Initialize(mapload)
	. = ..()
	new /atom/movable/atom_shadow(src)

/turf/closed/wall
	plane = WALL_PLANE

/turf/closed/wall/smooth_icon()
	. = ..()
	var/atom/movable/atom_shadow/shadow = locate(/atom/movable/atom_shadow) in src
	shadow?.icon_state = "wall-[smoothing_junction]"

/turf/podpol/wall
	plane = WALL_PLANE

/turf/podpol/wall/smooth_icon()
	. = ..()
	var/atom/movable/atom_shadow/shadow = locate(/atom/movable/atom_shadow) in src
	shadow?.icon_state = "wall-[smoothing_junction]"
