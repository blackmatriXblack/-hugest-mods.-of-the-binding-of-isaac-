-- =============================================================================
--  Big Horn Hands - The Binding of Isaac: Repentance
--  Big Horn summons giant hands from the ceiling periodically
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BigHornHands", 1)
local BIG_HORN_TYPE = 411 -- EntityType.ENTITY_BIG_HORN

function mod:onNPCUpdate(npc)
    if npc.Type ~= BIG_HORN_TYPE then return end
    
    -- Summon giant stone hands from ceiling every 180 frames
    if npc.FrameCount % 180 == 0 then
        local player = Isaac.GetPlayer(0)
        if player then
            -- Spawn 2 hands that track toward the player from the ceiling
            for i = 1, 2 do
                local spawnX = player.Position.X + (math.random() - 0.5) * 160
                local spawnPos = Vector(spawnX, 40) -- From ceiling
                local hand = Isaac.Spawn(EntityType.ENTITY_MOMS_DEAD_HAND, 0, 0, spawnPos, Vector(0, 4), npc)
                if hand then
                    hand:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                end
            end
        end
    end
    
    -- During ground pound state, also drop hands
    if npc.State == 12 and npc.StateFrame == 15 then
        for i = 1, 3 do
            local spawnX = math.random(80, 560)
            Isaac.Spawn(EntityType.ENTITY_MOMS_DEAD_HAND, 0, 0, Vector(spawnX, 40), Vector(0, 3), npc)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, BIG_HORN_TYPE)
Isaac.DebugString("BigHornHands loaded!")
