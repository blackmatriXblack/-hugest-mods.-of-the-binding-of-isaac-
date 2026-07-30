-- =============================================================================
--  CurseRoomImmunity — The Binding of Isaac: Repentance
--  50% chance curse room doors don't damage you on exit.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CurseRoomImmunity", 1)

function mod:PreventCurseDamage(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
    local player = entity:ToPlayer()
    if not player then return nil end

    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_CURSE then
        -- Check if damage is from curse room door
        if damageSource == EntityType.ENTITY_EFFECT and damageFlags & DamageFlag.DAMAGE_CURSED_DOOR > 0 then
            if math.random() < 0.5 then
                return false  -- negate damage
            end
        end
    end

    return nil
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.PreventCurseDamage)
Isaac.DebugString("CurseRoomImmunity loaded!")
