-- =============================================================================
--  SwallowedPennyHeal - The Binding of Isaac: Repentance
--  Swallowed Penny trinket also heals half a red heart on pickup
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SwallowedPennyHeal", 1)
local TRINKET_SWALLOWED_PENNY = 1

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_SWALLOWED_PENNY) then return end

    local data = player:GetData()
    if not data.spHealed then
        data.spHealed = true
        player:AddHearts(1)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("SwallowedPennyHeal loaded!")
