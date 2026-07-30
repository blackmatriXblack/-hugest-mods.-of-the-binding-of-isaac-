-- =============================================================================
--  Adversary Laser - The Binding of Isaac: Repentance
--  The Adversary's brimstone laser homes slightly toward the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AdversaryLaser", 1)
local ADVERSARY_TYPE = 268 -- EntityType.ENTITY_ADVERSARY

function mod:onNPCUpdate(npc)
    if npc.Type ~= ADVERSARY_TYPE then return end
    
    -- During brimstone laser state, apply slight homing to all lasers
    if npc.State == 8 then
        local player = Isaac.GetPlayer(0)
        if not player then return end
        
        local roomEntities = Isaac.GetRoomEntities()
        for _, ent in ipairs(roomEntities) do
            -- Find active brimstone lasers spawned by Adversary
            if ent.Type == EntityType.ENTITY_LASER and ent.SpawnerEntity == npc then
                local laser = ent:ToLaser()
                if laser then
                    -- Curve laser angle 0.5 degrees per frame toward player
                    local toPlayer = player.Position - npc.Position
                    local currentAngle = laser.AngleDegrees
                    local targetAngle = math.deg(math.atan2(toPlayer.Y, toPlayer.X))
                    
                    -- Smooth angle adjustment
                    local diff = targetAngle - currentAngle
                    -- Normalize to [-180, 180]
                    while diff > 180 do diff = diff - 360 end
                    while diff < -180 do diff = diff + 360 end
                    
                    local newAngle = currentAngle + math.clamp(diff, -0.5, 0.5)
                    laser.AngleDegrees = newAngle
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, ADVERSARY_TYPE)
Isaac.DebugString("AdversaryLaser loaded!")
