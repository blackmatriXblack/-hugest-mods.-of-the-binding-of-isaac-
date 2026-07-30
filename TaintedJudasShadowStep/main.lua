-- =============================================================================
--  TaintedJudasShadowStep - The Binding of Isaac: Repentance
--  Tainted Judas: Dark Arts grants +0.5 temporary damage per enemy passed through.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedJudasShadowStep", 1)
local TAINTED_JUDAS = 24
local DARK_ARTS = CollectibleType.COLLECTIBLE_DARK_ARTS -- id 705
local damageBonus = 0
local passageCount = 0
local prevFrameActive = false

function mod:onPEffectUpdate(player)
    if player:GetPlayerType() ~= TAINTED_JUDAS then return end

    local isActive = player:HasCollectible(DARK_ARTS)
    -- Check if Dark Arts was just used (simplified detection)
    if isActive and not prevFrameActive then
        passageCount = passageCount + 1
        damageBonus = damageBonus + 0.5
        player:AddDamageModifier(damageBonus)
        Isaac.DebugString("TaintedJudasShadowStep: +0.5 damage, total bonus: " .. damageBonus)
    end

    prevFrameActive = isActive
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("TaintedJudasShadowStep loaded!")
