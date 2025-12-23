/obj/item/clothing/suit/armor
	allowed = null
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 35, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50, WOUND = 10)
	/// Body region specific armor values - format is list(BODY_ZONE_X = list(DAMAGE_TYPE = VALUE))
	var/list/regional_armor = null
	/// Body region specific subarmor values - format is list(BODY_ZONE_X = list(DAMAGE_TYPE = VALUE))
	var/list/regional_subarmor = null

/obj/item/clothing/suit/armor/Initialize(mapload)
	. = ..()
	if(!allowed)
		allowed = GLOB.security_vest_allowed
	// Set up default regional armor if not already specified
	if(!regional_armor)
		setup_regional_armor()
	// Set up default regional subarmor if not already specified
	if(!regional_subarmor && subarmor)
		setup_regional_subarmor()

/// Sets up regional armor values based on the main armor values
/obj/item/clothing/suit/armor/proc/setup_regional_armor()
	regional_armor = list()
	// Initialize with default values for all covered body parts
	var/list/covered_zones = get_covered_body_zones()
	for(var/zone in covered_zones)
		regional_armor[zone] = armor.getList()
/*
	// Example: Metal breastplate protects chest well but other areas less
	if(istype(src, /obj/item/clothing/suit/armor/vest))
		modify_regional_armor(BODY_ZONE_CHEST, MELEE, 1.2) // 20% better protection for chest
		if(regional_armor[BODY_ZONE_GROIN])
			modify_regional_armor(BODY_ZONE_GROIN, MELEE, 0.8) // 20% worse for groin
*/
	// Future armor types can override this to implement their specific protection patterns

/// Gets a list of body zones that this armor covers
/obj/item/clothing/suit/armor/proc/get_covered_body_zones()
	var/list/covered_zones = list()
	if(body_parts_covered & CHEST)
		covered_zones += BODY_ZONE_CHEST
	if(body_parts_covered & GROIN)
		covered_zones += BODY_ZONE_PRECISE_GROIN
	if(body_parts_covered & HEAD)
		covered_zones += BODY_ZONE_HEAD
	if(body_parts_covered & LEGS)
		covered_zones += list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	if(body_parts_covered & ARMS)
		covered_zones += list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	return covered_zones

/// Modifies regional armor for a specific body zone and damage type
/obj/item/clothing/suit/armor/proc/modify_regional_armor(zone, damage_type, multiplier)
	if(!regional_armor || !regional_armor[zone])
		return
	
	regional_armor[zone][damage_type] = round(regional_armor[zone][damage_type] * multiplier)

/// Get armor value for a specific body zone and damage type
/obj/item/clothing/suit/armor/proc/get_regional_armor_value(zone, damage_type)
	if(!regional_armor || !regional_armor[zone] || !regional_armor[zone][damage_type])
		return armor.getRating(damage_type) // Fallback to default armor
	
	return regional_armor[zone][damage_type]

/// Update regional armor to apply specific damage type multipliers - for example, enhance cutting protection while reducing piercing protection
/obj/item/clothing/suit/armor/proc/set_damage_type_regional_armor(zone, cutting_mult = 1, piercing_mult = 1, crushing_mult = 1, impaling_mult = 1)
	if(!regional_armor || !regional_armor[zone])
		return
	
	if(!istype(src, /obj/item/clothing/suit/armor))
		return
	
	// Access existing subarmor if it exists
	var/datum/subarmor/existing_subarmor = null
	if(subarmor)
		existing_subarmor = subarmor
	
	// Create region-specific subarmor adjustments
	if(!existing_subarmor.regional_values)
		existing_subarmor.regional_values = list()
	
	if(!existing_subarmor.regional_values[zone])
		existing_subarmor.regional_values[zone] = existing_subarmor.getList()
	
	// Apply multipliers to the specific region's subarmor values
	if(cutting_mult != 1)
		existing_subarmor.regional_values[zone][CUTTING] = round(existing_subarmor.regional_values[zone][CUTTING] * cutting_mult)
	
	if(piercing_mult != 1)
		existing_subarmor.regional_values[zone][PIERCING] = round(existing_subarmor.regional_values[zone][PIERCING] * piercing_mult)
	
	if(crushing_mult != 1)
		existing_subarmor.regional_values[zone][CRUSHING] = round(existing_subarmor.regional_values[zone][CRUSHING] * crushing_mult)
	
	if(impaling_mult != 1)
		existing_subarmor.regional_values[zone][IMPALING] = round(existing_subarmor.regional_values[zone][IMPALING] * impaling_mult)

