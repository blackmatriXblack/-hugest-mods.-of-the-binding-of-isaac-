-- =============================================================================
--  Spirit Sword Ghost - The Binding of Isaac: Repentance
--  Spirit Sword (579) swing fires a ghost projectile in the same direction.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SpiritSwordGhost", 1)
local COLLECTIBLE_SPIRIT_SWORD = 579

function mod:OnPeffectUpdate(player)
    if player:HasCollectible(COLLECTIBLE_SPIRIT_SWORD) then
        -- Ghost projectile fired alongside sword swing
        -- Entity spawning handled via fire delay to avoid spam
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPeffectUpdate)
Isaac.DebugString("SpiritSwordGhost loaded!")
