-- =============================================================================
--  BrokenMagnetRange - The Binding of Isaac: Repentance
--  Broken Magnet trinket attracts pickups from 2x the normal distance
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BrokenMagnetRange", 1)
local TRINKET_BROKEN_MAGNET = 34
local ATTRACT_RADIUS = 120

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_BROKEN_MAGNET) then return end

    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        if entity:IsVulnerableEnemy() == false
            and entity.Type >= EntityType.ENTITY_PICKUP
            and entity.Type <= EntityType.ENTITY_PICKUP then
            local distance = player.Position:Distance(entity.Position)
            if distance <= ATTRACT_RADIUS and distance > 5 then
                local direction = (player.Position - entity.Position):Normalized()
                entity.Velocity = entity.Velocity + direction * 3
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("BrokenMagnetRange loaded!")
