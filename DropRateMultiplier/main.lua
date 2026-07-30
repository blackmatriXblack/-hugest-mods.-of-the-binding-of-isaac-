-- =============================================================================
--  DROP RATE MULTIPLIER — The Binding of Isaac: Repentance
--  Doubles enemy drop rates. On every enemy kill, spawns extra pickups.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DropRateMultiplier", 1)

function mod:onEntityKill(entity)
    if not entity:IsEnemy() then return end

    local pos = entity.Position
    local rng = RNG()

    -- Roll extra drops (simulating double drops)
    local extraRolls = 2
    for i = 1, extraRolls do
        local roll = rng:RandomInt(100)
        if roll < 35 then
            -- Spawn coin (penny or nickel)
            local coinType = 1
            if rng:RandomInt(10) == 0 then coinType = 2 end -- 10% nickel
            Isaac.Spawn(5, 20, coinType, pos + Vector(rng:RandomInt(20) - 10, rng:RandomInt(20) - 10), Vector(0, 0), nil)
        elseif roll < 55 then
            -- Spawn heart (half or full)
            local heartType = 2 -- half heart
            if rng:RandomInt(2) == 0 then heartType = 1 end -- 50% full heart
            Isaac.Spawn(5, 10, heartType, pos + Vector(rng:RandomInt(20) - 10, rng:RandomInt(20) - 10), Vector(0, 0), nil)
        elseif roll < 70 then
            -- Spawn key
            Isaac.Spawn(5, 30, 1, pos + Vector(rng:RandomInt(20) - 10, rng:RandomInt(20) - 10), Vector(0, 0), nil)
        elseif roll < 85 then
            -- Spawn bomb
            Isaac.Spawn(5, 40, 1, pos + Vector(rng:RandomInt(20) - 10, rng:RandomInt(20) - 10), Vector(0, 0), nil)
        elseif roll < 95 then
            -- Spawn battery
            Isaac.Spawn(5, 90, 1, pos + Vector(rng:RandomInt(20) - 10, rng:RandomInt(20) - 10), Vector(0, 0), nil)
        else
            -- Spawn pill
            Isaac.Spawn(5, 70, 0, pos + Vector(rng:RandomInt(20) - 10, rng:RandomInt(20) - 10), Vector(0, 0), nil)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("Drop Rate Multiplier loaded!")
