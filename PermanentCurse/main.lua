-- =============================================================================
--  PermanentCurse - The Binding of Isaac: Repentance
--  Every floor has all 7 curses active simultaneously
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PermanentCurse", 1)
local game = Game()

local allCurses = {
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_LABYRINTH,
    LevelCurse.CURSE_OF_THE_LOST,
    LevelCurse.CURSE_OF_THE_UNKNOWN,
    LevelCurse.CURSE_OF_THE_CURSED,
    LevelCurse.CURSE_OF_MAZE,
    LevelCurse.CURSE_OF_BLIND,
}

function mod:onNewLevel()
    local level = game:GetLevel()
    if not level then return end

    -- Apply all 7 curses one by one
    for _, curse in ipairs(allCurses) do
        level:AddCurse(curse, true)
    end

    Isaac.DebugString("PermanentCurse: All 7 curses applied!")
end

function mod:onGameStart()
    -- Apply all curses immediately on game start
    local level = game:GetLevel()
    if level then
        for _, curse in ipairs(allCurses) do
            level:AddCurse(curse, true)
        end
    end
end

function mod:onPostRender()
    -- Display what curses are active
    local level = game:GetLevel()
    if level then
        local curses = level:GetCurses()
        local curseNames = {}

        if (curses & LevelCurse.CURSE_OF_DARKNESS) ~= 0 then table.insert(curseNames, "DARK") end
        if (curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 then table.insert(curseNames, "LABY") end
        if (curses & LevelCurse.CURSE_OF_THE_LOST) ~= 0 then table.insert(curseNames, "LOST") end
        if (curses & LevelCurse.CURSE_OF_THE_UNKNOWN) ~= 0 then table.insert(curseNames, "UNKN") end
        if (curses & LevelCurse.CURSE_OF_THE_CURSED) ~= 0 then table.insert(curseNames, "CURS") end
        if (curses & LevelCurse.CURSE_OF_MAZE) ~= 0 then table.insert(curseNames, "MAZE") end
        if (curses & LevelCurse.CURSE_OF_BLIND) ~= 0 then table.insert(curseNames, "BLND") end

        local displayStr = "CURSES: " .. table.concat(curseNames, ", ")
        Isaac.RenderText(
            displayStr,
            410, 18,
            0.8, 0.0, 0.8, 0.8
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)

Isaac.DebugString("PermanentCurse loaded! May God have mercy on your soul.")
