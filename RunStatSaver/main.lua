-- RunStatSaver: Saves kills and coins across runs using mod save data
local mod = RegisterMod("RunStatSaver", 1)
local stats = { kills = 0, coins = 0 }

function mod:onGameStart()
    if mod:HasData() then
        local data = mod:LoadData()
        if data and data.kills then
            stats.kills = data.kills
            stats.coins = data.coins
        end
    end
end

function mod:onEntityKill(entity)
    if entity:IsVulnerableEnemy() then
        stats.kills = stats.kills + 1
    end
end

function mod:onCoinPickup()
    stats.coins = stats.coins + 1
end

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    Isaac.RenderText("Total Kills: " .. stats.kills, 10, 30, 255, 255, 255, 255, 2)
    Isaac.RenderText("Total Coins: " .. stats.coins, 10, 50, 255, 255, 255, 255, 2)
end

function mod:onGameExit()
    mod:SaveData(stats)
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.onGameExit)
Isaac.DebugString("RunStatSaver loaded! Saving kills and coins across runs.")
