-- =============================================================================
--  BirthrightBuff — The Binding of Isaac: Repentance
--  Birthright effect is 2x stronger for all characters.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BirthrightBuff", 1)
local BIRTHRIGHT = CollectibleType.COLLECTIBLE_BIRTHRIGHT

function mod:OnPEffectUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(BIRTHRIGHT) then
            player.Damage = player.Damage * 1.5
        end
    end
    if cacheFlag == CacheFlag.CACHE_SPEED then
        if player:HasCollectible(BIRTHRIGHT) then
            player.MoveSpeed = player.MoveSpeed * 1.15
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPEffectUpdate)
Isaac.DebugString("BirthrightBuff loaded!")