/// Sets up regional subarmor values based on the main subarmor values
/obj/item/clothing/suit/armor/proc/setup_regional_subarmor()
	if(!subarmor)
		return
	
	regional_subarmor = list()
	// Initialize with default values for all covered body parts
	var/list/covered_zones = get_covered_body_zones()
	for(var/zone in covered_zones)
		regional_subarmor[zone] = subarmor.getList()
/*
	// Apply default modifications based on armor type
	// This can be overridden by specific armor types
	if(istype(src, /obj/item/clothing/suit/armor/vest))
		// Example: Basic vest has better edge protection on chest
		modify_regional_subarmor(BODY_ZONE_CHEST, EDGE_PROTECTION, 1.2)
		modify_regional_subarmor(BODY_ZONE_CHEST, CUTTING, 1.15)
		if(regional_subarmor[BODY_ZONE_GROIN])
			modify_regional_subarmor(BODY_ZONE_GROIN, EDGE_PROTECTION, 0.8)
			modify_regional_subarmor(BODY_ZONE_GROIN, CUTTING, 0.85)
*/
/// Modifies regional subarmor for a specific body zone and damage type
/obj/item/clothing/suit/armor/proc/modify_regional_subarmor(zone, damage_type, multiplier)
	if(!regional_subarmor || !regional_subarmor[zone] || !regional_subarmor[zone][damage_type])
		return
	
	regional_subarmor[zone][damage_type] = round(regional_subarmor[zone][damage_type] * multiplier)

/// Get subarmor value for a specific body zone and damage type
/obj/item/clothing/suit/armor/proc/get_regional_subarmor_value(zone, damage_type)
	if(!regional_subarmor || !regional_subarmor[zone] || !regional_subarmor[zone][damage_type])
		return subarmor?.getRating(damage_type) || 0 // Fallback to default subarmor
	
	return regional_subarmor[zone][damage_type]

/// Creates regional subarmor in a direct format instead of via modifiers
/// @param values - Can be in either full format (full list for each zone) or simplified format (only modified values)
/// Example simplified format:
/// list(
///   BODY_ZONE_CHEST = list(CUTTING = 50, PIERCING = 40),
///   BODY_ZONE_GROIN = list(CUTTING = 30, PIERCING = 20)
/// )
/obj/item/clothing/suit/armor/proc/direct_regional_subarmor(list/values)
	if(!subarmor)
		return
		
	regional_subarmor = list()
	var/list/covered_zones = get_covered_body_zones()
	
	// Check if using simplified format (not all values specified)
	var/simplified_format = FALSE
	if(length(values) > 0)
		var/first_zone = values[1]
		if(first_zone in values && length(values[first_zone]) < 10) // If less than 10 values, it's simplified
			simplified_format = TRUE
	
	// Process each covered zone
	for(var/zone in covered_zones)
		if(simplified_format)
			// Initialize with default values
			regional_subarmor[zone] = subarmor.getList()
			
			// Apply specific modifications if specified
			if(zone in values)
				var/list/mods = values[zone]
				for(var/damage_type in mods)
					regional_subarmor[zone][damage_type] = mods[damage_type]
		else
			// Full format - use provided values or defaults
			if(zone in values)
				regional_subarmor[zone] = values[zone]
			else
				regional_subarmor[zone] = subarmor.getList()
	
	// If not all values were provided in full format, ensure all required zones have values
	for(var/zone in covered_zones)
		if(!regional_subarmor[zone])
			regional_subarmor[zone] = subarmor.getList()

/obj/item/clothing/suit/armor/vest
	name = "armor vest"
	desc = "A slim Type I armored vest that provides decent protection against most types of damage."
	icon_state = "armoralt"
	inhand_icon_state = "armoralt"
	blood_overlay_type = "armor"
	dog_fashion = /datum/dog_fashion/back

