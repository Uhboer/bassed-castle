/atom/movable/screen/temperature
	name = "temperature"
	icon = 'modular_septic/icons/hud/quake/screen_quake.dmi'
	icon_state = "temp2"
	base_icon_state = "temp"
	screen_loc = ui_temperature
	var/temperature_index = 3

/atom/movable/screen/temperature/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][clamp(CEILING(temperature_index/2, 1), 1, 3)]"

/atom/movable/screen/temperature/Click(location, control, params)
	. = ..()
	switch(temperature_index)
		if(6)
			to_chat(usr, div_infobox(span_userdanger("I'm roasting alive!")))
		if(5)
			to_chat(usr, div_infobox(span_danger("It's very hot here!")))
		if(4)
			to_chat(usr, div_infobox(span_warning("It's hot here.")))
		if(3)
			to_chat(usr, div_infobox(span_notice("The temperature here is comfortable.")))
		if(2)
			to_chat(usr, div_infobox(span_warning("It's cold here.")))
		if(1)
			to_chat(usr, div_infobox(span_danger("It's very cold here!")))
		if(0)
			to_chat(usr, div_infobox(span_userdanger("I'm freezing!")))

/atom/movable/screen/temperature/proc/update_temperature(new_temp = 3)
	if(temperature_index == new_temp)
		return
	temperature_index = new_temp
	update_appearance()
