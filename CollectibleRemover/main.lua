local mod = RegisterMod("CollectibleRemover", 1)
local game = Game()

function mod:onNewRoom()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(1) then
        player:RemoveCollectible(1)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
