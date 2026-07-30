-- =============================================================================
--  TearSplitChain - The Binding of Isaac: Repentance
--  Piercing tears split into 2 perpendicular tears on each enemy hit.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TearSplitChain", 1)

function mod:onTearCollision(tear, collider)
    if not collider or not collider:IsVulnerableEnemy() then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local vel = tear.Velocity
    local speed = vel:Length()
    local perp1 = Vector(-vel.Y, vel.X)
    local perp2 = Vector(vel.Y, -vel.X)

    if perp1:Length() > 0 then
        perp1 = perp1:Normalized()
        perp2 = perp2:Normalized()
    else
        perp1 = Vector(1, 0)
        perp2 = Vector(0, 1)
    end

    for _, dir in ipairs({perp1, perp2}) do
        local t = player:FireTear(tear.Position, dir * speed * 0.7, false, false, false)
        t.Scale = tear.Scale * 0.7
        t.Color = Color(0.0, 1.0, 1.0, 1.0, 0, 0, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, mod.onTearCollision)
Isaac.DebugString("TearSplitChain loaded!")
