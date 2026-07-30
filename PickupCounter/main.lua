-- =============================================================================
--  PickupCounter - The Binding of Isaac: Repentance
--  Total pickups collected this run displayed as icons with counts
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PickupCounter", 1)
local pickups = {coins = 0, bombs = 0, keys = 0, hearts = 0, cards = 0, pills = 0, runes = 0, batteries = 0}

function mod:onPickupCollision(pickup, collider, low)
    if collider and collider:ToPlayer() then
        local variant = pickup.Variant
        if variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_LIL_BATTERY
           or variant == PickupVariant.PICKUP_DOUBLEPACK or variant == PickupVariant.PICKUP_STICKY_NICKEL
           or variant == PickupVariant.PICKUP_DIME or variant == PickupVariant.PICKUP_NICKEL
           or variant == PickupVariant.PICKUP_LUCKY_PENNY or variant == PickupVariant.PICKUP_GOLDEN_PENNY then
            pickups.coins = pickups.coins + 1
        elseif variant == PickupVariant.PICKUP_BOMB or variant == PickupVariant.PICKUP_BOMB_CHEST
               or variant == PickupVariant.PICKUP_BOMB_GIGA or variant == PickupVariant.PICKUP_BOMB_GOLDEN
               or variant == PickupVariant.PICKUP_BOMB_GOLDEN_TROLL or variant == PickupVariant.PICKUP_BOMB_TROLL then
            pickups.bombs = pickups.bombs + 1
        elseif variant == PickupVariant.PICKUP_KEY or variant == PickupVariant.PICKUP_KEY_DOUBLEPACK
               or variant == PickupVariant.PICKUP_KEY_GOLDEN or variant == PickupVariant.PICKUP_KEY_CHARGED
               or variant == PickupVariant.PICKUP_KEY_RING then
            pickups.keys = pickups.keys + 1
        elseif variant == PickupVariant.PICKUP_HEART or variant == PickupVariant.PICKUP_HEART_FULL
               or variant == PickupVariant.PICKUP_HEART_HALF or variant == PickupVariant.PICKUP_HEART_DOUBLEPACK
               or variant == PickupVariant.PICKUP_HEART_BLACK or variant == PickupVariant.PICKUP_HEART_ETERNAL
               or variant == PickupVariant.PICKUP_HEART_GOLDEN or variant == PickupVariant.PICKUP_HEART_SOUL
               or variant == PickupVariant.PICKUP_HEART_SCARED or variant == PickupVariant.PICKUP_HEART_BLENDED
               or variant == PickupVariant.PICKUP_HEART_BONE then
            pickups.hearts = pickups.hearts + 1
        elseif variant == PickupVariant.PICKUP_TAROTCARD then
            pickups.cards = pickups.cards + 1
        elseif variant == PickupVariant.PICKUP_PILL then
            pickups.pills = pickups.pills + 1
        elseif variant == PickupVariant.PICKUP_RUNE then
            pickups.runes = pickups.runes + 1
        elseif variant == PickupVariant.PICKUP_LIL_BATTERY or variant == PickupVariant.PICKUP_BATTERY then
            pickups.batteries = pickups.batteries + 1
        end
    end
end

function mod:onRender()
    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.755
    local y = sh * 0.018

    Isaac.RenderScaledText("Pickups", x, y, 0.8, 0.8, 1, 0.8, 0.3, 1)

    local entries = {
        {label = "c", count = pickups.coins, r = 1, g = 0.85, b = 0.2},
        {label = "B", count = pickups.bombs, r = 0.6, g = 0.6, b = 0.6},
        {label = "K", count = pickups.keys, r = 1, g = 0.85, b = 0.2},
        {label = "H", count = pickups.hearts, r = 1, g = 0.2, b = 0.2},
        {label = "C", count = pickups.cards, r = 0.5, g = 0.7, b = 1},
        {label = "P", count = pickups.pills, r = 0.3, g = 1, b = 0.5},
        {label = "R", count = pickups.runes, r = 0.7, g = 0.3, b = 1},
        {label = "E", count = pickups.batteries, r = 1, g = 1, b = 0.3},
    }

    for i, entry in ipairs(entries) do
        if entry.count > 0 then
            local row = i - 1
            Isaac.RenderScaledText(
                string.format("%s:%d", entry.label, entry.count),
                x, y + 14 + row * 15, 0.7, 0.7, entry.r, entry.g, entry.b, 1
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.onPickupCollision)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("PickupCounter loaded!")