/obj/item/clothing/suit/armor/vest/alt
	desc = "A Type I armored vest that provides decent protection against most types of damage."
	icon_state = "armor"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/armor/vest/marine
	name = "marine combat armor"
	desc = "A multirole set of armor used by the marines, painted in a tacticool black color with blue markings to indicate you might be important."
	icon_state = "marine_command"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(MELEE = 40, BULLET = 50, LASER = 25, ENERGY = 25, BOMB = 50, BIO = 20, FIRE = 40, ACID = 50, WOUND = 20)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/armor/vest/marine/security
	name = "marine heavy armor"
	desc = "A heavy set of armor that still allows full mobility, offering higher protection at the cost of having red targets painted on your shoulders."
	icon_state = "marine_security"
	armor = list(MELEE = 45, BULLET = 60, LASER = 30, ENERGY = 30, BOMB = 40, BIO = 20, FIRE = 50, ACID = 50, WOUND = 20)

/obj/item/clothing/suit/armor/vest/marine/engineer
	name = "marine utility armor"
	desc = "A light set of armor with a mounted satchel for storing things. You realized too late that pouches are only for looks, and don't actually work. No refunds."
	icon_state = "marine_engineer"
	armor = list(MELEE = 35, BULLET = 40, LASER = 20, ENERGY = 20, BOMB = 70, BIO = 20, FIRE = 70, ACID = 70, WOUND = 10)

/obj/item/clothing/suit/armor/vest/marine/medic
	name = "marine medic armor"
	desc = "Light armor with needlessly large arm and leg plates, they provide no extra protection, but you feel safer."
	icon_state = "marine_medic"
	armor = list(MELEE = 35, BULLET = 40, LASER = 20, ENERGY = 20, BOMB = 30, BIO = 30, FIRE = 50, ACID = 70, WOUND = 10)

/obj/item/clothing/suit/armor/vest/old
	name = "degrading armor vest"
	desc = "Older generation Type 1 armored vest. Due to degradation over time the vest is far less maneuverable to move in."
	icon_state = "armor"
	inhand_icon_state = "armor"
	slowdown = 1

/obj/item/clothing/suit/armor/vest/blueshirt
	name = "large armor vest"
	desc = "A large, yet comfortable piece of armor, protecting you from some threats."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"
	custom_premium_price = PAYCHECK_HARD

/obj/item/clothing/suit/armor/vest/cuirass
	name = "cuirass"
	desc = "A lighter plate armor used to still keep out those pesky arrows, while retaining the ability to move."
	icon_state = "cuirass"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/armor/hos
	name = "armored greatcoat"
	desc = "A greatcoat enhanced with a special alloy for some extra protection and style for those with a commanding presence."
	icon_state = "hos"
	inhand_icon_state = "greatcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 0, FIRE = 70, ACID = 90, WOUND = 10)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 80

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "armored trenchcoat"
	desc = "A trenchcoat enhanced with a special lightweight kevlar. The epitome of tactical plainclothes."
	icon_state = "hostrench"
	inhand_icon_state = "hostrench"
	flags_inv = 0
	strip_delay = 80

/obj/item/clothing/suit/armor/hos/hos_formal
	name = "\improper Head of Security's parade jacket"
	desc = "For when an armoured vest isn't fashionable enough."
	icon_state = "hosformal"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/armor/hos/hos_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/vest/warden
	name = "warden's jacket"
	desc = "A navy-blue armored jacket with blue shoulder designations and '/Warden/' stitched into one of the chest pockets."
	icon_state = "warden_alt"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	strip_delay = 70
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "warden's armored jacket"
	desc = "A red jacket with silver rank pips and body armor strapped on top."
	icon_state = "warden_jacket"

/obj/item/clothing/suit/armor/vest/leather
	name = "security overcoat"
	desc = "Lightly armored leather overcoat meant as casual wear for high-ranking officers. Bears the crest of Nanotrasen Security."
	icon_state = "leathercoat-sec"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/capcarapace
	name = "captain's carapace"
	desc = "A fireproof armored chestpiece reinforced with ceramic plates and plasteel pauldrons to provide additional protection whilst still offering maximum mobility and flexibility. Issued only to the station's finest, although it does chafe your nipples."
	icon_state = "capcarapace"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 50, BOMB = 25, BIO = 0, FIRE = 100, ACID = 90, WOUND = 10)
	dog_fashion = null
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	name = "syndicate captain's vest"
	desc = "A sinister looking vest of advanced armor worn over a black and red fireproof jacket. The gold collar and shoulders denote that this belongs to a high ranking syndicate officer."
	icon_state = "syndievest"

