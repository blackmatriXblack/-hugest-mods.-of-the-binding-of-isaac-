local mod = RegisterMod("LevelTryTeleport", 1)
local game = Game()
local input = Input()

function mod:onUpdate()
    if input:IsButtonPressed(Keyboard.KEY_T, 0) then
        local level = game:GetLevel()
        level:TryTeleport(5, true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
