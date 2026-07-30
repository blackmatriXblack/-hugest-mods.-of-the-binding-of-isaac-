-- TreasureRoomSpawner: Spawns 3 extra pedestal items in treasure rooms
local mod = RegisterMod("TreasureRoomSpawner", 1)

function mod:onNewRoom()
    local room = Game():GetLevel():GetCurrentRoom()
    local game = Game()
    local rng = RNG()
    rng:SetSeed(math.floor(os.time()), 0)
    if room:GetType() == 4 then
        local centerPos = room:GetCenterPos()
        for i = 1, 3 do
            local item = game:GetItemPool():GetCollectible(0, true, rng:Next())
            Isaac.Spawn(5, 100, item, centerPos + Vector(i * 30 - 45, 0), Vector(0, 0), nil)
        end
        Isaac.DebugString("TreasureRoomSpawner: Spawned 3 extra items!")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("TreasureRoomSpawner loaded! Treasure rooms get extra items.")
