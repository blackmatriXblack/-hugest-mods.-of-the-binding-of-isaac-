-- =============================================================================
--  Wormwood Tentacle - The Binding of Isaac: Repentance
--  Wormwood has 2 extra tentacles that attack independently
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("WormwoodTentacle", 1)
local WORMWOOD_TYPE = 902 -- EntityType.ENTITY_WORMWOOD

function mod:onNPCUpdate(npc)
    if npc.Type ~= WORMWOOD_TYPE then return end
    
    -- Prevent re-spawning tentacles too often
    if npc:GetData().tentaclesSpawned == nil then
        npc:GetData().tentaclesSpawned = false
    end
    
    if not npc:GetData().tentaclesSpawned and npc.FrameCount > 30 then
        -- Spawn 2 extra tentacle NPCs near Wormwood that follow it
        for i = 1, 2 do
            local offset = Vector((i == 1 and -60 or 60), -40)
            local tentacle = Isaac.Spawn(EntityType.ENTITY_WORMWOOD, 1, 0, npc.Position + offset, Vector.Zero, npc)
            if tentacle then
                tentacle:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                tentacle:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
                tentacle:GetData().parentWormwood = npc
                tentacle:GetData().isExtraTentacle = true
            end
        end
        npc:GetData().tentaclesSpawned = true
    end
    
    -- Keep extra tentacles near Wormwood
    if npc:GetData().isExtraTentacle and npc:GetData().parentWormwood then
        local parent = npc:GetData().parentWormwood
        if parent:Exists() and parent:IsVulnerableEnemy() then
            local targetAngle = math.atan2(npc.Position.Y - parent.Position.Y, npc.Position.X - parent.Position.X)
            local targetDist = 60
            local desiredPos = parent.Position + Vector(math.cos(targetAngle) * targetDist, math.sin(targetAngle) * targetDist)
            npc.Velocity = (desiredPos - npc.Position) * 0.1
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, WORMWOOD_TYPE)
Isaac.DebugString("WormwoodTentacle loaded!")
