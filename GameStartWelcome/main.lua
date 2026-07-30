-- =============================================================================
--  GameStartWelcome — The Binding of Isaac: Repentance
--  Give player a random trinket and full mapping at game start.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GameStartWelcome", 1)

function mod:onGameStart()
    local player = Isaac.GetPlayer(0)
    -- Give a random trinket
    local trinketId = Isaac.GetTrinketIdByName("")
    local randomTrinket = math.random(1, 187)
    player:AddTrinket(randomTrinket)
    -- Reveal full map
    local level = Game():GetLevel()
    for i = 0, level:GetNumRooms() - 1 do
        local roomDesc = level:GetRoomByIdx(i)
        if roomDesc then
            roomDesc.DisplayFlags = roomDesc.DisplayFlags | 5 -- visible + shown
        end
    end
    -- Set starting room fully visible
    local startRoom = level:GetStartingRoom()
    startRoom.DisplayFlags = startRoom.DisplayFlags | 5
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
Isaac.DebugString("GameStartWelcome loaded!")
