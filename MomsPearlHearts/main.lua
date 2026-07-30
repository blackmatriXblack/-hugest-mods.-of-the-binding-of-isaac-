-- =============================================================================
--  MomsPearlHearts - The Binding of Isaac: Repentance
--  Mom's Pearl trinket grants +1 soul heart on pickup
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MomsPearlHearts", 1)
local TRINKET_MOMS_PEARL = 13

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_MOMS_PEARL) then return end

    local data = player:GetData()
    if not data.mpGranted then
        data.mpGranted = true
        player:AddSoulHearts(2)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("MomsPearlHearts loaded!")
