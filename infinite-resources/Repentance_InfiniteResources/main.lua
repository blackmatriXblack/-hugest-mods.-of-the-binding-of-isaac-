-- =============================================================================
-- Infinite Resources Mod for The Binding of Isaac
-- Target Version: Repentance
-- Features: Infinite Health, Infinite Coins, Infinite Bombs, Infinite Keys
-- =============================================================================

local mod = RegisterMod("InfiniteResources", 1)

-- =============================================================================
-- Constants
-- =============================================================================
local MAX_COINS = 99
local MAX_BOMBS = 99
local MAX_KEYS = 99
local MAX_SOUL_HEARTS = 24  -- 12 full soul hearts as buffer (half-heart units)

-- =============================================================================
-- Helper: Replenish a numeric resource to its max cap
-- =============================================================================
local function replenishToMax(player, currentFn, addFn, maxValue)
    local current = currentFn(player)
    if current < maxValue then
        addFn(player, maxValue - current)
    end
end

-- =============================================================================
-- Main Callback: MC_POST_PEFFECT_UPDATE
-- Fires every game frame for each player entity.
-- Same enum name works in Afterbirth+, Repentance, and Repentance+.
-- =============================================================================
function mod:onPEffectUpdate(player)
    -- Safety: player should always be valid in this callback, but guard anyway
    if player == nil then
        return
    end

    -- ---- Infinite Coins ----
    replenishToMax(player,
        function(p) return p:GetNumCoins() end,
        function(p, v) p:AddCoins(v) end,
        MAX_COINS)

    -- ---- Infinite Bombs ----
    replenishToMax(player,
        function(p) return p:GetNumBombs() end,
        function(p, v) p:AddBombs(v) end,
        MAX_BOMBS)

    -- ---- Infinite Keys ----
    replenishToMax(player,
        function(p) return p:GetNumKeys() end,
        function(p, v) p:AddKeys(v) end,
        MAX_KEYS)

    -- ---- Infinite Health (Red Hearts) ----
    -- GetMaxHearts() returns the number of heart CONTAINERS (e.g., 3 = 3 containers)
    -- GetHearts() returns red heart fill in HALF-HEART units (e.g., 6 = 3 full hearts)
    -- Convert max containers to half-heart units to match GetHearts() units
    local maxHalfHearts = player:GetMaxHearts() * 2
    local currentHalfHearts = player:GetHearts()

    -- Only refill if the character has red heart containers
    if maxHalfHearts > 0 and currentHalfHearts < maxHalfHearts then
        player:AddHearts(maxHalfHearts - currentHalfHearts)
    end

    -- ---- Soul Heart Buffer (absorbs all incoming damage) ----
    -- Keep max soul hearts at all times so the player is effectively unkillable
    local soulHearts = player:GetSoulHearts()
    if soulHearts < MAX_SOUL_HEARTS then
        player:AddSoulHearts(MAX_SOUL_HEARTS - soulHearts)
    end
end

-- =============================================================================
-- Register the callback
-- =============================================================================
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)

-- =============================================================================
-- Mod loaded successfully
-- =============================================================================
Isaac.DebugString("Infinite Resources mod loaded! Enjoy infinite everything.")
