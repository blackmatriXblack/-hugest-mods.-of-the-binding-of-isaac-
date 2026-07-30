-- ==========================================================================
--  Tainted Satan Hoof - The Binding of Isaac: Repentance
--  Tainted Satan — hoof stomps 3 times in rapid succession.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedSatanHoof", 1)
local SATAN_ID = EntityType.ENTITY_SATAN
local stomp_count = 0
local stomp_timer = 0

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == SATAN_ID then
        local room = Game():GetRoom()
        local player = Isaac.GetPlayer(0)
        if not room or not player then return end

        if npc.FrameCount % 120 == 0 then
            stomp_count = 3
            stomp_timer = 0
        end

        if stomp_count > 0 then
            stomp_timer = stomp_timer + 1
            if stomp_timer % 15 == 0 then
                local stompPos = player.Position
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
                    stompPos, Vector.Zero, npc)
                stomp_count = stomp_count - 1
            end
        end
    end
end)

Isaac.DebugString("TaintedSatanHoof loaded!")
