-- =============================================================================
--  SpriteLoaderMod — The Binding of Isaac: Repentance
--  Show current player sprite animation name on HUD.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("SpriteLoaderMod", 1)
local game = Game()

function mod:onPostRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end
    local sprite = player:GetSprite()
    if not sprite then return end
    local anim = sprite:GetAnimation()
    local frame = sprite:GetFrame()
    local animName = "Animation: " .. anim .. " | Frame: " .. frame
    Isaac.RenderText(animName, 10, 52, 0.9, 0.9, 1, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("SpriteLoaderMod loaded!")
