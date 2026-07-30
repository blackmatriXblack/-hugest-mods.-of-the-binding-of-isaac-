-- Log active item usage and completion
local mod = RegisterMod("ActiveItemUseLogger", 1)
local game = Game()

function mod:onUseItem(itemId, rng, player, useFlags, activeSlot)
    Isaac.DebugString("Active item used!")
end

function mod:onPostUseItem(itemId, rng, player, useFlags, activeSlot)
    Isaac.DebugString("Active item effect complete!")
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem)
mod:AddCallback(ModCallbacks.MC_POST_USE_ITEM, mod.onPostUseItem)
Isaac.DebugString("ActiveItemUseLogger loaded! Logs active item usage and completion.")
