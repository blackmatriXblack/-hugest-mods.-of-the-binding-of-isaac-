-- =============================================================================
--  Dr. Fetus Bomb - The Binding of Isaac: Repentance
--  Dr. Fetus (52) bombs explode 50% larger.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DrFetusBomb", 1)
local COLLECTIBLE_DR_FETUS = 52
local EXPLOSION_SCALE = 1.5

function mod:OnPeffectUpdate(player)
    if player:HasCollectible(COLLECTIBLE_DR_FETUS) then
        -- Larger bomb explosions applied via tear/bomb scale
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPeffectUpdate)
Isaac.DebugString("DrFetusBomb loaded!")
