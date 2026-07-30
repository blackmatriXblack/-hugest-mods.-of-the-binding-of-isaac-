-- =============================================================================
--  GurdyTurret — The Binding of Isaac: Repentance
--  Gurdy (Type=30) has auto-targeting turret on top that fires at the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GurdyTurret", 1)

local GURDY_TYPE = EntityType.ENTITY_GURDY
local TURRET_FIRE_INTERVAL = 30 -- 1 second
local turretTimer = {}
local TURRET_OFFSET_Y = -60

function mod:onNPCUpdate(npc)
    if npc.Type ~= GURDY_TYPE or npc.Variant ~= 0 then
        return
    end

    local idx = GetPtrHash(npc)
    if not turretTimer[idx] then
        turretTimer[idx] = 0
    end

    turretTimer[idx] = turretTimer[idx] + 1

    if turretTimer[idx] >= TURRET_FIRE_INTERVAL then
        turretTimer[idx] = 0

        -- Find nearest player
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
            local turretPos = Vector(npc.Position.X, npc.Position.Y + TURRET_OFFSET_Y)
            local dir = (target.Position - turretPos):Normalized()
            local tearSpeed = 5

            local params = ProjectileParams()
            npc:FireProjectiles(turretPos, dir * tearSpeed, 0, params)
        end
    end
end

function mod:onNPCDeath(npc)
    local idx = GetPtrHash(npc)
    turretTimer[idx] = nil
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNPCDeath)
Isaac.DebugString("GurdyTurret loaded!")
