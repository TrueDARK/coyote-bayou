/datum/emote/living/carbon/airguitar
	key = "airguitar"
	message = "is strumming the air and headbanging like a lunatic."
	restraint_check = TRUE
	sound = 'sound/effects/airguitar.ogg'

/datum/emote/living/carbon/blink
	key = "blink"
	key_third_person = "blinks"
	message = "blinks."
	sound = 'sound/effects/blink.ogg'

/datum/emote/living/carbon/hddspinup
	key = "bootup"
	key_third_person = "whirrs up their on board memory."
	message = "whirrs up their on board memory."
	sound = 'sound/effects/bootup.ogg'

/datum/emote/living/carbon/beeper7
	key = "beeper7"
	key_third_person = "pings!"
	message = "pings!"
	sound = 'sound/effects/beeper7.ogg'

/datum/emote/living/carbon/blink_r
	key = "blink_r"
	message = "blinks rapidly."

/datum/emote/living/carbon/clap
	key = "clap"
	key_third_person = "claps"
	message = "claps."
	muzzle_ignore = TRUE
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE
	sound = list('sound/misc/clap1.ogg',
				'sound/misc/clap2.ogg',
				'sound/misc/clap3.ogg',
				'sound/misc/clap4.ogg')


/datum/emote/living/carbon/clap/can_run_emote(mob/living/user, status_check, intentional)
	. = ..()
	// Need hands to clap
	if(!user.get_bodypart(BODY_ZONE_L_ARM) || !user.get_bodypart(BODY_ZONE_R_ARM))
		return

/datum/emote/living/carbon/gnarl
	key = "gnarl"
	key_third_person = "gnarls"
	message = "gnarls and shows thier teeth..."
	sound = 'sound/alien/voice/gnarl1.ogg'

/datum/emote/living/carbon/moan
	key = "moan"
	key_third_person = "moans"
	message = "moans!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = SOFT_CRIT
	
/*
/datum/emote/living/carbon/moan/get_sound(mob/living/M) //need better, ie. more pleasured (because these are mostly when doing drugs) moans
	if(ishuman(M))
		if(M.gender == FEMALE)
			. = list(
				'sound/effects/female_moan1.ogg',
				'sound/effects/female_moan2.ogg',
				'sound/effects/female_moan3.ogg'
			)
		else
			. = list(
				'sound/effects/male_moan1.ogg',
				'sound/effects/male_moan2.ogg',
				'sound/effects/male_moan3.ogg'
			)
		return 
*/
/datum/emote/living/carbon/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."
	restraint_check = TRUE

/datum/emote/living/carbon/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."
	restraint_check = TRUE

/datum/emote/living/carbon/screech
	key = "screech"
	key_third_person = "screeches"
	message = "screeches."

/datum/emote/living/carbon/sign
	key = "sign"
	key_third_person = "signs"
	message_param = "signs the number %t."
	restraint_check = TRUE

/datum/emote/living/carbon/sign/select_param(mob/user, params)
	. = ..()
	if(!isnum(text2num(params)))
		return message

/datum/emote/living/carbon/sign/signal
	key = "signal"
	key_third_person = "signals"
	message_param = "raises %t fingers."
	restraint_check = TRUE

/datum/emote/living/carbon/tail
	key = "tail"
	message = "waves their tail."

/datum/emote/living/carbon/wink
	key = "wink"
	key_third_person = "winks"
	message = "winks."

/datum/emote/living/carbon/lick
	key = "lick"
	key_third_person = "licks"
	restraint_check = TRUE

/datum/emote/living/carbon/lick/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your active hand is full, and therefore you can't lick anything! Don't ask why!"))
		return
	var/obj/item/hand_item/healable/licker/licky = new(user)
	if(user.put_in_active_hand(licky))
		to_chat(user, span_notice("You extend your tongue and get ready to lick something."))
	else
		qdel(licky)

