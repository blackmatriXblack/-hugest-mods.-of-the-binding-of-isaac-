-- =============================================================================
--  TearCounterMod — The Binding of Isaac: Repentance
--  Count how many tears player has fired this run, display on HUD.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("TearCounterMod", 1)
mod.tearCount = 0

function mod:onPostFireTear(tear)
    mod.tearCount = mod.tearCount + 1
end

function mod:onNewRoom()
    -- Keep count across rooms, no reset
end

function mod:onGameStart(isContinued)
    if not isContinued then
        mod.tearCount = 0 -- reset only on new run
    end
end

function mod:onPostRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Calculate tears per second roughly
    local roomFrames = Game():GetRoom():GetFrameCount()
    local tps = 0
    if roomFrames > 0 then
        tps = (mod.tearCount / roomFrames) * 60
    end

    Isaac.RenderText("Tears Fired: " .. tostring(mod.tearCount), 10, 200, 0.8, 0.8, 0.2, 0.8, 1)
    Isaac.RenderText("Tears/sec: " .. string.format("%.1f", tps), 10, 212, 0.7, 0.7, 0.2, 0.8, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.onPostFireTear)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("TearCounterMod loaded!")
