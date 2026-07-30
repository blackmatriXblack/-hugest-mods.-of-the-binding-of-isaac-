-- ==========================================================================
--  Soul of Samson Berserk - The Binding of Isaac: Repentance
--  Soul of Samson berserk lasts 2x longer
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfSamsonBerserk", 1)
local game = Game()

local SOUL_SAMSON = CollectibleType.COLLECTIBLE_SOUL_OF_SAMSON
local berserkEndTime = {}

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_SAMSON then return end

    local idx = player.InitSeed
    -- Normal berserk lasts ~5 seconds (150 frames), double to ~10 seconds (300)
    berserkEndTime[idx] = game:GetFrameCount() + 300

    -- Re-apply bloodlust effect to extend beyond normal duration
    local effects = player:GetEffects()
    effects:AddCollectibleEffect(
        CollectibleType.COLLECTIBLE_BERSERK, false, 300)

    Isaac.DebugString("SoulOfSamsonBerserk: extended berserk to 10s")
end

function mod:onPlayerUpdate(player)
    local idx = player.InitSeed
    local endTime = berserkEndTime[idx]
    if endTime then
        local remaining = math.ceil((endTime - game:GetFrameCount()) / 30)
        if remaining > 0 then
            Isaac.RenderText("Berserk: " .. remaining .. "s",
                180, 160, 1, 0.9, 0.2, 0.1, 0.8)
        else
            berserkEndTime[idx] = nil
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_SAMSON)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("SoulOfSamsonBerserk loaded!")