/datum/emote/living/carbon/touch
	key = "touch"
	key_third_person = "touches"
	restraint_check = TRUE

/datum/emote/living/carbon/touch/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your active hand is full, and therefore you can't touch anything!"))
		return
	var/obj/item/hand_item/healable/toucher/touchy = new(user)
	if(user.put_in_active_hand(touchy))
		to_chat(user, span_notice("You get ready to touch something."))
	else
		qdel(touchy)

/datum/emote/living/carbon/tend
	key = "tend"
	key_third_person = "tends"
	restraint_check = TRUE

/datum/emote/living/carbon/tend/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your active hand is full, and therefore you can't tend anything!"))
		return
	var/obj/item/hand_item/healable/tender/tendy = new(user)
	if(user.put_in_active_hand(tendy))
		to_chat(user, span_notice("You retrieve your emergency kit and get ready to tend something."))
	else
		qdel(tendy)

//We are not naming this 'beaner' so help me god
/datum/emote/living/carbon/bean
	key = "bean"
	key_third_person = "beans"
	restraint_check = TRUE

/datum/emote/living/carbon/bean/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your beans are too full to bean the beans, what the hell are you doing???!?"))
		return
	var/obj/item/hand_item/beans/bean = new(user)
	if(user.put_in_active_hand(bean))
		to_chat(user, span_notice("You ready your beans for WAR!!"))
	else
		qdel(bean)

/datum/emote/living/carbon/cuphand
	key = "cuphand"
	key_third_person = "uses their hand as a cup."
	restraint_check = TRUE

/datum/emote/living/carbon/cuphand/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your cup your hand to hold liquids."))
		return
	var/obj/item/reagent_containers/food/drinks/sillycup/handcup/handcup = new(user)
	if(user.put_in_active_hand(handcup))
		to_chat(user, span_notice("Your cuphand is ready!"))
	else
		qdel(handcup)

//Biter//
/datum/emote/living/carbon/bite
	key = "bite"
	key_third_person = "bites"
	restraint_check = TRUE

/datum/emote/living/carbon/bite/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your hands are too full to properly bite!  Don't ask!"))
		return
	var/which_biter_to_spawn
	if(ishuman(user))
		if(HAS_TRAIT(user, TRAIT_BIGBITE))
			which_biter_to_spawn = /obj/item/hand_item/biter/big
		else if(HAS_TRAIT(user, TRAIT_FASTBITE))
			which_biter_to_spawn = /obj/item/hand_item/biter/fast
		else if(HAS_TRAIT(user, TRAIT_PLAYBITE))
			which_biter_to_spawn = /obj/item/hand_item/biter/play
		else if(HAS_TRAIT(user, TRAIT_SPICYBITE))
			which_biter_to_spawn = /obj/item/hand_item/biter/spicy
		else if(HAS_TRAIT(user, TRAIT_SABREBITE))
			which_biter_to_spawn = /obj/item/hand_item/biter/sabre
		else 
			which_biter_to_spawn = /obj/item/hand_item/biter 
	else
		which_biter_to_spawn = /obj/item/hand_item/biter/creature
	var/obj/item/hand_item/bite = new which_biter_to_spawn(user)
	if(user.put_in_active_hand(bite)) 
		to_chat(user, span_notice("You show your fangs and prepare to bite the mess out of something or someone!"))
	else
		qdel(bite)

//Tailer//
/datum/emote/living/carbon/tailer
	key = "tailer"
	key_third_person = "tails"
	restraint_check = TRUE

