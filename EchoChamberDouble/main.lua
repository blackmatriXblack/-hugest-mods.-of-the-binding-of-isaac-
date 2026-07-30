-- ==========================================================================
--  Echo Chamber Double - The Binding of Isaac: Repentance
--  Echo Chamber has 2x chance to duplicate card/pill effects
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EchoChamberDouble", 1)
local game = Game()

local ECHO_CHAMBER = CollectibleType.COLLECTIBLE_ECHO_CHAMBER
local lastCard = -1
local lastCardFrame = 0
local lastPill = -1
local lastPillFrame = 0

function mod:onUseCard(cardType, player)
    if not player:HasCollectible(ECHO_CHAMBER) then return end
    local rng = player:GetCollectibleRNG(ECHO_CHAMBER)
    if rng:RandomFloat() < 0.66 then
        local frame = game:GetFrameCount()
        if lastCard ~= cardType or frame - lastCardFrame > 2 then
            lastCard = cardType
            lastCardFrame = frame
            player:UseCard(cardType)
        end
    end
end

function mod:onUsePill(pillEffect, player, pillColor)
    if not player:HasCollectible(ECHO_CHAMBER) then return end
    local rng = player:GetCollectibleRNG(ECHO_CHAMBER)
    if rng:RandomFloat() < 0.66 then
        local frame = game:GetFrameCount()
        if lastPill ~= pillEffect or frame - lastPillFrame > 2 then
            lastPill = pillEffect
            lastPillFrame = frame
            player:UsePill(pillEffect, pillColor)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.onUseCard)
mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.onUsePill)
Isaac.DebugString("EchoChamberDouble loaded!")
