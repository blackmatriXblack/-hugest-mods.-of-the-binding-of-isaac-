-- ==========================================================================
--  Ultra Death Time - The Binding of Isaac: Repentance
--  Ultra Death's hourglass attack slows player by 50% for 3 seconds.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("UltraDeathTime", 1)
local DEATH_ID = EntityType.ENTITY_DEATH
local slow_timers = {}

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == DEATH_ID then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        if npc.FrameCount % 120 == 0 then
            slow_timers[player.Index] = 180
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WHITE_LIGHT, 0,
                player.Position, Vector.Zero, nil)
        end

        if slow_timers[player.Index] and slow_timers[player.Index] > 0 then
            slow_timers[player.Index] = slow_timers[player.Index] - 1
            player.Velocity = player.Velocity * 0.83
        end
    end
end)

Isaac.DebugString("UltraDeathTime loaded!")
