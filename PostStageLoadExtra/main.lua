-- =============================================================================
--  PostStageLoadExtra - The Binding of Isaac: Repentance
--  Spawns 2 extra random room types on each new stage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostStageLoadExtra", 1)

local extraRoomTypes = {
    RoomType.ROOM_DICE, RoomType.ROOM_LIBRARY,
    RoomType.ROOM_BARREN, RoomType.ROOM_PLANETARIUM,
    RoomType.ROOM_SACRIFICE, RoomType.ROOM_ARCADE,
    RoomType.ROOM_MINIBOSS, RoomType.ROOM_CURSE
}

function mod:onPostStageLoad()
    local level = Game():GetLevel()
    local game = Game()

    for i = 1, 2 do
        local roomType = extraRoomTypes[math.random(1, #extraRoomTypes)]

        -- Try to add a room of this type to an unused slot
        local placed = false
        for attempt = 1, 20 do
            local shape = math.random(1, 8) -- small rooms
            local x = math.random(0, 7)
            local y = math.random(0, 11)

            local desc = level:GetRoomByIdx(x, y)
            if desc == nil or desc.Data == nil or desc.Data.Shape == RoomShape.ROOMSHAPE_1x1 then
                if level:GetRoomByIdx(x, y) == nil then
                    level:MakeRedRoomDoor(x, y)
                    placed = true
                    break
                end
            end
        end

        if placed then
            Isaac.DebugString("Bonus room type " .. i .. " created!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_STAGE_LOAD, mod.onPostStageLoad)
Isaac.DebugString("PostStageLoadExtra loaded!")
