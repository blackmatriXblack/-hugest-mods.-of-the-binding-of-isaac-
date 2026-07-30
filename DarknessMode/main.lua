-- =============================================================================
--  DarknessMode - The Binding of Isaac: Repentance
--  Permanent Curse of Darkness but treasures glow with light
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DarknessMode", 1)
local game = Game()
local glowEntities = {}

function mod:onPostRender()
    -- Find all treasure/pedestal entities and draw glow around them
    local room = game:GetRoom()
    if not room then return end

    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        local shouldGlow = false
        local glowColor

        -- Treasure room items glow golden
        if ent.Type == EntityType.ENTITY_PICKUP and ent.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            shouldGlow = true
            glowColor = Color(1.0, 0.85, 0.2, 0.6, 0, 0, 0) -- Golden glow
        end

        -- Shop items glow silver
        if ent.Type == EntityType.ENTITY_PICKUP and ent.Variant == PickupVariant.PICKUP_SHOPITEM then
            shouldGlow = true
            glowColor = Color(0.7, 0.8, 1.0, 0.5, 0, 0, 0) -- Blue-silver glow
        end

        -- Boss room items glow red
        if ent.Type == EntityType.ENTITY_PICKUP and ent.Variant == PickupVariant.PICKUP_BOSSDROP then
            shouldGlow = true
            glowColor = Color(1.0, 0.3, 0.2, 0.5, 0, 0, 0) -- Red glow
        end

        if shouldGlow then
            local screenPos = Isaac.WorldToScreen(ent.Position)
            if screenPos.X > -100 and screenPos.X < 600 and screenPos.Y > -100 and screenPos.Y < 600 then
                -- Draw pulsing glow circle
                local pulse = 0.7 + 0.3 * math.sin(game:GetFrameCount() * 0.05)
                local radius = 40 * pulse
                local alpha = 0.3 + 0.15 * pulse

                -- Simple glow using multiple text characters
                for r = 10, radius, 8 do
                    local a = alpha * (1.0 - r / radius)
                    Isaac.RenderText(".", screenPos.X - 3, screenPos.Y - 3 + r * 0.5,
                        glowColor.R, glowColor.G, glowColor.B, a)
                end
            end
        end
    end
end

function mod:onNewLevel()
    -- Ensure Curse of Darkness is active every floor
    local level = game:GetLevel()
    if level then
        -- Add Curse of Darkness if not already present
        local curses = level:GetCurses()
        if (curses & LevelCurse.CURSE_OF_DARKNESS) == 0 then
            level:AddCurse(LevelCurse.CURSE_OF_DARKNESS, true)
        end
    end

    Isaac.DebugString("DarknessMode: Eternal darkness descends...")
end

function mod:onGameStart()
    -- Apply darkness curse immediately
    local level = game:GetLevel()
    if level then
        level:AddCurse(LevelCurse.CURSE_OF_DARKNESS, true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)

Isaac.DebugString("DarknessMode loaded!")
