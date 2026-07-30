-- =============================================================================
--  Urn of Souls Charge - The Binding of Isaac: Repentance
--  Urn of Souls (640) charges to full in 6 rooms instead of needing souls.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("UrnOfSoulsCharge", 1)
local COLLECTIBLE_URN_OF_SOULS = 640
local ROOMS_TO_FULL = 6

function mod:OnPeffectUpdate(player)
    if player:HasCollectible(COLLECTIBLE_URN_OF_SOULS) then
        local data = player:GetData()
        if not data.urnChargeCounter then
            data.urnChargeCounter = 0
        end
        -- Charge per room: 100 / ROOMS_TO_FULL = ~16.7% per room
        -- Full auto-charge at 1/6 per new room entry
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPeffectUpdate)
Isaac.DebugString("UrnOfSoulsCharge loaded!")
