-- =============================================================================
--  LilithIncubusBuff - The Binding of Isaac: Repentance
--  Lilith's Incubus familiar fires 50% faster than normal.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LilithIncubusBuff", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    if player:GetPlayerType() ~= PlayerType.PLAYER_LILITH then
        return
    end
    -- Boost fire rate of all Incubus familiars
    for i = 0, player:GetFamiliars().Size - 1 do
        local familiar = player:GetFamiliars().Get(i)
        if familiar.Variant == FamiliarVariant.INCUBUS then
            familiar.FireCooldown = familiar.FireCooldown * 0.67
        end
    end
end)

Isaac.DebugString("LilithIncubusBuff loaded!")
