/datum/element/mob_holder
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/worn_state
	var/alt_worn
	var/right_hand
	var/left_hand
	var/inv_slots
	var/proctype //if present, will be invoked on headwear generation.
	var/escape_on_find = FALSE //if present, will be released upon the item being 'found' (i.e. opening a container or pocket with it present)

/datum/element/mob_holder/Attach(datum/target, worn_state, alt_worn, right_hand, left_hand, inv_slots = NONE, proctype, escape_on_find)
	. = ..()

	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	src.worn_state = worn_state
	src.alt_worn = alt_worn
	src.right_hand = right_hand
	src.left_hand = left_hand
	src.inv_slots = inv_slots
	src.proctype = proctype
	src.escape_on_find = escape_on_find

	RegisterSignal(target, COMSIG_CLICK_ALT, .proc/mob_try_pickup, override = TRUE)
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/on_examine, override = TRUE)

/datum/element/mob_holder/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_CLICK_ALT)
	UnregisterSignal(source, COMSIG_PARENT_EXAMINE)

/datum/element/mob_holder/proc/on_examine(mob/living/source, mob/user, list/examine_list)
	if(ishuman(user) && !istype(source.loc, /obj/item/clothing/head/mob_holder))
		examine_list += span_notice("Looks like [source.p_they(TRUE)] can be picked up with <b>Alt+Click</b>!")

/datum/element/mob_holder/proc/mob_try_pickup(mob/living/source, mob/user)
	if(!user.Adjacent(source) || user.incapacitated())
		return FALSE
	if(isanimal(user))
		var/mob/living/simple_animal/S = user
		if(!S.dextrous)
			to_chat(user, span_warning("You aren't dextrous enough to do that!"))
			return FALSE
	else if(!ishuman(user))
		return FALSE
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your hands are full!"))
		return FALSE
	if(source.buckled)
		to_chat(user, span_warning("[source] is buckled to something!"))
		return FALSE
	if(source == user)
		to_chat(user, span_warning("You can't pick yourself up."))
		return FALSE
	source.visible_message(span_warning("[user] starts picking up [source]."), \
					span_userdanger("[user] starts picking you up!"))
	if(!do_after(user, 20, target = source) || source.buckled)
		return FALSE

	source.visible_message(span_warning("[user] picks up [source]!"), \
					span_userdanger("[user] picks you up!"))
	to_chat(user, span_notice("You pick [source] up."))
	source.drop_all_held_items()
	var/obj/item/clothing/head/mob_holder/holder = new(get_turf(source), source, worn_state, alt_worn, right_hand, left_hand, inv_slots)
	holder.escape_on_find = escape_on_find

	if(proctype)
		INVOKE_ASYNC(src, proctype, source, holder, user)
	user.put_in_hands(holder)
	return TRUE

/datum/element/mob_holder/proc/drone_worn_icon(mob/living/simple_animal/drone/D, obj/item/clothing/head/mob_holder/holder, mob/user)
	var/new_state = "[D.visualAppearence]_hat"
	holder.item_state = new_state
	holder.icon_state = new_state


//The item itself,
/obj/item/clothing/head/mob_holder
	name = "bugged mob"
	desc = "Yell at coderbrush."
	icon = null
	mob_overlay_icon = 'icons/mob/animals_held.dmi'
	righthand_file = 'icons/mob/animals_held_rh.dmi'
	lefthand_file = 'icons/mob/animals_held_lh.dmi'
	icon_state = ""
	w_class = WEIGHT_CLASS_BULKY
	dynamic_hair_suffix = ""
	var/mob/living/held_mob
	var/escape_on_find

/obj/item/clothing/head/mob_holder/Initialize(mapload, mob/living/target, worn_state, alt_worn, right_hand, left_hand, slots = NONE)
	. = ..()

	if(target)
		assimilate(target)

	if(alt_worn)
		mob_overlay_icon = alt_worn
	if(worn_state)
		item_state = worn_state
		icon_state = worn_state
	if(left_hand)
		lefthand_file = left_hand
	if(right_hand)
		righthand_file = right_hand
	slot_flags = slots

/obj/item/clothing/head/mob_holder/ComponentInitialize()
	. = ..()
	RegisterSignal(src, COMSIG_VORE_ATOM_DEVOURED, .proc/release)
	RegisterSignal(src, COMSIG_VORE_CAN_EAT, .proc/relay_caneat)
	RegisterSignal(src, COMSIG_VORE_CAN_BE_EATEN, .proc/relay_can_be_eaten)
	RegisterSignal(src, COMSIG_VORE_CAN_BE_FED_PREY, .proc/relay_can_be_fed)
	RegisterSignal(src, COMSIG_VORE_SNIFF_LIVING, .proc/relay_sniff)

/obj/item/clothing/head/mob_holder/proc/relay_caneat()
	return SEND_SIGNAL(held_mob, COMSIG_VORE_CAN_EAT)

/obj/item/clothing/head/mob_holder/proc/relay_can_be_eaten()
	return SEND_SIGNAL(held_mob, COMSIG_VORE_CAN_BE_EATEN)

