-- ==========================================================================
--  AfterimageTrail - The Binding of Isaac: Repentance
--  Player leaves a ghostly afterimage trail while moving!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("AfterimageTrail", 1)
local TRAIL_INTERVAL = 3
local trailTimer = 0
local MAX_TRAILS = 12
local trailPositions = {}

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local vel = player.Velocity
    if vel:Length() < 0.5 then
        trailTimer = 0
        return
    end

    trailTimer = trailTimer + 1
    if trailTimer % TRAIL_INTERVAL == 0 then
        table.insert(trailPositions, {
            pos = player.Position,
            alpha = 0.6,
            frame = 0
        })
        if #trailPositions > MAX_TRAILS then
            table.remove(trailPositions, 1)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    for _, trail in ipairs(trailPositions) do
        trail.frame = trail.frame + 1
        trail.alpha = 0.6 * (1 - trail.frame / 40)
        if trail.alpha > 0 then
            local screenPos = Isaac.WorldToScreen(trail.pos)
            local player = Isaac.GetPlayer(0)
            local spr = player:GetSprite()

            local size = 15 * (trail.alpha * 1.5)
        end
    end

    local toRemove = {}
    for i, trail in ipairs(trailPositions) do
        if trail.frame > 40 then
            table.insert(toRemove, i)
        end
    end
    for i = #toRemove, 1, -1 do
        table.remove(trailPositions, toRemove[i])
    end
end)

Isaac.DebugString("AfterimageTrail loaded! Ghost mode activated!")