/datum/emote/living/carbon/tailer/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your brains too busy to use your tail right now, maybe empty up your hands a bit?"))
		return
	var/which_tail_to_spawn
	if(HAS_TRAIT(user, TRAIT_TAILWHIP))
		which_tail_to_spawn = /obj/item/hand_item/tail/fast
	else if(HAS_TRAIT(user, TRAIT_TAILSMASH))
		which_tail_to_spawn = /obj/item/hand_item/tail/big
	else if(HAS_TRAIT(user, TRAIT_TAILSPICY))
		which_tail_to_spawn = /obj/item/hand_item/tail/spicy
	else if(HAS_TRAIT(user, TRAIT_TAILTHAGO))
		which_tail_to_spawn = /obj/item/hand_item/tail/thago
	else if(HAS_TRAIT(user, TRAIT_TAILPLAY))
		which_tail_to_spawn = /obj/item/hand_item/playfultail
	else 
		which_tail_to_spawn = /obj/item/hand_item/tail
	var/obj/item/hand_item/tail = new which_tail_to_spawn(user)
	if(user.put_in_active_hand(tail)) 
		to_chat(user, span_notice("You swing your tail around, ready for action!"))
	else
		qdel(tail)

//Clawer//
/datum/emote/living/carbon/claw 
	key = "claw" 
	key_third_person = "claws" 
	restraint_check = TRUE 

/datum/emote/living/carbon/claw/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your hands are too full to use your claws!"))
		return
	var/which_clawer_to_spawn
	if(ishuman(user))
		if(HAS_TRAIT(user, TRAIT_BIGCLAW))
			which_clawer_to_spawn = /obj/item/hand_item/clawer/big
		else if(HAS_TRAIT(user, TRAIT_FASTCLAW))
			which_clawer_to_spawn = /obj/item/hand_item/clawer/fast
		else if(HAS_TRAIT(user, TRAIT_PLAYCLAW))
			which_clawer_to_spawn = /obj/item/hand_item/clawer/play
		else if(HAS_TRAIT(user, TRAIT_SPICYCLAW))
			which_clawer_to_spawn = /obj/item/hand_item/clawer/spicy
		else if(HAS_TRAIT(user, TRAIT_RAZORCLAW))
			which_clawer_to_spawn = /obj/item/hand_item/clawer/razor
		else 
			which_clawer_to_spawn =  /obj/item/hand_item/clawer 
	else
		which_clawer_to_spawn =  /obj/item/hand_item/clawer/creature
	var/obj/item/hand_item/clawer/claw = new which_clawer_to_spawn(user) 
	if(user.put_in_active_hand(claw))
		to_chat(user, span_notice("You get your claws ready to slice!"))
	else
		qdel(claw)

//Tackler//


/datum/emote/living/carbon/tackle
	key = "tackle"
	key_third_person = "tackle"
	restraint_check = TRUE

/datum/emote/living/carbon/tackle/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your hands are too full to tackle!"))
		return
	var/obj/item/hand_item/tackler
	if(user.put_in_active_hand(tackler))
		to_chat(user, span_notice("You get ready to tackle!"))
	else
		qdel(tackler)

//Shover//
/datum/emote/living/carbon/shover
	key = "shove"
	key_third_person = "shoves"
	restraint_check = TRUE

/datum/emote/living/carbon/shover/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your hands are too full to really shove someone!"))
		return
	var/obj/item/hand_item/shover/shove = new(user)
	if(user.put_in_active_hand(shove))
		to_chat(user, span_notice("You get ready to shove someone back!"))
	else
		qdel(shove)

//armblade mutation//
/datum/emote/living/carbon/armblade
	key = "armblade"
	key_third_person = "draws an arm blade!"
	restraint_check = TRUE

/datum/emote/living/carbon/armblade/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your hands are too full to use your blade!"))
		return
	var/which_blade_to_spawn
	if(HAS_TRAIT(user, TRAIT_ARMBLADE))
		which_blade_to_spawn = /obj/item/hand_item/arm_blade/mutation
	else 
		to_chat(user, span_notice("You ain't got no arm blades!"))
	var/obj/item/hand_item/arm_blade/mutation/blade = new which_blade_to_spawn(user) 
	if(user.put_in_active_hand(blade))
		to_chat(user, span_notice("You get your blades ready to slice!"))
	else
		qdel(blade)