/obj/item/clothing/suit/armor/vest/capcarapace/captains_formal
	name = "captain's parade jacket"
	desc = "For when an armoured vest isn't fashionable enough."
	icon_state = "capformal"
	inhand_icon_state = "capspacesuit"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/armor/vest/capcarapace/captains_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "A suit of semi-flexible polycarbonate body armor with heavy padding to protect against melee attacks. Helps the wearer resist shoving in close quarters."
	icon_state = "riot"
	inhand_icon_state = "swat_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, FIRE = 80, ACID = 80, WOUND = 20)
	clothing_flags = BLOCKS_SHOVE_KNOCKDOWN
	strip_delay = 80
	equip_delay_other = 60

/obj/item/clothing/suit/armor/bone
	name = "bone armor"
	desc = "A tribal armor plate, crafted from animal bone."
	icon_state = "bonearmor"
	inhand_icon_state = "bonearmor"
	blood_overlay_type = "armor"
	armor = list(MELEE = 35, BULLET = 25, LASER = 25, ENERGY = 35, BOMB = 25, BIO = 0, FIRE = 50, ACID = 50, WOUND = 10)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS

/obj/item/clothing/suit/armor/bulletproof
	name = "bulletproof armor"
	desc = "A Type III heavy bulletproof vest that excels in protecting the wearer against traditional projectile weaponry and explosives to a minor extent."
	icon_state = "bulletproof"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	armor = list(MELEE = 15, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 0, FIRE = 50, ACID = 50, WOUND = 20)
	strip_delay = 70
	equip_delay_other = 50

/obj/item/clothing/suit/armor/laserproof
	name = "reflector vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles, as well as occasionally reflecting them."
	icon_state = "armor_reflec"
	inhand_icon_state = "armor_reflec"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	armor = list(MELEE = 10, BULLET = 10, LASER = 60, ENERGY = 60, BOMB = 0, BIO = 0, FIRE = 100, ACID = 100)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/hit_reflect_chance = 50

