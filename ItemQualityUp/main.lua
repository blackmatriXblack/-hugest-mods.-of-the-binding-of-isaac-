-- ItemQualityUp: Spawns a high-quality Angel room item in every new room
local mod = RegisterMod("ItemQualityUp", 1)

function mod:onNewRoom()
    local game = Game()
    local room = game:GetLevel():GetCurrentRoom()
    local centerPos = room:GetCenterPos()
    local rng = RNG()
    rng:SetSeed(math.floor(os.time()), 0)
    local item = game:GetItemPool():GetCollectible(1, true, rng:Next())
    Isaac.Spawn(5, 100, item, centerPos, Vector(0, 0), nil)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("ItemQualityUp loaded! Angel room item in every room.")
