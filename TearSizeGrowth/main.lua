-- =============================================================================
--  TearSizeGrowth - The Binding of Isaac: Repentance
--  Tears grow in size the longer they travel, up to 3x.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TearSizeGrowth", 1)

local tearSpawn = {}
local MAX_SCALE = 3.0

function mod:onTearUpdate(tear)
    if not tear.Visible then return end

    local ptr = GetPtrHash(tear)
    if not tearSpawn[ptr] then
        tearSpawn[ptr] = { spawnTime = tear.FrameCount }
    end

    local age = tear.FrameCount - tearSpawn[ptr].spawnTime
    local scale = math.min(1.0 + age * 0.03, MAX_SCALE)
    tear.Scale = scale

    -- Visual feedback: bigger tears get more red tint
    local redAmount = (scale - 1.0) / 2.0
    tear.Color = Color(1.0, 1.0 - redAmount, 1.0 - redAmount, 1.0, 0, 0, 0)
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.onTearUpdate)
Isaac.DebugString("TearSizeGrowth loaded!")
