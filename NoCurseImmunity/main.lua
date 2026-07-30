-- =============================================================================
--  NO CURSE IMMUNITY — The Binding of Isaac: Repentance
--  Removes all curses on level enter and continuously strips any new curses.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("NoCurseImmunity", 1)

function mod:onNewLevel()
    local level = Game():GetLevel()
    if level ~= nil then
        level:RemoveCurses()
    end
end

function mod:onUpdate()
    local level = Game():GetLevel()
    if level ~= nil then
        level:RemoveCurses()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("No Curse Immunity loaded!")
