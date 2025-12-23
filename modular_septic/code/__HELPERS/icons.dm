/proc/image2html(thing, target, width = 32, height = 32, format = "png", sourceonly = FALSE, extra_classes = null)
	if(!target)
		return
	if(!thing)
		return
	if(SSlag_switch.measures[DISABLE_USR_ICON2HTML] && usr && !HAS_TRAIT(usr, TRAIT_BYPASS_MEASURES))
		return

	if(target == world)
		target = GLOB.clients

	var/list/targets
	if(!islist(target))
		targets = list(target)
	else
		targets = target
		if (!targets.len)
			return

	if(!isfile(thing)) //special snowflake
		return
	var/name = SANITIZE_FILENAME("[generate_asset_name(thing)].[format]")
	if(!SSassets.cache[name])
		SSassets.transport.register_asset(name, thing)
	for(var/thing2 in targets)
		SSassets.transport.send_assets(thing2, name)
	if(sourceonly)
		return SSassets.transport.get_asset_url(name)
	return "<img class='[extra_classes]' src='[SSassets.transport.get_asset_url(name)]'>"

/proc/apply_height_filters(image/image, height = HUMAN_HEIGHT_MEDIUM)
	if(!image)
		return

	var/static/icon/cut_torso_mask = icon('modular_septic/icons/effects/human_height_masks.dmi', "cut_torso")
	var/static/icon/cut_legs_mask = icon('modular_septic/icons/effects/human_height_masks.dmi', "cut_legs")
	var/static/icon/lenghten_torso_mask = icon('modular_septic/icons/effects/human_height_masks.dmi', "lengthen_torso")
	var/static/icon/lenghten_legs_mask = icon('modular_septic/icons/effects/human_height_masks.dmi', "lengthen_legs")

	var/static/list/filters_torso = list(
		HUMAN_HEIGHT_GNOME = filter(arglist(displacement_map_filter(cut_torso_mask, x = 0, y = 0, size = 2))),
		HUMAN_HEIGHT_SHORTEST = filter(arglist(displacement_map_filter(cut_torso_mask, x = 0, y = 0, size = 1))),
		HUMAN_HEIGHT_TALLEST = filter(arglist(displacement_map_filter(lenghten_torso_mask, x = 0, y = 0, size = 1))),
	)
	var/static/list/filters_legs = list(
		HUMAN_HEIGHT_GNOME = filter(arglist(displacement_map_filter(cut_legs_mask, x = 0, y = 0, size = 3))),
		HUMAN_HEIGHT_SHORTEST = filter(arglist(displacement_map_filter(cut_legs_mask, x = 0, y = 0, size = 1))),
		HUMAN_HEIGHT_SHORT = filter(arglist(displacement_map_filter(cut_legs_mask, x = 0, y = 0, size = 1))),
		HUMAN_HEIGHT_TALL = filter(arglist(displacement_map_filter(lenghten_legs_mask, x = 0, y = 0, size = 1))),
		HUMAN_HEIGHT_TALLEST = filter(arglist(displacement_map_filter(lenghten_legs_mask, x = 0, y = 0, size = 1))),
	)

	for(var/manlet_specimen in filters_torso)
		image.filters -= filters_torso[manlet_specimen]

	for(var/manlet_specimen in filters_legs)
		image.filters -= filters_torso[manlet_specimen]

	var/filter_torso = filters_torso[height]
	if(filter_torso)
		image.filters += filter_torso

	var/filter_legs = filters_legs[height]
	if(filter_legs)
		image.filters += filter_legs
	return image

/proc/apply_height_offsets(image/image, height = HUMAN_HEIGHT_MEDIUM, on_head = FALSE)
	if(!image)
		return

	var/static/list/offsets_head = list(
		HUMAN_HEIGHT_GNOME = -5,
		HUMAN_HEIGHT_SHORTEST = -2,
		HUMAN_HEIGHT_SHORT = -1,
		HUMAN_HEIGHT_MEDIUM = 0,
		HUMAN_HEIGHT_TALL = 1,
		HUMAN_HEIGHT_TALLEST = 2,
	)
	var/static/list/offsets_normal = list(
		HUMAN_HEIGHT_GNOME = -3,
		HUMAN_HEIGHT_SHORTEST = -1,
		HUMAN_HEIGHT_SHORT = -1,
		HUMAN_HEIGHT_MEDIUM = 0,
		HUMAN_HEIGHT_TALL = 1,
		HUMAN_HEIGHT_TALLEST = 1,
	)

	image.pixel_y += (on_head ? offsets_head[height] : offsets_normal[height])
	return image

/proc/apply_width_filters(image/appearance, width)
	if(!appearance || !width)
		return appearance

	var/scale = 1.0
	switch(width)
		if(HUMAN_WIDTH_THIN)
			scale = 0.92
		if(HUMAN_WIDTH_SLIGHTLY_THIN)
			scale = 0.96
		if(HUMAN_WIDTH_AVERAGE)
			scale = 1.0
		if(HUMAN_WIDTH_SLIGHTLY_WIDE)
			scale = 1.04
		if(HUMAN_WIDTH_WIDE)
			scale = 1.08

	var/matrix/M = matrix()
	M.Scale(scale, 1)
	appearance.transform = M

	// Проверяем, является ли элемент лицевым (прическа, глаза, борода)
	var/is_facial = FALSE
	if(appearance.icon_state && (findtext(appearance.icon_state, "hair") || findtext(appearance.icon_state, "facial") || findtext(appearance.icon_state, "eye")))
		is_facial = TRUE

	if(!is_facial)
		var/pixel_offset = 0
		switch(width)
			if(HUMAN_WIDTH_THIN)
				pixel_offset = -2
			if(HUMAN_WIDTH_SLIGHTLY_THIN)
				pixel_offset = -1
			if(HUMAN_WIDTH_AVERAGE)
				pixel_offset = 0
			if(HUMAN_WIDTH_SLIGHTLY_WIDE)
				pixel_offset = 1
			if(HUMAN_WIDTH_WIDE)
				pixel_offset = 2

		appearance.pixel_x += pixel_offset

	return appearance

/proc/apply_width_offsets(image/appearance, width)
	if(!appearance || !width)
		return appearance

	// Проверяем, является ли элемент лицевым (прическа, глаза, борода)
	var/is_facial = FALSE
	if(appearance.icon_state && (findtext(appearance.icon_state, "hair") || findtext(appearance.icon_state, "facial") || findtext(appearance.icon_state, "eye")))
		is_facial = TRUE

	if(!is_facial)
		var/pixel_offset = 0
		switch(width)
			if(HUMAN_WIDTH_THIN)
				pixel_offset = -2
			if(HUMAN_WIDTH_SLIGHTLY_THIN)
				pixel_offset = -1
			if(HUMAN_WIDTH_AVERAGE)
				pixel_offset = 0
			if(HUMAN_WIDTH_SLIGHTLY_WIDE)
				pixel_offset = 1
			if(HUMAN_WIDTH_WIDE)
				pixel_offset = 2

		appearance.pixel_x += pixel_offset

	return appearance
