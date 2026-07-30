local mod = RegisterMod("NPCUpdateTracker", 1)
local npcCount = 0

function mod:onNPCUpdate(entity)
    if entity:IsEnemy() then
        npcCount = npcCount + 1
    end
end

function mod:onRender()
    Isaac.RenderText("NPCs updated: " .. tostring(npcCount), 50, 50, 1, 1, 1, 255)
end

function mod:onNewRoom()
    npcCount = 0
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
