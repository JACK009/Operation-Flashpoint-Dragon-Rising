-- Write your LUA script here

-- OFP Dragon Rising
-- Ultimate Randomness
-- Author: J.A.C.K. 009
-- Web: /
-- Date of creation: october 2013



-- todo:
--add vihicles
--add random artillery

function onMissionStart()
	-- initialize the randomization function
	math.randomseed(os.time()) 
	--some var 
	amountEnemiesToKill = math.random(120,250)
	amountAlliesToKill = amountEnemiesToKill
	
	amountEnemies = 0 
	amountAllies = 0
	
	enemiesKilled = 0
	alliesKilled = 0
	
	selectedEnemySpawnGroup = ""
	selectedAllySpawnGroup = ""
	
	--groupname of waypoints
	enemyWaypoins = "enemywaypoint"
	allyWaypoints = "allywaypoint"
	
	--names of echlons (name + random generated nr)
	allyEchlonName = "allyech"
 	enemyEchlonName = "enemyech"
	
	--groupname of move waypoints
	enemyMoveWaypoints = "enemymovewp"
	allyMoveWaypoints = "allymovewp"
	
	--entity name in explorer
	enemyEntityGroup = "enemyI"
	allyEntityGroup = "allyI"
	
	--subgroups in enemyEntity
	enemiesEntityGroupAmount = 39
	allyEntityGroupAmount = 46
	
	-- vihicles
	enemyVihicleEntityGroup = "enemyVhI"
	allyVihicleGroup = "enemyvh"
	allyVihicleEntityGroup = "allyVhI"
	allyVihicleGroup = "allyvh"
	enemiesVihicleEntityGroupAmount = 0
	allyVihicleEntityGroupAmount = 8
	maxVihicles = 2
	amountEnemyVihicles = 0
	amountAllyVihicles = 8
	
	--entity name in explorer and groupname
	enemyGroup = "enemy"
	allyGroup = "ally"
	
	--spawn timer	
	enemySpawnTimer = 5000
	allySpawnTimer = 5000
	
	--random spawn timer of 2 variables (minimum time and minimum time + seconds)
	enemyMinimumRandomTimer = 10000
	enemyAddedSeconds = 20000
	randomEnemySpawnTime = math.random(enemyMinimumRandomTimer, enemyMinimumRandomTimer + enemyAddedSeconds)
	 
	allyMinimumRandomTimer = 12 * 1000
	allyAddedSeconds = 24 * 1000
	randomAllySpawnTime = math.random(allyMinimumRandomTimer, allyMinimumRandomTimer + allyAddedSeconds)
	
	--system message total amount enemies/allies (calculated after spawn timer) 
	--should be less then spawntimer
	enemyAmountTimer = 1000
	allyAmountTimer = 1000
	
	--max amount (total limit 63)
	maxEnemyAmount = 34
	maxAllyAmount = 20
	
	--random artillery
	artilleryWaypoints = "artillerywp"
	minArtilleryTimer = 300 * 1000 -- 5 min
	maxArtilleryTimer = 750 * 1000 -- 12.5 min 
	artilleryTime = math.random(minArtilleryTimer, maxArtilleryTimer)
	
	--random time and weather
	minTd = 3 * 1000 -- 5 min
	maxTd = 7 * 1000 -- 12.5 min 
	--TimeDayTime = math.random(minTd, maxTd)
	--OFP:setFogCurrent(math.random(0,100))
--	OFP:setTimeOfDay(math.random(22,23),math.random(0,59),math.random(0,59))
	--OFP:setWeatherCurrent(math.random(0,4))
	 
	OFP:displaySystemMessage("Total objective kills: " .. amountEnemiesToKill)
	 
	OFP:setObjectiveState("objective", "IN_PROGRESS")
	OFP:setObjectiveVisibility("objective", true)

	OFP:addTimer("ArtilleryTimer", 100)
	--start spawn timer
	OFP:addTimer("EnemyTimer",randomEnemySpawnTime)
	OFP:addTimer("AllyTimer",randomAllySpawnTime)
--	OFP:addTimer("EnemyVihicleTimer",randomEnemySpawnTime)
--	OFP:addTimer("AllyVihicleTimer",randomAllySpawnTime)
	OFP:addTimer("TimeOfDayTimer",100)
end

-----------------------------------------------------------------
------------------ time of day -----------------------------------------------
-----------------------------------------------------------------
function onTimerTimeOfDayTimer()
--	OFP:getMissionTime();
	OFP:removeTimer("TimeOfDayTimer")
	OFP:setFogCurrent(math.random(40,100))
	OFP:setTimeOfDay(math.random(0,23),math.random(0,59),math.random(0,59))
	OFP:setWeatherCurrent(math.random(0,4))
	TimeDayTime = math.random(minTd, maxTd)
	
