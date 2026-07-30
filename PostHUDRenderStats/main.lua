-- =============================================================================
--  PostHUDRenderStats — The Binding of Isaac: Repentance
--  MC_POST_HUD_RENDER: Display current room's enemy count, total kills,
--  and DPS estimate as floating text.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostHUDRenderStats", 1)

local KILL_COUNT = 0
local LAST_HIT_TIME = 0
local RECENT_DAMAGE = {} -- deque of recent damage amounts

function mod:onNPCDamaged(npc, amount, flags, source, countdown)
    if source and source.Type == EntityType.ENTITY_PLAYER then
        KILL_COUNT = KILL_COUNT + 1
        table.insert(RECENT_DAMAGE, {time = Isaac.GetFrameCount(), amount = amount or 0})
        -- Keep only last 60 frames of damage
        while #RECENT_DAMAGE > 0 and
              Isaac.GetFrameCount() - RECENT_DAMAGE[1].time > 60 do
            table.remove(RECENT_DAMAGE, 1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onNPCDamaged)

function mod:onNewRoom()
    KILL_COUNT = 0
    RECENT_DAMAGE = {}
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)

function mod:onPostHUDRender()
    local room = Game():GetRoom()
    if not room then return end

    local enemyCount = 0
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsActiveEnemy() then
            enemyCount = enemyCount + 1
        end
    end

    -- Calculate recent DPS estimate
    local totalDamage = 0
    for _, d in ipairs(RECENT_DAMAGE) do
        totalDamage = totalDamage + d.amount
    end
    local dps = totalDamage -- damage in last 60 frames ≈ damage per second

    local statsText = string.format(
        "Enemies: %d | Kills: %d | DPS: %.1f",
        enemyCount,
        KILL_COUNT,
        dps
    )

    local textPos = Vector(60, 200)
    Isaac.RenderText(statsText, textPos.X, textPos.Y, 0.5, 1.0, 1.0, 1.0, 255)
end
mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.onPostHUDRender)

Isaac.DebugString("PostHUDRenderStats loaded!")
