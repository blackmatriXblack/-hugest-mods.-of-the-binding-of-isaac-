-- =============================================================================
--  TearFlagTracer - The Binding of Isaac: Repentance
--  Display all current tear flags as text on screen in real-time.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TearFlagTracer", 1)

local TEAR_FLAGS = {
    { flag = TearFlags.TEAR_PIERCING,       name = "PIERCING" },
    { flag = TearFlags.TEAR_SPECTRAL,       name = "SPECTRAL" },
    { flag = TearFlags.TEAR_HOMING,         name = "HOMING" },
    { flag = TearFlags.TEAR_SLOW,           name = "SLOW" },
    { flag = TearFlags.TEAR_POISON,         name = "POISON" },
    { flag = TearFlags.TEAR_FEAR,           name = "FEAR" },
    { flag = TearFlags.TEAR_CONFUSE,        name = "CONFUSE" },
    { flag = TearFlags.TEAR_CHARM,          name = "CHARM" },
    { flag = TearFlags.TEAR_BURN,           name = "BURN" },
    { flag = TearFlags.TEAR_WIGGLE,         name = "WIGGLE" },
    { flag = TearFlags.TEAR_BOUNCE,         name = "BOUNCE" },
    { flag = TearFlags.TEAR_MAGNETIZE,      name = "MAGNETIZE" },
    { flag = TearFlags.TEAR_BOOGER,         name = "BOOGER" },
    { flag = TearFlags.TEAR_BLACK_TOOTH,    name = "BLACK_TOOTH" },
    { flag = TearFlags.TEAR_ACID,           name = "ACID" },
    { flag = TearFlags.TEAR_BONE,           name = "BONE" },
    { flag = TearFlags.TEAR_BELIAL,         name = "BELIAL" },
    { flag = TearFlags.TEAR_ABSORB,         name = "ABSORB" },
    { flag = TearFlags.TEAR_PULSE,          name = "PULSE" },
    { flag = TearFlags.TEAR_ICE,            name = "ICE" },
    { flag = TearFlags.TEAR_MAGNETIC,       name = "MAGNETIC" },
    { flag = TearFlags.TEAR_BAIT,           name = "BAIT" },
    { flag = TearFlags.TEAR_BACKSTAB,       name = "BACKSTAB" },
    { flag = TearFlags.TEAR_GODHEAD,        name = "GODHEAD" },
    { flag = TearFlags.TEAR_BLOOD_BOMB,     name = "BLOOD_BOMB" },
    { flag = TearFlags.TEAR_MYSTERIOUS_LIQUID, name = "MYST_LIQUID" },
    { flag = TearFlags.TEAR_EXPLOSIVE,      name = "EXPLOSIVE" },
    { flag = TearFlags.TEAR_SPORE,          name = "SPORE" },
    { flag = TearFlags.TEAR_CONE,           name = "CONE" },
    { flag = TearFlags.TEAR_BOIL,           name = "BOIL" },
    { flag = TearFlags.TEAR_NEEDLE,         name = "NEEDLE" },
    { flag = TearFlags.TEAR_QUAKE,          name = "QUAKE" },
    { flag = TearFlags.TEAR_LUDOVICO,       name = "LUDOVICO" },
    { flag = TearFlags.TEAR_NAIL,           name = "NAIL" },
    { flag = TearFlags.TEAR_CUPID,          name = "CUPID" },
    { flag = TearFlags.TEAR_BOBBER,         name = "BOBBER" },
    { flag = TearFlags.TEAR_SPAWN_SHADOW,   name = "SPAWN_SHADOW" },
    { flag = TearFlags.TEAR_ICE_TRACES,     name = "ICE_TRACES" },
    { flag = TearFlags.TEAR_KNIFE,          name = "KNIFE" },
    { flag = TearFlags.TEAR_TURN_HORIZONTAL,name = "TURN_HORIZ" },
}

function mod:postRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local flags = player.TearFlags
    local x, y = 10, 25
    local font = Font()
    local activeCount = 0

    for _, tf in ipairs(TEAR_FLAGS) do
        if (flags & tf.flag) == tf.flag then
            font:DrawStringScaled(
                "+ " .. tf.name,
                x, y,
                0.8, 0.8,
                KColor(0.0, 1.0, 0.0, 1.0),
                0, false
            )
            y = y + 13
            activeCount = activeCount + 1
        end
    end

    font:DrawStringScaled(
        "Active Tear Flags: " .. activeCount,
        x, 10,
        1.0, 1.0,
        KColor(1.0, 1.0, 0.0, 1.0),
        0, false
    )

    if activeCount == 0 then
        font:DrawStringScaled(
            "(None)",
            x, y,
            0.7, 0.7,
        KColor(0.5, 0.5, 0.5, 1.0),
            0, false
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.postRender)
Isaac.DebugString("TearFlagTracer loaded!")
