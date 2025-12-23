/mob/dead/new_player
	var/still_choose = FALSE

/mob/dead/new_player/LateChoices()
	var/list/dat = list()
	if(SSlag_switch.measures[DISABLE_NON_OBSJOBS])
		dat += "<div class='notice red' style='font-size: 125%'>Only Observers may join at this time.</div><br>"
	dat += "<div class='notice'>Идёт раунд: [DisplayTimeText(world.time - SSticker.round_start_time)]</div>"
	if(SSshuttle.emergency)
		switch(SSshuttle.emergency.mode)
			if(SHUTTLE_ESCAPE)
				dat += "<div class='notice red'>The village has been evacuated.</div><br>"
			if(SHUTTLE_CALL)
				if(!SSshuttle.canRecall())
					dat += "<div class='notice red'>The village is currently undergoing evacuation procedures.</div><br>"
	for(var/datum/job/prioritized_job in SSjob.prioritized_jobs)
		if(prioritized_job.current_positions >= prioritized_job.total_positions)
			SSjob.prioritized_jobs -= prioritized_job
	dat += "<table><tr><td valign='top'>"
	var/column_counter = 0
	for(var/datum/job_department/department as anything in SSjob.joinable_departments)
		var/department_color = department.latejoin_color
		dat += "<fieldset style='width: 185px; border: 2px solid [department_color]; display: inline'>"
		dat += "<legend align='center' style='color: [department_color]'>[department.department_name]</legend>"
		var/list/dept_data = list()
		for(var/datum/job/job_datum as anything in department.department_jobs)
			if(IsJobUnavailable(job_datum.title, TRUE) != JOB_AVAILABLE)
				continue

			var/command_bold = ""
			if(job_datum.departments_bitflags & DEPARTMENT_BITFLAG_COMMAND)
				command_bold = " command"

			if(job_datum in SSjob.prioritized_jobs)
				dept_data += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'><span class='priority'>[job_datum.title] ([job_datum.current_positions])</span></a>"
			else
				dept_data += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job_datum.title]'>[job_datum.title] ([job_datum.current_positions])</a>"
		if(!length(dept_data))
			dept_data += "<span class='nopositions'>No positions open.</span>"
		dat += dept_data.Join()
		dat += "</fieldset><br>"
		column_counter++
		if(column_counter > 0 && !(column_counter % 3))
			dat += "</td><td valign='top'>"
	dat += "</td></tr></table></center>"
	dat += "</div></div>"
	var/datum/browser/popup = new(src, "latechoices", "Выбираю роль", 680, 580)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE) // 0 is passed to open so that it doesn't use the onclose() proc

/mob/dead/new_player/verb/playthis()
	set name = "Play"
	set category = "OOC"

	if(!isnewplayer(src))
		return
	if(!client)
		return
	if(client.ready_char)
		return
	if(client.should_not_play)
		alert("Oh, thanks... I can't create everything.")
		return
	if(SSticker.current_state < GAME_STATE_PLAYING)
		alert("The game hasn't started yet.")
		return

//	if(still_choose)
//		return
	if(!client)
		return
	var/crazyalert = alert(src, "Do I want to make myself, or am I random?",,"Make myself!","Random!","Cancel")
	switch(crazyalert)
		if("Make myself!")
			client.ready_char = TRUE
			name_make()

		if("Random!")
			client.name_ch = name_generate()
			if(prob(70))
				client.age_ch = rand(18, 40)
			else
				client.age_ch = rand(14, 100)
			client.ready_char = TRUE
			chooseRole()

		if("Cancel")
			return

/mob/dead/new_player/proc/name_make()
	var/nama = input(src, "What name?", "") as text
	if(!nama)
		alert(src, "Give name...")
		client.ready_char = FALSE
		return
	nama = reject_bad_name(nama)
	if(nama)
		client.name_ch = nama
		old_make()
	else
		alert(src, "Give normal name...")
		client.ready_char = FALSE
		return

/mob/dead/new_player/proc/old_make()
	var/namaa = input(src, "How old?", "") as num
	if(namaa < 14 || namaa > 100)
		alert(src, "Give normal age...")
		client.ready_char = FALSE
		return
	client.age_ch = namaa
	race_make()

/mob/dead/new_player/proc/race_make()
	var/skina = input(src, "What race?", "") as anything in list("Whiter", "Negroid", "Jewos", "Arabas")
	hair_make(skina)

/mob/dead/new_player/proc/hair_make(race)
	var/namaa = input(src, "What hair?", "") as anything in list("Bedhead 2", "Bald")
	beard_make(namaa, race)

/mob/dead/new_player/proc/beard_make(hair_type, race)
	var/namkaa = input(src, "What beard?", "") as anything in list("Shaved", "Beard (Very Long)")
	chooseRole(hair_type, namkaa, race)

/mob/dead/new_player/proc/name_generate()
//	var/special_name
	var/first_thing = pick("Jack", "Ivan", "Dontero", "John")
//	special_name = "[first_thing]"
	return first_thing

