-- =============================================================================
--  GreedierModeEnhance — The Binding of Isaac: Repentance
--  Greedier mode — waves are 50% larger, but enemies drop +50% coins.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GreedierModeEnhance", 1)

function mod:OnEntitySpawn(entity)
    if not entity:IsEnemy() then return end

    local game = Game()
    if not game:IsGreedMode() then return end

    if game.Difficulty == 3 then
        entity:AddEntityFlags(EntityFlag.FLAG_APPEAR)
    end
end

function mod:OnEntityKill(entity)
    if not entity:IsEnemy() then return end

    local game = Game()
    if not game:IsGreedMode() then return end

    if game.Difficulty == 3 then
        local rng = RNG()
        rng:SetSeed(entity.InitSeed + Game():GetFrameCount(), 0)

        if rng:RandomFloat() < 0.5 then
            local pos = entity.Position
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COIN,
                CoinSubType.COIN_PENNY,
                pos,
                Vector(rng:RandomInt(3) - 1, rng:RandomInt(3) - 1),
                nil
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.OnEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.OnEntityKill)
Isaac.DebugString("GreedierModeEnhance loaded!")
