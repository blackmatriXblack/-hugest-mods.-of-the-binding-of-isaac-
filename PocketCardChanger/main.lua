local mod = RegisterMod("PocketCardChanger", 1)
local game = Game()

function mod:onNewRoom()
    local player = Isaac.GetPlayer(0)
    local rng = RNG()
    rng:SetSeed(player:GetCollectibleRNG(0), 0)
    local cardId = rng:RandomInt(40) + 1
    player:SetCard(0, cardId)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
