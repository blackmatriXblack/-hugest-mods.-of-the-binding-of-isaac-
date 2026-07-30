-- =============================================================================
--  TaintedApollyonAbyss - The Binding of Isaac: Repentance
--  Tainted Apollyon: Abyss locusts deal +50% damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedApollyonAbyss", 1)
local TAINTED_APOLLYON = 34
local ABYSS = CollectibleType.COLLECTIBLE_ABYSS -- id 706
local LOCUST_VARIANT = FamiliarVariant.ABYSS_LOCUST
local DAMAGE_BOOST_MULT = 1.5

function mod:onPEffectUpdate(player)
    if player:GetPlayerType() ~= TAINTED_APOLLYON then return end
    if not player:HasCollectible(ABYSS) then return end

    -- Boost all Abyss locust familiars
    for i = 0, player:GetFamiliarCount() - 1 do
        local familiar = player:GetFamiliar(i)
        if familiar and familiar.Variant == LOCUST_VARIANT then
            -- Scale locust damage via the locust entity's collision damage
            familiar.CollisionDamage = familiar.CollisionDamage * DAMAGE_BOOST_MULT
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("TaintedApollyonAbyss loaded!")
