-- =============================================================================
--  TrinketEffectDisplay - The Binding of Isaac: Repentance
--  Display what all held trinkets do as tooltip text on screen
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TrinketEffectDisplay", 1)

-- Known trinket descriptions
local TRINKET_DESCRIPTIONS = {
    [TrinketType.TRINKET_SWALLOWED_PENNY] = "Drop coin on hit",
    [TrinketType.TRINKET_PETRIFIED_POOP] = "More drops from poop",
    [TrinketType.TRINKET_LUCKY_ROCK] = "Rocks drop coins",
    [TrinketType.TRINKET_MOMS_TOENAIL] = "Moms foot stomp on hit",
    [TrinketType.TRINKET_CANCER] = "+3 Tears (wool cap)",
    [TrinketType.TRINKET_CURVED_HORN] = "+2 Damage",
    [TrinketType.TRINKET_WHIP_WORM] = "+0.5 Shot Speed",
    [TrinketType.TRINKET_FLAT_WORM] = "Wider tears",
    [TrinketType.TRINKET_ROUND_WORM] = "+Range",
    [TrinketType.TRINKET_RING_WORM] = "Spectral + homing tears",
    [TrinketType.TRINKET_BROKEN_MAGNET] = "Coin magnet",
    [TrinketType.TRINKET_SAFETY_SCISSORS] = "Troll bombs -> bombs",
    [TrinketType.TRINKET_MISSING_PAGE] = "AoE dmg on hit",
    [TrinketType.TRINKET_NOSE_GOBLIN] = "Homing tears chance",
    [TrinketType.TRINKET_CALLUS] = "No spike/creep damage",
    [TrinketType.TRINKET_BLOODY_PENNY] = "Half red heart on coin pickup",
    [TrinketType.TRINKET_BURNT_PENNY] = "Bomb drop on coin pickup",
    [TrinketType.TRINKET_FLAT_PENNY] = "Key drop on coin pickup",
    [TrinketType.TRINKET_COUNTERFEIT_PENNY] = "+50% coins",
    [TrinketType.TRINKET_BUTT_PENNY] = "Fart on coin pickup",
    [TrinketType.TRINKET_BLESSED_PENNY] = "Soul heart on coin pickup",
    [TrinketType.TRINKET_LIBERTY_CAP] = "Mushroom effects",
    [TrinketType.TRINKET_UMBILICAL_CORD] = "Stat up at low HP",
    [TrinketType.TRINKET_CHILDS_HEART] = "+1 red heart drop chance",
    [TrinketType.TRINKET_RUSTED_KEY] = "+Key drop chance",
    [TrinketType.TRINKET_MATCH_STICK] = "+Bomb drop chance",
    [TrinketType.TRINKET_GOAT_HOOF] = "+0.15 Speed",
    [TrinketType.TRINKET_MOMS_PEARL] = "+Soul heart drop chance",
    [TrinketType.TRINKET_CAR_BATTERY] = "Double active item effect",
    [TrinketType.TRINKET_PAPER_CLIP] = "Open chests free",
    [TrinketType.TRINKET_MONKEY_PAW] = "3 black hearts on death",
    [TrinketType.TRINKET_MYSTERIOUS_PAPER] = "Random post-it effect",
    [TrinketType.TRINKET_DAEMONS_TAIL] = "80% heart -> key",
    [TrinketType.TRINKET_POKER_CHIP] = "Chests have more drops",
    [TrinketType.TRINKET_BLACK_LIPSTICK] = "+Devil room chance",
    [TrinketType.TRINKET_BIBLE_TRACT] = "+Angel room chance",
    [TrinketType.TRINKET_MISSING_POSTER] = "Respawn as Lost on death",
    [TrinketType.TRINKET_SIGIL_OF_BAPHOMET] = "1s invincible shield on kill",
    [TrinketType.TRINKET_VIBRANT_BULB] = "Active charge while active",
    [TrinketType.TRINKET_DIM_BULB] = "Stat up at low charge",
    [TrinketType.TRINKET_TICK] = "-15% boss HP, heal boss",
    [TrinketType.TRINKET_WIGGLE_WORM] = "Wiggly tears",
    [TrinketType.TRINKET_PULSE_WORM] = "Pulsing tears",
    [TrinketType.TRINKET_HOOK_WORM] = "Angled tears",
    [TrinketType.TRINKET_OBSESSED_FAN] = "Slow enemies",
    [TrinketType.TRINKET_BLIND_RAGE] = "Invincibility extender",
    [TrinketType.TRINKET_GOLDEN_HORSE_SHOE] = "+15% golden chest",
    [TrinketType.TRINKET_SILVER_DOLLAR] = "+Shop on next floor",
    [TrinketType.TRINKET_BLOOD_CROWN] = "+Treasure on next floor",
    [TrinketType.TRINKET_AZAZELS_STUMP] = "Small Azazel form",
    [TrinketType.TRINKET_FINGER_BONE] = "2% bone break on hit",
    [TrinketType.TRINKET_JAW_BREAKER] = "+1 flat dmg, -tears",
    [TrinketType.TRINKET_FISH_HEAD] = "Chance to spawn blue fly",
    [TrinketType.TRINKET_WALNUT] = "Stun on damage",
    [TrinketType.TRINKET_ADRENALINE] = "Stats up per empty heart",
    [TrinketType.TRINKET_LEFT_HAND] = "All chests -> red chests",
}

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.755
    local y = sh * 0.74

    Isaac.RenderScaledText("Trinkets", x, y, 0.8, 0.8, 0.3, 1, 0.8, 1)

    local trinketCount = 0
    -- Check trinket slot 1
    local trinket1 = player:GetTrinket(0)
    if trinket1 > 0 then
        local cfg = Isaac.GetItemConfig():GetTrinket(trinket1)
        local tname = cfg and cfg.Name or "Unknown"
        local desc = TRINKET_DESCRIPTIONS[trinket1] or ""
        trinketCount = trinketCount + 1
        Isaac.RenderScaledText(tname, x, y + 16, 0.75, 0.75, 1, 0.8, 0.3, 1)
        if desc ~= "" then
            Isaac.RenderScaledText(desc, x + 6, y + 30, 0.6, 0.6, 0.7, 0.7, 0.7, 0.85)
        end
    end

    -- Check trinket slot 2 (Mom's Purse / Belly Button)
    local trinket2 = player:GetTrinket(1)
    if trinket2 > 0 then
        local cfg = Isaac.GetItemConfig():GetTrinket(trinket2)
        local tname = cfg and cfg.Name or "Unknown"
        local desc = TRINKET_DESCRIPTIONS[trinket2] or ""
        trinketCount = trinketCount + 1
        local offY = 16 + (trinket1 > 0 and 46 or 0)
        Isaac.RenderScaledText(tname, x, y + offY, 0.75, 0.75, 0.3, 0.8, 1, 1)
        if desc ~= "" then
            Isaac.RenderScaledText(desc, x + 6, y + offY + 14, 0.6, 0.6, 0.7, 0.7, 0.7, 0.85)
        end
    end

    -- Gulped trinkets
    for i = 3, 10 do
        local gulpedTrinket = player:GetTrinket(i)
        if gulpedTrinket > 0 then
            local cfg = Isaac.GetItemConfig():GetTrinket(gulpedTrinket)
            local tname = cfg and cfg.Name or "Unknown"
            trinketCount = trinketCount + 1
            local offY = 16 + trinketCount * 30
            Isaac.RenderScaledText("[G] " .. tname, x, y + offY, 0.6, 0.6, 0.5, 0.5, 0.8, 0.7)
        end
    end

    if trinketCount == 0 then
        Isaac.RenderScaledText("None", x, y + 16, 0.6, 0.6, 0.4, 0.4, 0.4, 0.6)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("TrinketEffectDisplay loaded!")
