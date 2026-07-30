-- =============================================================================
--  Crawlspace Always - The Binding of Isaac: Repentance
--  Every floor spawns at least 3 crawlspace trapdoors!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CrawlspaceAlways", 1)
local spawned = false

function mod:onNewLevel()
    spawned = false
end

function mod:onNewRoom()
    if spawned then return end

    local level = Game():GetLevel()
    local room = Game():GetRoom()
    local roomDesc = level:GetCurrentRoomDesc()

    -- Spawn crawlspaces in dead-end rooms or special rooms
    if room:IsFirstVisit() then
        local roomType = room:GetType()
        -- Place crawlspace in non-special rooms
        if roomType ~= RoomType.ROOM_BOSS and
           roomType ~= RoomType.ROOM_ERROR and
           roomType ~= RoomType.ROOM_DEVIL and
           roomType ~= RoomType.ROOM_ANGEL then

            local center = room:GetCenterPos()

            -- Spawn 3 crawlspace trapdoors around the room
            for i = 1, 3 do
                local offsetX = (i - 2) * 60
                local pos = Vector(center.X + offsetX, center.Y + 40)
                local crawlspace = Isaac.Spawn(EntityType.ENTITY_EFFECT,
                    EffectVariant.CRAWL_SPACE, 0, pos, Vector.Zero, nil)
                if crawlspace then
                    crawlspace:GetSprite().Color = Color(0.5, 0.2, 1, 1, 0, 0, 0) -- Purple tint
                end
            end

            Isaac.DebugString("3 Crawlspaces spawned!")
            spawned = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("CrawlspaceAlways loaded!")