/mob/dead/new_player/proc/chooseRole(hair_type, beard_type, race)
	if(!client)
		return
	var/static/list/available_roles = list(
		"Villager"
	)
	if(!SSmapping.config?.war_gamemode)
		var/rolevich = input(src, "What role?", "") as null|anything in available_roles
		if(!rolevich)
			alert("Need to choose your role.")
			client.ready_char = FALSE
			return

		switch(rolevich)
			if("Villager")
				client.role_ch = "Villager"
			else
				alert("Unclear. The role of the common Villager.")
				client.role_ch = "Villager"

	dolboEbism(hair_type, beard_type, race)


/mob/dead/new_player/proc/dolboEbism(hair_type, beard_type, race)
	var/crazyalert = alert(src, "Or maybe there was another role?",,"Let's continue!","Yes, it seems like a different role...")
	switch(crazyalert)
		if("Let's continue!")
			for(var/obj/effect/landing/spawn_point as anything in GLOB.jobber_list)
				if(client)
					if(spawn_point.name == client.role_ch)
						if(spawn_point.spending > 0)
							var/list/spawn_locs = list()
							if(isturf(spawn_point.loc))
								spawn_locs += spawn_point.loc
							if(!spawn_locs)
								alert(src, "In fact, something bad is happening there...")
								client.ready_char = FALSE
								return FALSE
							GLOB.new_people_crazy += 1
							client.ready_char = FALSE
							spawn_point.spending--
							var/mob/living/carbon/human/character = new((pick(spawn_locs)))
							important(character, client)
							things(character, client, hair_type, beard_type, race)
							things_two(character, client, src)
						else
							alert(src, "No more slots.")
							client.ready_char = FALSE
							return FALSE
		if("Yes, it seems like a different role...")
			client.ready_char = FALSE
			return FALSE


/mob/dead/new_player/proc/important(mob/living/carbon/human/our, client/john)
	our.gender = pick(MALE, FEMALE)

	if(our.gender == MALE)
		our.body_type = MALE
		our.genitals = GENITALS_MALE
	else if(our.gender == FEMALE)
		our.body_type = FEMALE
		our.genitals = GENITALS_FEMALE
	else
		our.body_type = MALE
		our.genitals = pick(GENITALS_DICKGIRL, GENITALS_CUNTBOY, GENITALS_FUTA)

	our.underwear = "Nude"
	our.undershirt = "Nude"

	// Create the actual genital organs
	give_genital_organs(our)

//	our.way_type = pick("Unprocess", "Process")
	our.chat_color = ""
	our.real_name = john.name_ch
//	if(our.way_type == "Process")
//		our.real_name = "卐 [john.name_ch]"
//	else
//		our.real_name = "卍 [john.name_ch]"
	our.name = our.real_name

	our.age = john.age_ch
	var/crazyagelook
	if(prob(50))
		crazyagelook = our.age - rand(0, 4)
	else
		crazyagelook = our.age + rand(0, 4)
	our.looks_age = crazyagelook
	var/hander = pick(RIGHT_HANDED, LEFT_HANDED, AMBIDEXTROUS)
	our.handed_flags = hander

/mob/dead/new_player/proc/give_genital_organs(mob/living/carbon/human/H)
	// First, remove any existing genital organs
	for(var/obj/item/organ/genital/genital in H.internal_organs)
		qdel(genital)

	// Set up basic DNA features for genitals
	H.dna.features["breasts_size"] = rand(1, 7)
	H.dna.features["breasts_lactation"] = BREASTS_DEFAULT_LACTATION
	H.dna.features["penis_size"] = rand(1, 23)
	H.dna.features["penis_girth"] = PENIS_DEFAULT_GIRTH
	H.dna.features["penis_sheath"] = SHEATH_NONE
	H.dna.features["penis_circumcised"] = FALSE
	H.dna.features["balls_size"] = rand(1, 3)

	// Get the genital set based on assigned gender
	var/genitals_set = H.genitals

	// Create the needed genital organs
	for(var/genital_slot in GLOB.genital_sets[genitals_set])
		// Find the appropriate genital type for this slot
		var/obj/item/genital_type
		switch(genital_slot)
			if(ORGAN_SLOT_PENIS)
				genital_type = /obj/item/organ/genital/penis
			if(ORGAN_SLOT_TESTICLES)
				genital_type = /obj/item/organ/genital/testicles
			if(ORGAN_SLOT_VAGINA)
				genital_type = /obj/item/organ/genital/vagina
			if(ORGAN_SLOT_WOMB)
				genital_type = /obj/item/organ/genital/womb
			if(ORGAN_SLOT_BREASTS)
				genital_type = /obj/item/organ/genital/breasts
			if(ORGAN_SLOT_ANUS)
				genital_type = /obj/item/organ/genital/anus

		if(genital_type)
			// Create and insert the organ
			var/obj/item/organ/genital/new_genital = new genital_type()
			new_genital.Insert(H, FALSE, FALSE)

			// Update its appearance from DNA
			if(new_genital.mutantpart_key)
				H.dna.mutant_bodyparts[new_genital.mutantpart_key] = list(
					MUTANT_INDEX_NAME = new_genital.genital_name,
					MUTANT_INDEX_COLOR = list("#FFFFFF", "#FFFFFF", "#FFFFFF")
				)
				new_genital.build_from_dna(H.dna, new_genital.mutantpart_key)
				new_genital.update_icon_state()

	// Update the body
	H.update_body()

