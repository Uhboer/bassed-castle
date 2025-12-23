/obj/structure/tank_core/MouseDrop(mob/living/target, mob/living/user)
	if(target != user)
		return
	
	if(driver)
		to_chat(user, "<span class='warning'>This tank already has a driver!</span>")
		return
	
	if(!check_integrity())
		to_chat(user, "<span class='warning'>The tank is damaged and cannot move!</span>")
		return
	
	if(!do_after(user, 2 SECONDS, src))
		return
	
	driver = user
	user.forceMove(src)
	to_chat(user, "<span class='notice'>You enter the tank.</span>")

/obj/structure/tank_core/verb/exit_tank()
	set name = "Exit Tank"
	set category = "Tank"
	set src in view(0)
	
	if(driver != usr)
		to_chat(usr, "<span class='warning'>You are not the driver of this tank!</span>")
		return
	
	driver.forceMove(get_turf(src))
	driver = null
	to_chat(usr, "<span class='notice'>You exit the tank.</span>")

/obj/structure/tank_core/relaymove(mob/user, direction)
	if(user != driver)
		return
	
	if(!check_integrity())
		to_chat(user, "<span class='warning'>The tank is damaged and cannot move!</span>")
		return
	
	try_move(direction)

/obj/structure/tank_gun/verb/fire_gun()
	set name = "Fire"
	set category = "Tank"
	set src in view(1)
	
	var/obj/structure/tank_core/C = core
	if(!C || C.driver != usr)
		to_chat(usr, "<span class='warning'>You cannot fire this gun!</span>")
		return
	
	if(!fire())
		to_chat(usr, "<span class='warning'>The gun is reloading!</span>")
		return
	
	to_chat(usr, "<span class='notice'>You fire the gun.</span>") 