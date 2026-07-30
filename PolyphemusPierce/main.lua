-- =============================================================================
--  Polyphemus Pierce - The Binding of Isaac: Repentance
--  Polyphemus (169) tears gain piercing if they also have spectral.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PolyphemusPierce", 1)
local COLLECTIBLE_POLYPHEMUS = 169

function mod:ApplyPierce(player)
    if player:HasCollectible(COLLECTIBLE_POLYPHEMUS) then
        if player.TearFlags & TearFlags.TEAR_SPECTRAL ~= 0 then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ApplyPierce)
Isaac.DebugString("PolyphemusPierce loaded!")