/mob/dead/new_player/proc/things(mob/living/carbon/human/our, client/john, hair_type, beard_type, race)
	if(our.age < 18)
		ADD_TRAIT(our, TRAIT_CHILDO, "special_childo")
	if (prob(100))
		our.vampiric = TRUE
		our.dna.species.bite_sharpness = SHARP_POINTY
	if(("Baby Dream" in SSantagonists.johny_event) && (!HAS_TRAIT(our, TRAIT_CHILDO)))
		our.age = rand(14, 17)
		var/crazyagelook
		if(prob(50))
			crazyagelook = our.age - rand(0, 4)
		else
			crazyagelook = our.age + rand(0, 4)
		our.looks_age = crazyagelook
		ADD_TRAIT(our, TRAIT_CHILDO, "special_childo")
//	if(!SSmapping.config?.war_gamemode)
//		if(prob(10))
//			ADD_TRAIT(our, TRAIT_DMT, "special_dmt")
	if(HAS_TRAIT(our, TRAIT_CHILDO))
		our.height = HUMAN_HEIGHT_SHORTEST
//		our.width = HUMAN_WIDTH_THIN
	else
		var/height_choose = pick(HUMAN_HEIGHT_SHORTEST, HUMAN_HEIGHT_SHORT, HUMAN_HEIGHT_MEDIUM, HUMAN_HEIGHT_TALL, HUMAN_HEIGHT_TALLEST)
		our.height = height_choose
//		our.width = pick(HUMAN_WIDTH_THIN, HUMAN_WIDTH_SLIGHTLY_THIN, HUMAN_WIDTH_AVERAGE, HUMAN_WIDTH_SLIGHTLY_WIDE, HUMAN_WIDTH_WIDE)
	switch(john.role_ch)
		if("Villager")
			our.truerole = "Villager"
			our.pod_faction = "Town"
			our.hairstyle = pick("Bedhead 2", "Bald")
			our.facial_hairstyle = pick("Shaved", "Beard (Very Long)")
			our.racestory = pick("Negroid", "Whiter", "Jewos", "Arabas")
/*
		if("Froggist")
			our.truerole = "Froggist"
			our.pod_faction = "Forest"
			our.hairstyle = pick("Bedhead 2", "Bald")
			our.facial_hairstyle = pick("Shaved", "Beard (Very Long)")
			our.racestory = pick("Negroid", "Whiter", "Jewos", "Arabas")
*/
	if(hair_type)
		our.hairstyle = hair_type
	if(beard_type)
		our.facial_hairstyle = beard_type
	if(race)
		our.racestory = race
	switch(our.truerole)
		if("Villager")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/holier)
			our.equipOutfit(/datum/outfit/vilagrk)

/mob/dead/new_player/proc/things_two(mob/living/carbon/human/our, client/john)
	var/eye_coloring
	var/attributika
	switch(our.racestory)
		if ("Whiter")
			eye_coloring = pick("#201818", "#00320f", "#000032")
			our.skin_tone = pick("caucasian1", "caucasian2", "caucasian3", "albino", "ash")
			our.hair_color = pick("#000000", "#1f120f", "#3b2621ff", "#d7d49f")
			attributika = /datum/attribute_holder/sheet/whiter
		if ("Negroid")
			eye_coloring = pick("#1a0c0c", "#382806", "#201818", "#cc0000", "#ff00b3")
			our.skin_tone = pick("nox", "nox2", "nox3")
			our.hair_color = pick("#000000", "#1d1d1d", "#0f0908", "#030020")
			attributika = /datum/attribute_holder/sheet/nigger
		if ("Jewos")
			eye_coloring = pick("#00320f", "#00772e", "#10bea7")
			our.skin_tone = pick("caucasian1", "caucasian2", "caucasian3", "albino", "ash")
			our.hair_color = pick("#000000", "#1d1d1d", "#0f0908", "#030020")
			attributika = /datum/attribute_holder/sheet/jewos
		if ("Arabas")
			eye_coloring = pick("#000032", "#000077", "#1010be")
			our.skin_tone = pick("arab", "araber", "arabox")
			our.hair_color = pick("#000000", "#362626", "#030211", "#06003a")
			attributika = /datum/attribute_holder/sheet/arabas
//	var/eye_coloring = pick("#000000", "#1f120f","#c30000","#00ffff","#156d0a","#ff00b3")
	our.facial_hair_color = our.hair_color
	switch(john.role_ch)
		if("Pighuman")
			eye_coloring = pick("#000000","#c30000")
	for(var/obj/item/organ/eyes/organ_eyes in our.internal_organs)
		if(organ_eyes.current_zone == BODY_ZONE_PRECISE_L_EYE)
			our.left_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			our.dna.update_ui_block(DNA_LEFT_EYE_COLOR_BLOCK)
		else
			our.right_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			our.dna.update_ui_block(DNA_RIGHT_EYE_COLOR_BLOCK)

	// Check if the human has genital organs, if not create them
	var/has_genitals = FALSE
	for(var/obj/item/organ/genital/organ in our.internal_organs)
		has_genitals = TRUE
		break

	if(!has_genitals)
		// If no genitals were found, we'll need to create them
		// Re-assign genitals based on gender if it wasn't set properly
		if(!our.genitals)
			if(our.gender == MALE)
				our.genitals = GENITALS_MALE
			else if(our.gender == FEMALE)
				our.genitals = GENITALS_FEMALE
			else
				our.genitals = pick(GENITALS_DICKGIRL, GENITALS_CUNTBOY, GENITALS_FUTA)

		// Now create the organs
		give_genital_organs(our)

	our.attributes?.add_sheet(attributika)

