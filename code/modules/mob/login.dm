/mob/Login()
	GLOB.player_list |= src
	GLOB.has_played_list |= src
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Mob Login: [key_name(src)] was assigned to a [type]")
	world.update_status()
	client.screen = list()				//remove hud items just in case
	client.images = list()

	if(!hud_used)
		create_mob_hud()
	if(hud_used)
		hud_used.show_hud(hud_used.hud_version)
		hud_used.update_ui_style(ui_style2icon(client.prefs.UI_style))

	. = ..()

	reset_perspective(loc)

	if(loc)
		loc.on_log(TRUE)

	SSpornhud.request_every_genital(src)

	//readd this mob's HUDs (antag, med, etc)
	reload_huds()

	reload_fullscreen() // Reload any fullscreen overlays this mob has.

	add_click_catcher()

	sync_mind()

	//Reload alternate appearances
	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)

	update_client_colour()
	update_mouse_pointer()
	if(client)
		client.view_size?.resetToDefault()
		if(client.player_details && istype(client.player_details))
			if(client.player_details.player_actions.len)
				for(var/datum/action/A in client.player_details.player_actions)
					A.Grant(src)

			for(var/foo in client.player_details.post_login_callbacks)
				var/datum/callback/CB = foo
				CB.Invoke()

	mind?.hide_ckey = client?.prefs?.hide_ckey

	log_message("Client [key_name(src)] has taken ownership of mob [src]([src.type])", LOG_OWNERSHIP)
	SEND_SIGNAL(src, COMSIG_MOB_CLIENT_LOGIN, client)
	SSprogress_bars.client_connected(client.ckey)

	if(has_field_of_vision && CONFIG_GET(flag/use_field_of_vision))
		LoadComponent(/datum/component/field_of_vision, field_of_vision_type)
	
	switch(client.prefs.kisser)
		if(KISS_BOYS)
			SSstatpanels.cached_boykissers |= ckey
		if(KISS_GIRLS)
			SSstatpanels.cached_girlkissers |= ckey
		if(KISS_ANY)
			SSstatpanels.cached_anykissers |= ckey
	switch(client.prefs.tbs)
		if(TBS_TOP)
			SSstatpanels.cached_tops |= ckey
		if(TBS_BOTTOM)
			SSstatpanels.cached_bottoms |= ckey
		if(TBS_SHOES)
			SSstatpanels.cached_switches |= ckey

