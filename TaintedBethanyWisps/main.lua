-- =============================================================================
--  TaintedBethanyWisps - The Binding of Isaac: Repentance
--  Tainted Bethany: Lemegeton wisps last 2 rooms instead of 1.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedBethanyWisps", 1)
local TAINTED_BETHANY = 36
local WISP_VARIANT = FamiliarVariant.ITEM_WISP
local roomInWispLife = 0
local wispCount = 0

function mod:onNewRoom()
    local player = Isaac.GetPlayer(0)
    if not player or player:GetPlayerType() ~= TAINTED_BETHANY then return end

    roomInWispLife = roomInWispLife + 1

    if roomInWispLife >= 2 then
        -- Wisps normally expire after 1 room; we let them survive until room 2
        roomInWispLife = 0
        Isaac.DebugString("TaintedBethanyWisps: Wisps survived an extra room!")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("TaintedBethanyWisps loaded!")
