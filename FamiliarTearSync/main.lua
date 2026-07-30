-- =============================================================================
--  FamiliarTearSync - The Binding of Isaac: Repentance
--  All familiars fire tears that match the player's damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FamiliarTearSync", 1)

function mod:onPeffectUpdate(player)
    local dmg = player.Damage

    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent:IsFamiliar() and ent:ToFamiliar() then
            ent:ToFamiliar().CollisionDamage = dmg
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPeffectUpdate)
Isaac.DebugString("FamiliarTearSync loaded!")
