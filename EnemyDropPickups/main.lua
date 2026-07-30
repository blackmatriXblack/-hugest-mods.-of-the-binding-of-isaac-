-- =============================================================================
--  Enemy Drop Pickups - The Binding of Isaac: Repentance
--  Every enemy killed drops a random pickup!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("EnemyDropPickups", 1)

function mod:onNpcDeath(npc)
    if not npc:IsVulnerableEnemy() then return end

    local pos = npc.Position
    local rng = npc:GetDropRNG()
    local roll = rng:RandomInt(100)

    -- Drop a random pickup with fun distribution
    if roll < 25 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos, Vector.Zero, nil)
    elseif roll < 45 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, pos, Vector.Zero, nil)
    elseif roll < 60 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, pos, Vector.Zero, nil)
    elseif roll < 75 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, pos, Vector.Zero, nil)
    elseif roll < 85 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0, pos, Vector.Zero, nil)
    elseif roll < 92 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, pos, Vector.Zero, nil)
    elseif roll < 97 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, pos, Vector.Zero, nil)
    else
        -- Rare drop: trinket
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, pos, Vector.Zero, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNpcDeath)
Isaac.DebugString("EnemyDropPickups loaded!")
