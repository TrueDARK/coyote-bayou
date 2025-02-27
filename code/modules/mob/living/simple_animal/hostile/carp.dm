#define REGENERATION_DELAY 60  // After taking damage, how long it takes for automatic regeneration to begin for megacarps (ty robustin!)

/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/reagent_containers/food/snacks/fishmeat/carp = 2)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	taunt_chance = 30
	speed = 0
	maxHealth = 35
	health = 35
	spacewalk = TRUE
	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("gnashes")
	//Space carp aren't affected by cold.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list("carp")
	movement_type = FLYING
	pressure_resistance = 200
	gold_core_spawnable = HOSTILE_SPAWN
	//some carps heal over time
	var/regen_cooldown = 0 //Used for how long it takes before a healing will take place default in 60 seconds
	var/regen_amount = 0 //How much is healed pre regen cooldown

/mob/living/simple_animal/hostile/carp/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(regen_amount)
		regen_cooldown = world.time + REGENERATION_DELAY

/mob/living/simple_animal/hostile/carp/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(regen_amount && regen_cooldown < world.time)
		heal_overall_damage(regen_amount)

/mob/living/simple_animal/hostile/carp/AttackingTarget()
	. = ..()
	var/atom/my_target = get_target()
	if(!. || !ishuman(my_target))
		return
	var/mob/living/carbon/human/H = my_target
	H.adjustStaminaLoss(8)

/mob/living/simple_animal/hostile/carp/holocarp
	icon_state = "holocarp"
	icon_living = "holocarp"
	maxbodytemp = INFINITY
	gold_core_spawnable = NO_SPAWN
	del_on_death = 1

/mob/living/simple_animal/hostile/carp/megacarp
	icon = 'icons/mob/broadMobs.dmi'
	name = "Mega Space Carp"
	desc = "A ferocious, fang bearing creature that resembles a shark. This one seems especially ticked off."
	icon_state = "megacarp"
	icon_living = "megacarp"
	icon_dead = "megacarp_dead"
	icon_gib = "megacarp_gib"
	regen_amount = 6

	maxHealth = 30
	health = 30
	pixel_x = -16
	mob_size = MOB_SIZE_LARGE

	obj_damage = 80
	melee_damage_lower = 20
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/carp/megacarp/Initialize()
	. = ..()
	name = "[pick(GLOB.megacarp_first_names)] [pick(GLOB.megacarp_last_names)]"
	melee_damage_lower += rand(4, 10)
	melee_damage_upper += rand(10,20)
	maxHealth += rand(40,60)
	move_to_delay = rand(3,7)

/mob/living/simple_animal/hostile/carp/cayenne
	name = "Cayenne"
	desc = "A failed Syndicate experiment in weaponized space carp technology, it now serves as a lovable mascot."
	gender = FEMALE
	regen_amount = 8

	speak_emote = list("squeaks")
	maxHealth = 90
	health = 90
	gold_core_spawnable = NO_SPAWN
	faction = list(ROLE_SYNDICATE, "carp") //They are still a carp
	AIStatus = AI_OFF

	harm_intent_damage = 12
	obj_damage = 70
	melee_damage_lower = 15
	melee_damage_upper = 18

#undef REGENERATION_DELAY
