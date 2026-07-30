local mod = RegisterMod("ModRemoveData", 1)
local input = Input()

function mod:onGameStarted(continued)
    Isaac.DebugString("Press R to remove saved data")
end

function mod:onUpdate()
    if input:IsButtonPressed(Keyboard.KEY_R, 0) then
        mod:RemoveData()
        Isaac.DebugString("Saved data removed!")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStarted)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
