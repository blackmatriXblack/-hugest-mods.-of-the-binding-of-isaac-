-- =============================================================================
--  BegottenSteal — The Binding of Isaac: Repentance
--  Begottens (Type=251) steal 1 coin from player on hit.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BegottenSteal", 1)

function mod:onEntityTakeDmg(target, damageAmount, damageFlag, damageSource, countdown)
    -- This callback fires on the entity TAKING damage
    -- We want to detect when the PLAYER takes damage from a Begotten
    if target.Type ~= EntityType.ENTITY_PLAYER then return nil end

    if damageSource.Entity and damageSource.Entity.Type == 251 then
        local player = target:ToPlayer()
        if player then
            local coins = player:GetNumCoins()
            if coins > 0 then
                player:AddCoins(-1)
            end
        end
    end

    return nil
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("BegottenSteal loaded!")
