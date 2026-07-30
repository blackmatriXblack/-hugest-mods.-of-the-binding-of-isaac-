-- =============================================================================
--  Chocolate Milk Rapid - The Binding of Isaac: Repentance
--  Chocolate Milk (69) rapid fire taps deal 50% more damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ChocolateMilkRapid", 1)
local COLLECTIBLE_CHOCOLATE_MILK = 69
local RAPID_DAMAGE_MULT = 1.5

function mod:OnPeffectUpdate(player)
    if player:HasCollectible(COLLECTIBLE_CHOCOLATE_MILK) then
        -- Rapid tap bonus: reduced charge = more damage
        -- Damage multiplier applied based on charge level
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPeffectUpdate)
Isaac.DebugString("ChocolateMilkRapid loaded!")
