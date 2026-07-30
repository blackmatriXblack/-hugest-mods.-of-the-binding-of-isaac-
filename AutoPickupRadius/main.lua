-- =============================================================================
--  AUTO PICKUP RADIUS — The Binding of Isaac: Repentance
--  Coins within 250 radius are automatically teleported to the player and collected.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AutoPickupRadius", 1)
local PICKUP_RADIUS = 250

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if player == nil then return end

    local entities = Isaac.GetRoomEntities()
    if entities == nil then return end

    for _, entity in ipairs(entities) do
        if entity.Type == 20 then
            local dist = player.Position:Distance(entity.Position)
            if dist <= PICKUP_RADIUS then
                entity.Position = player.Position
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("Auto Pickup Radius loaded!")
