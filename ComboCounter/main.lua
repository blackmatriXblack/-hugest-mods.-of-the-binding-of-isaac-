-- ==========================================================================
--  ComboCounter - The Binding of Isaac: Repentance
--  Rapid hits build a combo counter — higher combos = more damage!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ComboCounter", 1)
local combo = 0
local comboTimer = 0
local COMBO_DECAY = 60
local DAMAGE_PER_COMBO = 0.3

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
    if source and source:ToPlayer() and entity:IsVulnerableEnemy() then
        combo = combo + 1
        comboTimer = COMBO_DECAY
        local bonus = combo * DAMAGE_PER_COMBO
        entity:TakeDamage(bonus, 0, EntityRef(source), 0)
        if combo % 5 == 0 then
            SFXManager():Play(SoundEffect.SOUND_KEY_PICKUP_GAUNTLET, 0.5, 0, false, 1 + combo * 0.05)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if combo > 0 then
        comboTimer = comboTimer - 1
        if comboTimer <= 0 then
            combo = 0
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if combo >= 3 then
        local w, h = Isaac.GetScreenWidth(), Isaac.GetScreenHeight()
        local r, g, b = 1, 1, 0
        if combo >= 20 then r, g, b = 1, 0, 0
        elseif combo >= 10 then r, g, b = 1, 0.5, 0 end
        local scale = 1.5 + combo * 0.05
        local alpha = math.min(1, comboTimer / 30)
        Isaac.RenderText(combo .. "x COMBO!", w / 2 - 50, h - 80, r, g, b, alpha, scale)
    end
end)

Isaac.DebugString("ComboCounter loaded! Rack 'em up!")
