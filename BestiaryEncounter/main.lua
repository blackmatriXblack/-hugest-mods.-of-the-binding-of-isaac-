-- =============================================================================
--  BestiaryEncounter - The Binding of Isaac: Repentance
--  Mark every enemy type encountered as discovered in persistent mod data
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BestiaryEncounter", 1)
local BESTIARY_KEY = "BESTIARY_DATA"
local discovered = {}
local showBestiary = false

-- Monster type names (simplified reference)
local monsterNames = {
    [10] = "Fly", [11] = "Pooter", [12] = "Gaper", [13] = "Gusher",
    [14] = "Horfe", [15] = "Charger", [20] = "Mulliboom", [21] = "Mulligan",
    [22] = "Hive", [24] = "Dople", [25] = "Clotty", [27] = "Globin",
    [28] = "Black Globin", [30] = "Host", [31] = "Red Host", [33] = "Boom Fly",
    [34] = "Red Boom Fly", [36] = "Sucker", [38] = "Squirt", [39] = "Sparks",
    [41] = "Tumor", [42] = "Stone Grimace", [45] = "Hanger", [46] = "Swarmer",
    [47] = "Pale Gaper", [48] = "Round Worm", [49] = "Leaper", [50] = "Fire Leaper",
    [51] = "Mom", [52] = "Mom's Heart", [54] = "Satan", [55] = "Isaac",
    [56] = "The Fallen", [60] = "Death", [61] = "Pestilence", [62] = "Famine",
    [63] = "War", [66] = "Null", [67] = "Sins", [68] = "Spider",
    [69] = "Big Spider", [70] = "Trite", [71] = "Rag Man",
    [80] = "Monstro", [81] = "Gemini", [82] = "Larry Jr.",
    [83] = "The Duke of Flies", [84] = "Fistula", [86] = "Pin",
    [87] = "Gurdy", [88] = "Loki", [89] = "Scolex", [90] = "Blighted Ovum",
    [91] = "Peep", [92] = "Dingle", [93] = "Dark One", [94] = "The Adversary",
    [95] = "Polycephalus", [96] = "The Gate", [97] = "Daddy Long Legs",
    [98] = "Mask of Infamy", [99] = "Mega Maw", [100] = "The Cage",
    [101] = "The Haunt", [102] = "Mr. Fred", [103] = "The Lamb",
    [104] = "Mega Satan", [106] = "Rag Mega", [107] = "Sisters Vis",
    [200] = "Hush", [210] = "Delirium", [220] = "Mother",
}

function mod:onEntitySpawn(entity)
    local monsterType = entity.Type
    local monsterVariant = entity.Variant
    local subType = entity.SubType

    if entity:IsActiveEnemy() then
        local key = string.format("%d_%d_%d", monsterType, monsterVariant, subType)
        if not discovered[key] then
            discovered[key] = true
            -- Save to persistent data
            local data = mod:GetData()
            if data[BESTIARY_KEY] == nil then data[BESTIARY_KEY] = {} end
            data[BESTIARY_KEY][key] = true
        end
    end
end

function mod:onRender()
    -- Toggle with T key
    if Input.IsButtonPressed(Keyboard.KEY_T, 0) then
        showBestiary = not showBestiary
        if showBestiary then
            local data = mod:GetData()
            if data[BESTIARY_KEY] ~= nil then
                discovered = data[BESTIARY_KEY]
            end
        end
    end

    if not showBestiary then return end

    local font = Font()
    local x = 40
    local y = 50
    local alpha = 0.85
    local count = 0
    for _ in pairs(discovered) do count = count + 1 end

    font:DrawString("=== BESTIARY (T to toggle) ===", x, y, KColor(1, 0.8, 0, alpha), 0, false)
    y = y + 20
    font:DrawString(string.format("Discovered: %d enemies", count), x, y, KColor(0.5, 1, 0.5, alpha), 0, false)
    y = y + 24

    local shown = 0
    for key, _ in pairs(discovered) do
        if shown >= 25 then break end
        local mType = string.match(key, "^(%d+)_")
        local mName = monsterNames[tonumber(mType)] or ("Type_" .. tostring(mType))
        font:DrawString("  * " .. mName, x + 10, y, KColor(1, 1, 0.7, alpha), 0, false)
        y = y + 16
        shown = shown + 1
    end

    if count > 25 then
        font:DrawString(string.format("  ... and %d more", count - 25), x + 10, y, KColor(0.5, 0.5, 0.5, alpha), 0, false)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("BestiaryEncounter loaded!")
