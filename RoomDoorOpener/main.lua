local mod = RegisterMod("RoomDoorOpener", 1)
local game = Game()

function mod:onNewRoom()
    local room = game:GetRoom()
    for i = 0, 3 do
        local door = room:GetDoor(i)
        if door and door:Exists() then
            local pos = room:GetDoorSlotPosition(i)
            Isaac.Spawn(5, 20, 1, pos, Vector(0, 0), nil)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
