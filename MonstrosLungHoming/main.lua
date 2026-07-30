-- =============================================================================
--  Monstro's Lung Homing - The Binding of Isaac: Repentance
--  Monstro's Lung (229) charged shot gains slight homing.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MonstrosLungHoming", 1)
local COLLECTIBLE_MONSTROS_LUNG = 229

function mod:ApplyHoming(player)
    if player:HasCollectible(COLLECTIBLE_MONSTROS_LUNG) then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ApplyHoming)
Isaac.DebugString("MonstrosLungHoming loaded!")
