-- =============================================================================
--  Rag Mega Raglings - The Binding of Isaac: Repentance
--  Rag Mega spawns 4 friendly spiders that orbit and protect him
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RagMegaRaglings", 1)
local RAG_MEGA_TYPE = 246 -- EntityType.ENTITY_RAG_MEGA

function mod:onEntitySpawn(entity)
    if entity.Type ~= RAG_MEGA_TYPE then return end
    
    -- Spawn 4 friendly orbiting spiders
    for i = 0, 3 do
        local angle = i * math.pi * 2 / 4
        local spawnPos = entity.Position + Vector(math.cos(angle) * 80, math.sin(angle) * 80)
        local spider = Isaac.Spawn(EntityType.ENTITY_SPIDER, 1, 0, spawnPos, Vector.Zero, entity)
        if spider then
            spider:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
            spider:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
            spider:GetData().orbitIndex = i
            spider:GetData().orbitParent = entity
            spider:GetData().orbitSpeed = 0.03
        end
    end
end

function mod:onNPCUpdate(npc)
    -- Update orbiting spiders
    if npc:GetData().orbitParent then
        local parent = npc:GetData().orbitParent
        if parent:Exists() and parent:IsVulnerableEnemy() then
            local angle = npc:GetData().orbitIndex * math.pi * 2 / 4
            angle = angle + npc.FrameCount * npc:GetData().orbitSpeed
            local targetPos = parent.Position + Vector(math.cos(angle) * 80, math.sin(angle) * 80)
            npc.Velocity = (targetPos - npc.Position) * 0.15
            
            -- If player is close to parent, spiders shoot
            local player = Isaac.GetPlayer(0)
            if player and player.Position:Distance(parent.Position) < 200 and npc.FrameCount % 45 == 0 then
                local dir = (player.Position - npc.Position):Normalized()
                Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, dir * 3, npc)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn, RAG_MEGA_TYPE)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("RagMegaRaglings loaded!")
