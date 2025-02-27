/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	req_access = null
	can_weld_shut = FALSE
	horizontal = TRUE
	allow_objects = TRUE
	allow_dense = TRUE
	dense_when_open = TRUE
	climbable = TRUE
	climb_time = 10 //real fast, because let's be honest stepping into or onto a crate is easy
	climb_stun = 0 //climbing onto crates isn't hard, guys
	delivery_icon = "deliverycrate"
	material_drop = /obj/item/stack/sheet/plasteel
	material_drop_amount = 5
	var/obj/item/paper/fluff/jobs/cargo/manifest/manifest

/obj/structure/closet/crate/New()
	..()
	if(icon_state == "[initial(icon_state)]open")
		opened = TRUE
	update_icon()

/obj/structure/closet/crate/CanAllowThrough(atom/movable/mover, border_dir)
	..()
	if(!istype(mover, /obj/structure/closet))
		var/obj/structure/closet/crate/locatedcrate = locate(/obj/structure/closet/crate) in get_turf(mover)
		if(locatedcrate) //you can walk on it like tables, if you're not in an open crate trying to move to a closed crate
			if(opened) //if we're open, allow entering regardless of located crate openness
				return 1
			if(!locatedcrate.opened) //otherwise, if the located crate is closed, allow entering
				return 1
	if(barricade == FALSE)
		return !density
	else if(density == FALSE)
		return 1
	else if(istype(mover, /obj/item/projectile)) //bullets can fly over crates, guaranteed if the shooter is adjacent
		var/obj/item/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return 1
		if(prob(proj_pass_rate))
			return 1
		return 0
	else
		return !density

/obj/structure/closet/crate/update_icon_state()
	icon_state = "[initial(icon_state)][opened ? "open" : ""]"

/obj/structure/closet/crate/closet_update_overlays(list/new_overlays)
	. = new_overlays
	if(manifest)
		. += "manifest"

/obj/structure/closet/crate/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	. = ..()
	if(manifest)
		tear_manifest(user)

/obj/structure/closet/crate/tool_interact(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_WIRECUTTER && manifest)
		tear_manifest(user)
		return TRUE
	return ..()

/obj/structure/closet/crate/open(mob/living/user)
	. = ..()
	if(. && manifest)
		to_chat(user, span_notice("The manifest is torn off [src]."))
		playsound(src, 'sound/items/poster_ripped.ogg', 75, 1)
		manifest.forceMove(get_turf(src))
		manifest = null
		update_icon()

/obj/structure/closet/crate/handle_lock_addition()
	return

/obj/structure/closet/crate/handle_lock_removal()
	return

/obj/structure/closet/crate/proc/tear_manifest(mob/user)
	to_chat(user, span_notice("You tear the manifest off of [src]."))
	playsound(src, 'sound/items/poster_ripped.ogg', 75, 1)

	manifest.forceMove(loc)
	if(ishuman(user))
		user.put_in_hands(manifest)
	manifest = null
	update_icon()

/obj/structure/closet/crate/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	resistance_flags = FLAMMABLE
	can_weld_shut = FALSE
	breakout_time = 200
	max_integrity = 70
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 5
	var/pryLidTimer = 250

/obj/structure/closet/crate/coffin/examine(mob/user)
	. = ..()
	if(user.mind?.has_antag_datum(ANTAG_DATUM_BLOODSUCKER))
		. += span_cult("This is a coffin which you can use to regenerate your burns and other wounds faster.")
		. += span_cult("You can also thicken your blood if you survive the day, and hide from the sun safely while inside.")
	/*	if(user.mind.has_antag_datum(ANTAG_DATUM_VASSAL)
			. += {"<span class='cult'>This is a coffin which your master can use to shield himself from the unforgiving sun.\n
			You yourself are still human and dont need it. Yet.</span>"} */

/obj/structure/closet/crate/footlocker
	desc = "Low metal locker for personal effects."
	name = "footlocker"
	icon_state = "footlocker"

/obj/structure/closet/crate/footchest
	desc = "A wooden chest with iron bands."
	name = "personal chest"
	icon_state = "footchest"

/obj/structure/closet/crate/internals
	desc = "An internals crate."
	name = "internals crate"
	icon_state = "o2crate"

/obj/structure/closet/crate/trashcart
	desc = "A heavy, metal trashcart with wheels."
	name = "trash cart"
	icon_state = "trashcart"
	drag_delay = 0.0 SECONDS //Heavy, but wheeled.

