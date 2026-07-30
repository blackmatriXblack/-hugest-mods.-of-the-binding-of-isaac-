-- ==========================================================================
--  TearFountain - The Binding of Isaac: Repentance
--  Player constantly fires tears in all 8 directions while standing still!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TearFountain", 1)
local fountainTimer = 0
local TEAR_RATE = 12

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local vel = player.Velocity
    if vel:Length() > 0.3 then
        fountainTimer = 0
        return
    end

    fountainTimer = fountainTimer + 1
    if fountainTimer % TEAR_RATE ~= 0 then return end

    local angles = {0, 45, 90, 135, 180, 225, 270, 315}
    local speed = 3 + math.random(0, 2)
    for _, angle in ipairs(angles) do
        local rad = math.rad(angle)
        local dir = Vector(math.cos(rad), math.sin(rad))
        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
            player.Position, dir * speed, player)
        if tear then
            tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
            tear:SetColor(Color(0.4 + math.sin(fountainTimer * 0.1) * 0.3,
                0.6 + math.cos(fountainTimer * 0.07) * 0.3,
                1.0, 1, 0, 0, 0), 0, 1)
        end
    end

    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
        player.Position, Vector.Zero, player):SetTimeout(5)
end)

Isaac.DebugString("TearFountain loaded! ALL DIRECTIONS FIRE!")
