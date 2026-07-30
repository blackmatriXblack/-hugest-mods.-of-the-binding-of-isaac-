-- ==========================================================================
--  StoneyLevel2Teleport - The Binding of Isaac: Repentance
--  Level 2 Stoney teleports to player position when emerging.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("StoneyLevel2Teleport", 1)
local ENEMY_STONEY = 302
local TELEPORT_COOLDOWN = 180
local EMERGE_DELAY = 30

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_STONEY or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.teleportTimer then data.teleportTimer = 0 end
    if not data.isHidden then data.isHidden = false end
    if not data.emergeTimer then data.emergeTimer = 0 end

    if data.isHidden then
        data.emergeTimer = data.emergeTimer + 1
        if data.emergeTimer >= EMERGE_DELAY then
            -- Teleport to player and emerge
            local player = Isaac.GetPlayer(0)
            if player then
                npc.Position = player.Position + Vector(math.random(-30, 30), math.random(-30, 30))
            end
            data.isHidden = false
            data.teleportTimer = 0
        end
    else
        data.teleportTimer = data.teleportTimer + 1
        if data.teleportTimer >= TELEPORT_COOLDOWN then
            data.isHidden = true
            data.emergeTimer = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("StoneyLevel2Teleport loaded!")