// ОДЁЖКА ВСЯКАЯ

/obj/item/clothing/under/codec/purp
	name = "Clothes"
	desc = "Good quality."
	icon = 'modular_pod/icons/obj/clothing/under/under.dmi'
	icon_state = "pur"
	worn_icon = 'modular_pod/icons/mob/clothing/under/under.dmi'
	worn_icon_state = "pur"
	lefthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_lefthand.dmi'
	righthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_righthand.dmi'
	inhand_icon_state = "soldat"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	armor = list(MELEE = 1, BULLET = 1, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)
	carry_weight = 300 GRAMS
	can_adjust = FALSE
	body_parts_covered = CHEST|VITALS|ARMS
/*
	var/picked

/obj/item/clothing/under/codec/purp/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/under/codec/purp/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "Выбери пометку.","Дизайн!") as null|anything in list("Никакая", "Символ", "Сплит")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "Символ")
		design = null
		design = input(user, "Выбери символ.","Дизайн!") as null|anything in list("life")
		if(!design)
			return
		design = "_[design]"
	var/colorone = input(user, "Выбери основной цвет.","Дизайн!") as color|null
	if(!colorone)
		return
	var/colortwo
	if(design != "Никакая")
		colortwo = input(user, "Выбери второй цвет.","Дизайн!") as color|null
		if(!colortwo)
			return
	if(world.time > (the_time + 30 SECONDS))
		return
	picked = TRUE
	if(design != "Никакая")
		detail_tag = design
	switch(design)
		if("Сплит")
			detail_tag = "_spl"
	color = colorone
	if(colortwo)
		detail_color = colortwo
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_w_uniform()

/obj/item/clothing/under/codec/purp/area/red
	picked = TRUE
	detail_color = "#f84e2d"
	detail_tag = "_spl"

/obj/item/clothing/under/codec/purp/area/blue
	picked = TRUE
	detail_color = "#2d4ef8"
	detail_tag = "_spl"

/obj/item/clothing/under/codec/purp/area/Initialize(mapload)
	. = ..()
	update_icon()
*/
// ШТАНИШКИ

/obj/item/clothing/pants/codec/purp
	name = "Pants"
	desc = "Good quality!"
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "pur_pants"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "pur_pants"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 100
	integrity_failure = 0.1
	limb_integrity = 90
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 400 GRAMS
	armor = list(MELEE = 1, BULLET = 1, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)

/obj/item/clothing/under/codec/purp/black
	color = "#151414"

/obj/item/clothing/pants/codec/purp/black
	color = "#151414"

/obj/item/clothing/under/codec/purp/red
	color = "#933400"

/obj/item/clothing/pants/codec/purp/red
	color = "#933400"

/obj/item/clothing/under/codec/maika
	name = "Clothes"
	desc = "Bad quality."
	icon = 'modular_pod/icons/obj/clothing/under/under.dmi'
	icon_state = "maika"
	worn_icon = 'modular_pod/icons/mob/clothing/under/under.dmi'
	worn_icon_state = "maika"
	lefthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_lefthand.dmi'
	righthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_righthand.dmi'
	inhand_icon_state = "soldat"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	armor = list(MELEE = 1, BULLET = 1, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)
	carry_weight = 300 GRAMS
	can_adjust = FALSE
	body_parts_covered = CHEST|VITALS|ARMS|GROIN

/obj/item/clothing/under/codec/maika/based
	name = "Clothes"
	desc = "Based."
	icon = 'modular_pod/icons/obj/clothing/under/under.dmi'
	icon_state = "based"
	worn_icon = 'modular_pod/icons/mob/clothing/under/under.dmi'
	worn_icon_state = "based"
	lefthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_lefthand.dmi'
	righthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_righthand.dmi'
	inhand_icon_state = "soldat"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	armor = list(MELEE = 1, BULLET = 1, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)
	carry_weight = 300 GRAMS
	can_adjust = FALSE
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/under/codec/maika/blacka
	name = "Clothes"
	desc = "Witchery."
	icon = 'modular_pod/icons/obj/clothing/under/under.dmi'
	icon_state = "blacka"
	worn_icon = 'modular_pod/icons/mob/clothing/under/under.dmi'
	worn_icon_state = "blacka"
	lefthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_lefthand.dmi'
	righthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_righthand.dmi'
	inhand_icon_state = "soldat"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	armor = list(MELEE = 1, BULLET = 1, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)
	carry_weight = 300 GRAMS
	can_adjust = FALSE
	body_parts_covered = CHEST|VITALS|ARMS|GROIN


