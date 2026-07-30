-- =============================================================================
--  DailyRunBuff - The Binding of Isaac: Repentance
--  Daily runs start with +3 damage and +2 tears for leaderboard fun
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DailyRunBuff", 1)
local game = Game()
local buffApplied = false

function mod:onPlayerInit(player)
    -- Only apply buff in daily runs
    if not game:IsDailyRun() then
        Isaac.DebugString("DailyRunBuff: Not a daily run, skipping buff")
        return
    end

    if buffApplied then return end
    buffApplied = true

    -- Apply damage buff: +3 flat damage
    local currentDamage = player.Damage
    player.Damage = currentDamage + 3.0

    -- Apply tears buff: +2 tears (lower delay = faster fire rate)
    local currentTears = player.MaxFireDelay
    -- Tears stat works inversely: lower is faster
    -- Add 2 to the tears stat (additive bonus)
    -- Base tears formula: fire delay = 16 - 6*sqrt(tears*1.3+1)
    -- We'll add damage multiplier items that grant tears up
    player:AddCollectible(CollectibleType.COLLECTIBLE_SAD_ONION, 0, false) -- +0.7 tears
    player:AddCollectible(CollectibleType.COLLECTIBLE_WIRE_COAT_HANGER, 0, false) -- +0.7 tears
    player:AddCollectible(CollectibleType.COLLECTIBLE_TORN_PHOTO, 0, false) -- +0.5 tears

    -- Visual feedback
    player:AnimateCollectible(CollectibleType.COLLECTIBLE_SAD_ONION)
    player:AnimateCollectible(CollectibleType.COLLECTIBLE_WIRE_COAT_HANGER)

    -- Show a celebratory message
    Isaac.DebugString("DailyRunBuff: +3 DMG and +2 TEARS granted for daily run!")
end

function mod:onPostRender()
    if not game:IsDailyRun() then return end

    local player = Isaac.GetPlayer(0)
    if not player or not player:Exists() then return end

    -- Show daily run buff status
    Isaac.RenderText(
        "[DAILY RUN BUFF: +3 DMG | +2 TEARS]",
        160, 4,
        1.0, 0.85, 0.0, 0.85
    )

    -- Show current stats
    local dmg = string.format("%.1f", player.Damage)
    local tears = string.format("%.1f", 30.0 / (player.MaxFireDelay + 1))
    Isaac.RenderText(
        "DMG: " .. dmg .. " | Tears: " .. tears,
        220, 18,
        0.8, 0.8, 0.2, 0.6
    )
end

function mod:onGameStart()
    buffApplied = false
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.onPlayerInit)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)

Isaac.DebugString("DailyRunBuff loaded! Daily runs get +3 DMG and +2 Tears.")
