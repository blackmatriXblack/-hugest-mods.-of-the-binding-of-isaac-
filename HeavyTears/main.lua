-- ==========================================================================
--  Heavy Tears - The Binding of Isaac: Repentance
--  Tears are affected by gravity — they arc downward like real projectiles
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HeavyTears", 1)
local game = Game()
local GRAVITY = 0.15
local tearVelocities = {}

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    tearVelocities[tear.InitSeed] = {
        vx = tear.Velocity.X,
        vy = tear.Velocity.Y,
        elapsed = 0,
    }
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    local data = tearVelocities[tear.InitSeed]
    if not data then return end

    if tear:IsDead() then
        tearVelocities[tear.InitSeed] = nil
        return
    end

    data.elapsed = data.elapsed + 1

    -- Apply gravity to tear velocity
    local newVY = data.vy + GRAVITY * data.elapsed
    local newVX = data.vx

    tear.Velocity = Vector(newVX, newVY)

    -- Add visual trail for heavy tear effect
    tear:SetColor(Color(0.8, 0.8, 1, 1, 0, 0, 0), -1, 1, false, false)
end)

Isaac.DebugString("Heavy Tears loaded!")
