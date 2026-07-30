-- =============================================================================
--  JacobEsauShare - The Binding of Isaac: Repentance
--  Jacob and Esau share 30% of incoming damage with each other.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("JacobEsauShare", 1)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, damageFlag, source, countdown)
    local player = entity:ToPlayer()
    if not player then return end
    local pType = player:GetPlayerType()
    if pType ~= PlayerType.PLAYER_JACOB and pType ~= PlayerType.PLAYER_ESAU then
        return
    end
    -- Find the other sibling
    local otherPlayer = nil
    for i = 0, Game():GetNumPlayers() - 1 do
        local p = Game():GetPlayer(i)
        local t = p:GetPlayerType()
        if p ~= player and (t == PlayerType.PLAYER_JACOB or t == PlayerType.PLAYER_ESAU) then
            otherPlayer = p
            break
        end
    end
    if otherPlayer then
        local shareAmount = amount * 0.30
        otherPlayer:TakeDamage(shareAmount, DamageFlag.DAMAGE_NOKILL, EntityRef(player), 0)
        -- Reduce original damage by the shared portion
        return false -- allow original damage to proceed
    end
end)

Isaac.DebugString("JacobEsauShare loaded!")
