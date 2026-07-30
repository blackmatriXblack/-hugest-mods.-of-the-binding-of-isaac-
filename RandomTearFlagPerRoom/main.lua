-- =============================================================================
--  RandomTearFlagPerRoom - The Binding of Isaac: Repentance
--  Grants a random tear flag effect each new room.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RandomTearFlagPerRoom", 1)

local FLAG_POOL = {
    TearFlags.TEAR_PIERCING,
    TearFlags.TEAR_SPECTRAL,
    TearFlags.TEAR_HOMING,
    TearFlags.TEAR_SLOW,
    TearFlags.TEAR_POISON,
    TearFlags.TEAR_FEAR,
    TearFlags.TEAR_CONFUSE,
    TearFlags.TEAR_CHARM,
    TearFlags.TEAR_BURN,
    TearFlags.TEAR_BOUNCE,
    TearFlags.TEAR_MAGNETIZE,
    TearFlags.TEAR_ACID,
    TearFlags.TEAR_BONE,
    TearFlags.TEAR_ICE,
    TearFlags.TEAR_EXPLOSIVE,
    TearFlags.TEAR_CUPID,
    TearFlags.TEAR_BOBBER,
}

local FLAG_NAMES = {
    "Piercing", "Spectral", "Homing", "Slow", "Poison",
    "Fear", "Confuse", "Charm", "Burn", "Bounce",
    "Magnetize", "Acid", "Bone", "Ice", "Explosive",
    "Cupid", "Bobber",
}

function mod:onNewRoom()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Clear previous random flags to avoid stacking
    for _, f in ipairs(FLAG_POOL) do
        player.TearFlags = player.TearFlags & ~f
    end

    local idx = player:GetDropRNG():RandomInt(#FLAG_POOL) + 1
    player.TearFlags = player.TearFlags | FLAG_POOL[idx]

    local color = KColor(0.2 + idx * 0.04, 0.8, 1.0 - idx * 0.02, 1.0)
    Isaac.DebugString(FLAG_NAMES[idx] .. " tears this room!")
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("RandomTearFlagPerRoom loaded!")