--	OFP:addTimer("RandomTimeOfDay",TimeDayTime)
end

function onTimerRandomTimeOfDay()
	OFP:removeTimer("RandomTimeOfDay")
	OFP:displaySystemMessage("weather change ")
	OFP:setFogTarget(math.random(40,100), math.random(0,23),math.random(0,59),math.random(0,59))
	OFP:setWeatherTarget(math.random(0,4), math.random(0,23),math.random(0,59),math.random(0,59))
	TimeDayTime = math.random(minTd, maxTd)
	OFP:addTimer("RandomTimeOfDay",TimeDayTime)
end

function onTimerArtilleryTimer()
	local artilleryArmy = math.random(0, 1)
	OFP:removeTimer("ArtilleryTimer")
	artilleryTime = math.random(minArtilleryTimer, maxArtilleryTimer)
	
	local artilleryWaypointsTotal = OFP:getGroupSize(artilleryWaypoints)
	local randomArtilleryWaypointNr = math.random(0, artilleryWaypointsTotal -1)
	local selectedArtilleryWaypoint = OFP:getGroupMember(artilleryWaypoints, randomArtilleryWaypointNr)
	
	local typeArtillery = math.random(0, 1)
	
	if typeArtillery == 0 then --call airstrike
	
		local airstrikeAmmoType = math.random(0, 2)
		if airstrikeAmmoType == 0 then
		airstrikeAmmoType = "Small"
		elseif  airstrikeAmmoType == 1 then
		airstrikeAmmoType = "Large"
		elseif  airstrikeAmmoType == 2 then
		airstrikeAmmoType = "JDAM"
		end
		
		OFP:callAirStrike(artilleryArmy, selectedArtilleryWaypoint, airstrikeAmmoType)
		
	else --call artillery
		local artilleryAmmoSize = math.random(0, 2)
		if artilleryAmmoSize == 0 then
		artilleryAmmoSize = "Mortar"
		elseif  artilleryAmmoSize == 1 then
		artilleryAmmoSize = "HeavyMortar"
		elseif  artilleryAmmoSize == 2 then
		artilleryAmmoSize = "Howitzer"
		end
		
		local artilleryAmmoType = math.random(0, 2)
		if artilleryAmmoType == 0 then
		artilleryAmmoType = "Smoke"
		elseif  artilleryAmmoType == 1 then
		artilleryAmmoType = "HE"
		elseif  artilleryAmmoType == 2 then
		artilleryAmmoType = "Illumination"
		end
		
		local artilleryFormationType = math.random(0, 4)
		if artilleryFormationType == 0 then
		artilleryFormationType = "Barrage"
		elseif  artilleryFormationType == 1 then
		artilleryFormationType = "Scattered"
		elseif  artilleryFormationType == 2 then
		artilleryFormationType = "Tight"
		elseif  artilleryFormationType == 3 then
		artilleryFormationType = "Harassing"
		elseif  artilleryFormationType == 4 then
		artilleryFormationType = "Single"
		end
		
		-- we call ArtilleryStrike
		--OFP:callArtilleryStrike(1, selectedArtilleryWaypoint,"HeavyMortar", "Smoke","Single", 10000)
		OFP:callArtilleryStrike(artilleryArmy,selectedArtilleryWaypoint, artilleryAmmoSize, artilleryAmmoType, artilleryFormationType, 10000)
	end
		
	
	OFP:addTimer("ArtilleryTimer", artilleryTime)
end

-----------------------------------------------------------------
----------------------- enemy spawn ------------------------------------------
-----------------------------------------------------------------

function onTimerEnemyTimer() 
	if amountEnemies < maxEnemyAmount then
		-- random waypoint
		local maximumEnemyWaypoins = OFP:getGroupSize(enemyWaypoins)
		local randomEnemyWaypointNr = math.random(0, maximumEnemyWaypoins -1)
		local selectedWaypoint = OFP:getGroupMember(enemyWaypoins, randomEnemyWaypointNr)
		
		-- spawn enemies @ selected waypoint
		local x, y, z = OFP:getPosition(selectedWaypoint)
		
		-- select a random nr (max entities)
		local randomEnemyEntitynr = math.random(1, enemiesEntityGroupAmount)
		
		--	OFP:activateEntitySet(enemyEntity)
		
		-- spawn selected ally entity
		OFP:spawnEntitySetAtLocation(enemyEntityGroup .. randomEnemyEntitynr ,x,y,z)
		selectedEnemySpawnGroupnr = randomEnemyEntitynr
		--select group to spawn	
--	OFP:spawnEntitySetAtLocation(enemyEntity ,x,y,z)
	
	end
	
	OFP:addTimer("EnemyAmountTimer",enemyAmountTimer)
	OFP:addTimer("EnemyRandomSpawnTimer",1000)
	if amountEnemies < (maxEnemyAmount/2) then
		OFP:addTimer("EnemyMoveTimer",300)
	end
	
	OFP:removeTimer("EnemyTimer")
