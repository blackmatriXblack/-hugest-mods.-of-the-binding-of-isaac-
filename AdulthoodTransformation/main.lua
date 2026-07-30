-- =============================================================================
--  AdulthoodTransformation - The Binding of Isaac: Repentance
--  Adult (Stompy) transformation deals stomp damage to ALL enemies in room when entering
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AdulthoodTransformation", 1)

local adultItems = {
    CollectibleType.COLLECTIBLE_GROWTH_HORMONES,
    CollectibleType.COLLECTIBLE_STEROIDS,
    CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE,
    CollectibleType.COLLECTIBLE_STEVEN,
    CollectibleType.COLLECTIBLE_LEO,
}

local function isAdult(player)
    local count = 0
    for _, id in ipairs(adultItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    return count >= 3
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not isAdult(player) then goto continue end

        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() then
                ent:TakeDamage(40.0 + player.Damage * 2, DamageFlag.DAMAGE_CRUSH, EntityRef(player), 0)
            end
        end
        ::continue::
    end
end)

Isaac.DebugString("AdulthoodTransformation loaded!")
