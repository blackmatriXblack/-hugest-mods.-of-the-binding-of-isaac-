-- ==========================================================================
--  Urn of Souls Overflow - The Binding of Isaac: Repentance
--  Urn of Souls can store 2x the soul charges
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("UrnOfSoulsOverflow", 1)
local game = Game()

local URN = CollectibleType.COLLECTIBLE_URN_OF_SOULS
local MAX_BOOSTED = 40

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(URN) then return end
    for slot = 0, 3 do
        if player:GetActiveItem(slot) == URN then
            local charge = player:GetActiveCharge(slot)
            if charge > 0 then
                Isaac.RenderText("Souls: " .. math.floor(charge) .. "/" .. MAX_BOOSTED,
                    50, 90, 1, 0.5, 0.5, 1, 0.8)
            end
            break
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("UrnOfSoulsOverflow loaded!")
