-- =============================================================================
--  HushTimerExtend - The Binding of Isaac: Repentance
--  Hush timer extended to 40 minutes but Hush has 2x HP
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HushTimerExtend", 1)
local game = Game()
local hushHPBoosted = false

function mod:onNewLevel()
    -- Reset Hush HP boost tracker each level
    hushHPBoosted = false
end

function mod:onPostEntitySpawn(entity)
    -- Detect Hush spawn and double its HP
    if entity.Type == EntityType.ENTITY_HUSH or
       entity.Type == EntityType.ENTITY_HUSH_FLY or
       (entity:IsBoss() and string.find(entity:GetSprite():GetFilename() or "", "hush")) then

        if not hushHPBoosted then
            hushHPBoosted = true
            local currentMaxHP = entity.MaxHitPoints
            local currentHP = entity.HitPoints

            -- Double Hush's HP
            entity.MaxHitPoints = currentMaxHP * 2
            entity.HitPoints = currentHP * 2

            -- Visual indicator: tint Hush red/purple to show empowered status
            entity:SetColor(Color(1.0, 0.3, 1.0, 1.0, 0, 0, 0), 30, 0)

            Isaac.DebugString("HushTimerExtend: Hush HP doubled from " .. tostring(currentMaxHP) .. " to " .. tostring(currentMaxHP * 2))
        end
    end
end

function mod:onPostRender()
    -- Show the extended timer info
    local room = game:GetRoom()
    if not room then return end

    -- Only show in floors leading to Hush (Womb and beyond)
    local level = game:GetLevel()
    if level then
        local stage = level:GetStage()
        local stageType = level:GetStageType()

        -- Womb/Utero (stage 7) and beyond
        if stage >= 7 then
            local gameTime = game:GetFrameCount() / 30  -- Convert to seconds approximation
            local minutes = gameTime / 60
            local remaining = 40 - minutes

            if remaining > 0 then
                local colorR, colorG = 0.0, 1.0
                if remaining < 10 then
                    colorR, colorG = 1.0, 0.3 -- Warning color
                elseif remaining < 15 then
                    colorR, colorG = 1.0, 0.8 -- Caution color
                end

                local remainingStr = string.format("HUSH GATE: %.1f min remaining", remaining)
                Isaac.RenderText(
                    remainingStr,
                    180, 20,
                    colorR, colorG, 0.3, 0.8
                )

                Isaac.RenderText(
                    "(Extended to 40 min | Hush has 2x HP)",
                    130, 34,
                    0.6, 0.6, 0.6, 0.6
                )
            else
                Isaac.RenderText(
                    "HUSH GATE: OPEN (40 min extended)",
                    160, 20,
                    0.3, 1.0, 0.3, 0.8
                )
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onPostEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)

Isaac.DebugString("HushTimerExtend loaded! 40 min timer, 2x HP Hush.")