/obj/structure/closet/crate/medical
	desc = "A medical crate."
	name = "medical crate"
	icon_state = "medicalcrate"

/obj/structure/closet/crate/medical/anchored
	anchored = TRUE
	storage_capacity = 30

/obj/structure/closet/crate/freezer
	desc = "A freezer."
	name = "freezer"
	icon_state = "freezer"

//Snowflake organ freezer code
//Order is important, since we check source, we need to do the check whenever we have all the organs in the crate

/obj/structure/closet/crate/freezer/open()
	recursive_organ_check(src)
	..()

/obj/structure/closet/crate/freezer/close()
	..()
	recursive_organ_check(src)

/obj/structure/closet/crate/freezer/Destroy()
	recursive_organ_check(src)
	return ..()

/obj/structure/closet/crate/freezer/Initialize()
	. = ..()
	recursive_organ_check(src)

/obj/structure/closet/crate/freezer/blood
	name = "blood freezer"
	desc = "A freezer containing packs of blood."
	icon_state = "surgery"

/obj/structure/closet/crate/freezer/blood/anchored
	anchored = TRUE
	storage_capacity = 30

/obj/structure/closet/crate/freezer/blood/fake
	should_populate_contents = FALSE

/obj/structure/closet/crate/freezer/blood/PopulateContents()
	. = ..()
	new /obj/item/reagent_containers/blood/random(src) //Welcome to blood pack roulette!
	new /obj/item/reagent_containers/blood/random(src)
	new /obj/item/reagent_containers/blood/random(src)
	new /obj/item/reagent_containers/blood/random(src)
	new /obj/item/reagent_containers/blood/random(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/blood/random(src)

/obj/structure/closet/crate/freezer/surplus_limbs
	name = "surplus prosthetic limbs"
	desc = "A crate containing an assortment of cheap prosthetic limbs."

/obj/structure/closet/crate/freezer/surplus_limbs/fake
	should_populate_contents = FALSE

/obj/structure/closet/crate/freezer/surplus_limbs/PopulateContents()
	. = ..()
	new /obj/item/bodypart/l_arm/robot/surplus(src)
	new /obj/item/bodypart/l_arm/robot/surplus(src)
	new /obj/item/bodypart/r_arm/robot/surplus(src)
	new /obj/item/bodypart/r_arm/robot/surplus(src)
	new /obj/item/bodypart/l_leg/robot/surplus(src)
	new /obj/item/bodypart/l_leg/robot/surplus(src)
	new /obj/item/bodypart/r_leg/robot/surplus(src)
	new /obj/item/bodypart/r_leg/robot/surplus(src)

/obj/structure/closet/crate/radiation
	desc = "A crate with a radiation sign on it."
	name = "radiation crate"
	icon_state = "radiation"
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydrocrate"

/obj/structure/closet/crate/engineering
	name = "engineering crate"
	icon_state = "engi_crate"

/obj/structure/closet/crate/engineering/electrical
	icon_state = "engi_e_crate"

/obj/structure/closet/crate/rcd
	desc = "A crate for the storage of an RCD."
	name = "\improper RCD crate"
	icon_state = "engi_crate"

/obj/structure/closet/crate/rcd/fake
	should_populate_contents = FALSE

/obj/structure/closet/crate/rcd/PopulateContents()
	..()
	for(var/i in 1 to 4)
		new /obj/item/rcd_ammo(src)
	new /obj/item/construction/rcd(src)

/obj/structure/closet/crate/science
	name = "science crate"
	desc = "A science crate."
	icon_state = "scicrate"

/obj/structure/closet/crate/solarpanel_small
	name = "budget solar panel crate"
	icon_state = "engi_e_crate"

/obj/structure/closet/crate/solarpanel_small/PopulateContents()
	..()
	for(var/i in 1 to 13)
		new /obj/item/solar_assembly(src)
	new /obj/item/circuitboard/computer/solar_control(src)
	new /obj/item/paper/guides/jobs/engi/solars(src)
	new /obj/item/electronics/tracker(src)

/obj/structure/closet/crate/goldcrate
	name = "gold crate"

/obj/structure/closet/crate/goldcrate/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/stack/sheet/mineral/gold(src, 1, FALSE)
	new /obj/item/storage/belt/champion(src)

/obj/structure/closet/crate/silvercrate
	name = "silver crate"

/obj/structure/closet/crate/silvercrate/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/coin/silver(src)
