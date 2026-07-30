-- =============================================================================
--  BanItemsHotkey - The Binding of Isaac: Repentance
--  Press a key to ban the nearest item pedestal from ever appearing again
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BanItemsHotkey", 1)
local game = Game()
local bannedItems = {}
local banCooldown = 0
local BAN_KEY = Keyboard.KEY_B     -- Press 'B' to ban
local COOLDOWN_FRAMES = 30

-- Load banned items from save data
function mod:loadBannedItems()
    if mod.SaveData and mod.SaveData.bannedItems then
        bannedItems = mod.SaveData.bannedItems
    end
end

function mod:onGameStart()
    mod:loadBannedItems()
end

function mod:onPostUpdate()
    -- Cooldown management
    if banCooldown > 0 then
        banCooldown = banCooldown - 1
        return
    end

    -- Check if ban key is pressed
    local keyboardInput = Input.IsButtonTriggered(BAN_KEY, 0)
    if not keyboardInput then return end

    local player = Isaac.GetPlayer(0)
    if not player or not player:Exists() then return end

    -- Find nearest item pedestal
    local nearestPedestal = nil
    local nearestDist = 999999

    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_PICKUP
        and ent.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local dist = player.Position:Distance(ent.Position)
            if dist < nearestDist and dist < 150 then -- Within range
                nearestDist = dist
                nearestPedestal = ent
            end
        end
    end

    if nearestPedestal then
        local itemId = nearestPedestal.SubType
        local itemConfig = Isaac.GetItemConfig():GetCollectible(itemId)
        local itemName = itemConfig and itemConfig.Name or "Unknown Item"

        -- Ban the item
        bannedItems[itemId] = (bannedItems[itemId] or 0) + 1
        banCooldown = COOLDOWN_FRAMES

        -- Remove the pedestal with a visual effect
        nearestPedestal:Remove()

        -- Save banned items
        if not mod.SaveData then mod.SaveData = {} end
        mod.SaveData.bannedItems = bannedItems

        Isaac.DebugString("BanItems: BANNED " .. itemName .. " (#" .. tostring(itemId) .. ")")
    end
end

function mod:onPostRender()
    -- Display the ban key hint
    Isaac.RenderText(
        "[B] to BAN nearest item",
        8, 340,
        0.9, 0.2, 0.2, 0.7
    )

    -- Show banned item count
    local banCount = 0
    for _ in pairs(bannedItems) do
        banCount = banCount + 1
    end
    Isaac.RenderText(
        "Banned: " .. tostring(banCount) .. " items",
        8, 354,
        0.6, 0.6, 0.6, 0.6
    )

    -- Show cooldown indicator
    if banCooldown > 0 then
        local cdPercent = banCooldown / COOLDOWN_FRAMES
        Isaac.RenderText(
            "Cooldown: " .. string.format("%.1f", banCooldown / 30) .. "s",
            8, 368,
            0.8, 0.5, 0.0, cdPercent
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onPostUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)

Isaac.DebugString("BanItemsHotkey loaded! Press B to ban the nearest item.")
