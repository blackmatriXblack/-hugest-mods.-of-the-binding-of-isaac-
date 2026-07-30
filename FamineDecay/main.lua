-- =============================================================================
--  FamineDecay — The Binding of Isaac: Repentance
--  Famine (Type=23) applies permanent speed debuff stacking on hit
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FamineDecay", 1)

local FAMINE_TYPE = EntityType.ENTITY_FAMINE
local SPEED_PENALTY = -0.1
local MAX_DEBUFF = -0.8

local famineDebuff = {}

function mod:onEntityTakeDmg(target, damageAmount, damageFlag, damageSource, damageCountdownFrames)
    if not damageSource or damageSource.Type ~= EntityType.ENTITY_FAMINE then
        return
    end

    local player = target:ToPlayer()
    if not player then
        return
    end

    local idx = GetPtrHash(player)
    local currentDebuff = famineDebuff[idx] or 0
    famineDebuff[idx] = math.max(currentDebuff + SPEED_PENALTY, MAX_DEBUFF)

    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()
end

function mod:onPlayerCache(player, cacheFlag)
    if cacheFlag ~= CacheFlag.CACHE_SPEED then
        return
    end

    local idx = GetPtrHash(player)
    local debuff = famineDebuff[idx]
    if debuff then
        player.MoveSpeed = player.MoveSpeed + debuff
    end
end

function mod:onPlayerDeath(player)
    local idx = GetPtrHash(player)
    famineDebuff[idx] = nil
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg, EntityType.ENTITY_PLAYER)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onPlayerCache)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player) mod:onPlayerDeath(player) end)

Isaac.DebugString("FamineDecay loaded!")
