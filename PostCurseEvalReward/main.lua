-- =============================================================================
--  PostCurseEvalReward - The Binding of Isaac: Repentance
--  Phantom memory: reveals map for 5 seconds if Cursed of the Lost.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostCurseEvalReward", 1)
local revealTimer = 0

function mod:onPostCurseEval()
    local level = Game():GetLevel()
    -- Check for Curse of the Lost (bit 5, value 16)
    if level:GetCurses() & LevelCurse.CURSE_OF_LOST ~= 0 then
        revealTimer = 150 -- 5 seconds
        Isaac.DebugString("Phantom memory: map revealed briefly!")
    end
end

function mod:onPostRender()
    if revealTimer <= 0 then return end
    revealTimer = revealTimer - 1
    -- Use the Shovel-style reveal: fill the minimap temporarily
    local level = Game():GetLevel()
    for y = 0, 12 do
        for x = 0, 8 do
            if level:GetRoomByIdx(x, y) ~= nil and level:GetRoomByIdx(x, y).Data then
                level:SetStateFlag(x, y, RoomStateFlag.STATE_VISITED, true)
            end
        end
    end
    if revealTimer == 1 then
        Isaac.DebugString("Phantom memory faded.")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, mod.onPostCurseEval)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("PostCurseEvalReward loaded!")
