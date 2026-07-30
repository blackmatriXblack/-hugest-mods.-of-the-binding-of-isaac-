-- ==========================================================================
--  Stat Shuffle - The Binding of Isaac: Repentance
--  Player stats shuffle randomly every 30 seconds
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("StatShuffle", 1)
local game = Game()
local shuffleTimer = 0
local SHUFFLE_DELAY = 900 -- 30 seconds
local currentStats = {}

local function ShuffleStats(player)
    -- Randomly redistribute player stats
    local stats = {
        Damage = math.random(1, 10) + math.random(),
        Tears = math.random(1, 10),
        ShotSpeed = math.random(8, 20) / 10,
        Range = math.random(5, 15),
        Speed = math.random(8, 20) / 10,
        Luck = math.random(-2, 3),
    }

    currentStats = stats
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    
    -- Visual feedback
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02,
        0, player.Position, Vector.Zero, nil)
    Isaac.DebugString(string.format("Stats shuffled! DMG:%.1f RATE:%d SPD:%.1f",
        stats.Damage, stats.Tears, stats.Speed))
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    shuffleTimer = shuffleTimer + 1

    if shuffleTimer >= SHUFFLE_DELAY then
        shuffleTimer = 0
        ShuffleStats(player)
    end
end)

-- Initial shuffle on game start
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    shuffleTimer = SHUFFLE_DELAY - 30 -- Shuffle almost immediately
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if #currentStats == 0 then return end
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = currentStats.Damage or player.Damage
    end
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = math.max(1, 30 - (currentStats.Tears or 5) * 3)
    end
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = currentStats.ShotSpeed or player.ShotSpeed
    end
    if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = (currentStats.Range or 5) * 40
    end
    if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = (currentStats.Speed or 1) * 0.5
    end
    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = currentStats.Luck or player.Luck
    end
end)

-- Show current stats on HUD
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local countdown = math.ceil((SHUFFLE_DELAY - shuffleTimer) / 30)
    if countdown <= 5 then
        Isaac.RenderText(string.format("Shuffling in %ds!", countdown),
            250, 20, 1, 1, 0.8, 0.2)
    end
end)

Isaac.DebugString("Stat Shuffle loaded!")
