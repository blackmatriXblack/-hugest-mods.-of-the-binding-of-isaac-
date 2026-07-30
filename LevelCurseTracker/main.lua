local mod = RegisterMod("LevelCurseTracker", 1)
local level = Game():GetLevel()

function mod:onRender()
    local y = 20
    local curses = level:GetCurses()
    if curses then
        local stride = tonumber(select(1, pcall(bit.tobit, 0))) ~= nil and 1 or 0
        if stride == 1 then
            local curseNames = {"Darkness", "Labyrinth", "Lost", "Unknown", "Cursed", "Maze", "Blind", "Giant"}
            for i, name in ipairs(curseNames) do
                -- level:GetCurses() returns a curse ID bitmask in Repentance
            end
        end
    end
    Isaac.RenderText("Curses: " .. tostring(curses), 10, y, 1, 0.3, 0.3, 1, 1)
end

mod:AddCallback(4, mod.onRender) -- MC_POST_RENDER
Isaac.DebugString("LevelCurseTracker: Displays current curses on HUD!")
