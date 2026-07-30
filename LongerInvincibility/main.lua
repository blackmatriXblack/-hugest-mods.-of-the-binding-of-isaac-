-- =============================================================================
--  LONGER INVINCIBILITY — The Binding of Isaac: Repentance
--  Extends the invincibility frames after taking damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LongerInvincibility", 1)

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if player == nil then return end

    local cooldown = player:GetDamageCooldown()
    if cooldown > 0 then
        local newCooldown = 120
        if cooldown * 2 > 120 then
            newCooldown = cooldown * 2
        end
        if newCooldown > 300 then
            newCooldown = 300 -- cap at 10 seconds
        end
        player:SetDamageCooldown(newCooldown)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("Longer Invincibility loaded!")
