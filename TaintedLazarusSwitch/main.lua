-- =============================================================================
--  TaintedLazarusSwitch — The Binding of Isaac: Repentance
--  Tainted Lazarus auto-switches every 20 seconds instead of per-room.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedLazarusSwitch", 1)
local TAINTED_LAZARUS = 22
local SWITCH_INTERVAL = 600
local frameCounter = 0

function mod:OnPlayerUpdate(player)
    if player:GetPlayerType() ~= TAINTED_LAZARUS then return end

    frameCounter = frameCounter + 1
    if frameCounter >= SWITCH_INTERVAL then
        frameCounter = 0
        local flip = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
        if flip == CollectibleType.COLLECTIBLE_FLIP then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_FLIP, false, false)
        end
    end
end

function mod:OnNewRoom()
    frameCounter = 0
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
Isaac.DebugString("TaintedLazarusSwitch loaded!")
