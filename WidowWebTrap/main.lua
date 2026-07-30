-- =============================================================================
--  WidowWebTrap - The Binding of Isaac: Repentance
--  Widow boss - web spit also spawns spider webs on the floor that slow the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("WidowWebTrap", 1)
local WIDOW_ID = 100
local SPIDERWEB_ID = GridEntityType.GRID_SPIDER_WEB
local lastWebFrame = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= WIDOW_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local room = Game():GetRoom()

    -- Every 120 frames (~4 seconds), spawn spider web traps around the room
    if frame - lastWebFrame >= 120 then
        lastWebFrame = frame

        -- Place 3-5 spider webs in random positions near edges
        for _ = 1, math.random(3, 5) do
            local x = room:GetCenterPos().X + math.random(-180, 180)
            local y = room:GetCenterPos().Y + math.random(-140, 140)
            local pos = Vector(x, y)
            local gridIndex = room:GetGridIndex(pos)
            local grid = room:GetGridEntity(gridIndex)

            -- Only spawn on empty floor tiles
            if grid == nil then
                Isaac.GridSpawn(SPIDERWEB_ID, 0, gridIndex, true)
            end
        end
    end

    -- Existing spider webs periodically spawn tiny spiders (every 300 frames)
    if frame % 300 == 0 and frame - lastWebFrame > 60 then
        for x = room:GetTopLeftPos().X + 40, room:GetBottomRightPos().X - 40, 80 do
            for y = room:GetTopLeftPos().Y + 40, room:GetBottomRightPos().Y - 40, 80 do
                local pos = Vector(x, y)
                local idx = room:GetGridIndex(pos)
                local grid = room:GetGridEntity(idx)
                if grid and grid:GetType() == SPIDERWEB_ID then
                    -- Small chance to spawn a tiny spider from each web
                    if math.random(1, 10) <= 3 then
                        Isaac.Spawn(EntityType.ENTITY_SPIDER, 0, 0, pos, Vector(0, 0), nil)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("WidowWebTrap loaded!")