//arm tentacle mutation//
/datum/emote/living/carbon/tentarm
	key = "tentarm"
	key_third_person = "contorts their arm into a tentacle!"
	restraint_check = TRUE

/datum/emote/living/carbon/tentarm/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your hands are too full to use your tentacle arm!"))
		return
	var/which_tentacle_to_spawn
	if(HAS_TRAIT(user, TRAIT_ARMTENT))
		which_tentacle_to_spawn = /obj/item/gun/magic/tentacle
	else 
		to_chat(user, span_notice("You ain't got no arm tentacles, you goof!"))
	var/obj/item/gun/magic/tentacle/tentacle = new which_tentacle_to_spawn(user) 
	if(user.put_in_active_hand(tentacle))
		to_chat(user, span_notice("You get your arm tentacle ready to grab!"))
	else
		qdel(tentacle)

//Rock throw//
/datum/emote/living/carbon/rocker
	key = "rocks"
	key_third_person = "rocks"
	restraint_check = TRUE
	COOLDOWN_DECLARE(rock_cooldown)
	var/damageMult
	var/hasPickedUp = FALSE
	var/timerEnabled
	var/damageNerf = 2.2


/datum/emote/living/carbon/rocker/run_emote(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, rock_cooldown) && !HAS_TRAIT(user, TRAIT_MONKEYLIKE))
		to_chat(user, span_warning("You cant find any rocks yet!"))
		return
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your hands are too full to go looking for rocks!"))
		return
	var/obj/item/ammo_casing/caseless/rock/rock = new(user)

	if(hasPickedUp)
		rock.throwforce = damageMult / damageNerf

	if(user.put_in_active_hand(rock))
		hasPickedUp = TRUE
		damageMult = rock.throwforce
		if(!timerEnabled)
			addtimer(CALLBACK(src, .proc/reset_damage), 2.5 SECONDS)
			timerEnabled = TRUE
		COOLDOWN_START(src, rock_cooldown, 2.5 SECONDS)
		to_chat(user, span_notice("You find a nice hefty throwing rock!"))
	else
		qdel(rock)

/datum/emote/living/carbon/rocker/proc/reset_damage()
	hasPickedUp = FALSE
	timerEnabled = FALSE
	damageMult = initial(damageMult)

//brick//
/datum/emote/living/carbon/bricker
	key = "brick"
	key_third_person = "bricks"
	restraint_check = TRUE
	COOLDOWN_DECLARE(brick_cooldown)
	var/damageMult
	var/hasPickedUp = FALSE
	var/timerEnabled
	var/damageNerf = 2.2

/datum/emote/living/carbon/bricker/run_emote(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, brick_cooldown) && !HAS_TRAIT(user, TRAIT_QUICK_BUILD))
		to_chat(user, span_warning("You cant find any bricks yet!"))
		return
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your hands are too full to go looking for bricks!"))
		return
	var/obj/item/ammo_casing/caseless/brick/brick = new(user)

	if(hasPickedUp)
		brick.throwforce = damageMult / damageNerf

	if(user.put_in_active_hand(brick))
		hasPickedUp = TRUE
		damageMult = brick.throwforce
		if(!timerEnabled)
			addtimer(CALLBACK(src, .proc/reset_damage), 2.5 SECONDS)
			timerEnabled = TRUE
		COOLDOWN_START(src, brick_cooldown, 2.5 SECONDS)
		to_chat(user, span_notice("You find a nice weighty brick!"))
	else
		qdel(brick)

/datum/emote/living/carbon/bricker/proc/reset_damage()
	hasPickedUp = FALSE
	timerEnabled = FALSE
	damageMult = initial(damageMult)

/datum/emote/living/carbon/tsk
	key = "tsk"
	message = "tsks audibly."

/datum/emote/living/carbon/braidpull
	key = "braidpull"
	message = "pulls their braid fitfully."

