-- =============================================================================
--  ClosetRoomBonus - The Binding of Isaac: Repentance
--  Small closet rooms always contain either a trinket or a card pickup for the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ClosetRoomBonus", 1)

local function IsClosetRoom()
    local room = Game():GetRoom()
    local shape = room:GetRoomShape()

    -- Closets are the smallest room shapes (shape 1 = 1x1, shape 10 = narrow horizontal/vertical)
    -- Check dimensions: closets are typically 1x1, 1x0.5, or 0.5x1
    return shape == RoomShape.ROOMSHAPE_1x1
        or shape == RoomShape.ROOMSHAPE_1x05V
        or shape == RoomShape.ROOMSHAPE_05x1H
        or shape == RoomShape.ROOMSHAPE_1x05_UD
end

local function SpawnClosetBonus()
    if not IsClosetRoom() then return end

    local room = Game():GetRoom()
    local center = room:GetCenterPos()
    local rng = RNG()
    rng:SetSeed(room:GetAwardSeed(), 0)

    -- 50% trinket, 50% card/rune
    if rng:RandomInt(2) == 0 then
        -- Spawn a random trinket
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TRINKET,
            0,
            Vector(center.X, center.Y - 10),
            Vector.Zero,
            nil
        )
    else
        -- Spawn a consumable card or rune
        local cardType = rng:RandomInt(2)
        if cardType == 0 then
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TAROTCARD,
                Card.CARD_FOOL, -- Will be randomized by the game
                Vector(center.X, center.Y - 10),
                Vector.Zero,
                nil
            )
        else
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_RUNE,
                0,
                Vector(center.X, center.Y - 10),
                Vector.Zero,
                nil
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SpawnClosetBonus)
Isaac.DebugString("ClosetRoomBonus loaded!")
