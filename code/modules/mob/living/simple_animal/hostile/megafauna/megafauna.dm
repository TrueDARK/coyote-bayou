/mob/living/simple_animal/hostile/megafauna
	name = "boss of this gym"
	desc = "Attack the weak point for massive damage."
	health = 1000
	maxHealth = 1000
	a_intent = INTENT_HARM
	sentience_type = SENTIENCE_BOSS
	environment_smash = ENVIRONMENT_SMASH_RWALLS
	mob_biotypes = MOB_ORGANIC|MOB_EPIC
	obj_damage = 400
	light_range = 3
	faction = list("mining", "boss")
	weather_immunities = list("lava","ash")
	movement_type = FLYING
	robust_searching = 1
	ranged_ignores_vision = TRUE
	stat_attack = UNCONSCIOUS
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	minbodytemp = 0
	maxbodytemp = INFINITY
	vision_range = 4
	aggro_vision_range = 15
	move_force = MOVE_FORCE_OVERPOWERING
	move_resist = MOVE_FORCE_OVERPOWERING
	pull_force = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_SIZE_LARGE
	layer = LARGE_MOB_LAYER //Looks weird with them slipping under mineral walls and cameras and shit otherwise
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1 | HEAR_1
	has_field_of_vision = FALSE //You are a frikkin boss
	despawns_when_lonely = FALSE // you dont get lonely when you're THE BOSS
	/// Crusher loot dropped when fauna killed with a crusher
	var/list/crusher_loot
	var/medal_type
	/// Score given to players when the fauna is killed
	var/score_type = BOSS_SCORE
	/// If the megafauna is actually killed (vs entering another phase)
	var/elimination = 0
	/// Modifies attacks when at lower health
	var/anger_modifier = 0
	/// Internal tracking GPS inside fauna
	var/obj/item/gps/internal
	/// Next time fauna can use a melee attack
	var/recovery_time = 0

	var/true_spawn = TRUE // if this is a megafauna that should grant achievements, or have a gps signal
	var/nest_range = 10
	var/chosen_attack = 1 // chosen attack num
	var/list/attack_action_types = list()
	var/small_sprite_type
	ignore_other_mobs = TRUE // Their entire existance is to kill players

/mob/living/simple_animal/hostile/megafauna/Initialize(mapload)
	. = ..()
	apply_status_effect(STATUS_EFFECT_CRUSHERDAMAGETRACKING)
	ADD_TRAIT(src, TRAIT_NO_TELEPORT, MEGAFAUNA_TRAIT)
	for(var/action_type in attack_action_types)
		var/datum/action/innate/megafauna_attack/attack_action = new action_type()
		attack_action.Grant(src)
	if(small_sprite_type)
		var/datum/action/small_sprite/small_action = new small_sprite_type()
		small_action.Grant(src)
	recenter_wide_sprite()

/mob/living/simple_animal/hostile/megafauna/Destroy()
	QDEL_NULL(internal)
	. = ..()

/mob/living/simple_animal/hostile/megafauna/Moved()
	if(istype(nest, /datum/component/spawner))
		var/datum/component/spawner/this_nest = nest.resolve()
		if(this_nest && this_nest.parent && get_dist(this_nest.parent, src) > nest_range)
			var/turf/closest = get_turf(this_nest.parent)
			for(var/i = 1 to nest_range)
				closest = get_step(closest, get_dir(closest, src))
			forceMove(closest) // someone teleported out probably and the megafauna kept chasing them
			LoseTarget()
			return
	return ..()

/mob/living/simple_animal/hostile/megafauna/death(gibbed)
	if(health > 0)
		return
	else
		var/datum/status_effect/crusher_damage/C = has_status_effect(STATUS_EFFECT_CRUSHERDAMAGETRACKING)
		var/crusher_kill = FALSE
		if(C && crusher_loot && C.total_damage >= maxHealth * 0.6)
			spawn_crusher_loot()
			crusher_kill = TRUE
		if(!(flags_1 & ADMIN_SPAWNED_1))
			var/tab = "megafauna_kills"
			if(crusher_kill)
				tab = "megafauna_kills_crusher"
			SSblackbox.record_feedback("tally", tab, 1, "[initial(name)]")
			if(!elimination)	//used so the achievment only occurs for the last legion to die.
				grant_achievement(medal_type, score_type, crusher_kill)
		..()

/mob/living/simple_animal/hostile/megafauna/proc/spawn_crusher_loot()
	loot = crusher_loot

/mob/living/simple_animal/hostile/megafauna/gib()
	if(health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/megafauna/dust(just_ash, drop_items, force)
	if(!force && health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/megafauna/AttackingTarget()
	if(recovery_time >= world.time)
		return
	. = ..()
	var/atom/my_target = get_target()
	if(. && isliving(my_target))
		var/mob/living/L = my_target
		if(L.stat != DEAD)
			if(!client && ranged && ranged_cooldown <= world.time)
				OpenFire()
/*
		else
			devour(L)

/mob/living/simple_animal/hostile/megafauna/proc/devour(mob/living/L)
	if(!L)
		return
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	if(!is_station_level(z) || client) //NPC monsters won't heal while on station
		adjustBruteLoss(-L.maxHealth/2)
	L.gib()
*/

/mob/living/simple_animal/hostile/megafauna/ex_act(severity, target)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			adjustBruteLoss(250)

		if (EXPLODE_HEAVY)
			adjustBruteLoss(100)

		if(EXPLODE_LIGHT)
			adjustBruteLoss(50)

/mob/living/simple_animal/hostile/megafauna/proc/SetRecoveryTime(buffer_time)
	recovery_time = world.time + buffer_time
	ranged_cooldown = max(ranged_cooldown, world.time + buffer_time)		// CITADEL BANDAID FIX FOR MEGAFAUNA NOT RESPECTING RECOVERY TIME.

/mob/living/simple_animal/hostile/megafauna/proc/grant_achievement(medaltype, scoretype, crusher_kill)
	if(!medal_type || (flags_1 & ADMIN_SPAWNED_1)) //Don't award medals if the medal type isn't set
		return FALSE
	if(!SSmedals.hub_enabled) // This allows subtypes to carry on other special rewards not tied with medals. (such as bubblegum's arena shuttle)
		return TRUE

	for(var/mob/living/L in view(7,src))
		if(L.stat || !L.client)
			continue
		var/client/C = L.client
		SSmedals.UnlockMedal("Boss [BOSS_KILL_MEDAL]", C)
		SSmedals.UnlockMedal("[medaltype] [BOSS_KILL_MEDAL]", C)
		if(crusher_kill && istype(L.get_active_held_item(), /obj/item/kinetic_crusher))
			SSmedals.UnlockMedal("[medaltype] [BOSS_KILL_MEDAL_CRUSHER]", C)
		SSmedals.SetScore(BOSS_SCORE, C, 1)
		SSmedals.SetScore(score_type, C, 1)
	return TRUE

/datum/action/innate/megafauna_attack
	name = "Megafauna Attack"
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = ""
	var/mob/living/simple_animal/hostile/megafauna/M
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/megafauna_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/megafauna))
		M = L
		return ..()
	return FALSE

/datum/action/innate/megafauna_attack/Activate()
	M.chosen_attack = chosen_attack_num
	to_chat(M, chosen_message)
