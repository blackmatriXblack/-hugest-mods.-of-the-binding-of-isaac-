-- =============================================================================
--  FistulaSegment — The Binding of Isaac: Repentance
--  Fistula (Type=27) segments have independent AI and shoot tears
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FistulaSegment", 1)

local FISTULA_TYPE = EntityType.ENTITY_FISTULA
local FISTULA_VARIANTS = {0, 1, 2} -- Main, medium, small
local SHOOT_INTERVAL = 40 -- ~1.33 seconds
local shootTimer = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= FISTULA_TYPE then
        return
    end

    local idx = GetPtrHash(npc)
    if not shootTimer[idx] then
        shootTimer[idx] = math.random(0, SHOOT_INTERVAL - 1)
    end

    shootTimer[idx] = shootTimer[idx] + 1

    if shootTimer[idx] >= SHOOT_INTERVAL then
        shootTimer[idx] = 0

        -- Find nearest player and shoot a tear
        local target = nil
        local nearestDist = 99999
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player and player:IsAlive() then
                local dist = npc.Position:Distance(player.Position)
                if dist < nearestDist then
                    nearestDist = dist
                    target = player
                end
            end
        end

        if target then
            local dir = (target.Position - npc.Position):Normalized()
            local tearSpeed = 4 + math.random() * 2
            npc:FireProjectiles(npc.Position, dir * tearSpeed, 0, ProjectileParams())
        end
    end
end

function mod:onNPCDeath(npc)
    local idx = GetPtrHash(npc)
    shootTimer[idx] = nil
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNPCDeath)
Isaac.DebugString("FistulaSegment loaded!")
