-- =============================================================================
--  Reap Creep Tar - The Binding of Isaac: Repentance
--  Reap Creep's tar pits spread and spawn small creep minions
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ReapCreepTar", 1)
local REAP_CREEP_TYPE = 900 -- EntityType.ENTITY_REAP_CREEP

function mod:onNPCUpdate(npc)
    if npc.Type ~= REAP_CREEP_TYPE then return end
    
    -- Every 60 frames, spawn a tar pool at a random nearby position
    if npc.FrameCount % 60 == 0 then
        local angle = math.random() * math.pi * 2
        local dist = 60 + math.random() * 80
        local spawnPos = npc.Position + Vector(math.cos(angle) * dist, math.sin(angle) * dist)
        
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, spawnPos, Vector.Zero, npc)
    end
    
    -- Every 120 frames, spawn a small creep minion from existing tar
    if npc.FrameCount % 120 == 0 then
        local roomEntities = Isaac.GetRoomEntities()
        for _, ent in ipairs(roomEntities) do
            if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == EffectVariant.CREEP_BLACK then
                if math.random() < 0.3 then
                    local minion = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, ent.Position, Vector.Zero, npc)
                    if minion then
                        minion:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, REAP_CREEP_TYPE)
Isaac.DebugString("ReapCreepTar loaded!")
