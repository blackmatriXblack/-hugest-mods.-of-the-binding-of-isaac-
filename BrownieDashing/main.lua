-- =============================================================================
--  Brownie Dashing - The Binding of Isaac: Repentance
--  Brownie dashes faster and leaves a brown creep trail behind
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BrownieDashing", 1)
local BROWNIE_TYPE = 402 -- EntityType.ENTITY_BROWNIE

function mod:onNPCUpdate(npc)
    if npc.Type ~= BROWNIE_TYPE then return end
    
    -- Check if Brownie is in a dashing state (State 8 = charging/jumping)
    if npc.State == 8 or npc.State == 9 then
        -- Boost dash speed by 50%
        npc.Velocity = npc.Velocity * 1.5
        
        -- Spawn brown creep trail every 3 frames
        if npc.FrameCount % 3 == 0 then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, npc.Position, Vector.Zero, nil)
            if creep then
                creep:ToEffect().Timeout = 120
                creep:ToEffect().Scale = 0.8
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, BROWNIE_TYPE)
Isaac.DebugString("BrownieDashing loaded!")
