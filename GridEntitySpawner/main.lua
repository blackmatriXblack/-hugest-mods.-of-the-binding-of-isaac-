local mod = RegisterMod("GridEntitySpawner", 1)
local game = Game()

function mod:onNewRoom()
    local room = game:GetRoom()
    local center = room:GetCenterPos()
    Isaac.GridSpawn(1000, 0, center, true)
end

function mod:onGridSpawn(gridEntity)
    Isaac.DebugString("Grid entity spawned: " .. tostring(gridEntity:GetType()))
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPAWN, mod.onGridSpawn)
