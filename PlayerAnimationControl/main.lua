local mod = RegisterMod("PlayerAnimationControl", 1)
local player = Isaac.GetPlayer(0)

function mod:onNewRoom()
    local id = math.random(1, 100) + 1
    player:AnimateCollectible(id)
    player:AnimateHappy()
end

mod:AddCallback(8, mod.onNewRoom) -- MC_POST_NEW_ROOM
Isaac.DebugString("PlayerAnimationControl: Fun animations on room entry!")
