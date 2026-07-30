-- =============================================================================
--  PICKUP MULTIPLIER — The Binding of Isaac: Repentance
--  Auto-collects ALL pickup types within 150 radius of the player.
--  Teleports pickups to the player to trigger collection.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PickupMultiplier", 1)
local PICKUP_RADIUS = 150

local function isPickupEntity(entity)
    return entity.Type == 5 -- ENTITY_PICKUP = 5
end

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if player == nil then return end

    local entities = Isaac.GetRoomEntities()
    if entities == nil then return end

    for _, entity in ipairs(entities) do
        if isPickupEntity(entity) then
            local dist = player.Position:Distance(entity.Position)
            if dist <= PICKUP_RADIUS then
                -- Teleport to player to trigger automatic collection
                entity.Position = player.Position
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("Pickup Multiplier loaded!")
