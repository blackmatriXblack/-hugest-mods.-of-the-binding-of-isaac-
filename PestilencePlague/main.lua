-- =============================================================================
--  PestilencePlague — The Binding of Isaac: Repentance
--  Pestilence (Type=24) creep pools are 2x larger and apply confusion
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PestilencePlague", 1)

local PESTILENCE_TYPE = EntityType.ENTITY_PESTILENCE
local CREEP_RADIUS_MULTIPLIER = 2.0

function mod:onNPCUpdate(npc)
    if npc.Type ~= PESTILENCE_TYPE then
        return
    end

    local creep = npc:GetCreep()
    if creep then
        creep.Scale = CREEP_RADIUS_MULTIPLIER
    end

    -- Apply confusion to players standing on Pestilence creep
    local room = Game():GetRoom()
    for i = 0, room:GetAliveEnemiesCount() - 1 do
        -- No, let's check players
    end

    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player and creep and creep:GetPosition():Distance(player.Position) < (creep.Scale * 40) then
            player:AddConfusion(30, true) -- 30 frames confusion, ignore existing
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("PestilencePlague loaded!")
