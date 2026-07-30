-- TreasureExplosion: 10% chance to spawn 5 random items when entering any room
local mod = RegisterMod("TreasureExplosion", 1)

function mod:onNewRoom()
    local rng = RNG()
    rng:SetSeed(math.floor(os.time()), 0)
    if rng:RandomInt(100) < 10 then
        local game = Game()
        local room = game:GetLevel():GetCurrentRoom()
        local centerPos = room:GetCenterPos()
        for i = 1, 5 do
            local item = game:GetItemPool():GetCollectible(0, true, rng:Next())
            Isaac.Spawn(5, 100, item, centerPos + Vector(i * 30 - 75, 0), Vector(0, 0), nil)
        end
        Isaac.DebugString("TreasureExplosion: 5 random items spawned!")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("TreasureExplosion loaded! 10% chance for 5 items per room.")
