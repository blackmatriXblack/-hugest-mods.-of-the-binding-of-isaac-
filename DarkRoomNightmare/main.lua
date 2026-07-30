-- =============================================================================
--  DarkRoomNightmare - The Binding of Isaac: Repentance
--  Dark Room enemies have 2x HP but drop double the amount of pickups on death
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DarkRoomNightmare", 1)

local function IsDarkRoom()
    local level = Game():GetLevel()
    return level:GetStage() == LevelStage.STAGE9
end

-- Track which enemies have been doubled so we don't double twice
local doubledEnemies = {}

local function OnEntitySpawn(entity)
    if not IsDarkRoom() then return end
    if not entity:IsVulnerableEnemy() then return end
    if doubledEnemies[GetPtrHash(entity)] then return end

    -- Mark as doubled and boost HP
    doubledEnemies[GetPtrHash(entity)] = true
    entity:AddEntityFlags(EntityFlag.FLAG_DOUBLE_DROPS)
    entity.MaxHitPoints = entity.MaxHitPoints * 2
    entity.HitPoints = entity.MaxHitPoints
end

local function OnNpcDeath(npc)
    if not IsDarkRoom() then return end
    if not npc:IsVulnerableEnemy() then return end

    -- Double pickups: spawn a second copy of whatever drops
    local dropVariants = {
        {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL},
        {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY},
        {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL},
        {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL},
    }

    -- 50% chance to drop a bonus pickup
    if math.random(1, 100) <= 50 then
        local drop = dropVariants[math.random(1, #dropVariants)]
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            drop[1],
            drop[2],
            Vector(npc.Position.X + math.random(-15, 15), npc.Position.Y + math.random(-15, 15)),
            Vector(math.random(-2, 2), math.random(-3, 0)),
            nil
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, OnEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, OnNpcDeath)
Isaac.DebugString("DarkRoomNightmare loaded!")
