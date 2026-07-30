-- =============================================================================
--  FloatingKnightOrbit — The Binding of Isaac: Repentance
--  Floating Knights (Type=17, Variant=1) orbit the player in circles.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FloatingKnightOrbit", 1)

local ORBIT_RADIUS = 120
local ORBIT_SPEED = 0.03   -- Radians per frame
local knightAngles = {}

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 17 or npc.Variant ~= 1 then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local idx = npc.Index
    if not knightAngles[idx] then
        knightAngles[idx] = math.random() * math.pi * 2
    end

    knightAngles[idx] = knightAngles[idx] + ORBIT_SPEED
    local angle = knightAngles[idx]

    -- Calculate circular orbit position around player
    local targetX = player.Position.X + math.cos(angle) * ORBIT_RADIUS
    local targetY = player.Position.Y + math.sin(angle) * ORBIT_RADIUS
    local targetPos = Vector(targetX, targetY)

    -- Smoothly move toward orbit position
    local moveDir = (targetPos - npc.Position):Normalized()
    local speed = (targetPos - npc.Position):Length() * 0.1 + 1
    npc.Velocity = moveDir * speed
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("FloatingKnightOrbit loaded!")
