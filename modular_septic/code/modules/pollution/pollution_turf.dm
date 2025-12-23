/turf
	/// Pollution datum of this turf
	var/datum/pollution/pollution

/turf/proc/pollute_turf(pollution_type, amount, cap)
	if(!pollution)
		pollution = new(src)
	pollution.add_pollutant(pollution_type, amount)
	// Ensure pollution is activated and starts spreading immediately
	SET_ACTIVE_POLLUTION(pollution)
	update_adjacent_pollution()

/turf/proc/pollute_list_turf(list/pollutions, cap)
	if(!pollution)
		pollution = new(src)
	if(cap && pollution.total_amount >= cap)
		return
	pollution.add_pollutant_list(pollutions)
	// Ensure pollution is activated and starts spreading immediately
	SET_ACTIVE_POLLUTION(pollution)
	update_adjacent_pollution()
