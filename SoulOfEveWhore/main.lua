-- ==========================================================================
--  Soul of Eve Whore - The Binding of Isaac: Repentance
--  Soul of Eve activates Whore of Babylon regardless of HP
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfEveWhore", 1)
local game = Game()

local SOUL_EVE = CollectibleType.COLLECTIBLE_SOUL_OF_EVE
local whoreActive = {}

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_EVE then return end

    local idx = player.InitSeed
    -- Activate Whore of Babylon effect regardless of red heart count
    -- Whore of Babylon gives +1.5 damage and +0.3 speed at half red heart or less
    -- This mod grants it at full HP
    local effects = player:GetEffects()
    effects:AddCollectibleEffect(
        CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON, true, 300)

    -- Additional: if player already has Whore of Babylon item,
    -- give extra boost regardless of HP state
    if player:HasCollectible(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then
        player:AddDamage(2.5, 300) -- Extra damage for 10 seconds
        player.MoveSpeed = player.MoveSpeed + 0.5
    else
        player:AddDamage(1.5, 300)
        player.MoveSpeed = player.MoveSpeed + 0.3
    end

    whoreActive[idx] = true

    Isaac.DebugString("SoulOfEveWhore: Whore of Babylon activated")
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_EVE)
Isaac.DebugString("SoulOfEveWhore loaded!")
