-- =============================================================================
--  DamageMeter - The Binding of Isaac: Repentance
--  Display a damage-per-second meter tracking damage dealt in the last 3 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DamageMeter", 1)
local game = Game()
local damageLog = {}

function mod:onEntityDamage(target, amount, flags, source, countdown)
    if source and source.Entity and source.Entity:ToPlayer() and target:IsEnemy() then
        damageLog[#damageLog + 1] = {
            frame = game:GetFrameCount(),
            dmg = amount
        }
    end
end

function mod:onRender()
    local now = game:GetFrameCount()
    local cutoff = now - 90
    local totalDmg = 0
    local i = 1
    while i <= #damageLog do
        if damageLog[i].frame < cutoff then
            table.remove(damageLog, i)
        else
            totalDmg = totalDmg + damageLog[i].dmg
            i = i + 1
        end
    end
    local dps = totalDmg / 3.0

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.018
    local y = sh * 0.33

    -- Title
    Isaac.RenderScaledText("Damage Meter", x, y, 0.9, 0.9, 1, 0.7, 0.2, 1)

    -- DPS Value
    local dpsColorR, dpsColorG = 0.3, 1
    if dps > 50 then dpsColorR, dpsColorG = 1, 0.3 end
    Isaac.RenderScaledText(string.format("%.1f DPS", dps), x, y + 16, 1.4, 1.4, dpsColorR, dpsColorG, 0.2, 1)

    -- Visual Bar (scaled to 100 max)
    local barMax = 100
    local ratio = math.min(dps / barMax, 1.0)
    local barLen = 22
    local filled = math.floor(ratio * barLen)
    local barStr = "[" .. string.rep("█", filled) .. string.rep("░", barLen - filled) .. "]"
    Isaac.RenderScaledText(barStr, x, y + 36, 0.65, 0.65, 0.8, 0.8, 0.8, 0.85)
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityDamage)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("DamageMeter loaded!")
