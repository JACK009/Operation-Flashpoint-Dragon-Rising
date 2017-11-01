-- Write your LUA script here
function onMissionStart()
  spawnCount  = 0
  spawnTime   = 5000
  spawnRadius = 350
  maxEntities = 50
  maxSpawns   = 100    
  OFP:addTimer("Enemy","1000")
end

function onTimerEnemy()   
   grpSize = OFP:getGroupSize("grpEnemies") 
   x,y,z   = OFP:getPosition("grpAllies")
  
   if grpSize ~= 0 then
      OFP:displaySystemMessage("Wave " .. spawnCount .. " - " .. grpSize .. " enemies")    
   end
     
   degrees = math.random(1,360)
   radians = math.rad(degrees)
   x = (spawnRadius * math.cos(radians)) + x 
   z = (spawnRadius * math.sin(radians)) + z   
   
   if grpSize < maxEntities and spawnCount < maxSpawns then
      spawnGroup = OFP:spawnEntitySetAtLocation("entEnemies",x,5,z)
      spawnCount = spawnCount + 1
   end
  
   OFP:removeTimer("Enemy")
   OFP:addTimer("Enemy",spawnTime)    
end

function onSpawnedReady_entEnemies(setName,setID,tableOfEntities,errorCode)
   local grpSize  = OFP:getGroupSize("grpAllies")-1
   local grpIndex = math.random(0,grpSize)   
   OFP:assault("grpEnemies",OFP:getGroupMember("grpAllies",grpIndex),10,"ADDTOEND")
end

function onDeath(victim,killer)
  if OFP:getSide(victim) == 1 then    
    if spawnCount == maxSpawns and not OFP:isAlive("grpEnemies") then      
      OFP:missionCompleted()
    end
  end
end

function onAllPlayersDead()
  OFP:missionFailedKIA()
end
