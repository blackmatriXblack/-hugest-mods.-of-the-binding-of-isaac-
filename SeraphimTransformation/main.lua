-- =============================================================================
--  SeraphimTransformation - The Binding of Isaac: Repentance
--  Seraphim transformation adds +2 soul hearts on transform and periodic holy light beams
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SeraphimTransformation", 1)
local hasGrantedHearts = {}

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local idx = player.InitSeed
    if player:GetPlayerType() == PlayerType.PLAYER_SAMSON then
        -- Seraphim uses a specific PlayerType; check via player:GetEffects()
        -- Using a simpler detection: 3+ angel/devil items
    end
end)

-- Simplified: Check if player has Seraphim transform via 3+ relevant items
local seraphimItems = {
    CollectibleType.COLLECTIBLE_THE_HALO,
    CollectibleType.COLLECTIBLE_SACRED_HEART,
    CollectibleType.COLLECTIBLE_HOLY_MANTLE,
    CollectibleType.COLLECTIBLE_DEAD_DOVE,
    CollectibleType.COLLECTIBLE_GODHEAD,
    CollectibleType.COLLECTIBLE_HOLY_LIGHT,
    CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
    CollectibleType.COLLECTIBLE_CELTIC_CROSS,
    CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL,
    CollectibleType.COLLECTIBLE_SWORN_PROTECTOR,
}

local function isSeraphim(player)
    local count = 0
    for _, id in ipairs(seraphimItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    return count >= 3
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local idx = GetPtrHash(player)
    if not isSeraphim(player) then
        hasGrantedHearts[idx] = nil
        return
    end
    if not hasGrantedHearts[idx] then
        player:AddSoulHearts(4)
        hasGrantedHearts[idx] = true
    end
    -- Periodic holy light: every 300 frames (~10 sec), fire a holy beam
    local frame = game:GetFrameCount()
    if frame % 300 == 0 then
        local room = game:GetRoom()
        local enemies = Isaac.GetRoomEntities()
        for _, ent in ipairs(enemies) do
            if ent:IsActiveEnemy() then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
                    ent.Position, Vector(0, 0), player)
                break
            end
        end
    end
end)

Isaac.DebugString("SeraphimTransformation loaded!")