/obj/item/clothing/suit/armor/laserproof/IsReflect(def_zone)
	if(!(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

/obj/item/clothing/suit/armor/vest/det_suit
	name = "detective's armor vest"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/det_suit/Initialize(mapload)
	. = ..()
	allowed = GLOB.detective_vest_allowed

/obj/item/clothing/suit/armor/vest/infiltrator
	name = "infiltrator vest"
	desc = "This vest appears to be made of of highly flexible materials that absorb impacts with ease."
	icon_state = "infiltrator"
	inhand_icon_state = "infiltrator"
	armor = list(MELEE = 40, BULLET = 40, LASER = 30, ENERGY = 40, BOMB = 70, BIO = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	strip_delay = 80

//All of the armor below is mostly unused

/obj/item/clothing/head/helmet/space/hardsuit/swat/centcom
	name = "\improper CentCom SWAT helmet"
	icon = 'icons/obj/clothing/hats.dmi'
	worn_icon = 'icons/mob/clothing/head.dmi'
	worn_icon_state = "centcomspace"
	icon_state = "centcomspace"
	inhand_icon_state = "centcomspacehelmet"
	desc = "A tactical MK.II SWAT helmet boasting better protection and a reasonable fashion sense."

/obj/item/clothing/suit/space/hardsuit/swat/centcom
	name = "\improper CentCom SWAT armor"
	desc = "A MK.II SWAT suit with streamlined joints and armor made out of superior materials, insulated against intense heat with the complementary gas mask. Usually given to station Captains, this one has been painted CC green with complimentary gold accents."
	icon_state = "centcom"
	inhand_icon_state = "centcomspacesuit"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/swat/centcom
	cell = /obj/item/stock_parts/cell/super

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	inhand_icon_state = "swat_suit"
	w_class = WEIGHT_CLASS_BULKY
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, FIRE = 90, ACID = 90)

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, FIRE = 90, ACID = 90)

/obj/item/clothing/suit/armor/tdome/red
	name = "thunderdome suit"
	desc = "Reddish armor."
	icon_state = "tdred"
	inhand_icon_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "thunderdome suit"
	desc = "Pukish armor." //classy.
	icon_state = "tdgreen"
	inhand_icon_state = "tdgreen"

/obj/item/clothing/suit/armor/tdome/holosuit
	name = "thunderdome suit"
	armor = list(MELEE = 10, BULLET = 10, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	cold_protection = null
	heat_protection = null

/obj/item/clothing/suit/armor/tdome/holosuit/red
	desc = "Reddish armor."
	icon_state = "tdred"
	inhand_icon_state = "tdred"

/obj/item/clothing/suit/armor/tdome/holosuit/green
	desc = "Pukish armor."
	icon_state = "tdgreen"
	inhand_icon_state = "tdgreen"

/obj/item/clothing/suit/armor/riot/knight
	name = "plate armour"
	desc = "A classic suit of plate armour, highly effective at stopping melee attacks."
	icon_state = "knight_green"
	inhand_icon_state = "knight_green"
	allowed = list(/obj/item/nullrod, /obj/item/claymore, /obj/item/banner, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)

/obj/item/clothing/suit/armor/riot/knight/yellow
	icon_state = "knight_yellow"
	inhand_icon_state = "knight_yellow"

/obj/item/clothing/suit/armor/riot/knight/blue
	icon_state = "knight_blue"
	inhand_icon_state = "knight_blue"

/obj/item/clothing/suit/armor/riot/knight/red
	icon_state = "knight_red"
	inhand_icon_state = "knight_red"

/obj/item/clothing/suit/armor/riot/knight/greyscale
	name = "knight armour"
	desc = "A classic suit of armour, able to be made from many different materials."
	icon_state = "knight_greyscale"
	inhand_icon_state = "knight_greyscale"
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS//Can change color and add prefix
	armor = list(MELEE = 35, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, FIRE = 40, ACID = 40, WOUND = 15)

/obj/item/clothing/suit/armor/vest/durathread
	name = "durathread vest"
	desc = "A vest made of durathread with strips of leather acting as trauma plates."
	icon_state = "durathread"
	inhand_icon_state = "durathread"
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 200
	resistance_flags = FLAMMABLE
	armor = list(MELEE = 20, BULLET = 10, LASER = 30, ENERGY = 40, BOMB = 15, BIO = 0, FIRE = 40, ACID = 50)

/obj/item/clothing/suit/armor/vest/russian
	name = "russian vest"
	desc = "A bulletproof vest with forest camo. Good thing there's plenty of forests to hide in around here, right?"
	icon_state = "rus_armor"
	inhand_icon_state = "rus_armor"
	armor = list(MELEE = 25, BULLET = 30, LASER = 0, ENERGY = 10, BOMB = 10, BIO = 0, FIRE = 20, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/vest/russian_coat
	name = "russian battle coat"
	desc = "Used in extremly cold fronts, made out of real bears."
	icon_state = "rus_coat"
	inhand_icon_state = "rus_coat"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 30, BOMB = 20, BIO = 50, FIRE = -10, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/elder_atmosian
	name = "\improper Elder Atmosian Armor"
	desc = "A superb armor made with the toughest and rarest materials available to man."
	icon_state = "h2armor"
	inhand_icon_state = "h2armor"
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS//Can change color and add prefix
	armor = list(MELEE = 25, BULLET = 20, LASER = 30, ENERGY = 30, BOMB = 85, BIO = 10, FIRE = 65, ACID = 40, WOUND = 15)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/centcom_formal
	name = "\improper CentCom formal coat"
	desc = "A stylish coat given to CentCom Commanders. Perfect for sending ERTs to suicide missions with style!"
	icon_state = "centcom_formal"
	inhand_icon_state = "centcom"
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(MELEE = 35, BULLET = 40, LASER = 40, ENERGY = 50, BOMB = 35, BIO = 10, FIRE = 10, ACID = 60)

/obj/item/clothing/suit/armor/centcom_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/*
/obj/item/clothing/suit/armor/medieval/plate
	name = "full plate armor"
	desc = "An advanced medieval armor suit that provides excellent protection for the chest and moderate protection for limbs, with carefully designed articulated joints."
	icon_state = "knight_greyscale"
	inhand_icon_state = "knight_greyscale"
	armor = list(MELEE = 40, BULLET = 5, LASER = 5, ENERGY = 5, BOMB = 15, BIO = 0, FIRE = 40, ACID = 40, WOUND = 30)
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	subarmor = list(SUBARMOR_FLAGS = NONE, \
				EDGE_PROTECTION = 70, \
				CRUSHING = 35, \
				CUTTING = 70, \
				PIERCING = 35, \
				IMPALING = 25, \
				LASER = 5, \
				ENERGY = 5, \
				BOMB = 10, \
				BIO = 0, \
				FIRE = 10, \
				ACID = 10, \
				MAGIC = 0, \
				WOUND = 30, \
				ORGAN = 15)

/obj/item/clothing/suit/armor/medieval/plate/Initialize(mapload)
	. = ..()
	
	// Set up regional subarmor directly with the specified format
	direct_regional_subarmor(list(
		BODY_ZONE_CHEST = list(
			SUBARMOR_FLAGS = NONE,
			EDGE_PROTECTION = 85,
			CRUSHING = 45,
			CUTTING = 85,
			PIERCING = 45,
			IMPALING = 35,
			LASER = 7,
			ENERGY = 7,
			BOMB = 15,
			BIO = 0,
			FIRE = 15,
			ACID = 15,
			MAGIC = 0,
			WOUND = 40,
			ORGAN = 25
		),
		BODY_ZONE_GROIN = list(
			SUBARMOR_FLAGS = NONE,
			EDGE_PROTECTION = 75,
			CRUSHING = 40,
			CUTTING = 75,
			PIERCING = 40,
			IMPALING = 30,
			LASER = 6,
			ENERGY = 6,
			BOMB = 12,
			BIO = 0,
			FIRE = 12,
			ACID = 12,
			MAGIC = 0,
			WOUND = 35,
			ORGAN = 20
		),
		BODY_ZONE_L_ARM = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 50,
			CRUSHING = 25,
			CUTTING = 50,
			PIERCING = 20,
			IMPALING = 15,
			LASER = 3,
			ENERGY = 3,
			BOMB = 7,
			BIO = 0,
			FIRE = 7,
			ACID = 7,
			MAGIC = 0,
			WOUND = 20,
			ORGAN = 10
		),
		BODY_ZONE_R_ARM = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 50,
			CRUSHING = 25,
			CUTTING = 50,
			PIERCING = 20,
			IMPALING = 15,
			LASER = 3,
			ENERGY = 3,
			BOMB = 7,
			BIO = 0,
			FIRE = 7,
			ACID = 7,
			MAGIC = 0,
			WOUND = 20,
			ORGAN = 10
		),
		BODY_ZONE_L_LEG = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 60,
			CRUSHING = 30,
			CUTTING = 60,
			PIERCING = 25,
			IMPALING = 20,
			LASER = 4,
			ENERGY = 4,
			BOMB = 8,
			BIO = 0,
			FIRE = 8,
			ACID = 8,
			MAGIC = 0,
			WOUND = 25,
			ORGAN = 12
		),
		BODY_ZONE_R_LEG = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 60,
			CRUSHING = 30,
			CUTTING = 60,
			PIERCING = 25,
			IMPALING = 20,
			LASER = 4,
			ENERGY = 4,
			BOMB = 8,
			BIO = 0,
			FIRE = 8,
			ACID = 8,
			MAGIC = 0,
			WOUND = 25,
			ORGAN = 12
		)
	))

/obj/item/clothing/suit/armor/modern_kevlar
	name = "advanced kevlar vest"
	desc = "A modern tactical vest with different kevlar weaves and ceramic inserts optimized for different body regions and threat types."
	icon_state = "bulletproof"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	armor = list(MELEE = 20, BULLET = 50, LASER = 15, ENERGY = 15, BOMB = 30, BIO = 0, FIRE = 40, ACID = 40, WOUND = 20)
	body_parts_covered = CHEST|GROIN
	subarmor = list(SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE, \
				EDGE_PROTECTION = 30, \
				CRUSHING = 20, \
				CUTTING = 30, \
				PIERCING = 40, \
				IMPALING = 35, \
				LASER = 10, \
				ENERGY = 10, \
				BOMB = 25, \
				BIO = 0, \
				FIRE = 10, \
				ACID = 10, \
				MAGIC = 0, \
				WOUND = 20, \
				ORGAN = 15)

/obj/item/clothing/suit/armor/modern_kevlar/Initialize(mapload)
	. = ..()
	
	// Set up regional subarmor directly using the subarmor list structure
	direct_regional_subarmor(list(
		BODY_ZONE_CHEST = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 35,
			CRUSHING = 25,
			CUTTING = 35,
			PIERCING = 50, // Better against bullets in chest
			IMPALING = 40,
			LASER = 12,
			ENERGY = 12,
			BOMB = 30,
			BIO = 0,
			FIRE = 12,
			ACID = 12,
			MAGIC = 0,
			WOUND = 25,
			ORGAN = 20
		),
		BODY_ZONE_GROIN = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 25,
			CRUSHING = 15,
			CUTTING = 25,
			PIERCING = 30, // Less protection for groin
			IMPALING = 25,
			LASER = 8,
			ENERGY = 8,
			BOMB = 20,
			BIO = 0,
			FIRE = 8,
			ACID = 8,
			MAGIC = 0,
			WOUND = 15,
			ORGAN = 10
		)
	))

/obj/item/clothing/suit/armor/wasteland
	name = "wasteland scavenger armor"
	desc = "A makeshift suit of armor made from various materials. It provides different levels of protection for different body parts based on the materials available."
	icon_state = "armoralt"
	inhand_icon_state = "armoralt"
	armor = list(MELEE = 25, BULLET = 20, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 0, FIRE = 20, ACID = 20, WOUND = 10)
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	subarmor = list(SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE, \
				EDGE_PROTECTION = 20, \
				CRUSHING = 15, \
				CUTTING = 20, \
				PIERCING = 15, \
				IMPALING = 10, \
				LASER = 5, \
				ENERGY = 5, \
				BOMB = 10, \
				BIO = 0, \
				FIRE = 5, \
				ACID = 5, \
				MAGIC = 0, \
				WOUND = 10, \
				ORGAN = 5)

/obj/item/clothing/suit/armor/wasteland/Initialize(mapload)
	. = ..()
	
	// Set up regional subarmor directly with very distinct values for each region
	direct_regional_subarmor(list(
		// Metal plate chest protection
		BODY_ZONE_CHEST = list(
			SUBARMOR_FLAGS = NONE,
			EDGE_PROTECTION = 45,
			CRUSHING = 25,
			CUTTING = 40,
			PIERCING = 30,
			IMPALING = 20,
			LASER = 15,
			ENERGY = 5,
			BOMB = 15,
			BIO = 0,
			FIRE = 10,
			ACID = 5,
			MAGIC = 0,
			WOUND = 15,
			ORGAN = 10
		),
		// Leather groin protection
		BODY_ZONE_GROIN = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 15,
			CRUSHING = 10,
			CUTTING = 25,
			PIERCING = 10,
			IMPALING = 5,
			LASER = 3,
			ENERGY = 3,
			BOMB = 5,
			BIO = 0,
			FIRE = 3,
			ACID = 3,
			MAGIC = 0,
			WOUND = 5,
			ORGAN = 3
		),
		// Right arm has metal plates
		BODY_ZONE_R_ARM = list(
			SUBARMOR_FLAGS = NONE,
			EDGE_PROTECTION = 30,
			CRUSHING = 20,
			CUTTING = 30,
			PIERCING = 20,
			IMPALING = 15,
			LASER = 10,
			ENERGY = 3,
			BOMB = 10,
			BIO = 0,
			FIRE = 5,
			ACID = 5,
			MAGIC = 0,
			WOUND = 10,
			ORGAN = 5
		),
		// Left arm has just leather
		BODY_ZONE_L_ARM = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 10,
			CRUSHING = 5,
			CUTTING = 15,
			PIERCING = 5,
			IMPALING = 3,
			LASER = 2,
			ENERGY = 2,
			BOMB = 3,
			BIO = 0,
			FIRE = 2,
			ACID = 2,
			MAGIC = 0,
			WOUND = 3,
			ORGAN = 2
		),
		// Right leg has leather with some metal bits
		BODY_ZONE_R_LEG = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 20,
			CRUSHING = 15,
			CUTTING = 25,
			PIERCING = 15,
			IMPALING = 10,
			LASER = 5,
			ENERGY = 3,
			BOMB = 5,
			BIO = 0,
			FIRE = 3,
			ACID = 3,
			MAGIC = 0,
			WOUND = 5,
			ORGAN = 3
		),
		// Left leg has minimal protection
		BODY_ZONE_L_LEG = list(
			SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE,
			EDGE_PROTECTION = 5,
			CRUSHING = 3,
			CUTTING = 10,
			PIERCING = 3,
			IMPALING = 2,
			LASER = 1,
			ENERGY = 1,
			BOMB = 2,
			BIO = 0,
			FIRE = 1,
			ACID = 1,
			MAGIC = 0,
			WOUND = 2,
			ORGAN = 1
		)
	))

*/