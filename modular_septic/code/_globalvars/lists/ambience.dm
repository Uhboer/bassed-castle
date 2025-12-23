GLOBAL_LIST_INIT(generic_ambience,list(null))

GLOBAL_LIST_INIT(maint_ambience,list(null))

GLOBAL_LIST_INIT(escape_ambience,list(null))

GLOBAL_LIST_INIT(lab_ambience,list(null))

GLOBAL_LIST_INIT(zeethree_ambience,list(null))

GLOBAL_LIST_INIT(holy_ambience,list(null))

GLOBAL_LIST_INIT(danger_ambience,list(null))

GLOBAL_LIST_INIT(ruins_ambience,list(null))

GLOBAL_LIST_INIT(engi_ambience,list(null))

GLOBAL_LIST_INIT(mining_ambience,list(null))

GLOBAL_LIST_INIT(medical_ambience,list(null))

GLOBAL_LIST_INIT(spooky_ambience,list(null))

GLOBAL_LIST_INIT(space_ambience,list(null))

GLOBAL_LIST_INIT(elevator_ambience,list(null))

GLOBAL_LIST_INIT(away_ambience,list(null))

GLOBAL_LIST_INIT(reebe_ambience,list(null))

GLOBAL_LIST_INIT(creepy_ambience,list(
	'sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg',
	'sound/effects/heart_beat.ogg', 'sound/effects/screech.ogg',
	'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg',
	'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg',
	'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg',
	'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg',
	'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',
	'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg',
	'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg',
	'sound/hallucinations/over_here3.ogg', 'sound/hallucinations/turn_around1.ogg',
	'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg',
	'sound/hallucinations/wail.ogg'))

GLOBAL_LIST_INIT(outdoor_ambience,list(null))

GLOBAL_LIST_INIT(ambience_assoc,list(
	AMBIENCE_GENERIC = GLOB.generic_ambience,
	AMBIENCE_ELEVATOR = GLOB.elevator_ambience,
	AMBIENCE_OUTDOOR = GLOB.outdoor_ambience,
	AMBIENCE_ESCAPE = GLOB.escape_ambience,
	AMBIENCE_LAB = GLOB.lab_ambience,
	AMBIENCE_ZEETHREE = GLOB.zeethree_ambience,
	AMBIENCE_HOLY = GLOB.holy_ambience,
	AMBIENCE_DANGER = GLOB.danger_ambience,
	AMBIENCE_RUINS = GLOB.ruins_ambience,
	AMBIENCE_ENGI = GLOB.engi_ambience,
	AMBIENCE_MINING = GLOB.mining_ambience,
	AMBIENCE_MEDICAL = GLOB.medical_ambience,
	AMBIENCE_SPOOKY = GLOB.spooky_ambience,
	AMBIENCE_SPACE = GLOB.space_ambience,
	AMBIENCE_MAINT = GLOB.maint_ambience,
	AMBIENCE_AWAY = GLOB.away_ambience,
	AMBIENCE_REEBE = GLOB.reebe_ambience,
	AMBIENCE_CREEPY = GLOB.creepy_ambience))
