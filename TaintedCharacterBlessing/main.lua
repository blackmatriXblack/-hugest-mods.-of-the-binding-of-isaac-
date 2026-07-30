-- =============================================================================
--  TaintedCharacterBlessing — The Binding of Isaac: Repentance
--  All Tainted characters start with +1 damage and +0.5 speed.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedCharacterBlessing", 1)

local TAINTED_MIN = 21
local TAINTED_MAX = 37

function mod:OnPlayerInit(player)
    local pType = player:GetPlayerType()
    if pType >= TAINTED_MIN and pType <= TAINTED_MAX then
        player:AddDamage(1.0)
        player:AddShotSpeed(0.5)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.OnPlayerInit)
Isaac.DebugString("TaintedCharacterBlessing loaded!")
