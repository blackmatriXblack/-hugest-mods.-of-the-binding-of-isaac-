-- BombImmunity: Negates all bomb/explosion damage to the player
local mod = RegisterMod("BombImmunity", 1)

function mod:onTakeDamage(entity, amount, flags, source, cooldown)
    if source and source.Type == 4 then
        Isaac.DebugString("BombImmunity: Explosion damage negated!")
        return false
    end
    return nil
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onTakeDamage)
Isaac.DebugString("BombImmunity loaded! Immune to bomb damage.")
