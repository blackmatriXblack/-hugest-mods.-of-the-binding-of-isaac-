-- Track and count active effects in the room, show on HUD
local mod = RegisterMod("EffectUpdateMod", 1)
local game = Game()
local effectCount = 0

function mod:onEffectUpdate(effect)
    if effect then
        effectCount = effectCount + 1
    end
end

function mod:onPostRender()
    Isaac.RenderText("Active effects: " .. effectCount, 60, 220, 1, 1, 1, 1)
    effectCount = 0
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.onEffectUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("EffectUpdateMod loaded! Tracks and displays active effect count.")
