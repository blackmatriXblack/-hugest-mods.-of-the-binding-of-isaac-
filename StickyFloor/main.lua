-- ==========================================================================
--  Sticky Floor - The Binding of Isaac: Repentance
--  Player moves 50% slower but fires tears 50% faster as tradeoff
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("StickyFloor", 1)
local game = Game()
local SPEED_MULT = 0.5
local TEARS_MULT = 1.5

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    -- Apply speed reduction
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)

    -- Sticky visual effect on feet
    player:SetColor(Color(0.6, 0.4, 0.2, 1, 0, 0, 0), -1, 1, false, false)

    -- Spawn sticky creep traps at player feet occasionally
    if math.random() < 0.1 then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BROWN,
            0, player.Position, Vector.Zero, nil)
    end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed * SPEED_MULT
    end
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = math.max(1, player.MaxFireDelay / TEARS_MULT)
    end
end)

Isaac.DebugString("Sticky Floor loaded!")
