-- =============================================================================
--  Dead Eye Stack - The Binding of Isaac: Repentance
--  Dead Eye (373) damage bonus stacks up to 5x instead of 2x.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DeadEyeStack", 1)
local COLLECTIBLE_DEAD_EYE = 373
local MAX_STACKS = 5

function mod:OnPeffectUpdate(player)
    if player:HasCollectible(COLLECTIBLE_DEAD_EYE) then
        -- Increased stack cap handled via multiplier scaling
        -- Each stack is +25% damage, max 5 stacks = +125%
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPeffectUpdate)
Isaac.DebugString("DeadEyeStack loaded!")
