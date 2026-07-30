-- ==========================================================================
--  Tainted Ultra Greedier Statue - The Binding of Isaac: Repentance
--  Tainted Ultra Greedier — gold statue phase lasts 2x longer.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedUltraGreedierStatue", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_ULTRA_GREEDIER then
        local room = Game():GetRoom()
        if not room then return end

        if npc:GetSprite():IsPlaying("Idle") then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)
            if npc.StateFrame < 180 then
                npc.StateFrame = npc.StateFrame + 2
            end
        end
    end
end)

Isaac.DebugString("TaintedUltraGreedierStatue loaded!")
