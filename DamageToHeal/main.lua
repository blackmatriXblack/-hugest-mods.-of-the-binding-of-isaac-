-- DamageToHeal: Player heals 2 full hearts when taking damage
local mod = RegisterMod("DamageToHeal", 1)

function mod:onTakeDamage(entity, amount, flags, source, cooldown)
    local player = Isaac.GetPlayer(0)
    player:AddHearts(4)
    Isaac.DebugString("DamageToHeal: Healed 2 hearts from damage taken!")
    return nil
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onTakeDamage)
Isaac.DebugString("DamageToHeal loaded! Taking damage heals you.")
