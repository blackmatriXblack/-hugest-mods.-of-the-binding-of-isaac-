-- OneCoinShop: Gives player 99 coins when entering a shop room
local mod = RegisterMod("OneCoinShop", 1)

function mod:onNewRoom()
    local room = Game():GetLevel():GetCurrentRoom()
    if room:GetType() == 2 then
        local player = Isaac.GetPlayer(0)
        player:AddCoins(99)
        Isaac.DebugString("OneCoinShop: 99 coins added on shop entry!")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("OneCoinShop loaded! 99 coins in every shop.")
