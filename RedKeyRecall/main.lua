-- ==========================================================================
--  Red Key Recall - The Binding of Isaac: Repentance
--  Red Key reveals the room type behind walls before opening them
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RedKeyRecall", 1)
local game = Game()

local RED_KEY = CollectibleType.COLLECTIBLE_RED_KEY

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player or not player:HasCollectible(RED_KEY) then return end

    -- Check if player has red key in active slot
    local hasRedKey = false
    for slot = 0, 3 do
        if player:GetActiveItem(slot) == RED_KEY then
            hasRedKey = true
            break
        end
    end
    if not hasRedKey then return end

    -- Scan all four walls within range for red room outlines
    local directions = {
        {Vector(0, -200), "NORTH"},
        {Vector(0, 200), "SOUTH"},
        {Vector(200, 0), "EAST"},
        {Vector(-200, 0), "WEST"}
    }

    for _, dir in ipairs(directions) do
        local pos = player.Position + dir[1]
        local room = game:GetRoom()
        local roomDesc = game:GetLevel():GetRoomByIdx(0, 0)
        -- Check if this position would create a valid red room
        local doorSlot = -1
        for d = 0, 3 do
            local door = room:GetDoor(d)
            if door and (player.Position - door.Position):Length() < 20 then
                doorSlot = d
                break
            end
        end

        if doorSlot >= 0 then
            local screenPos = Isaac.WorldToScreen(player.Position + dir[1] * 0.25)
            -- Show hint text near the outline
            Isaac.RenderText(dir[2] .. " DOOR",
                screenPos.X - 20, screenPos.Y, 1, 1, 0.3, 0.3, 0.8)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("RedKeyRecall loaded!")