end

function onTimerEnemyVihicleTimer()
	if amountEnemyVihicles < maxVihicles then
	
	end
end

-----------------------------------------------------------------
----------------------- enemy move timer ------------------------------------------
-----------------------------------------------------------------

function onTimerEnemyMoveTimer()

		OFP:removeTimer("EnemyMoveTimer")
		local maximumEnemyMoveWaypoins = OFP:getGroupSize(enemyMoveWaypoints)
		local randomEnemyMoveWaypointNr = math.random(0, maximumEnemyMoveWaypoins -1)
		local selectedMoveWaypoint = OFP:getGroupMember(enemyMoveWaypoints, randomEnemyMoveWaypointNr)
		
		--move group nr
		
		-- select etity echlon
		local selectedEchlon = enemyEchlonName .. selectedEnemySpawnGroupnr
		OFP:move("enemygr" .. selectedEnemySpawnGroupnr, selectedMoveWaypoint, "OVERRIDE")
		
	--	OFP:assault("enemyech1", selectedMoveWaypoint, "OVERRIDE")
	--	OFP:assault("Echelon",selectedMoveWaypoint, "OVERRIDE")
	--	OFP:displaySystemMessage("Total objective kills: " .. amountEnemiesToKill)
end


-----------------------------------------------------------------
---------------------- enemy random spawn timer -------------------------------------------
-----------------------------------------------------------------

function onTimerEnemyRandomSpawnTimer()
	OFP:removeTimer("EnemyRandomSpawnTimer")
	amountEnemies = OFP:getGroupSize(enemyGroup)
	--set new value to spawntimer (after onmissionstart)
	randomEnemySpawnTime = math.random(enemyMinimumRandomTimer, enemyMinimumRandomTimer + enemyAddedSeconds)
	
	--set timer based on amount of enemies
		
	if amountEnemies < (maxEnemyAmount/8) then
		randomEnemySpawnTime = randomEnemySpawnTime / 8
		
	elseif amountEnemies < (maxEnemyAmount/4) then
		randomEnemySpawnTime = randomEnemySpawnTime / 4
		
	elseif amountEnemies < (maxEnemyAmount/2) then
		randomEnemySpawnTime = randomEnemySpawnTime / 2
	end
	--OFP:displaySystemMessage("enemy spawntimer: " .. randomEnemySpawnTime)
	OFP:addTimer("EnemyTimer",randomEnemySpawnTime)
end

-----------------------------------------------------------------
-----------------------------------------------------------------
---------------------- enemy count total enemies -------------------------------------------

function onTimerEnemyAmountTimer()
	OFP:removeTimer("EnemyAmountTimer")
	amountEnemies = OFP:getGroupSize(enemyGroup)
	--OFP:displaySystemMessage("Total enemies: " .. amountEnemies)
end

-----------------------------------------------------------------
---------------------- ally spawn timer -------------------------------------------
-----------------------------------------------------------------

function onTimerAllyTimer()  
	if amountAllies < maxAllyAmount then
		-- random waypoint
		local maximumAllyWaypoins = OFP:getGroupSize(allyWaypoints)
		local randomAllyWaypointNr = math.random(0, maximumAllyWaypoins -1)
		local selectedWaypoint = OFP:getGroupMember(allyWaypoints, randomAllyWaypointNr)
		
		-- spawn enemies @ selected waypoint
		local x, y, z = OFP:getPosition(selectedWaypoint)
		
		-- select a random nr (max entities)
		local randomAllyEntitynr = math.random(1, allyEntityGroupAmount)
		selectedAllySpawnGroupnr = randomAllyEntitynr
		
	--	OFP:activateEntitySet(allyEntity)
		-- spawn selected ally entity
		OFP:spawnEntitySetAtLocation(allyEntityGroup .. randomAllyEntitynr ,x,y,z)
		
		OFP:move("allygr" .. selectedAllySpawnGroupnr, selectedMoveWaypoint, "ADDTOEND")
	--	OFP:displaySystemMessage("allygr" .. selectedAllySpawnGroupnr)
	end
	
		OFP:addTimer("AllyAmountTimer",allyAmountTimer)
		OFP:addTimer("AllyRandomSpawnTimer",1000)
			
		if amountAllies < (maxAllyAmount/2) then
			OFP:addTimer("AllyMoveTimer",300)
		end
	OFP:removeTimer("AllyTimer")
end

