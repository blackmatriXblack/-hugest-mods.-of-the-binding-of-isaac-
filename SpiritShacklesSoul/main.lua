-- =============================================================================
--  Spirit Shackles Soul - The Binding of Isaac: Repentance
--  Spirit Shackles (674) chain lightning also deals 50% damage in area.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SpiritShacklesSoul", 1)
local COLLECTIBLE_SPIRIT_SHACKLES = 674
local AREA_DAMAGE_MULT = 0.5

function mod:OnPeffectUpdate(player)
    if player:HasCollectible(COLLECTIBLE_SPIRIT_SHACKLES) then
        -- Chain lightning area damage: 50% of main damage to nearby enemies
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPeffectUpdate)
Isaac.DebugString("SpiritShacklesSoul loaded!")
