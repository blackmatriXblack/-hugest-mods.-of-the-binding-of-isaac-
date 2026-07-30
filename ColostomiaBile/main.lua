-- =============================================================================
--  Colostomia Bile - The Binding of Isaac: Repentance
--  Colostomia's bile pools spawn gas clouds that slow the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ColostomiaBile", 1)
local COLOSTOMIA_TYPE = 915

function mod:onNPCUpdate(npc)
    if npc.Type ~= COLOSTOMIA_TYPE then return end
    
    -- During bile attack, spawn gas clouds around the room
    if npc.State == 8 and npc.StateFrame % 30 == 0 then
        local player = Isaac.GetPlayer(0)
        if not player then return end
        
        -- Spawn gas cloud at a position between Colostomia and the player
        local midPos = (npc.Position + player.Position) / 2
        local offset = Vector((math.random()-0.5)*80, (math.random()-0.5)*80)
        local cloudPos = midPos + offset
        
        local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POISON_CLOUD, 0, cloudPos, Vector.Zero, npc)
        if gas then
            gas:ToEffect().Timeout = 180
            gas:ToEffect().Scale = 1.5
        end
    end
    
    -- When exiting bile pool state, spawn gas clouds near existing creep
    if npc.State == 1 and npc.StateFrame == 1 then
        local roomEntities = Isaac.GetRoomEntities()
        local creepCount = 0
        for _, ent in ipairs(roomEntities) do
            if ent.Type == EntityType.ENTITY_EFFECT and (
                ent.Variant == EffectVariant.PLAYER_CREEP_BROWN or
                ent.Variant == EffectVariant.CREEP_BLACK
            ) then
                creepCount = creepCount + 1
                if creepCount <= 3 and math.random() < 0.4 then
                    local gas = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POISON_CLOUD, 0, ent.Position, Vector.Zero, npc)
                    if gas then
                        gas:ToEffect().Timeout = 120
                        gas:ToEffect().Scale = 1.2
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, COLOSTOMIA_TYPE)
Isaac.DebugString("ColostomiaBile loaded!")
