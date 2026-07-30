-- Remove Magic Mushroom (ID 12) from all pools each floor
local mod = RegisterMod("PoolItemRemover", 1)
local game = Game()

function mod:onNewLevel()
    local itemPool = game:GetItemPool()
    if itemPool then
        itemPool:RemoveCollectible(12)
        Isaac.DebugString("PoolItemRemover: Removed Magic Mushroom (12) from pools.")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
Isaac.DebugString("PoolItemRemover loaded! Removes Magic Mushroom from all pools each floor.")
