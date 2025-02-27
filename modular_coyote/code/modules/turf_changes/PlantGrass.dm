// Refactors plant grass to work on multiple turfs.
// I'm going to grab you by the antlers and stick every point of it up your ass

// pascal deez nuts
/turf/open/proc/plantGrass(Plantforce = FALSE)
	var/Weight = 0
	var/obj/structure/flora/randPlant = null

	//spontaneously spawn grass
	if(Plantforce || prob(GRASS_SPONTANEOUS))
		randPlant = pickweight(GLOB.lush_plant_spawn_list) //Create a new grass object at this location, and assign var
		new randPlant(src)
		return TRUE

	//loop through neighbouring desert turfs, if they have grass, then increase weight
	for(var/turf/open/indestructible/ground/T in RANGE_TURFS(3, src))
		if(istype(T, src))
			if(locate(/obj/structure/flora) in T)
				Weight += GRASS_WEIGHT

	//use weight to try to spawn grass
	if(prob(Weight))
		//If surrounded on 5+ sides, pick from lush
		if(Weight == (5 * GRASS_WEIGHT))
			randPlant = pickweight(GLOB.lush_plant_spawn_list)
		else
			randPlant = pickweight(GLOB.desolate_plant_spawn_list)
		new randPlant(src)
		return TRUE

/turf/open/
	var/spawnPlants = FALSE
	// var/obj/structure/flora/turfPlant // jon, this dels harder than my dick in ur ass

/turf/open/Initialize()
	. = ..()
	
	if(!spawnPlants)
		return
	if((locate(/obj/structure) in src))
		return
	if(locate(/obj/machinery) in src)
		return
	plantGrass()

/turf/open/ChangeTurf(path, new_baseturf, flags)
	for(var/obj/structure/flora/turfPlant in contents)
		qdel(turfPlant)
	. =  ..()

/turf/open/indestructible/ground/outside/dirt
	spawnPlants = TRUE

/turf/open/indestructible/ground/outside/savannah
	spawnPlants = TRUE

/turf/open/indestructible/ground/outside/dirt_s
	spawnPlants = TRUE

/turf/open/indestructible/ground/outside/grass_s
	spawnPlants = TRUE

/turf/open/indestructible/ground/outside/desert
	spawnPlants = TRUE

/turf/open/floor/plating/f13/outside/desert
	spawnPlants = TRUE
