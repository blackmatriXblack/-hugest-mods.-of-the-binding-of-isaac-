-- =============================================================================
--  PreCurseEvalBlock - The Binding of Isaac: Repentance
--  25% chance to block one random curse each floor.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreCurseEvalBlock", 1)
local blockedCurseText = ""
local blockedTimer = 0

function mod:onPreCurseEval()
    if math.random(1, 100) > 25 then return end

    local level = Game():GetLevel()
    local curses = level:GetCurses()
    local curseNames = {
        {bit = LevelCurse.CURSE_OF_DARKNESS, name = "Curse of Darkness"},
        {bit = LevelCurse.CURSE_OF_LABYRINTH, name = "Curse of the Labyrinth"},
        {bit = LevelCurse.CURSE_OF_LOST, name = "Curse of the Lost"},
        {bit = LevelCurse.CURSE_OF_UNKNOWN, name = "Curse of the Unknown"},
        {bit = LevelCurse.CURSE_OF_CURSED, name = "Curse of the Cursed"},
        {bit = LevelCurse.CURSE_OF_MAZE, name = "Curse of the Maze"},
        {bit = LevelCurse.CURSE_OF_BLIND, name = "Curse of the Blind"}
    }

    -- Pick a random curse and remove it if present
    local shuffled = {}
    for i, v in ipairs(curseNames) do shuffled[i] = v end
    for i = #shuffled, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end

    for _, curse in ipairs(shuffled) do
        if curses & curse.bit ~= 0 then
            level:RemoveCurse(curse.bit)
            blockedCurseText = "Blocked: " .. curse.name
            blockedTimer = 180
            Isaac.DebugString(blockedCurseText)
            return
        end
    end

    blockedCurseText = "No curse to block!"
    blockedTimer = 120
end

function mod:onPostRender()
    if blockedTimer <= 0 then return end
    blockedTimer = blockedTimer - 1
    Isaac.RenderText(blockedCurseText, 60, 90, 0.3, 0.8, 1, 1)
end

mod:AddCallback(ModCallbacks.MC_PRE_CURSE_EVAL, mod.onPreCurseEval)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("PreCurseEvalBlock loaded!")
