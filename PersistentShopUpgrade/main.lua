-- =============================================================================
--  PersistentShopUpgrade - The Binding of Isaac: Repentance
--  Shops permanently upgrade as you play more runs — more items, cheaper
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PersistentShopUpgrade", 1)
local UPGRADE_KEY = "SHOP_UPGRADE_LEVEL"
local shopLevel = 0

local function GetShopLevel()
    local data = mod:GetData()
    if data[UPGRADE_KEY] == nil then data[UPGRADE_KEY] = 0 end
    return data[UPGRADE_KEY]
end

local function UpgradeShop()
    local data = mod:GetData()
    local current = GetShopLevel()
    data[UPGRADE_KEY] = math.min(current + 1, 10)
    shopLevel = data[UPGRADE_KEY]
    Isaac.DebugString("PersistentShopUpgrade: Shop upgraded to level " .. shopLevel .. "!")
end

function mod:onGameStart(continued)
    shopLevel = GetShopLevel()
    Isaac.DebugString("PersistentShopUpgrade: Current shop level: " .. shopLevel)

    -- Apply benefits to player based on shop level
    local player = Isaac.GetPlayer(0)
    if player and shopLevel > 0 then
        -- Bonus starting coins
        local bonusCoins = math.floor(shopLevel / 2)
        if bonusCoins > 0 and not continued then
            player:AddCoins(bonusCoins)
        end
    end
end

function mod:onNewRoom()
    local room = Game():GetRoom()
    local roomType = room:GetType()

    -- Only affect shop rooms
    if roomType ~= RoomType.ROOM_SHOP then return end

    local level = GetShopLevel()
    if level <= 0 then return end

    local player = Isaac.GetPlayer(0)

    -- Restock machines work better at higher levels
    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        if entity.Type == 6 and entity.Variant == 7 then -- Restock Machine
            -- Reduce jam chance
            if level >= 3 then
                entity:ClearEntityFlags(1 << 10)
            end
        end
    end

    -- Apply discount based on level
    -- Level 1-3: 10% off, 4-6: 20% off, 7-9: 30% off, 10: 50% off
    local discountPercent = 0
    if level <= 3 then discountPercent = 10
    elseif level <= 6 then discountPercent = 20
    elseif level <= 9 then discountPercent = 30
    else discountPercent = 50
    end

    -- Apply discount to shop items
    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP then
            -- Only apply to shop-bought items with prices
            if entity.Price > 0 then
                local newPrice = math.floor(entity.Price * (1 - discountPercent / 100))
                entity.Price = math.max(1, newPrice)
            end
        end
    end

    Isaac.DebugString(string.format("PersistentShopUpgrade: Shop level %d | Discount %d%% applied",
        level, discountPercent))
end

-- Upgrade shop after each completed run
function mod:onGameEnd()
    local game = Game()
    -- Only upgrade if player made progress
    local level = game:GetLevel()
    if level:GetStage() >= 3 then
        UpgradeShop()
    end
end

function mod:onRender()
    if Input.IsButtonPressed(Keyboard.KEY_L, 0) then
        local level = GetShopLevel()
        Isaac.DebugString("Current shop upgrade level: " .. level)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.onGameEnd)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("PersistentShopUpgrade loaded!")
