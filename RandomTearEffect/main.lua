-- =============================================================================
--  RandomTearEffect - The Binding of Isaac: Repentance
--  Each tear fired has a random effect (homing, piercing, explosive, poison, fear, charm)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RandomTearEffect", 1)
local game = Game()

local tearEffects = {
    "homing",
    "piercing",
    "explosive",
    "poison",
    "fear",
    "charm",
    "slowing",
    "burning",
    "spectral",
    "giant",
}

function mod:onFireTear(tear)
    local rng = RNG()
    rng:SetSeed(tear.InitSeed, 42)
    local effectIndex = (rng:RandomInt(#tearEffects)) + 1
    local effect = tearEffects[effectIndex]

    -- Apply tear flags/modifiers based on random effect
    local tearFlags = tear.TearFlags

    if effect == "homing" then
        -- Grant homing effect via tear flags
        tear.TearFlags = tearFlags | TearFlags.TEAR_HOMING
        tear:ChangeColor(Color(0.3, 0.3, 1.0, 1.0, 0, 0, 0), 0, 255)

    elseif effect == "piercing" then
        tear.TearFlags = tearFlags | TearFlags.TEAR_PIERCING
        tear:ChangeColor(Color(0.8, 0.8, 0.2, 1.0, 0, 0, 0), 0, 255)

    elseif effect == "explosive" then
        tear.TearFlags = tearFlags | TearFlags.TEAR_BOMB
        tear:ChangeColor(Color(1.0, 0.2, 0.1, 1.0, 0, 0, 0), 0, 255)

    elseif effect == "poison" then
        tear.TearFlags = tearFlags | TearFlags.TEAR_POISON
        tear:ChangeColor(Color(0.1, 0.8, 0.1, 1.0, 0, 0, 0), 0, 255)

    elseif effect == "fear" then
        tear.TearFlags = tearFlags | TearFlags.TEAR_FEAR
        tear:ChangeColor(Color(0.6, 0.1, 0.6, 1.0, 0, 0, 0), 0, 255)

    elseif effect == "charm" then
        tear.TearFlags = tearFlags | TearFlags.TEAR_CHARM
        tear:ChangeColor(Color(1.0, 0.5, 0.8, 1.0, 0, 0, 0), 0, 255)

    elseif effect == "slowing" then
        tear.TearFlags = tearFlags | TearFlags.TEAR_SLOW
        tear:ChangeColor(Color(0.3, 0.6, 1.0, 1.0, 0, 0, 0), 0, 255)

    elseif effect == "burning" then
        tear.TearFlags = tearFlags | TearFlags.TEAR_BURN
        tear:ChangeColor(Color(1.0, 0.4, 0.0, 1.0, 0, 0, 0), 0, 255)

    elseif effect == "spectral" then
        tear.TearFlags = tearFlags | TearFlags.TEAR_SPECTRAL
        tear:ChangeColor(Color(0.7, 0.7, 1.0, 0.6, 0, 0, 0), 0, 255)

    elseif effect == "giant" then
        -- Scale up the tear visually and damage
        tear.Scale = tear.Scale * 2.0
        tear.CollisionDamage = tear.CollisionDamage * 1.5
        tear:ChangeColor(Color(1.0, 0.2, 1.0, 1.0, 0, 0, 0), 0, 255)
    end

    -- Show effect name briefly
    local player = Isaac.GetPlayer(0)
    if player then
        local displayPos = Isaac.WorldToScreen(player.Position)
        -- Visual feedback that effect was applied
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.onFireTear)

Isaac.DebugString("RandomTearEffect loaded!")
