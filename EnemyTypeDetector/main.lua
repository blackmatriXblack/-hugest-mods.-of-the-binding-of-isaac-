-- =============================================================================
--  EnemyTypeDetector — The Binding of Isaac: Repentance
--  When looking at enemy (near crosshair), display their Type/Variant/SubType.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("EnemyTypeDetector", 1)
local game = Game()
local NEAR_RANGE = 60 -- pixels from crosshair

function mod:onPostRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Use player's tear firing direction as "crosshair" direction
    local playerPos = player.Position
    local aimDir = player:GetAimDirection()
    local aimVec = aimDir:Resized(300) -- search range of 300 pixels

    local nearestEnemy = nil
    local nearestDist = math.huge

    -- Iterate all entities in room to find nearest enemy along aim direction
    local entities = Isaac.GetRoomEntities()
    for i = 0, #entities - 1 do
        local ent = entities[i]
        if ent and ent:IsVulnerableEnemy() then
            local entPos = ent.Position
            local toEnt = entPos - playerPos
            local projDist = toEnt:Dot(aimVec:Normalized())
            local perpDist = math.abs(toEnt:Dot(aimVec:Rotated(90):Normalized()))

            -- Check if enemy is within a cone in front of player
            if projDist > 0 and perpDist < NEAR_RANGE and projDist < 300 then
                local totalDist = math.sqrt(projDist * projDist + perpDist * perpDist)
                if totalDist < nearestDist then
                    nearestDist = totalDist
                    nearestEnemy = ent
                end
            end
        end
    end

    if nearestEnemy then
        local eType = nearestEnemy.Type
        local eVariant = nearestEnemy.Variant
        local eSubType = nearestEnemy.SubType
        local eHP = nearestEnemy.HitPoints
        local line = "Enemy: T=" .. tostring(eType) ..
                     " V=" .. tostring(eVariant) ..
                     " S=" .. tostring(eSubType) ..
                     " HP=" .. tostring(eHP)
        Isaac.RenderText(line, 200, 120, 0.7, 0.7, 0.8, 1, 0.4)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("EnemyTypeDetector loaded!")
