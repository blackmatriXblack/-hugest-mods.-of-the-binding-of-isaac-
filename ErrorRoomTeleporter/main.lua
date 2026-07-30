-- =============================================================================
--  Error Room Teleporter - The Binding of Isaac: Repentance
--  10% chance per room entry to be thrown into an I AM ERROR room!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ErrorRoomTeleporter", 1)
local TELEPORT_CHANCE = 10 -- 10%
local processedRooms = {}
local gameFrame = 0

function mod:onNewRoom()
    gameFrame = gameFrame + 1

    local room = Game():GetRoom()
    local roomIdx = room:GetRoomListIndex()

    -- Skip already processed rooms to avoid loops
    if processedRooms[roomIdx] then return end
    processedRooms[roomIdx] = true

    -- Skip special rooms (boss, devil, angel, etc.)
    local roomType = room:GetType()
    if roomType == RoomType.ROOM_ERROR or
       roomType == RoomType.ROOM_BOSS or
       roomType == RoomType.ROOM_DEVIL or
       roomType == RoomType.ROOM_ANGEL or
       roomType == RoomType.ROOM_SECRET or
       roomType == RoomType.ROOM_SUPERSECRET then
        return
    end

    -- 10% chance to teleport to I AM ERROR room
    local rng = RNG()
    rng:SetSeed(room:GetSpawnSeed() + gameFrame, 0)
    local roll = rng:RandomInt(100)

    if roll < TELEPORT_CHANCE then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        -- Visual warning effect
        player:GetSprite().Color = Color(1, 0, 0, 1, 0, 0, 0) -- Flash red
        Game():ShakeScreen(15)

        -- Teleport to I AM ERROR room
        local level = Game():GetLevel()
        level:SetStateFlag(LevelStateFlag.STATE_ERROR_ROOM, true)

        Isaac.DebugString("I AM ERROR! Teleported!")
        Isaac.DebugString("ERROR ROOM TRIGGERED after " .. gameFrame .. " rooms!")

        -- Spawn glitch effect at player's last position
        local pos = player.Position
        for i = 1, 5 do
            local offsetX = math.random(-30, 30)
            local offsetY = math.random(-30, 30)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE,
                0, pos + Vector(offsetX, offsetY), Vector.Zero, nil)
        end

        -- Teleport via console command
        Isaac.ExecuteCommand("stage 13a") -- I AM ERROR room

        -- Reset processed rooms to allow re-entry
        processedRooms = {}
    end
end

function mod:onNewLevel()
    processedRooms = {}
    gameFrame = 0
    Isaac.DebugString("Error Room Teleporter active! 10% chance...")
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
Isaac.DebugString("ErrorRoomTeleporter loaded! 10% ERROR chance!")
