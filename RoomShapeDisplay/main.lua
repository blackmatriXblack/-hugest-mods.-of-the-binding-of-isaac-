local mod = RegisterMod("RoomShapeDisplay", 1)
local game = Game()

function mod:onNewRoom()
    local room = game:GetRoom()
    local shape = room:GetRoomShape()
    Isaac.DebugString("Room shape: " .. tostring(shape))
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
