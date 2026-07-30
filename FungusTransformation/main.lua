-- =============================================================================
--  FungusTransformation - The Binding of Isaac: Repentance
--  Fun Guy transformation drops a mushroom pickup per room clear
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FungusTransformation", 1)

local fungusItems = {
    CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
    CollectibleType.COLLECTIBLE_MINI_MUSH,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE,
    CollectibleType.COLLECTIBLE_BLUE_CAP,
    CollectibleType.COLLECTIBLE_DEAD_SEA_SCROLLS,
}

local mushroomPickups = {
    CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
    CollectibleType.COLLECTIBLE_MINI_MUSH,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE,
    CollectibleType.COLLECTIBLE_BLUE_CAP,
}

local function isFunGuy(player)
    local count = 0
    for _, id in ipairs(fungusItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    return count >= 3
end

local roomsCleared = {}

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local room = game:GetRoom()
    if not room:IsClear() then return end

    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local idx = GetPtrHash(player)
        local roomIdx = game:GetLevel():GetCurrentRoomIndex()

        if isFunGuy(player) and roomsCleared[idx] ~= roomIdx then
            roomsCleared[idx] = roomIdx
            local pos = room:FindFreePickupSpawnPosition(player.Position, 40, true)
            local shroom = mushroomPickups[math.random(#mushroomPickups)]
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                shroom, pos, Vector(0, 0), player)
        end
    end
end)

Isaac.DebugString("FungusTransformation loaded!")