//	still_choose = TRUE
//	to_chat(user, span_dead("I reflect myself in all possible colors thanks to the black glass, in all possible directions, giving birth to Maya and hoping that some time I will wake up from this dream. Now I'm playing."))
//	hello_special_trait(our)

	our.key = key
	if(check_rights_for(our.client, R_ADMIN))
		our.client.verbs += /client/proc/debug_variables
	updateshit(our)

/mob/dead/new_player/proc/updateshit(mob/living/carbon/human/our)
//	still_choose = FALSE
	qdel(src)
	our << output(null,"output")

	var/datum/component/babble/babble = our.GetComponent(/datum/component/babble)
	if(!babble)
		switch(our.truerole)
			if("Venturer" || "Villager" || "Guard" || "Jailed" || "Black Witcher")
				if(our.age >= 18)
					if(our.gender != FEMALE)
						our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_male.ogg')
					else
						our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_female.ogg')
				else
					our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/plimpus.ogg')
			if("Cockroach")
				our.AddComponent(/datum/component/babble, 'modular_pod/sound/voice/cockroach/cock_hu3.ogg')
				our.remove_language(/datum/language/common, TRUE, TRUE, LANGUAGE_HALBER)
				our.grant_language(/datum/language/aphasia, TRUE, TRUE, LANGUAGE_HALBER)
				our.language_holder.selected_language = /datum/language/aphasia
			if("Pighuman")
				our.AddComponent(/datum/component/babble, 'modular_pod/sound/eff/pigtalk.ogg')
				our.remove_language(/datum/language/common, TRUE, TRUE, LANGUAGE_HALBER)
				our.grant_language(/datum/language/yoinky, TRUE, TRUE, LANGUAGE_HALBER)
				our.language_holder.selected_language = /datum/language/yoinky
			if("Ladax")
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/plimpus.ogg')
			if("Kador")
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_male.ogg')
			else
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/gakster.ogg')
	else
		switch(our.truerole)
			if("Venturer" || "Villager" || "Guard" || "Jailed" || "Black Witcher")
				if(our.age >= 18)
					if(our.gender != FEMALE)
						babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_male.ogg'
					else
						babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_female.ogg'
				else
					babble.babble_sound_override = 'modular_septic/sound/voice/babble/plimpus.ogg'
			if("Cockroach")
				babble.babble_sound_override = 'modular_pod/sound/voice/cockroach/cock_hu3.ogg'
				our.remove_language(/datum/language/common, TRUE, TRUE, LANGUAGE_HALBER)
				our.grant_language(/datum/language/aphasia, TRUE, TRUE, LANGUAGE_HALBER)
				our.language_holder.selected_language = /datum/language/aphasia
			if("Pighuman")
				babble.babble_sound_override = 'modular_pod/sound/eff/pigtalk.ogg'
				our.remove_language(/datum/language/common, TRUE, TRUE, LANGUAGE_HALBER)
				our.grant_language(/datum/language/yoinky, TRUE, TRUE, LANGUAGE_HALBER)
				our.language_holder.selected_language = /datum/language/yoinky
			if("Ladax")
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/plimpus.ogg'
			if("Kador")
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_male.ogg'
			else
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/gakster.ogg'
		babble.volume = BABBLE_DEFAULT_VOLUME
		babble.duration = BABBLE_DEFAULT_DURATION

	our.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	var/area/joined_area = get_area(our.loc)
	if(joined_area)
		joined_area.on_joining_game(our)
//	for(var/obj/item/organ/genital/genital in our.internal_organs)
//		genital.build_from_dna(our.dna, genital.mutantpart_key)
		// Make sure the icon state is properly set for each genital
//		genital.update_icon_state()
	for(var/obj/item/organ/plushp in our.internal_organs)
		plushp.maxHealth += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
	for(var/obj/item/bodypart/plusbodyhp as anything in our.bodyparts)
		plusbodyhp.max_damage += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
		plusbodyhp.max_stamina_damage += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
	our.gain_extra_effort(1, TRUE)
	switch(our.truerole)
		if("Ladax")
			to_chat(our, span_dead("On a physical level I feel like I want to kill the Kadors."))
			our.playsound_local(our, 'modular_pod/sound/eff/ladax.ogg', 90, FALSE)
		if("Kador")
			to_chat(our, span_dead("On a physical level I feel like I want to kill the Ladaxes."))
			our.playsound_local(our, 'modular_pod/sound/eff/kador.ogg', 60, FALSE)
		else
			if (HAS_TRAIT(our, TRAIT_DMT))
				to_chat(our, span_dead("I am a dream terrorist. I must go to any tree and pull out a laptop from there, with which I can get tools and cause a nuclear explosion. I must blow up this dream, turning it into a singular horror."))
			if (our.vampiric)
				to_chat(our, span_dead("I'M A VAMPIRE... I better not show this beautiful feature to these weak people."))
				our.playsound_local(our, 'modular_pod/gothica/sound/vampiros.ogg', 90, FALSE)
			else
				our.playsound_local(our, 'modular_pod/sound/eff/podpol_hello.ogg', 90, FALSE)
	our.cursings()
	if(our.special_zvanie)
		switch(our.special_zvanie)
			if("Ladax Father")
				to_chat(our, span_yellowteamradio("I'm Ladax Father!"))
			if("Worst Kador")
				to_chat(our, span_yellowteamradio("I'm Worst Kador!"))
			if("Boar")
				to_chat(our, span_redteamradio("I'm BOARhuman!"))

	our.dna.features["body_size"] = BODY_SIZE_NORMAL
	our.dna.update_body_size()
	our.dna.update_dna_identity()
	our.attributes?.update_attributes()
	our.regenerate_icons()
	our.fully_heal(TRUE)
	set_nutrition(300)
	set_hydration(300)
