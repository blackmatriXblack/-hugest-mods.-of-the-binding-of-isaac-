-- =============================================================================
--  AngelRoomBoost — The Binding of Isaac: Repentance
--  Angel rooms appear 100% if you skipped first devil deal.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AngelRoomBoost", 1)

local devilDealSkipped = false
local currentStage = nil

function mod:BoostAngelChance()
    local level = Game():GetLevel()
    local stage = level:GetStage()

    -- Reset tracking on new stage
    if stage ~= currentStage then
        currentStage = stage
        devilDealSkipped = false
    end
end

function mod:CheckDevilDealSkip()
    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_DEVIL then
        devilDealSkipped = true
    end
end

function mod:ApplyAngelChance()
    if devilDealSkipped then
        local level = Game():GetLevel()
        level:SetAngelRoomChance(100)
        level:SetDevilRoomChance(0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.BoostAngelChance)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.CheckDevilDealSkip)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ApplyAngelChance)
Isaac.DebugString("AngelRoomBoost loaded!")
