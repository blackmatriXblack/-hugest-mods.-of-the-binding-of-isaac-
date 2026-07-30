local mod = RegisterMod("ExtraAnimationCheck", 1)
local game = Game()

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if player:IsExtraAnimationFinished() then
        Isaac.DebugString("Animation finished")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
