-- =============================================================================
--  Mom's Knife Return - The Binding of Isaac: Repentance
--  Mom's Knife (114) returns to player 2x faster.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MomsKnifeReturn", 1)
local COLLECTIBLE_MOMS_KNIFE = 114

function mod:OnKnifeUpdate(knife)
    local player = knife.SpawnerEntity
    if player and player:ToPlayer() then
        if player:ToPlayer():HasCollectible(COLLECTIBLE_MOMS_KNIFE) then
            -- Boost return velocity by 2x
            knife.Velocity = knife.Velocity * 2
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.OnKnifeUpdate)
Isaac.DebugString("MomsKnifeReturn loaded!")
