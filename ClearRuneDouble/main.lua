-- ==========================================================================
--  Clear Rune Double - The Binding of Isaac: Repentance
--  Clear Rune copies the effect of held card/pill AND the pocket item
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ClearRuneDouble", 1)
local game = Game()

local CLEAR_RUNE = CollectibleType.COLLECTIBLE_CLEAR_RUNE

function mod:onUseItem(itemType, rng, player)
    if itemType ~= CLEAR_RUNE then return end

    -- Clear Rune normally copies only pill/card; also copy pocket active item
    local pocketItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
    if pocketItem ~= CollectibleType.COLLECTIBLE_NULL
        and pocketItem ~= CLEAR_RUNE then
        -- Trigger the pocket active item effect
        player:UseActiveItem(pocketItem, false, false)
        Isaac.DebugString("ClearRuneDouble: copied pocket item " ..
            tostring(pocketItem))
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, CLEAR_RUNE)
Isaac.DebugString("ClearRuneDouble loaded!")
