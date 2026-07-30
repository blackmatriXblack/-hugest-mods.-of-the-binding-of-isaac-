-- =============================================================================
--  FontTextTester — The Binding of Isaac: Repentance
--  Display current room name on screen using Font() API.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("FontTextTester", 1)
local game = Game()

function mod:onPostRender()
    local level = game:GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    if not roomDesc then return end
    local roomType = roomDesc.Data and roomDesc.Data.Type or RoomType.ROOM_DEFAULT
    local roomName = "Room Type: " .. tostring(roomType)

    -- Use Font() API to render text with custom font properties
    local font = Font()
    font:Load("font/pftempestasevencondensed.fnt") -- standard Isaac font
    Isaac.RenderText(roomName, 10, 28, 1, 1, 1, 1)
    -- Also display room variant for more detail
    local variant = roomDesc.Data and roomDesc.Data.Variant or 0
    Isaac.RenderText("Variant: " .. tostring(variant), 10, 40, 0.8, 0.8, 1, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("FontTextTester loaded!")