/obj/item/clothing/head/mob_holder/proc/relay_can_be_fed()
	return SEND_SIGNAL(held_mob, COMSIG_VORE_CAN_BE_FED_PREY)

/obj/item/clothing/head/mob_holder/proc/relay_sniff(datum/source, mob/living/living_sniffer)
	return SEND_SIGNAL(held_mob, COMSIG_VORE_SNIFF_LIVING, living_sniffer)

/obj/item/clothing/head/mob_holder/proc/assimilate(mob/living/target)
	target.setDir(SOUTH)
	held_mob = target
	target.forceMove(src)
	var/image/I = new //work around to retain the same appearance to the mob idependently from inhands/worn states.
	I.appearance = target.appearance
	I.layer = FLOAT_LAYER //So it doesn't get screwed up by layer overrides.
	I.plane = FLOAT_PLANE //Same as above but for planes.
	I.override = TRUE
	add_overlay(I)
	name = target.name
	desc = target.desc
	switch(target.mob_size)
		if(MOB_SIZE_TINY)
			w_class = WEIGHT_CLASS_TINY
		if(MOB_SIZE_SMALL)
			w_class = WEIGHT_CLASS_NORMAL
		if(MOB_SIZE_LARGE)
			w_class = WEIGHT_CLASS_HUGE

/obj/item/clothing/head/mob_holder/Destroy()
	if(held_mob)
		release()
	return ..()

/obj/item/clothing/head/mob_holder/examine(mob/user)
	return held_mob?.examine(user) || ..()

/obj/item/clothing/head/mob_holder/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	if(AM == held_mob)
		held_mob.reset_perspective()
		held_mob = null
		QDEL_IN(src, 1) //To avoid a qdel loop.

/obj/item/clothing/head/mob_holder/Entered(atom/movable/AM, atom/newloc)
	. = ..()
	if(AM != held_mob)
		var/destination = loc
		if(isliving(loc)) //the mob is held or worn, drop things on the floor
			destination = get_turf(loc)
		AM.forceMove(destination)

/obj/item/clothing/head/mob_holder/dropped(mob/user)
	. = ..()
	if(held_mob && !ismob(loc) && !istype(loc,/obj/item/storage))//don't release on soft-drops
		release()

/obj/item/clothing/head/mob_holder/proc/release(atom/movable/here)
	if(held_mob)
		var/mob/living/L = held_mob
		held_mob = null
		L.forceMove(istype(here) ? here : get_turf(L))
		L.reset_perspective()
		L.setDir(SOUTH)
	if(!QDELETED(src))
		qdel(src)

/obj/item/clothing/head/mob_holder/relaymove(mob/user)
	return

/obj/item/clothing/head/mob_holder/container_resist()
	if(isliving(loc))
		var/mob/living/L = loc
		L.visible_message(span_warning("[held_mob] escapes from [L]!"), span_warning("[held_mob] escapes your grip!"))
	release()

/obj/item/clothing/head/mob_holder/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(M == held_mob || !ishuman(M)) //monkeys holding monkeys holding monkeys...
		return FALSE
	return ..()

/obj/item/clothing/head/mob_holder/assume_air(datum/gas_mixture/env)
	var/atom/location = loc
	if(!loc)
		return //null
	var/turf/T = get_turf(loc)
	while(location != T)
		location = location.loc
		if(ismob(location))
			return location.loc.assume_air(env)
	return location.assume_air(env)

/obj/item/clothing/head/mob_holder/proc/get_loc_for_air()
	var/atom/location = loc
	if(!loc)
		return //null
	var/turf/T = get_turf(loc)
	while(location != T)
		location = location.loc
		if(ismob(location))
			return location.loc
	return location

/obj/item/clothing/head/mob_holder/assume_air_moles(datum/gas_mixture/env, moles)
	var/atom/location = get_loc_for_air()
	return location.assume_air_moles(env, moles)

/obj/item/clothing/head/mob_holder/assume_air_ratio(datum/gas_mixture/env, ratio)
	var/atom/location = get_loc_for_air()
	return location.assume_air_ratio(env, ratio)

/obj/item/clothing/head/mob_holder/remove_air(amount)
	var/atom/location = get_loc_for_air()
	return location.remove_air(amount)

/obj/item/clothing/head/mob_holder/remove_air_ratio(ratio)
	var/atom/location = get_loc_for_air()
	return location.remove_air_ratio(ratio)

/obj/item/clothing/head/mob_holder/transfer_air(datum/gas_mixture/taker, amount)
	var/atom/location = get_loc_for_air()
	return location.transfer_air(taker, amount)

/obj/item/clothing/head/mob_holder/transfer_air_ratio(datum/gas_mixture/taker, ratio)
	var/atom/location = get_loc_for_air()
	return location.transfer_air(taker, ratio)

// escape when found if applicable
/obj/item/clothing/head/mob_holder/on_found(mob/living/finder)
	if(escape_on_find)
		finder.visible_message("[finder] accidentally releases the [held_mob]!")
		release()
