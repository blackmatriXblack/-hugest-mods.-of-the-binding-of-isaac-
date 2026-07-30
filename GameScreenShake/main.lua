local mod = RegisterMod("GameScreenShake", 1)
local game = Game()

function mod:onNewRoom()
    game:ShakeScreen(10)
    game:Darken(0.3, 60)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
