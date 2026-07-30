-- =============================================================================
--  Hornfel Rocks - The Binding of Isaac: Repentance
--  Hornfel throws 2x more rocks and they bounce off walls once
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HornfelRocks", 1)
local HORNFEL_TYPE = 910

function mod:onNPCUpdate(npc)
    if npc.Type ~= HORNFEL_TYPE then return end
    
    -- During rock throw state, double the rocks and give bounce property
    if npc.State == 8 and npc.StateFrame == 15 then
        local player = Isaac.GetPlayer(0)
        if not player then return end
        
        -- Spawn extra rock projectiles (normally 3, now 6 total)
        for i = 1, 3 do
            local angle = (player.Position - npc.Position):GetAngleDegrees()
            angle = angle + (i - 2) * 12
            local rad = math.rad(angle)
            local dir = Vector(math.cos(rad), math.sin(rad))
            local rock = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 1, 0, npc.Position, dir * 5, npc)
            if rock then
                local proj = rock:ToProjectile()
                proj:GetData().canBounce = true
                proj:GetData().bounced = false
                proj.Scale = 1.3
            end
        end
    end
end

-- Wall bounce logic for Hornfel projectiles
function mod:onProjectileUpdate(proj)
    if not proj:GetData().canBounce or proj:GetData().bounced then return end
    
    local pos = proj.Position
    local vel = proj.Velocity
    local bounced = false
    
    -- Room boundaries (approximate)
    if pos.X < 60 or pos.X > 580 then
        proj.Velocity = Vector(-vel.X, vel.Y)
        bounced = true
    end
    if pos.Y < 60 or pos.Y > 300 then
        proj.Velocity = Vector(vel.X, -vel.Y)
        bounced = true
    end
    
    if bounced then
        proj:GetData().bounced = true
        -- Flash effect on bounce
        proj:AddEntityFlags(EntityFlag.FLAG_BRIGHT)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, HORNFEL_TYPE)
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.onProjectileUpdate)
Isaac.DebugString("HornfelRocks loaded!")
