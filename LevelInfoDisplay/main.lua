-- LevelInfoDisplay: Shows chapter, stage, and room count on HUD
local mod = RegisterMod("LevelInfoDisplay", 1)
local chapter = 0
local stage = 0
local numRooms = 0

function mod:onNewLevel()
    local level = Game():GetLevel()
    chapter = level:GetChapter()
    stage = level:GetStage()
    numRooms = level:GetNumRooms()
end

function mod:onRender()
    local infoStr = "Chapter: " .. chapter .. ", Stage: " .. stage .. ", Rooms: " .. numRooms
    Isaac.RenderText(infoStr, 10, 10, 255, 255, 255, 255, 2)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("LevelInfoDisplay loaded! Displaying floor info on HUD.")