function onTimerAllyVihicleTimer()
	if amountAllyVihicles < maxVihicles then
		local maximumAllyWaypoins = OFP:getGroupSize(allyWaypoints)
		local randomAllyWaypointNr = math.random(0, maximumAllyWaypoins -1)
		local selectedWaypoint = OFP:getGroupMember(allyWaypoints, randomAllyWaypointNr)
		
		-- spawn enemies @ selected waypoint
		local x, y, z = OFP:getPosition(selectedWaypoint)
		
		-- select a random nr (max entities)
		local randomAllyEntitynr = math.random(1, allyVihicleEntityGroupAmount)
		--selectedAllySpawnGroupnr = randomAllyEntitynr
		
	--	OFP:activateEntitySet(allyEntity)
		-- spawn selected ally entity
		amountAllyVihicles = amountAllyVihicles + 1
		OFP:spawnEntitySetAtLocation(allyVihicleEntityGroup .. randomAllyEntitynr ,x,y,z)
	end
	OFP:removeTimer("AllyVihicleTimer")
end

-----------------------------------------------------------------
------------------------- ally move timer ----------------------------------------
-----------------------------------------------------------------

function onTimerAllyMoveTimer()

		local maximumAllyMoveWaypoins = OFP:getGroupSize(allyMoveWaypoints)
		local randomAllyMoveWaypointNr = math.random(0, maximumAllyMoveWaypoins -1)
		local selectedMoveWaypoint = OFP:getGroupMember(allyMoveWaypoints, randomAllyMoveWaypointNr)
		
		--move group nr	
		OFP:move("allygr" .. selectedAllySpawnGroupnr, selectedMoveWaypoint, "ADDTOEND")
	--	OFP:assault("allyEch1", selectedMoveWaypoint, "OVERRIDE")
	--	OFP:assault("Echelon",selectedMoveWaypoint, "OVERRIDE")
	--	OFP:displaySystemMessage("Total objective kills: " .. amountEnemiesToKill)
	OFP:removeTimer("AllyMoveTimer")
		
end

-----------------------------------------------------------------
------------------------ ally ransom spawn timer -----------------------------------------
-----------------------------------------------------------------

function onTimerAllyRandomSpawnTimer()
	OFP:removeTimer("AllyRandomSpawnTimer")
	amountAllies = OFP:getGroupSize(allyGroup)
	--set new value to spawntimer (after onmissionstart)
	randomAllySpawnTime = math.random(enemyMinimumRandomTimer, enemyMinimumRandomTimer + enemyAddedSeconds)
	
	--set timer based on amount of enemies
		
	if amountAllies < (maxAllyAmount/8) then
		randomAllySpawnTime = randomAllySpawnTime / 8
		
	elseif amountAllies < (maxAllyAmount/4) then
		randomAllySpawnTime = randomAllySpawnTime / 4
		
	elseif amountAllies < (maxAllyAmount/2) then
		randomAllySpawnTime = randomAllySpawnTime / 2
	end
	
	--OFP:displaySystemMessage("ally spawntimer: " .. randomAllySpawnTime)
	OFP:addTimer("AllyTimer",randomAllySpawnTime)
end

-----------------------------------------------------------------
------------------------- ally count total timer ----------------------------------------
-----------------------------------------------------------------

function onTimerAllyAmountTimer()
	OFP:removeTimer("AllyAmountTimer")
	amountAllies = OFP:getGroupSize(allyGroup)
--	OFP:displaySystemMessage("Total allies: " .. amountAllies)
end

-----------------------------------------------------------------
------------------------- on dead ----------------------------------------
-----------------------------------------------------------------

function onDeath(victim,killer)
	if OFP:getObjectiveState("objective") == "IN_PROGRESS"	then
		if OFP:getSide(victim) == 1 then
  
		    enemiesKilled = enemiesKilled + 1
		    --OFP:displaySystemMessage("Total enemies to kill: " .. amountEnemiesToKill - enemiesKilled)
		    OFP:displaySystemMessage(enemiesKilled .."/" .. amountEnemiesToKill .. " enemies killed") 
	     
		    if enemiesKilled >= amountEnemiesToKill then 
		    	OFP:setObjectiveState("objective", "COMPLETED")     
		      	OFP:addTimer("timerEnd", 8000)
		    end
    
	  	else
	  	
		   	alliesKilled = alliesKilled + 1
		    
		    OFP:displaySystemMessage(alliesKilled .."/" .. amountAlliesToKill .. " allies killed")  
		    
		    if alliesKilled >= amountAlliesToKill then 
			    OFP:setObjectiveState("objective", "FAILED")     
			    OFP:addTimer("timerEnd", 8000)
		  	end
		end
	end
end

-----------------------------------------------------------------
------------------------- end mission ----------------------------------------
-----------------------------------------------------------------

function onTimer_timerEnd()
	if OFP:getObjectiveState("objective") == "COMPLETED" then
		OFP:missionCompleted()
	else
		OFP:missionFailed()
	end
end

function onAllPlayersDead()
	OFP:setObjectiveState("objective", "FAILED")
 	OFP:missionFailedKIA()
end