//	var/obj/item/cardydocs/crazy = new(get_turf(src))
//	our.put_in_hands(crazy)
//	var/height_str = capitalize_like_old_man(our.height)
//	var/handa = unparse_handedness(our.handed_flags)
//	crazy.info_about_me = "Name: [our.real_name]\n"
//	crazy.info_about_me += "Date of Birth: [our.age] years ago\n"
//	crazy.info_about_me += "Sex: [our.gender]\n"
//	crazy.info_about_me += "Height: [height_str]\n"
//	crazy.info_about_me += "Dominant Hand: [handa]\n"

//	our.can_fly = TRUE

/mob/dead/new_player/proc/hello_special_trait(mob/living/carbon/human/our)
	var/my_trait = pick(TRAIT_DEPRESSION, TRAIT_PAINLOVER, TRAIT_HYPERSENT, TRAIT_MISANTHROPE)
	ADD_TRAIT(our, my_trait, "special_trait")

/datum/outfit/pigchurch
	name = "Pigchurch Uniform"
	suit = /obj/item/clothing/suit/armor/robanaguzlik
	pants = /obj/item/clothing/pants/steelmailpants/based
	belt = /obj/item/podpol_weapon/klevec

/datum/outfit/vilagrk
	name = "Villager Uniform"
	suit = /obj/item/clothing/suit/armor/robanaguzlik
	pants = /obj/item/clothing/pants/codec/brownpants
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/key/podpol/woody/villagerkey

/datum/outfit/froggist
	name = "Froggist Uniform"
	uniform = /obj/item/clothing/under/codec/maika/rubaha
	pants = /obj/item/clothing/pants/codec/brownpants
	belt = /obj/item/podpol_weapon/klevec


/datum/outfit/lifedrinker
	name = "Lifedrinker Uniform"
	suit = /obj/item/clothing/suit/armor/vest/chainmail/hauberk
	pants = /obj/item/clothing/pants/steelmailpants/based
	neck = /obj/item/clothing/neck/coif
	r_hand = /obj/item/podpol_weapon/sword/horsecutter

/*
	var/mob/dead/observer/ghost = new() // Transfer safety to observer spawning proc.
	var/obj/effect/landing/ghost/spawn_point = locate() in world
	ghost.forceMove(spawn_point.loc)
	ghost.key = key
	ghost.client = client
	ghost.update_appearance()
	ghost.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	ghost.raltaea = TRUE
	SSdroning.play_area_sound(get_area(ghost), ghost?.client)

	QDEL_NULL(mind)
	qdel(src)


		client.name_ch = name_generate()
		if(prob(70))
			client.age_ch = rand(18, 40)
		else
			client.age_ch = rand(18, 100)
		client.ready_char = TRUE
		alert("I remembered who I am!")
		chooseRole()
*/

