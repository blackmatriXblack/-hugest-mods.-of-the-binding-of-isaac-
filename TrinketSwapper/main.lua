local mod = RegisterMod("TrinketSwapper", 1)
local game = Game()

function mod:onNewLevel()
    local player = Isaac.GetPlayer(0)
    local rng = RNG()
    rng:SetSeed(player:GetCollectibleRNG(0), 0)
    local trinketId = rng:RandomInt(190) + 1
    local currentTrinket = player:GetTrinket(0)
    if currentTrinket ~= 0 then
        player:TryRemoveTrinket(0)
        Isaac.Spawn(5, currentTrinket, 0, player.Position, Vector(0, 0), player)
    end
    player:AddTrinket(trinketId)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
