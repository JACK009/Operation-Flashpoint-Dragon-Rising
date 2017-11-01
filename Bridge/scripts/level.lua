-- Write your LUA script here
function onMissionStart()
  EnemySpawn1 = 0
  EnemySpawn2 = 0
  enemiesKilled = 0
  blnStage1 = true
  
  totalEnemies1 = 0  
  totalEnemies2 = 0
   
  OFP:setObjectiveState("objective", "IN_PROGRESS")    
  OFP:displaySystemMessage("Eliminate all PLA enemies.")
  EnemySpawn1 = OFP:activateEntitySet("enemies1")   
  OFP:addTimer("Start", 1000)  
end

function onEnter_triggerzone1(zoneName, unitName)
  
end

function onDeath(victim,killer)
  if OFP:getSide(victim) == 1 then
    if blnStage1 then              
      OFP:displaySystemMessage(OFP:getEchelonSize("echEnemies1") .. " of " .. totalEnemies1 .. " remaining")
	  if(not OFP:isAlive("echEnemies1")) then
	    blnStage1 = false
	    EnemySpawn2 = OFP:activateEntitySet("enemies2")	    
	    OFP:addTimer("Start", 2500); 
 	  end
    else           
      OFP:displaySystemMessage(OFP:getEchelonSize("echEnemies2") .. " of " .. totalEnemies2 .. " remaining")
      if(not OFP:isAlive("echEnemies2")) then	  
	    OFP:setObjectiveState("objective", "COMPLETED")
        OFP:missionCompleted()  
	  end
    end
  end  
end

function getTotalEnemies()
  if blnStage1 then    
    return OFP:getGroupSize("grpEnemies1")
  else
    return OFP:getGroupSize("grpEnemies2")
  end  
end

function onTimerStart()
  OFP:removeTimer("Start")
  if blnStage1 then    
    totalEnemies1 = OFP:getGroupSize("grpEnemies1")            
    OFP:displaySystemMessage(OFP:getEchelonSize("echEnemies1") .. " of " .. totalEnemies1 .. " remaining")    
  else
    totalEnemies2 = OFP:getGroupSize("grpEnemies2")            
    OFP:displaySystemMessage(OFP:getEchelonSize("echEnemies2") .. " of " .. totalEnemies2 .. " remaining")   
  end
  OFP:addTimer("RemainingEnemies", 20000)  	 
end

function onTimerRemainingEnemies()
  OFP:removeTimer("RemainingEnemies")
  if blnStage1 then           
	OFP:displaySystemMessage(OFP:getEchelonSize("echEnemies1") .. " of " .. totalEnemies1 .. " remaining")	
  else    
    OFP:displaySystemMessage(OFP:getEchelonSize("echEnemies2") .. " of " .. totalEnemies2 .. " remaining")
  end
  OFP:addTimer("RemainingEnemies", 20000)	 
end

function onAllPlayersDead()
  OFP:missionFailedKIA()
end
