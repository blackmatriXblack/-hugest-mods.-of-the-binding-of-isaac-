-- =============================================================================
--  GazingGlobinLaser — The Binding of Isaac: Repentance
--  Gazing Globins (Type=11, Variant=1) fire a brimstone laser every 4 seconds.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GazingGlobinLaser", 1)

local LASER_INTERVAL = 120  -- 4 seconds at 30 FPS
local laserTimers = {}

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 11 or npc.Variant ~= 1 then return end

    local idx = npc.Index
    if not laserTimers[idx] then
        laserTimers[idx] = 0
    end

    laserTimers[idx] = laserTimers[idx] + 1

    if laserTimers[idx] >= LASER_INTERVAL then
        laserTimers[idx] = 0
        local player = Isaac.GetPlayer(0)
        if not player then return end

        local dir = (player.Position - npc.Position):Normalized()
        local startPos = npc.Position + dir * 20

        -- Spawn a brimstone-style laser beam effect
        local laser = Isaac.Spawn(
            EntityType.ENTITY_EFFECT, 1, 0,
            startPos, dir * 12, npc
        )
        if laser then
            laser.DepthOffset = 10
            laser:SetColor(Color(1, 0.1, 0.1, 0.9), 0, 1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("GazingGlobinLaser loaded!")