/obj/item/clothing/under/codec/maika/rubaha
	name = "Clothes"
	desc = "A traditional shirt for the most common peasants."
	icon = 'modular_pod/icons/obj/clothing/under/under.dmi'
	icon_state = "rubaha"
	worn_icon = 'modular_pod/icons/mob/clothing/under/under.dmi'
	worn_icon_state = "rubaha"
	lefthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_lefthand.dmi'
	righthand_file = 'modular_septic/icons/mob/inhands/clothing/clothing_righthand.dmi'
	inhand_icon_state = "soldat"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	armor = list(MELEE = 1, BULLET = 1, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)
	carry_weight = 300 GRAMS
	can_adjust = FALSE
	body_parts_covered = CHEST|VITALS|ARMS|GROIN

/obj/item/clothing/pants/codec/brownpants
	name = "Pants"
	desc = "Brown work pants."
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "brownpants"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "brownpants"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 150
	integrity_failure = 0.1
	limb_integrity = 150
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 500 GRAMS
	armor = list(MELEE = 2, BULLET = 2, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)


/obj/item/clothing/pants/codec/camo
	name = "Pants"
	desc = "Camouflage."
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "camo"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "camo"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 150
	integrity_failure = 0.1
	limb_integrity = 150
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 500 GRAMS
	armor = list(MELEE = 2, BULLET = 2, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)

/obj/item/clothing/pants/codec/blacka
	name = "Pants"
	desc = "Witchery."
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "blacka"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "blacka"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 150
	integrity_failure = 0.1
	limb_integrity = 150
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 500 GRAMS
	armor = list(MELEE = 2, BULLET = 2, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)

/obj/item/clothing/pants/codec/panta
	name = "Pants"
	desc = "Bad quality!"
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "panta"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "panta"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 100
	integrity_failure = 0.1
	limb_integrity = 90
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 400 GRAMS
	armor = list(MELEE = 1, BULLET = 1, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)

/obj/item/clothing/pants/armored/caterpillar
	name = "Caterpillar Pants"
	desc = "At least it protects from bullshit."
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "caterpillar"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "caterpillar"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 300
	integrity_failure = 0.1
	limb_integrity = 290
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 600 GRAMS
	subarmor = list(SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE, \
				EDGE_PROTECTION = 35, \
				CRUSHING = 15, \
				CUTTING = 35, \
				PIERCING = 5, \
				IMPALING = 5, \
				LASER = 1, \
				ENERGY = 0, \
				BOMB = 5, \
				BIO = 0, \
				FIRE = 10, \
				ACID = 5, \
				MAGIC = 0, \
				WOUND = 6, \
				ORGAN = 6)

/obj/item/clothing/pants/armored/steel
	name = "Steel Pants"
	desc = "What if you pee in them?"
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "steel_pants"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "steel_pants"
	armor_broken_sound = "heavy"
	armor_damaged_sound = "heavy"
	max_integrity = 500
	integrity_failure = 0.1
	limb_integrity = 450
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 900 GRAMS
	subarmor = list(SUBARMOR_FLAGS = NONE, \
				EDGE_PROTECTION = 75, \
				CRUSHING = 35, \
				CUTTING = 55, \
				PIERCING = 40, \
				IMPALING = 10, \
				LASER = 1, \
				ENERGY = 0, \
				BOMB = 5, \
				BIO = 0, \
				FIRE = 10, \
				ACID = 5, \
				MAGIC = 0, \
				WOUND = 6, \
				ORGAN = 6)

/obj/item/clothing/pants/codec/graya
	name = "Pants"
	desc = "Undefined quality!"
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "grayka_pants"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "grayka_pants"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 100
	integrity_failure = 0.1
	limb_integrity = 90
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 400 GRAMS
	armor = list(MELEE = 1, BULLET = 1, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 2, ACID = 2, WOUND = 1)
