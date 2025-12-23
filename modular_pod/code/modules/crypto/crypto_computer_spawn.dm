/**
 * Cryptocurrency Computer Registration
 * Makes the computer available in-game through spawn menus
 */

/obj/item/wallframe/crypto_computer_kit
	name = "cryptocurrency terminal kit"
	desc = "A kit containing everything needed to build a wall-mounted cryptocurrency terminal."
	icon = 'icons/obj/computer.dmi'
	icon_state = "telescreen"
	result_path = /obj/structure/crypto_computer/wall
	pixel_shift = 32

/obj/structure/crypto_computer/wall
	name = "wall-mounted cryptocurrency terminal"
	desc = "A wall-mounted terminal for investing in and trading cryptocurrencies."
	icon_state = "crypto_wall"
	anchored = TRUE
	density = FALSE
	pixel_y = 32

// Portable variant
/obj/item/crypto_computer_portable
	name = "portable cryptocurrency terminal"
	desc = "A portable terminal for cryptocurrency trading on the go."
	icon = 'icons/obj/computer.dmi'
	icon_state = "laptop-closed"
	var/obj/structure/crypto_computer/internal_computer

/obj/item/crypto_computer_portable/Initialize(mapload)
	. = ..()
	internal_computer = new /obj/structure/crypto_computer()
	internal_computer.news_cooldown = 120 SECONDS // Twice as long between updates for portable version

/obj/item/crypto_computer_portable/Destroy()
	QDEL_NULL(internal_computer)
	return ..()

/obj/item/crypto_computer_portable/attack_self(mob/user)
	if(!internal_computer)
		to_chat(user, "<span class='warning'>The terminal appears to be damaged!</span>")
		return
	
	to_chat(user, "<span class='notice'>You open up the [src] and access the cryptocurrency terminal.</span>")
	internal_computer.attack_hand(user)

// High-tech variant
/obj/structure/crypto_computer/advanced
	name = "advanced cryptocurrency terminal"
	desc = "A high-tech terminal with real-time data processing for cryptocurrency trading."
	icon_state = "crypto_advanced"
	news_cooldown = 30 SECONDS // Faster updates

/obj/structure/crypto_computer/advanced/Initialize(mapload)
	. = ..()
	// The advanced terminal starts with more historical data
	for(var/i in 1 to 5)
		process() // Run the process 5 times to build up history 