/*
/mob/dead/new_player/proc/name_generate()
	var/special_name
	var/second_thing = null
	var/third_thing = null
	var/first_thing = pick("Hark", "Sideless", "Moan", "Hax", "Morx", "Nok", "Nox", "Garrett", "Haramec", "Enclave", "Vial", "Torner", "Web", "Hvax", "Coiler", "Boyd", "Hex", "Sacrec", "Rave")
	special_name = "[first_thing]"
	if(prob(40))
		second_thing = pick("Moon", "Stone", "Black")
		special_name = "[first_thing] [second_thing]"
	if(prob(10))
		third_thing = pick("I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X")
		if(second_thing)
			special_name = "[first_thing] [second_thing] [third_thing]"
		else
			special_name = "[first_thing] [third_thing]"
	return special_name

/mob/dead/new_player/proc/chooseRole()
	if(!isnewplayer(src))
		return
	if(!client)
		return
	if(SSmapping.config?.war_gamemode)
		var/rolevich = input("Wait, what role?", "") as text
		switch(rolevich)
			if("Ladax")
				var/numba = GLOB.kapnoe - GLOB.aashol
				if(numba >= 1)
					alert("Too much of them. Play as Kador.")
					client.ready_char = FALSE
					return
				client.role_ch = "ladax"
			if("Kador")
				var/numbar = GLOB.aashol - GLOB.kapnoe
				if(numbar >= 1)
					alert("Too much of them. Play as Ladax.")
					client.ready_char = FALSE
					return
				client.role_ch = "kador"
			if("God SMO")
				if(GLOB.phase_of_war == "Third")
					client.role_ch = "god smo"
				else
					alert("We need Third Phase.")
					client.ready_char = FALSE
					return
			if("Halbermensch")
				if(GLOB.phase_of_war == "Third")
					client.role_ch = "halbermensch"
				else
					alert("We need Third Phase.")
					client.ready_char = FALSE
					return
			else
				var/numba = GLOB.kapnoe - GLOB.aashol
				var/numbor = GLOB.aashol - GLOB.kapnoe
				if(numba <= 1)
					alert("Unclear. The role of the common Ladax.")
					client.role_ch = "ladax"
				else
					if(numbor <= 1)
						alert("Unclear. The role of the common Kador.")
						client.role_ch = "kador"
	else
		var/rolevich = input("Wait, what role?", "") as text
		switch(rolevich)
			if("Venturer")
				client.role_ch = "venturer"
			else
				alert("Unclear. The role of the common Venturer.")
				client.role_ch = "venturer"
	dolboEbism()

/mob/dead/new_player/proc/dolboEbism()
	var/crazyalert = alert("Or maybe there was another role?",,"Let's continue!","Yes, it seems like a different role...")
	switch(crazyalert)
		if("Let's continue!")
			for(var/obj/effect/landing/spawn_point as anything in GLOB.jobber_list)
				if(client)
					if(spawn_point.name == client.role_ch)
						if(spawn_point.spending > 0)
							var/list/spawn_locs = list()
							if(isturf(spawn_point.loc))
								spawn_locs += spawn_point.loc
							if(!spawn_locs)
								alert("In fact, something bad is happening there...")
								client.ready_char = FALSE
								return FALSE
							GLOB.new_people_crazy += 1
							if(client.role_ch != "halbermensch")
								spawn_point.spending--
								var/mob/living/carbon/human/character = new((pick(spawn_locs)))
								important(character)
								things(character)
								things_two(character)
								hello_special_trait(character)
								qdel(src)
								updateshit(character)
							else
								spawn_point.spending--
								var/mob/living/carbon/human/species/halbermensch/character = new((pick(spawn_locs)))
								important(character)
								things(character)
								things_two(character)
								qdel(src)
								updateshit(character)
						else
							alert("No more slots.")
							client.ready_char = FALSE
							return FALSE
		if("Yes, it seems like a different role...")
			client.ready_char = FALSE
			return FALSE

/mob/dead/new_player/proc/important(mob/living/carbon/human/our)
	our.gender = pick(MALE, FEMALE, NEUTER)
	our.genitals = pick(GENITALS_MALE, GENITALS_FEMALE, GENITALS_DICKGIRL, GENITALS_CUNTBOY, GENITALS_FUTA)
	our.body_type = pick(MALE, FEMALE)
	our.chat_color = ""
	our.real_name = client.name_ch
	our.name = our.real_name
	our.age = client.age_ch
	var/hander = pick(RIGHT_HANDED, LEFT_HANDED, AMBIDEXTROUS)
	our.handed_flags = hander
	our.fully_heal(TRUE)

/mob/dead/new_player/proc/things(mob/living/carbon/human/our)
	var/height_choose = pick(HUMAN_HEIGHT_SHORTEST, HUMAN_HEIGHT_SHORT, HUMAN_HEIGHT_MEDIUM, HUMAN_HEIGHT_TALL)
	our.height = height_choose
	switch(client.role_ch)
		if("ladax")
			our.truerole = "Ladax"
			our.pod_faction = "ladax"
			our.hairstyle = "Bedhead 2"
			our.facial_hairstyle = "Shaved"
			our.hair_color = pick("#000000", "#1f120f", "#d7d49f")
			GLOB.kapnoe += 1
		if("kador")
			our.truerole = "Kador"
			our.pod_faction = "kador"
			our.hairstyle = "Bald"
			our.facial_hairstyle = "Shaved"
			GLOB.aashol += 1
		if("venturer")
			our.truerole = "Venturer"
			our.pod_faction = "out"
			our.hairstyle = "Bedhead 2"
			our.facial_hairstyle = "Shaved"
			our.hair_color = pick("#000000", "#1f120f", "#d7d49f")
		if("halbermensch")
			our.real_name = "Halbermensch"
			our.pod_faction = null
			our.truerole = "Halbermensch"
			our.hairstyle = "Bald"
			our.facial_hairstyle = "Shaved"
			our.kaotiks_body = 50
			GLOB.halbera += 1
		if("god smo")
			our.truerole = "God SMO"
			our.pod_faction = "god smo"
			our.hairstyle = "Bedhead 2"
			our.facial_hairstyle = "Shaved"
			our.hair_color = pick("#ff0aff")
			our.kaotiks_body = 100
			our.real_name = "God SMO"
			our.name = our.real_name
			our.height = HUMAN_HEIGHT_TALLEST
			GLOB.smo += 1
	switch(our.truerole)
		if("Ladax")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/kapno)
			if(prob(10))
				our.equipOutfit(/datum/outfit/kapnofather)
				our.special_zvanie = "Ladax Father"
			else
				switch(GLOB.phase_of_war)
					if("First")
						our.equipOutfit(/datum/outfit/kapno)
					if("Second")
						if(prob(20))
							our.equipOutfit(/datum/outfit/kapnosec)
						else
							our.equipOutfit(/datum/outfit/kapno)
					if("Third")
						if(prob(20))
							our.equipOutfit(/datum/outfit/kapnosec)
						else
							our.equipOutfit(/datum/outfit/kapno)
		if("Kador")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/konch)
			if(prob(10))
				our.equipOutfit(/datum/outfit/mostkonch)
				our.special_zvanie = "Worst Kador"
			else
				switch(GLOB.phase_of_war)
					if("First")
						our.equipOutfit(/datum/outfit/konch)
					if("Second")
						if(prob(20))
							our.equipOutfit(/datum/outfit/konchsec)
						else
							our.equipOutfit(/datum/outfit/konch)
					if("Third")
						if(prob(20))
							our.equipOutfit(/datum/outfit/konchsec)
						else
							our.equipOutfit(/datum/outfit/konch)
		if("Prisoner")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/prisoner)
			our.equipOutfit(/datum/outfit/prizoner)
		if("Venturer")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/prisoner)
			our.equipOutfit(/datum/outfit/prizoner)
		if("God SMO")
			our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/svogod)
			our.equipOutfit(/datum/outfit/svogod)
		if("Halbermensch")
			if(client?.ckey == "realmt")
				our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/halbermensch_realmt)
			else
				our.attributes?.add_sheet(/datum/attribute_holder/sheet/job/halbermensch)

/mob/dead/new_player/proc/updateshit(mob/living/carbon/human/our)
	var/datum/component/babble/babble = our.GetComponent(/datum/component/babble)
	if(!babble)
		switch(our.truerole)
			if("Ladax")
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/plimpus.ogg')
			if("Kador")
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_male.ogg')
			if("Venturer")
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/babble_male.ogg')
			if("Halbermensch")
				our.AddComponent(/datum/component/babble, 'modular_pod/sound/mobs_yes/babble/halber.ogg')
			else
				our.AddComponent(/datum/component/babble, 'modular_septic/sound/voice/babble/gakster.ogg')
	else
		switch(our.truerole)
			if("Ladax")
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/plimpus.ogg'
			if("Kador")
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_male.ogg'
			if("Venturer")
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/babble_male.ogg'
			if("Halbermensch")
				our.AddComponent(/datum/component/babble, 'modular_pod/sound/mobs_yes/babble/halber.ogg')
			else
				babble.babble_sound_override = 'modular_septic/sound/voice/babble/gakster.ogg'
		babble.volume = BABBLE_DEFAULT_VOLUME
		babble.duration = BABBLE_DEFAULT_DURATION

	our.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	var/area/joined_area = get_area(our.loc)
	if(joined_area)
		joined_area.on_joining_game(our)
	for(var/obj/item/organ/genital/genital in our.internal_organs)
		genital.build_from_dna(our.dna, genital.mutantpart_key)
	for(var/obj/item/organ/plushp in our.internal_organs)
		plushp.maxHealth += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
	for(var/obj/item/bodypart/plusbodyhp as anything in our.bodyparts)
		plusbodyhp.max_damage += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
		plusbodyhp.max_stamina_damage += GET_MOB_ATTRIBUTE_VALUE(our, STAT_ENDURANCE)
	our.gain_extra_effort(1, TRUE)
	switch(our.truerole)
		if("Ladax")
			to_chat(our, span_dead("On a physical level I feel like I want to kill the Kadors."))
			our.playsound_local(our, 'modular_pod/sound/eff/ladax.ogg', 90, FALSE)
		if("Kador")
			to_chat(our, span_dead("On a physical level I feel like I want to kill the Ladaxes."))
			our.playsound_local(our, 'modular_pod/sound/eff/kador.ogg', 60, FALSE)
		else
			our.playsound_local(our, 'modular_pod/sound/eff/podpol_hello.ogg', 90, FALSE)
	our.cursings()
	if(our.special_zvanie)
		switch(our.special_zvanie)
			if("Ladax Father")
				to_chat(our, span_yellowteamradio("I'm Ladax Father!"))
			if("Worst Kador")
				to_chat(our, span_yellowteamradio("I'm Worst Kador!"))
	our.dna.features["body_size"] = BODY_SIZE_NORMAL
	our.dna.update_body_size()
	our.dna.update_dna_identity()
	our.attributes?.update_attributes()
	our.regenerate_icons()

/mob/dead/new_player/proc/things_two(mob/living/carbon/human/our)
	var/eye_coloring = pick("#000000", "#1f120f","#c30000","#00ffff","#156d0a","#ff00b3")
	switch(client.role_ch)
		if("kador")
			eye_coloring = "#c30000"
	for(var/obj/item/organ/eyes/organ_eyes in our.internal_organs)
		if(organ_eyes.current_zone == BODY_ZONE_PRECISE_L_EYE)
			our.left_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			our.dna.update_ui_block(DNA_LEFT_EYE_COLOR_BLOCK)
		else
			our.right_eye_color = sanitize_hexcolor(eye_coloring, 6, FALSE)
			organ_eyes.old_eye_color = eye_coloring
			our.dna.update_ui_block(DNA_RIGHT_EYE_COLOR_BLOCK)
	mind.active = FALSE
	mind.transfer_to(our)
	mind.set_original_character(our)
	our.key = key

/mob/dead/new_player/proc/hello_special_trait(mob/living/carbon/human/our)
	var/my_trait = pick(TRAIT_DEPRESSION, TRAIT_PAINLOVER, TRAIT_HYPERSENT, TRAIT_MISANTHROPE)
	ADD_TRAIT(our, my_trait, "special_trait")
*/
/datum/outfit/kapno/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		suit = /obj/item/clothing/suit/armor/roba
	if(prob(50))
		head = /obj/item/clothing/head/headbanda/greener

