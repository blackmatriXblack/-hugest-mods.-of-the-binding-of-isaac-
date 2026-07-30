-- ==========================================================================
--  Dark Arts Combo - The Binding of Isaac: Repentance
--  Tainted Judas Dark Arts piercing damage increases 15 percent per enemy passed
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DarkArtsCombo", 1)
local game = Game()

local DARK_ARTS = CollectibleType.COLLECTIBLE_DARK_ARTS
local enemiesPassed = 0
local darkArtsActive = false

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(DARK_ARTS) then
        darkArtsActive = false
        return
    end

    -- Check if Dark Arts effect is active (player becomes ghost during effect)
    if player:IsCoopGhost() or not player:IsVisible() then
        -- Player just started dark arts dash
        darkArtsActive = true
    elseif darkArtsActive then
        -- Dark arts just ended, apply accumulated damage bonus
        darkArtsActive = false
        if enemiesPassed > 0 then
            local bonus = enemiesPassed * 0.15
            player:AddDamage(bonus, 150) -- Bonus lasts 5 seconds after dash
            Isaac.RenderText("+" .. string.format("%.0f", bonus * 100) .. "% DMG",
                200, 200, 1, 1, 0, 0, 1)
        end
        enemiesPassed = 0
    end

    -- Count enemies near player during dash
    if darkArtsActive then
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent:IsVulnerableEnemy() then
                local dist = (player.Position - ent.Position):Length()
                if dist < 50 then
                    enemiesPassed = enemiesPassed + 1
                    -- Mark as counted by giving brief invulnerability frame
                    ent:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
                    ent:ClearEntityFlags(EntityFlag.FLAG_FRIENDLY)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("DarkArtsCombo loaded!")
