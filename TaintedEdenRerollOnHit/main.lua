-- =============================================================================
--  TaintedEdenRerollOnHit — The Binding of Isaac: Repentance
--  Tainted Eden has a small chance to reroll when taking damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedEdenRerollOnHit", 1)
local TAINTED_EDEN = 26
local REROLL_CHANCE = 0.1

function mod:OnEntityTakeDmg(target, amount, flags, source, cd)
    if target.Type ~= EntityType.ENTITY_PLAYER then return end

    local player = target:ToPlayer()
    if not player then return end

    if player:GetPlayerType() ~= TAINTED_EDEN then return end

    local rng = RNG()
    rng:SetSeed(player:GetDropRNG():Next(), 0)

    if rng:RandomFloat() < REROLL_CHANCE then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_D100, false, false)
        Isaac.DebugString("Tainted Eden rerolled!")
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnEntityTakeDmg)
Isaac.DebugString("TaintedEdenRerollOnHit loaded!")
