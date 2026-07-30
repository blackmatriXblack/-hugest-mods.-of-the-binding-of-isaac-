-- ==========================================================================
--  InkSplat - The Binding of Isaac: Repentance
--  Ink enemy splats ink on screen edges reducing visibility for 3 seconds.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("InkSplat", 1)
local ENEMY_INK = 9
local INK_DURATION = 90
local SPLAT_COOLDOWN = 180

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_INK then return end
    local data = npc:GetData()
    if not data.splatTimer then data.splatTimer = 0 end
    if not data.inkActive then data.inkActive = false end
    if not data.inkEndFrame then data.inkEndFrame = 0 end

    if data.inkActive then
        -- Apply dark overlay effect to room
        local room = Game():GetRoom()
        room:SetCreepEffect(EffectVariant.PLAYER_CREEP_RED, 999, 0, npc.Position, 999, 0)
        if Game():GetFrameCount() >= data.inkEndFrame then
            data.inkActive = false
            data.splatTimer = 0
        end
    else
        data.splatTimer = data.splatTimer + 1
        if data.splatTimer >= SPLAT_COOLDOWN then
            data.inkActive = true
            data.inkEndFrame = Game():GetFrameCount() + INK_DURATION
            data.inkSpriteTimer = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("InkSplat loaded!")