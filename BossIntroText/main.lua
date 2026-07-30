-- ==========================================================================
--  BossIntroText - The Binding of Isaac: Repentance
--  Huge dramatic boss name text appears when entering a boss room!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BossIntroText", 1)
local bossText = nil
local textTimer = 0
local TEXT_DURATION = 120
local textAlpha = 0

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_BOSS then
        for _, ent in pairs(Isaac.GetRoomEntities()) do
            if ent:IsBoss() and ent:IsActiveEnemy() then
                bossText = ent:GetSprite():GetFilename()
                bossText = bossText:gsub("gfx/", ""):gsub("%.anm2", ""):upper()
                textTimer = 0
                textAlpha = 1
                SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO, 1.0, 0, false, 1.0)
                break
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not bossText or textTimer >= TEXT_DURATION then
        bossText = nil
        return
    end
    textTimer = textTimer + 1

    if textTimer < 30 then
        textAlpha = math.min(1, textTimer / 30)
    elseif textTimer > TEXT_DURATION - 30 then
        textAlpha = math.max(0, (TEXT_DURATION - textTimer) / 30)
    end

    local scale = 3 + math.sin(textTimer * 0.15) * 0.3
    local r, g, b = 1, 0, 0
    if textTimer % 20 < 10 then r, g, b = 0.9, 0.1, 0.1 else r, g, b = 1, 0.3, 0 end

    Isaac.RenderText(bossText,
        Isaac.GetScreenWidth() / 2 - 100,
        Isaac.GetScreenHeight() / 3,
        r, g, b, textAlpha, scale)
end)

Isaac.DebugString("BossIntroText loaded! ROUND 1... FIGHT!")