/datum/outfit/kapnosec/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		suit = /obj/item/clothing/suit/armor/roba
	if(prob(50))
		head = /obj/item/clothing/head/headbanda/greener

/datum/outfit/kapnosec
	name = "Kapno Uniform"

	l_pocket = /obj/item/key/podpol/woody/kapnodvorkey
	uniform = /obj/item/clothing/under/codec/purp
	pants = /obj/item/clothing/pants/codec/purp
//	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/gun/ballistic/revolver/remis/nova

/datum/outfit/kapno
	name = "Kapno Uniform"

	l_pocket = /obj/item/key/podpol/woody/kapnodvorkey
	uniform = /obj/item/clothing/under/codec/purp
	pants = /obj/item/clothing/pants/codec/purp
//	shoes = /obj/item/clothing/shoes/jackboots

/datum/outfit/kapnofather/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		suit = /obj/item/clothing/suit/armor/roba

/datum/outfit/kapnofather
	name = "Kapnofather Uniform"

	uniform = null
	r_pocket = /obj/item/key/podpol/woody/kapnokey
	l_pocket = /obj/item/key/podpol/woody/kapnodvorkey
	belt = /obj/item/podpol_weapon/sword/steel
	oversuit = /obj/item/clothing/suit/armor/vest/bulletproofer
	pants = /obj/item/clothing/pants/codec/purp/red
