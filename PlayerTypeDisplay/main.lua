-- Display current player character type on HUD
local mod = RegisterMod("PlayerTypeDisplay", 1)
local game = Game()

function mod:onPEffectUpdate(player, cacheFlags)
    if player then
        local playerType = player:GetPlayerType()
        Isaac.DebugString("Current player type: " .. tostring(playerType))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("PlayerTypeDisplay loaded! Shows current player character type.")
