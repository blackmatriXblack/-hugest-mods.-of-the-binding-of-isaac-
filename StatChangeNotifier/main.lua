-- =============================================================================
--  StatChangeNotifier - The Binding of Isaac: Repentance
--  Briefly flash "+DMG" or "+SPD" etc. on screen when stats change
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("StatChangeNotifier", 1)
local game = Game()

local lastStats = {damage = 0, speed = 0, tearDelay = 0, range = 0, shotSpeed = 0, luck = 0}
local notifications = {}

function mod:onPEffectUpdate(player)
    if not player then return end

    local newDamage = player.Damage
    local newSpeed = player.MoveSpeed
    local newTearDelay = player.TearDelay
    local newRange = player.TearRange
    local newShotSpeed = player.ShotSpeed
    local newLuck = player.Luck

    local now = game:GetFrameCount()

    -- Check and notify stat changes
    local function checkStat(name, oldVal, newVal, symbol, r, g, b)
        if oldVal > 0 and math.abs(newVal - oldVal) > 0.01 then
            local diff = newVal - oldVal
            local prefix = diff >= 0 and "+" or ""
            notifications[#notifications + 1] = {
                text = string.format("%s%s %.2f", prefix, symbol, diff),
                r = r, g = g, b = b,
                frame = now,
                life = 120 -- 4 seconds
            }
        end
    end

    checkStat("DMG", lastStats.damage, newDamage, "DMG", 1, 0.3, 0.3)
    checkStat("SPD", lastStats.speed, newSpeed, "SPD", 0.3, 1, 0.3)
    checkStat("TEAR", -lastStats.tearDelay, -newTearDelay, "TEAR", 0.3, 0.6, 1)
    checkStat("RNG", lastStats.range, newRange, "RNG", 0.8, 0.8, 0.3)
    checkStat("SHOT", lastStats.shotSpeed, newShotSpeed, "SHOT", 1, 0.5, 0.5)
    checkStat("LCK", lastStats.luck, newLuck, "LCK", 0.3, 1, 0.6)

    lastStats.damage = newDamage
    lastStats.speed = newSpeed
    lastStats.tearDelay = newTearDelay
    lastStats.range = newRange
    lastStats.shotSpeed = newShotSpeed
    lastStats.luck = newLuck
end

function mod:onRender()
    local now = game:GetFrameCount()
    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()

    local baseX = sw * 0.78
    local baseY = sh * 0.35

    local i = 1
    while i <= #notifications do
        local n = notifications[i]
        local age = now - n.frame
        if age > n.life then
            table.remove(notifications, i)
        else
            local alpha = 1.0
            local fadeStart = n.life - 30
            if age > fadeStart then alpha = 1.0 - (age - fadeStart) / 30 end

            local yOff = (i - 1) * 20
            Isaac.RenderScaledText(
                n.text,
                baseX, baseY + yOff, 0.8, 0.8, n.r, n.g, n.b, alpha
            )

            i = i + 1
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("StatChangeNotifier loaded!")