//	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/helmet/codec/def_yel
	neck = /obj/item/clothing/neck/chainer

/datum/outfit/konch/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		suit = /obj/item/clothing/suit/armor/sexcoat
	if(prob(50))
		head = /obj/item/clothing/head/headbanda

/datum/outfit/konchsec/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		suit = /obj/item/clothing/suit/armor/sexcoat
	if(prob(50))
		head = /obj/item/clothing/head/headbanda

/datum/outfit/konchsec
	name = "Konch Uniform"

	l_pocket = /obj/item/key/podpol/woody/konchkey
//	r_pocket = /obj/item/reagent_containers/pill/carbonylmethamphetamine
	uniform = /obj/item/clothing/under/codec/maika
	pants = /obj/item/clothing/pants/codec/panta
//	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/gun/ballistic/shotgun/doublebarrel/bobox

/datum/outfit/konch
	name = "Konch Uniform"

	l_pocket = /obj/item/key/podpol/woody/konchkey
//	r_pocket = /obj/item/reagent_containers/pill/carbonylmethamphetamine
	uniform = /obj/item/clothing/under/codec/maika
	pants = /obj/item/clothing/pants/codec/panta
//	shoes = /obj/item/clothing/shoes/jackboots

/datum/outfit/mostkonch
	name = "Mostkonch Uniform"

	mask = /obj/item/clothing/mask/gas/ballisticarmor
	l_pocket = /obj/item/key/podpol/woody/konchkey
	uniform = /obj/item/clothing/under/codec/maika
	pants = /obj/item/clothing/pants/codec/panta
//	shoes = /obj/item/clothing/shoes/jackboots
//	belt = /obj/item/melee/bita/cep/iron
	r_hand = /obj/item/melee/bita/hammer/sledge
	suit = /obj/item/clothing/suit/armor/vest/chainmail/steel
	back = /obj/item/melee/shieldo/buckler/wooden

/datum/outfit/mostkonch/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		mask = null
		head = /obj/item/clothing/head/helmet/ironhelmos

/datum/outfit/svogod
	name = "Svogod Uniform"

	r_hand = /obj/item/podpol_weapon/axe/big
	l_hand = /obj/item/melee/hehe/pickaxe/iron
//	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/vest/bulletproofer
	back = /obj/item/storage/belt/military/itobe/svo
	neck = /obj/item/clothing/neck/chainer
	suit_store = /obj/item/gun/ballistic/automatic/remis/svd

/datum/outfit/prizoner
	name = "Prizoner Uniform"
	uniform = /obj/item/clothing/under/codec/maika
	pants = /obj/item/clothing/pants/venturer
	shoes = /obj/item/clothing/shoes/laceup

/datum/outfit/ventura
	name = "Ventura Uniform"
	uniform = /obj/item/clothing/under/venturerclassic
	pants = /obj/item/clothing/pants/venturer
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/simcard
	id = /obj/item/cellphone

/datum/outfit/ventura/drug
	name = "Ventura Uniform"
	uniform = /obj/item/clothing/under/venturerclassic
	pants = /obj/item/clothing/pants/venturer
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/simcard
	id = /obj/item/cellphone
	mask = /obj/item/clothing/mask/cigarette/rollie/cannabis
	l_hand = /obj/item/storage/backpack/basket/drug
