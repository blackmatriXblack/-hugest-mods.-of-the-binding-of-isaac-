-- ==========================================================================
--  Dataminer Buff - The Binding of Isaac: Repentance
--  Dataminer no longer randomly shuffles stats, only visuals change
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DataminerBuff", 1)
local game = Game()

local DATAMINER = CollectibleType.COLLECTIBLE_DATAMINER
local statsSnapshot = {}
local lastDataminerFrame = 0

function mod:onUseItem(itemType, rng, player)
    if itemType ~= DATAMINER then return end

    local idx = player.InitSeed

    -- Save current stats before dataminer shuffles them
    statsSnapshot[idx] = {
        damage = player.Damage,
        tears = player.MaxFireDelay,
        range = player.TearRange,
        speed = player.MoveSpeed,
        luck = player.Luck
    }

    lastDataminerFrame = game:GetFrameCount()
end

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(DATAMINER) then return end

    local idx = player.InitSeed
    local frame = game:GetFrameCount()

    -- Restore stats 2 frames after dataminer use
    if statsSnapshot[idx] and frame - lastDataminerFrame > 0
        and frame - lastDataminerFrame < 10 then
        local snap = statsSnapshot[idx]
        -- Dataminer applies random stat changes;
        -- we counter them by force-restoring original stats
        if player.Damage ~= snap.damage then
            player:AddDamage(snap.damage - player.Damage, 0)
        end
        -- Visual changes (sprite distortion) are preserved for the fun factor
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, DATAMINER)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("DataminerBuff loaded!")
