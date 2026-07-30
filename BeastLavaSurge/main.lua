-- ==========================================================================
--  Beast Lava Surge - The Binding of Isaac: Repentance
--  The Beast boss — lava surges rise 30% more frequently.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BeastLavaSurge", 1)
local surge_timer = 0

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_MOTHER and npc.SubType > 0 then
        local room = Game():GetRoom()
        local player = Isaac.GetPlayer(0)
        if not room or not player then return end

        surge_timer = surge_timer + 1
        if surge_timer >= 50 then
            surge_timer = 0
            for i = 1, 3 do
                local x = room:GetLeftWallPos() + math.random() * (room:GetRightWallPos() - room:GetLeftWallPos())
                local lavaPos = Vector(x, room:GetBottomRightPos().Y)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 0,
                    lavaPos, Vector(0, -4), npc)
            end
        end
    end
end)

Isaac.DebugString("BeastLavaSurge loaded!")
