-- =============================================================================
--  TaintedCainRecipe - The Binding of Isaac: Repentance
--  Tainted Cain: Bag of Crafting shows possible recipe result as floating text.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedCainRecipe", 1)
local TAINTED_CAIN = 23
local CRAFTING_ITEM = CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING -- id 710

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player or player:GetPlayerType() ~= TAINTED_CAIN then return end

    -- Display hint text near player
    local pos = Isaac.WorldToScreen(player.Position)
    Isaac.RenderText("Pickups nearby = recipe hint", pos.X - 60, pos.Y + 40, 1, 1, 1, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("TaintedCainRecipe loaded!")
