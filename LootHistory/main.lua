-- =============================================================================
--  LootHistory - The Binding of Isaac: Repentance
--  Show a scrolling list of last 5 items and pickups collected
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LootHistory", 1)

local MAX_HISTORY = 5
local lootHistory = {}

function mod:onPickupCollision(pickup, collider, low)
    if collider and collider:ToPlayer() then
        local name = ""
        local r, g, b = 0.7, 0.7, 0.7
        local subtype = pickup.SubType

        if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local cfg = Isaac.GetItemConfig():GetCollectible(subtype)
            if cfg then
                name = cfg.Name or "Item"
                r, g, b = 1, 0.9, 0.3 -- Gold for items
            end
        elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
            local cfg = Isaac.GetItemConfig():GetTrinket(subtype)
            if cfg then
                name = cfg.Name or "Trinket"
                r, g, b = 1, 0.5, 0.5 -- Pink for trinkets
            end
        elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then
            local cfg = Isaac.GetItemConfig():GetCard(subtype)
            if cfg then
                name = cfg.Name or "Card"
            end
            r, g, b = 0.5, 0.7, 1 -- Blue for cards
        elseif pickup.Variant == PickupVariant.PICKUP_PILL then
            local pillColor = pickup:GetPillColor()
            name = "Pill"
            r, g, b = 0.3, 1, 0.5 -- Green for pills
        elseif pickup.Variant == PickupVariant.PICKUP_HEART then
            name = "Heart"
            r, g, b = 1, 0.3, 0.3 -- Red for hearts
        elseif pickup.Variant == PickupVariant.PICKUP_COIN then
            name = "Coin"
            r, g, b = 1, 0.85, 0.2
        elseif pickup.Variant == PickupVariant.PICKUP_KEY then
            name = "Key"
            r, g, b = 0.85, 0.75, 0.2
        elseif pickup.Variant == PickupVariant.PICKUP_BOMB then
            name = "Bomb"
            r, g, b = 0.6, 0.6, 0.6
        elseif pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY then
            name = "Battery"
            r, g, b = 0.4, 1, 0.3
        else
            return
        end

        if name ~= "" then
            table.insert(lootHistory, 1, {
                name = name,
                r = r, g = g, b = b,
                frame = Game():GetFrameCount()
            })
            if #lootHistory > MAX_HISTORY then
                table.remove(lootHistory)
            end
        end
    end
end

function mod:onRender()
    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.755
    local y = sh * 0.28
    local now = Game():GetFrameCount()

    Isaac.RenderScaledText("Loot History", x, y, 0.8, 0.8, 0.8, 0.6, 1, 1)

    for i, loot in ipairs(lootHistory) do
        local age = now - loot.frame
        local alpha = 1.0
        local fadeStart = 300 -- items fade after 10 seconds
        if age > fadeStart then
            alpha = math.max(0, 1.0 - (age - fadeStart) / 60)
        end
        if alpha > 0 then
            local row = i - 1
            Isaac.RenderScaledText(
                loot.name,
                x, y + 16 + row * 16, 0.7, 0.7, loot.r, loot.g, loot.b, alpha
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.onPickupCollision)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("LootHistory loaded!")
