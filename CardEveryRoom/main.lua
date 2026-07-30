-- CardEveryRoom: Spawns a random card at the center of every room entered
local mod = RegisterMod("CardEveryRoom", 1)

function mod:onNewRoom()
    local rng = RNG()
    rng:SetSeed(math.floor(os.time()), 0)
    local game = Game()
    local room = game:GetLevel():GetCurrentRoom()
    local centerPos = room:GetCenterPos()
    local card = game:GetItemPool():GetCard(rng:Next())
    Isaac.Spawn(5, 300, card, centerPos, Vector(0, 0), nil)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("CardEveryRoom loaded! Random card spawns in every room.")
