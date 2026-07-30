-- =============================================================================
--  Lil Blub Bounce - The Binding of Isaac: Repentance
--  Lil Blub bounces 3x faster and spawns drowning creep on land
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LilBlubBounce", 1)
local LIL_BLUB_TYPE = 901 -- EntityType.ENTITY_LIL_BLUB

function mod:onNPCUpdate(npc)
    if npc.Type ~= LIL_BLUB_TYPE then return end
    
    -- Triple bounce speed during jump/charge state
    if npc.State == 8 or npc.State == 9 then
        npc.Velocity = npc.Velocity * 3.0
    end
    
    -- Spawn drowning creep on land every 15 frames
    if npc.FrameCount % 15 == 0 and not npc:IsFlying() then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, npc.Position, Vector.Zero, npc)
        if creep then
            creep:ToEffect().Timeout = 90
            creep:ToEffect().Scale = 1.2
        end
    end
    
    -- When touching the ground after a bounce, spawn a burst of creep
    if npc.State == 1 and npc.StateFrame == 1 and npc.FrameCount > 10 then
        for i = 0, 5 do
            local angle = i * math.pi * 2 / 6
            local spawnPos = npc.Position + Vector(math.cos(angle) * 40, math.sin(angle) * 40)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, spawnPos, Vector.Zero, npc)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, LIL_BLUB_TYPE)
Isaac.DebugString("LilBlubBounce loaded!")
