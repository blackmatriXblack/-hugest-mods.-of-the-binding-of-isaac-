-- EntitySpawnCounter: Counts all spawned entities and displays total on HUD
local mod = RegisterMod("EntitySpawnCounter", 1)
local entityCount = 0

function mod:onEntitySpawn(entityType, variant, subtype, pos, velocity, spawner, seed)
    entityCount = entityCount + 1
end

function mod:onRender()
    Isaac.RenderText("Entities: " .. entityCount, 10, 10, 255, 255, 255, 255, 2)
end

function mod:onGameStart()
    entityCount = 0
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
Isaac.DebugString("EntitySpawnCounter loaded! Counting entities on HUD.")
