-- =============================================================================
--  Cage Tremor - The Binding of Isaac: Repentance
--  The Cage's ground pound causes falling rocks from ceiling
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CageTremor", 1)
local CAGE_TYPE = 269 -- EntityType.ENTITY_CAGE

function mod:onNPCUpdate(npc)
    if npc.Type ~= CAGE_TYPE then return end
    
    -- During ground pound state, spawn falling rocks
    if npc.State == 12 and npc.StateFrame <= 30 then
        if npc.StateFrame % 5 == 0 then
            local player = Isaac.GetPlayer(0)
            
            -- Spawn rocks that fall from ceiling toward player positions
            local targetPositions = {}
            if player then
                table.insert(targetPositions, player.Position)
                -- Additional rocks near player
                for i = 1, 2 do
                    local offset = Vector((math.random()-0.5)*200, (math.random()-0.5)*100)
                    table.insert(targetPositions, player.Position + offset)
                end
            end
            
            for _, targetPos in ipairs(targetPositions) do
                -- Spawn rock at ceiling above target
                local rockSpawn = Vector(targetPos.X, 30)
                local rock = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, rockSpawn, Vector(0, 6), npc)
                if rock then
                    rock:GetData().fallTarget = targetPos.Y
                    rock:GetData().isCageRock = true
                    rock:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                end
            end
        end
    end
    
    -- Small tremor rocks near Cage during normal movement
    if npc.State == 1 and npc.FrameCount % 60 == 0 then
        local tremorPos = npc.Position + Vector((math.random()-0.5)*120, (math.random()-0.5)*60)
        local rock = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, 
            Vector(tremorPos.X, 30), Vector(0, 5), npc)
        if rock then
            rock:GetData().isCageRock = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, CAGE_TYPE)
Isaac.DebugString("CageTremor loaded!")
