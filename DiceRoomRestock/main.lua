-- =============================================================================
--  DiceRoomRestock - The Binding of Isaac: Repentance
--  Dice rooms restock all floor item pedestals when the dice face is activated
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DiceRoomRestock", 1)

local diceRoomsUsed = {}  -- Track which dice rooms have been used this floor

local function IsDiceRoom()
    local room = Game():GetRoom()
    return room:GetType() == RoomType.ROOM_DICE
end

local function OnGridUpdate(grid)
    -- Check if it's a dice room grid entity (dice face)
    if grid:GetType() ~= GridEntityType.GRID_DECORATIVE then return end

    local room = Game():GetRoom()
    if room:GetType() ~= RoomType.ROOM_DICE then return end

    -- Check if the dice floor has been activated (state changed from inactive to active)
    local state = grid.State
    if state < 1 then return end  -- Not activated yet

    local roomIdx = Game():GetLevel():GetCurrentRoomIndex()
    if diceRoomsUsed[roomIdx] then return end
    diceRoomsUsed[roomIdx] = true

    -- The dice has been activated - now restock all floor items
    local level = Game():GetLevel()
    local rooms = level:GetRooms()

    for i = 0, rooms.Size - 1 do
        local roomDesc = rooms:Get(i)
        local roomObj = Game():GetRoom()

        -- Check all entities in each room for item pedestals
        local entities = Isaac.GetRoomEntities()
        if entities then
            for j = 0, entities.Size - 1 do
                local e = entities:Get(j)
                if e and e:Exists()
                   and e.Type == EntityType.ENTITY_PICKUP
                   and e.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                    -- Reroll this pedestal by removing and spawning a new one
                    local pos = e.Position
                    local subType = e.SubType

                    -- Remove old pedestal
                    e:Remove()

                    -- Spawn new random item (reroll effect)
                    local newItem = Isaac.Spawn(
                        EntityType.ENTITY_PICKUP,
                        PickupVariant.PICKUP_COLLECTIBLE,
                        0,  -- Random item from current pool
                        pos,
                        Vector.Zero,
                        nil
                    )
                end
            end
        end
    end

    -- Visual feedback
    local player = Isaac.GetPlayer(0)
    if player then
        local effect = Isaac.Spawn(
            EntityType.ENTITY_EFFECT,
            EffectVariant.DICE_FLOOR,
            0,
            player.Position,
            Vector.Zero,
            player
        )
    end
end

local function ResetDiceTracker()
    -- Reset dice room usage tracking on new floor
    diceRoomsUsed = {}
end

mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_UPDATE, OnGridUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ResetDiceTracker)
Isaac.DebugString("DiceRoomRestock loaded!")
