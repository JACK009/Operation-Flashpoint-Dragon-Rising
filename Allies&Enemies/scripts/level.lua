-- Write your LUA script here
function onMissionStart()
  spawnCountEnemies  = 0
  spawnCountAllies   = 0
  spawnTimeEnemies   = 2500
  spawnTimeAllies    = 10000
  spawnDistance      = 200
  maxEntitiesEnemies = 40
  maxEntitiesAllies  = 15
  maxSpawnsEnemies   = 100
  maxSpawnsAllies    = 100
  enemiesKilled      = 0 
  
  OFP:addTimer("Enemy","1000")
  OFP:addTimer("Ally","1000")
    
  x,y,z = OFP:getPosition("way")
end

function onTimerEnemy()  
  sizeEnemies = OFP:getGroupSize("grpEnemies")
  xEnemy = x - spawnDistance  
  
  --OFP:displaySystemMessage(sizeEnemies .. " enemies")
    
  if sizeEnemies < maxEntitiesEnemies and spawnCountEnemies < maxSpawnsEnemies then   
    wpEnemy     = OFP:spawnEntitySetAtLocation("way",x,y,z)     
    spawnEnemy  = OFP:spawnEntitySetAtLocation("entEnemies",xEnemy,y,z)
    wpointEnemy = OFP:getNearestWaypoint("way")
    spawnCountEnemies = spawnCountEnemies + 1
  end  
 
  OFP:removeTimer("Enemy")  
  OFP:addTimer("Enemy",spawnTimeEnemies)        
end

function onTimerAlly()  
  sizeAllies  = OFP:getGroupSize("grpAllies")    
  xAlly = x + spawnDistance
  
  --OFP:displaySystemMessage(sizeAllies .. " allies")  
  
  if sizeAllies < maxEntitiesAllies and spawnCountAllies < maxSpawnsAllies then  
    wpAlly     = OFP:spawnEntitySetAtLocation("way",x,y,z)     
    spawnAlly  = OFP:spawnEntitySetAtLocation("entAllies",xAlly,y,z)
    wpointAlly = OFP:getNearestWaypoint("way")
    spawnCountAllies = spawnCountAllies + 1
  end  
 
  OFP:removeTimer("Ally")  
  OFP:addTimer("Ally",spawnTimeAllies)        
end

function onSpawnedReady_entEnemies(setName,setID,tableOfEntities,errorCode)
  OFP:move("grpEnemies",wpointEnemy,"OVERRIDE")
  OFP:destroyEntitySet("wpEnemy")
end

function onSpawnedReady_entAllies(setName,setID,tableOfEntities,errorCode)
  OFP:move("grpAllies",wpointAlly,"OVERRIDE")
  OFP:destroyEntitySet("wpAlly")
end

function onDeath(victim,killer)
  if OFP:getSide(victim) == 1 then
    enemiesKilled = enemiesKilled + 1
    OFP:displaySystemMessage(enemiesKilled .. " enemies killed !")  
    if spawnCountEnemies == maxSpawnsEnemies and not OFP:isAlive("grpEnemies") then      
      OFP:missionCompleted()
    end
  end
end

function onAllPlayersDead()
  OFP:missionFailedKIA()
end
