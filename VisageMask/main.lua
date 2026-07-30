-- =============================================================================
--  Visage Mask - The Binding of Isaac: Repentance
--  The Visage mask phase summons floating skulls that orbit and shoot
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("VisageMask", 1)
local VISAGE_TYPE = 909

function mod:onNPCUpdate(npc)
    if npc.Type ~= VISAGE_TYPE then return end
    
    -- During mask phase (state 10), spawn orbiting skulls every 120 frames
    if npc.State == 10 and npc.FrameCount % 120 == 0 then
        local skullCount = 3
        for i = 0, skullCount - 1 do
            local angle = i * math.pi * 2 / skullCount + npc.FrameCount * 0.02
            local spawnPos = npc.Position + Vector(math.cos(angle) * 90, math.sin(angle) * 90)
            local skull = Isaac.Spawn(EntityType.ENTITY_DEATHS_HEAD, 0, 0, spawnPos, Vector.Zero, npc)
            if skull then
                skull:GetData().orbitAngle = angle
                skull:GetData().orbitParent = npc
                skull:GetData().orbitDist = 90
            end
        end
    end
    
    -- Update orbiting skulls
    if npc:GetData().orbitParent then
        local parent = npc:GetData().orbitParent
        if parent:Exists() then
            npc:GetData().orbitAngle = npc:GetData().orbitAngle + 0.03
            local targetPos = parent.Position + Vector(
                math.cos(npc:GetData().orbitAngle) * npc:GetData().orbitDist,
                math.sin(npc:GetData().orbitAngle) * npc:GetData().orbitDist
            )
            npc.Velocity = (targetPos - npc.Position) * 0.2
            
            -- Shoot at player every 60 frames
            local player = Isaac.GetPlayer(0)
            if player and npc.FrameCount % 60 == 0 then
                local dir = (player.Position - npc.Position):Normalized()
                Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, dir * 3, npc)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, VISAGE_TYPE)
Isaac.DebugString("VisageMask loaded!")