/datum/emote/living/carbon/hairfix
	key = "hairfix"
	message = "is trying to fix their hair."

/datum/emote/living/carbon/handclasp
	key = "clasp"
	message = "clasps their hands in front of them."

/datum/emote/living/carbon/eyeroll
	key = "eyeroll"
	message = "rolls their eyes."

/datum/emote/living/carbon/tongueclick
	key = "tongueclick"
	message = "clicks their tongue as if annoyed."

/datum/emote/living/carbon/kneel
	key = "kneel"
	message = "slowly drops to the ground, kneeling with their legs underneath them."

/datum/emote/living/carbon/snicker
	key = "snicker"
	message = "snickers quietly to themselves."

/datum/emote/living/carbon/huff
	key = "huff"
	message = "huffs loudly, exhausted or exasperated. Who knows."

/datum/emote/living/carbon/wait
	key = "wait"
	message = "holds up one finger, giving the universal sign for 'wait a moment'."

/datum/emote/living/carbon/waveon
	key = "waveon"
	message = "waves a hand motioning someone, or something, onward."

/datum/emote/living/carbon/halt
	key = "halt"
	message = "raises a hand palm out, motioning for someone or something to halt."

/datum/emote/living/carbon/eh
	key = "eh"
	message = "raises a hand then motions with it horizontal, similar to waves. A pretty noncomital thing."

/datum/emote/living/carbon/daydream
	key = "daydream"
	message = "seems lost in a daydream, their eyes slightly glazed over and giving a thousand yard stare."

/datum/emote/living/carbon/drool
	key = "drool"
	message = "looks like they're drooling a little."

/datum/emote/living/carbon/blank
	key = "blank"
	message = "looks like they have no thoughts in their head."

/datum/emote/living/carbon/snunch
	key = "snunch"
	message = "is lunching like a snake."

//hahadorks

/datum/emote/living/carbon/powerpose
	key = "powerpose"
	message = "puts their hands on their hips and takes a steady pose."
	message_param = "power poses like a super hero at %t."
	restraint_check = TRUE

/datum/emote/living/carbon/snaplook
	key = "snaplook"
	message = "snaps their gaze around!"
	message_param = "snaps their gaze around, locking onto %t!"

/datum/emote/living/carbon/peace
	key = "peace"
	message = "throws up a peace sign!"
	message_param = "throws up a peace sign at %t!"

/datum/emote/living/carbon/thebird
	key = "thebird"
	message = "fires off the bird!"
	message_param = "full sends the bird at %t!"

/datum/emote/living/carbon/thebirds
	key = "thebirds"
	message = "gives both barrels of the bird!"
	message_param = "double barrels the birds at %t!"

/datum/emote/living/carbon/vlick
	key = "vlick"
	message = "pretends to lick between their spread pointer and middle finger!"

/datum/emote/living/carbon/cheekpoke
	key = "cheekpoke"
	message = "pushes their tongue into their cheek."

/datum/emote/living/carbon/headbob
	key = "headbob"
	message = "is bobbing their head to something."

/datum/emote/living/carbon/hairflick
	key = "hairflick"
	message = "flicks their hair back out of their face."

/datum/emote/living/carbon/hairchew
	key = "hairchew"
	message = "chews on their bangs a little bit."

/datum/emote/living/carbon/lewdintent
	key = "lewdintent"
	restraint_check = TRUE

/datum/emote/living/carbon/lewdintent/run_emote(mob/user)
	. = ..()
	if(user.get_active_held_item())
		to_chat(user, span_warning("Your active hand is full, you can't wear your sleeve on your shoulder! Don't ask why!"))
		return
	var/obj/item/clothing/accessory/heart/dtf = new(user)
	if(user.put_in_active_hand(dtf))
		to_chat(user, span_notice("You're ready to make it clear to others what it is you REALLY want!"))
	else
		qdel(dtf)
