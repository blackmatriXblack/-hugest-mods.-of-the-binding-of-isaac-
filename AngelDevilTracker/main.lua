-- =============================================================================
--  AngelDevilTracker - The Binding of Isaac: Repentance
--  Shows current Angel/Devil deal chance percentage on HUD
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AngelDevilTracker", 1)
local game = Game()

function mod:onPostRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local level = game:GetLevel()
    if not level then return end

    -- Get Devil/Angel room chance
    local devilChance = level:GetDevilRoomChance()
    local angelChance = level:GetAngelRoomChance()
    local devilDealDone = level:GetStateFlag(LevelStateFlag.STATE_DEVILROOM_SPAWNED)

    -- Draw HUD panel at top-left area
    local x = 8
    local y = 280

    -- Title
    Isaac.RenderText(
        "DEAL CHANCE TRACKER",
        x, y,
        1.0, 0.7, 0.0, 0.85
    )

    -- Devil deal chance
    local devilColorR, devilColorG = 1.0, 0.2
    if devilDealDone then
        devilColorR, devilColorG = 0.3, 0.3
    end

    Isaac.RenderText(
        "Devil: " .. string.format("%.1f%%", devilChance),
        x, y + 14,
        devilColorR, devilColorG, 0.2, 0.8
    )

    -- Devil chance breakdown (what affects it)
    local baseChance = level:GetDevilRoomChance()
    if not devilDealDone then
        -- Show modifiers
        local hadRedHeartDamage = not player:IsWhoreOfBabylon() and false
        Isaac.RenderText(
            "  Base: 100% | Floor -: " .. string.format("%.0f%%", 100 - baseChance),
            x, y + 28,
            0.6, 0.6, 0.6, 0.5
        )
    else
        Isaac.RenderText(
            "  (Deal already taken this floor)",
            x, y + 28,
            0.5, 0.5, 0.5, 0.5
        )
    end

    -- Angel deal chance
    local angelColorR, angelColorG, angelColorB = 0.8, 0.9, 1.0

    Isaac.RenderText(
        "Angel: " .. string.format("%.1f%%", angelChance),
        x, y + 42,
        angelColorR, angelColorG, angelColorB, 0.8
    )

    -- Angel chance info
    local hasAngelKey = player:HasCollectible(CollectibleType.COLLECTIBLE_DUALITY) or
                        player:HasCollectible(CollectibleType.COLLECTIBLE_EUCHARIST)

    if angelChance > 0 then
        local infoText = "  Chance to replace Devil"
        if hasAngelKey then
            infoText = "  (Angel key item active)"
        end
        Isaac.RenderText(
            infoText,
            x, y + 56,
            0.6, 0.6, 0.8, 0.5
        )
    else
        Isaac.RenderText(
            "  (No Angel chance yet)",
            x, y + 56,
            0.4, 0.4, 0.5, 0.5
        )
    end

    -- Show deal room status
    local dealStatusX = x
    local dealStatusY = y + 70

    if devilDealDone then
        Isaac.RenderText(
            "STATUS: Devil deal taken",
            dealStatusX, dealStatusY,
            0.5, 0.5, 0.5, 0.6
        )
    else
        if devilChance >= 100 then
            Isaac.RenderText(
                "STATUS: Deal guaranteed!",
                dealStatusX, dealStatusY,
                0.0, 1.0, 0.0, 0.8
            )
        elseif devilChance > 0 then
            Isaac.RenderText(
                "STATUS: Chance pending...",
                dealStatusX, dealStatusY,
                1.0, 0.8, 0.0, 0.7
            )
        else
            Isaac.RenderText(
                "STATUS: No deal possible",
                dealStatusX, dealStatusY,
                0.8, 0.2, 0.2, 0.6
            )
        end
    end

    -- Visual probability bar
    local barWidth = 80
    local barX = x
    local barY = dealStatusY + 14

    Isaac.RenderText("[", barX, barY, 0.5, 0.5, 0.5, 0.7)
    local filledWidth = math.floor(barWidth * math.min(devilChance, 100) / 100)
    for i = 1, barWidth do
        local char = (i <= filledWidth) and "#" or "-"
        local r, g = 1.0, 0.2
        if i <= filledWidth then
            r = 1.0 - (i / barWidth) * 0.6
            g = 0.2 + (i / barWidth) * 0.7
        else
            r, g = 0.3, 0.3
        end
        Isaac.RenderText(char, barX + 8 + i * 1.8, barY, r, g, 0.2, 0.6)
    end
    Isaac.RenderText("] " .. string.format("%.0f%%", math.min(devilChance, 100)),
        barX + 8 + barWidth * 1.8, barY, 0.8, 0.8, 0.8, 0.7)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)

Isaac.DebugString("AngelDevilTracker loaded! Deal chances now visible.")
