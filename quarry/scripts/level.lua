-- Write your LUA script here

enemies = 0;
enemiesDead = 0;

function onMissionStart()
	OFP:setObjectiveState("objective", "IN_PROGRESS");
	OFP:setObjectiveVisibility("objective", true);
	OFP:activateEntitySet("enemy");
end



--function onDeath(victim, killer)
	--	if OFP:getSide(victim) == 1 then
	--		enemiesDead = enemiesDead + 1;
			
		--	  if(not OFP:isAlive("enemies")) then 
		--    OFP:setObjectiveState("objective", "COMPLETED");
		--	    OFP:missionCompleted();    
		--	  end

		--	OFP:displaySystemMessage(enemiesDead .. "/" ..enemies);
			--if enemiesDead == enemies then  
			--	OFP:setObjectiveState("objective", "COMPLETED"); -- set objective complete
			--	OFP:addTimer("timerEnd", 8000);			
		--	end
	--	end
--end

--function onTimer_timerEnd()
--	if OFP:getObjectiveState("objective") == "COMPLETED" then
--		OFP:missionCompleted()
--	else
--		OFP:missionFailed()
--	end
--end


--function onEnter_triggerzone(zoneName, unitName)
--	EnemySpawn = OFP:activateEntitySet("enemy");
--end

function onAllPlayersDead()
	OFP:missionFailedKIA();
end

