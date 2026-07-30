-- ==========================================================================
--  Random Teleports - The Binding of Isaac: Repentance
--  Player randomly teleports to a different room every 45 seconds
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RandomTeleports", 1)
local game = Game()
local teleportTimer = 0
local TELEPORT_DELAY = 1350 -- 45 seconds at 30fps

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    teleportTimer = teleportTimer + 1

    if teleportTimer >= TELEPORT_DELAY then
        teleportTimer = 0
        local level = game:GetLevel()
        local rooms = level:GetRooms()
        
        if rooms and rooms.Size > 1 then
            -- Pick a random room that isn't the current one
            local currentRoom = game:GetRoom()
            local targetIdx = currentRoom:GetGridIndex()
            local attempts = 0
            
            while targetIdx == currentRoom:GetGridIndex() and attempts < 50 do
                local randomRoom = rooms:Get(math.random(0, rooms.Size - 1))
                if randomRoom then
                    targetIdx = randomRoom.SafeGridIndex
                end
                attempts = attempts + 1
            end

            if targetIdx ~= currentRoom:GetGridIndex() then
                -- Create teleport effect
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TELEPORT,
                    0, player.Position, Vector.Zero, nil)
                game:StartRoomTransition(targetIdx, DoorSlot.NO_DOOR_SLOT,
                    RoomTransitionAnim.TELEPORT)
                Isaac.DebugString("Random teleport triggered!")
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if teleportTimer > TELEPORT_DELAY - 150 then
        local secondsLeft = math.ceil((TELEPORT_DELAY - teleportTimer) / 30)
        Isaac.RenderText(string.format("Teleport in %d...", secondsLeft),
            260, 140, 0.8, 0.7, 0.2, 1)
    end
end)

Isaac.DebugString("Random Teleports loaded!")
