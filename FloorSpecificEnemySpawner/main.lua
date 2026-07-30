local mod = RegisterMod("FloorSpecificEnemySpawner", 1)
local level = Game():GetLevel()
local spawned = false

function mod:onNewLevel()
    spawned = false
    local ch = level:GetChapter()
    local enemyTypes = {18, 22, 28, 30, 88, 95} -- Flies, Gapers, Spiders, Babies, DeathHeads, Endgame
    local eType = enemyTypes[ch + 1] or 18
    local player = Isaac.GetPlayer(0)
    for i = 1, 5 do
        local ox = math.random(-60, 60)
        local oy = math.random(-60, 60)
        Isaac.Spawn(eType, 0, 0, player.Position + Vector(ox, oy), Vector(0, 0), nil)
    end
end

mod:AddCallback(14, mod.onNewLevel) -- MC_POST_NEW_LEVEL
Isaac.DebugString("FloorSpecificEnemySpawner: Chapter-based enemies spawned on new level!")
