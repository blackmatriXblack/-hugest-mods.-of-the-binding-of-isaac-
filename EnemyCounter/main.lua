-- =============================================================================
--  EnemyCounter - The Binding of Isaac: Repentance
--  Show how many enemies are currently alive in the room
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("EnemyCounter", 1)

function mod:onRender()
    local room = Game():GetRoom()
    if not room then return end

    local entities = Isaac.GetRoomEntities()
    local enemyCount = 0
    local bossCount = 0
    local championCount = 0

    for i = 0, #entities - 1 do
        local e = entities[i]
        if e:IsEnemy() and e:IsVulnerableEnemy() then
            enemyCount = enemyCount + 1
            if e:IsBoss() then
                bossCount = bossCount + 1
            end
            if e:IsChampion() then
                championCount = championCount + 1
            end
        end
    end

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.018
    local y = sh * 0.25

    -- Title
    Isaac.RenderScaledText("Enemies", x, y, 0.85, 0.85, 1, 0.5, 0.5, 1)

    -- Count display
    local colorR, colorG = 1, 1
    if enemyCount > 5 then colorR, colorG = 1, 0.5
    elseif enemyCount > 2 then colorR, colorG = 1, 0.8
    end

    Isaac.RenderScaledText(
        string.format("Alive: %d", enemyCount),
        x, y + 15, 1.2, 1.2, colorR, colorG, 0.2, 1
    )

    -- Boss indicator
    if bossCount > 0 then
        Isaac.RenderScaledText(
            string.format("BOSS: %d", bossCount),
            x, y + 34, 0.8, 0.8, 1, 0.2, 0.2, 1
        )
    end

    -- Champion indicator
    if championCount > 0 then
        Isaac.RenderScaledText(
            string.format("CHAMP: %d", championCount),
            x, y + 48, 0.75, 0.75, 1, 0.8, 0.2, 1
        )
    end

    -- Visual bar
    local maxShow = 15
    local ratio = math.min(enemyCount / maxShow, 1.0)
    local barLen = 18
    local filled = math.floor(ratio * barLen)
    local barStr = string.rep("█", filled) .. string.rep("░", barLen - filled)
    Isaac.RenderScaledText(barStr, x, y + 62, 0.55, 0.55, colorR, colorG, 0.3, 0.7)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("EnemyCounter loaded!")
