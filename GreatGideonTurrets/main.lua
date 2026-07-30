-- =============================================================================
--  Great Gideon Turrets - The Binding of Isaac: Repentance
--  Great Gideon's turrets fire 2x faster but have 30% less HP
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GreatGideonTurrets", 1)
local GIDEON_TYPE = 911
local GIDEON_TURRET_TYPE = 912

function mod:onNPCUpdate(npc)
    -- Reduce turret HP by 30% on first encounter
    if npc.Type == GIDEON_TURRET_TYPE then
        if npc:GetData().hpAdjusted == nil then
            npc.MaxHitPoints = math.floor(npc.MaxHitPoints * 0.7)
            npc.HitPoints = math.min(npc.HitPoints, npc.MaxHitPoints)
            npc:GetData().hpAdjusted = true
        end
        
        -- Double fire rate: force shoot every 20 frames instead of 40
        if npc.FrameCount % 20 == 0 and npc:IsVulnerableEnemy() then
            local player = Isaac.GetPlayer(0)
            if player and player.Position:Distance(npc.Position) < 500 then
                local dir = (player.Position - npc.Position):Normalized()
                Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, dir * 4, npc)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, GIDEON_TURRET_TYPE)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, GIDEON_TYPE)
Isaac.DebugString("GreatGideonTurrets loaded!")
