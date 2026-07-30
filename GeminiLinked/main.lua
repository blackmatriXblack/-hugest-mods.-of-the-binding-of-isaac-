-- =============================================================================
--  GeminiLinked — The Binding of Isaac: Repentance
--  Gemini (Type 28 and 29) — when one takes damage, both take same damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GeminiLinked", 1)

local GEMINI_TYPE = EntityType.ENTITY_GEMINI -- Type 28
local GEMINI_ALT_TYPE = 29 -- The other half (contusion)

function mod:onEntityTakeDmg(target, damageAmount, damageFlag, damageSource, damageCountdownFrames)
    -- Only trigger for Gemini types
    if target.Type ~= GEMINI_TYPE and target.Type ~= GEMINI_ALT_TYPE then
        return
    end

    local linkedType = (target.Type == GEMINI_TYPE) and GEMINI_ALT_TYPE or GEMINI_TYPE

    -- Find the linked Gemini in the room
    local room = Game():GetRoom()
    for i = 0, room:GetAliveEnemiesCount() - 1 do
        local other = room:GetAliveEnemy(i)
        if other and GetPtrHash(other) ~= GetPtrHash(target) and other.Type == linkedType then
            -- Apply same damage to the other Gemini
            other:TakeDamage(damageAmount, 0, EntityRef(target), 0)
            break
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("GeminiLinked loaded!")
